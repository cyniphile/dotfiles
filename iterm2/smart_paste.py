#!/usr/bin/env python3
"""
smart_paste — one-shortcut paste for iTerm2 that mirrors VS Code behavior.

Bind a key (e.g. Cmd+V) to:  Invoke Script Function -> smart_paste(session_id: session.id)

If the clipboard holds an image, it sends Ctrl+V (0x16) so Claude Code reads the
image from the clipboard. Otherwise it sends the clipboard text as a bracketed
paste (so multi-line text doesn't auto-execute). async_send_text writes straight
to the tty, so it bypasses iTerm key mappings — no conflict with other bindings.

Clipboard access is in-process via NSPasteboard (PyObjC ships in the iTerm2
Python runtime). pb.types() is a metadata lookup that never materializes any
flavor. The previous version shelled out to `osascript -e 'clipboard info'`,
which renders every clipboard flavor on each paste: ~0.15s for plain text,
~0.6s with a small image on the clipboard, 1-2s for a Retina screenshot.
"""

import iterm2
from AppKit import NSPasteboard, NSPasteboardTypeString

# Pasteboard UTIs that mean an image is on the clipboard — the same cases the
# old `clipboard info` markers matched (PNG, TIFF, JPEG, GIF, AVIF, BMP).
IMAGE_UTIS = {
    "public.png", "public.tiff", "public.jpeg", "public.heic", "public.heif",
    "public.avif", "com.compuserve.gif", "com.microsoft.bmp",
}


async def main(connection):
    app = await iterm2.async_get_app(connection)
    pasteboard = NSPasteboard.generalPasteboard()

    @iterm2.RPC
    async def smart_paste(session_id):
        session = app.get_session_by_id(session_id)
        if session is None:
            return
        if IMAGE_UTIS.intersection(pasteboard.types() or ()):
            # Ctrl+V -> Claude Code's image-paste path reads the clipboard.
            await session.async_send_text("\x16")
        else:
            text = pasteboard.stringForType_(NSPasteboardTypeString)
            if text:
                # Bracketed paste: wrap so newlines insert instead of executing.
                # Strip literal paste-end sequences so pasted content can't
                # close the bracket early and execute what follows.
                text = text.replace("\x1b[201~", "")
                await session.async_send_text("\x1b[200~" + text + "\x1b[201~")

    await smart_paste.async_register(connection)


iterm2.run_forever(main)
