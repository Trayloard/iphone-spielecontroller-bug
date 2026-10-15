# iphone-spielecontroller-bug

This repository now contains a valid `keyboardLayout.json` file for collecting
VS Code browser keyboard mapping data.

## Capture keyboard layout data

1. Open VS Code in the browser on the affected device.
2. Run `Developer: Inspect Key Mappings (JSON)` from the Command Palette.
3. Copy the full JSON output.
4. Replace the contents of `keyboardLayout.json` with that JSON.

## Why this change

The previously shared layout content was comment-only text and not valid JSON,
which breaks JSON parsing/consumption in tooling. The checked-in file is now
valid JSON and ready to receive real key mapping data.
