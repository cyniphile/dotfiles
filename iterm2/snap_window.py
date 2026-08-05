#!/usr/bin/env python3
"""
snap_window — reshape the focused iTerm2 window to the left half, right half,
or back to full screen from a key binding.

Bind keys (Profiles > Keys) to:
    Invoke Script Function -> snap_window_left(session_id: session.id)
    Invoke Script Function -> snap_window_right(session_id: session.id)
    Invoke Script Function -> snap_window_full(session_id: session.id)

The Hotkey profile's own style stays "Full Screen", so F12 opens the window
exactly as before; these bindings only reshape it afterwards. A full-screen
window ignores frame changes, so a half-snap leaves full screen first. That
rebuilds the window around the same sessions, which invalidates the window
handle — hence the settle and the second lookup by session id.

Screen geometry comes from NSScreen (PyObjC ships in the iTerm2 Python
runtime); the API exposes no screen accessor. NSScreen and iterm2.Frame share
Cocoa coordinates — origin at the bottom left of the main display — so the
rects need no conversion.
"""

import asyncio

import iterm2
from AppKit import NSScreen

# Long enough for the post-full-screen window to be published to the API model.
EXIT_FULLSCREEN_SETTLE = 0.1


def screen_containing(frame):
    """The NSScreen holding the frame's center, else the main screen."""
    x = frame.origin.x + frame.size.width / 2
    y = frame.origin.y + frame.size.height / 2
    for screen in NSScreen.screens():
        f = screen.frame()
        if (f.origin.x <= x < f.origin.x + f.size.width and
                f.origin.y <= y < f.origin.y + f.size.height):
            return screen
    return NSScreen.mainScreen()


def window_for_session(app, session_id):
    for window in app.terminal_windows:
        for tab in window.tabs:
            for session in tab.sessions:
                if session.session_id == session_id:
                    return window
    return None


async def snap(app, session_id, side):
    """Move the window holding session_id. side: "left", "right", or None for full."""
    window = window_for_session(app, session_id)
    if window is None:
        return

    fullscreen = await window.async_get_fullscreen()
    if side is None:
        if not fullscreen:
            await window.async_set_fullscreen(True)
        return

    if fullscreen:
        await window.async_set_fullscreen(False)
        await asyncio.sleep(EXIT_FULLSCREEN_SETTLE)
        window = window_for_session(app, session_id)
        if window is None:
            return

    visible = screen_containing(await window.async_get_frame()).visibleFrame()
    width = visible.size.width / 2
    x = visible.origin.x + (width if side == "right" else 0)
    await window.async_set_frame(iterm2.Frame(
        origin=iterm2.Point(x, visible.origin.y),
        size=iterm2.Size(width, visible.size.height)))


async def main(connection):
    app = await iterm2.async_get_app(connection)

    @iterm2.RPC
    async def snap_window_left(session_id):
        await snap(app, session_id, "left")

    @iterm2.RPC
    async def snap_window_right(session_id):
        await snap(app, session_id, "right")

    @iterm2.RPC
    async def snap_window_full(session_id):
        await snap(app, session_id, None)

    await snap_window_left.async_register(connection)
    await snap_window_right.async_register(connection)
    await snap_window_full.async_register(connection)


iterm2.run_forever(main)
