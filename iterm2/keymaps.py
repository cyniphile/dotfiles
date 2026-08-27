#!/usr/bin/env python3
"""
keymaps - hand the terminal the Cmd chords that VS Code uses.

A terminal has no Cmd key, so a Cmd chord reaches nvim (or the shell) only as
an escape sequence. Each chord in keymaps.json becomes one profile key mapping
that sends the chord in CSI-u form:

    Cmd+Opt+C  ->  ESC [99;11u  ->  nvim reads <D-M-c>

99 is 'c'; 11 is 1 + alt(2) + super(8). nvim 0.11 decodes CSI u by itself, so
the chord arrives as a real <D-...> key; zsh and bash bind the raw sequence.
That is why this is better than the hex codes the profile also holds: Cmd+A ->
0x01 spends Ctrl+A forever, while a CSI-u sequence spends nothing.

The GUI calls the matching action "Send Escape Sequence". This writes it as
"Send Hex Code" instead: a hex code states every byte, and its action id is the
one the profile's own bindings already use, so no id is guessed.

Ownership: the script replaces every CSI-u hex binding on the profile and
leaves all others alone. So deleting a chord from keymaps.json removes it on
the next run, while the single-byte hex codes, the pane bindings and the
Invoke Script Function bindings stay as they are.

Runs from the AutoLaunch folder, so the profile is current at every launch. To
apply it now instead, run it from iTerm2's Scripts menu.
"""

import json
import os

import iterm2

HERE = os.path.dirname(os.path.realpath(__file__))
TABLE = os.path.join(HERE, "keymaps.json")
BACKUPS = os.path.expanduser("~/Library/Application Support/iTerm2/keymap-backups")

# macOS virtual key codes, which iTerm2 keys its map by. Letters and the
# punctuation of a US layout; add a row when a chord needs one.
KEYCODES = {
    "a": 0, "s": 1, "d": 2, "f": 3, "h": 4, "g": 5, "z": 6, "x": 7, "c": 8,
    "v": 9, "b": 11, "q": 12, "w": 13, "e": 14, "r": 15, "y": 16, "t": 17,
    "1": 18, "2": 19, "3": 20, "4": 21, "6": 22, "5": 23, "=": 24, "9": 25,
    "7": 26, "-": 27, "8": 28, "0": 29, "]": 30, "o": 31, "u": 32, "[": 33,
    "i": 34, "p": 35, "l": 37, "j": 38, "'": 39, "k": 40, ";": 41, "\\": 42,
    ",": 43, "/": 44, "n": 45, "m": 46, ".": 47, "`": 50,
}

# NSEvent modifier flags, and the CSI-u modifier bits. The sequence carries
# 1 plus the sum of the bits.
NS_FLAGS = {"shift": 0x20000, "ctrl": 0x40000, "opt": 0x80000, "cmd": 0x100000}
CSI_BITS = {"shift": 1, "opt": 2, "ctrl": 4, "cmd": 8}
ALIASES = {"command": "cmd", "super": "cmd", "option": "opt", "alt": "opt",
           "control": "ctrl"}

ACTION_HEX_CODE = 11
CSI_U_PREFIX = "0x1b 0x5b"      # ESC [
CSI_U_FINAL = "0x75"            # u


def parse(chord):
    """'Cmd+Opt+C' -> (the key iTerm2 files the mapping under, bytes to send)."""
    parts = [p.strip().lower() for p in chord.split("+")]
    mods, key = set(parts[:-1]), parts[-1]
    mods = {ALIASES.get(m, m) for m in mods}
    if not mods <= set(NS_FLAGS):
        raise ValueError(f"{chord}: unknown modifier {sorted(mods - set(NS_FLAGS))}")
    if key not in KEYCODES:
        raise ValueError(f"{chord}: no virtual key code for {key!r}")

    # iTerm2 files a mapping under charactersIgnoringModifiers, which still
    # applies Shift, then the flags, then the virtual key code.
    char = key.upper() if "shift" in mods else key
    flags = sum(NS_FLAGS[m] for m in mods)
    ident = f"0x{ord(char):x}-0x{flags:x}-0x{KEYCODES[key]:x}"

    # CSI u reports the unshifted code point and carries Shift as a modifier.
    csi = f"\x1b[{ord(key)};{1 + sum(CSI_BITS[m] for m in mods)}u"
    return ident, csi


def binding(csi):
    return {
        "Version": 2,
        "Apply Mode": 0,
        "Action": ACTION_HEX_CODE,
        "Text": " ".join(f"0x{byte:02x}" for byte in csi.encode()),
        "Escaping": 2,
    }


def is_ours(value):
    text = value.get("Text", "")
    return (value.get("Action") == ACTION_HEX_CODE
            and text.startswith(CSI_U_PREFIX) and text.endswith(CSI_U_FINAL))


def back_up(name, keymap):
    os.makedirs(BACKUPS, exist_ok=True)
    path = os.path.join(BACKUPS, f"{name}.json")
    with open(path, "w") as handle:
        json.dump(keymap, handle, indent=2, sort_keys=True)
    return path


async def main(connection):
    with open(TABLE) as handle:
        table = json.load(handle)
    wanted = {}
    for item in table["chords"]:
        ident, csi = parse(item["chord"])
        wanted[ident] = binding(csi)

    profiles = await iterm2.Profile.async_get(connection)
    by_name = {profile.name: profile for profile in profiles}
    for name in table["profiles"]:
        profile = by_name.get(name)
        if profile is None:
            print(f"keymaps: no profile named {name!r}; known: {sorted(by_name)}")
            continue

        # The API exposes no keyboard-map setter, so use the generic property
        # setter that every generated setter is built on. session_id is None
        # here, so the write goes to the stored profile, not to one session.
        current = profile._simple_get("Keyboard Map")
        if current is None:
            # Not the same as an empty map: it means the query returned no such
            # property. Writing then would drop every binding on the profile.
            print(f"keymaps: {name}: the API returned no Keyboard Map, so "
                  "nothing was written")
            continue
        merged = {key: value for key, value in current.items() if not is_ours(value)}
        merged.update(wanted)
        if merged == current:
            print(f"keymaps: {name} already holds the {len(wanted)} chords")
            continue
        print(f"keymaps: {name}: previous map saved to {back_up(name, current)}")
        await profile._async_simple_set("Keyboard Map", merged)
        print(f"keymaps: {name}: wrote {len(wanted)} chords, kept "
              f"{len(merged) - len(wanted)} other bindings")


iterm2.run_until_complete(main)
