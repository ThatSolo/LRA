# Lazarus Raid Assignments (LRA)

A MacroQuest Lua addon for EQEmu multiboxing. It's a port of the WoW addon Angry Assignments' idea to EverQuest: author a named "page" of raid instructions, broadcast it to everyone else running the script, and it pops up as a big, hard-to-miss banner on their screen.

## What it does

- Write named "pages" — freeform lines (kill order, tank swaps, interrupt rotation, whatever) — in a control panel.
- Hit **Save & Send** and it broadcasts over raid chat (group chat outside a raid) to every character running this same script, including yourself. Receivers don't do anything; the page just appears.
- The page shows up as a large, borderless banner window that flashes "UPDATED" so people notice it mid-fight, and can auto-hide while you're in combat.
- A separate **Kill Order** list lets you mark your current target with EQ's raid marker numbers (`/rmarknpc`) as you go.
- Everyone runs the same script; a **Raid Leader / Master** checkbox is a purely local, per-install setting that decides whether that install can author & send pages (Master) or only receive them (Client).
- Saved pages can be **exported to a share code** (and imported from one) so you can hand a page to someone without them having to retype it, and can be **drag-reordered** in the Saved Pages list.
- A minimized **mini bar** shrinks the control panel down to a small floating badge icon, matching the look of Drel's TurboSuite mini bar.

## Install

Copy this whole folder into your MacroQuest `lua` directory so you end up with:

```
<MacroQuest folder>\lua\LRA
```

Then run:

```
/lua run LRA
```
## Slash commands (optional — handy for an EQ hotbutton)

| Command | Effect |
|---|---|
| `/lra master on\|off` | Raid Leader/Master vs. Client (receive only) |
| `/lra send <page name>` | Broadcast a saved page (Master only) |
| `/lra show` / `/lra hide` | Toggle the banner |
| `/lra panel show\|hide` | Toggle the control window |
| `/lra announce on\|off` | Toggle broadcasting entirely (Master only) |
| `/lra debug on\|off` | Print every raw incoming chat line (useful if broadcasts aren't showing up on other screens — send the output so the chat-line pattern can be tightened) |
| `/lra exit` | Unload the script |

## How the broadcast works

There's no addon-message channel in EQ like WoW has, so this rides on ordinary raid/group chat: each Send breaks the page into a few chat lines wrapped in a `[KOA-...]` marker and says them over `/rs` (or `/g` outside a raid). Every character with the script running listens for that marker and reassembles the page locally — so **every raider who wants to see assignments needs this same script running**, not just the sender.

## Credits

| Role | Who |
|---|---|
| Author | ThatSolo (Realist) |
| TurboSuite (mini-bar / theming patterns) | [Drel](https://github.com/drel-git/Turbo) |
| Idea | [Angry Assignments](https://www.curseforge.com/wow/addons/angry-assignments) (WoW addon) |

## License

MIT — see [LICENSE](LICENSE).
