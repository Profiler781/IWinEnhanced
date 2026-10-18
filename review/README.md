# Code review: October 2026

This folder goes with the pull request that fixes the issues found in a full read of IWinEnhanced 2.5 (commit `e5908a2`).

- [CODE_REVIEW.md](CODE_REVIEW.md): the full report, in English
- [RAPPORT_FR.md](RAPPORT_FR.md): the same report, in French

**Nothing was tested in game.** The fixes come from reading the code and the 1.12 API. Please run the checklist below before merging. Each important or medium fix is its own commit, so any of them can be reverted on its own.

## Commits

| Commit | Findings | Files |
|---|---|---|
| Read the consumableAOE setting with the right key | I-1 | `core/condition.lua` |
| Return a duration from GetTimeToEnergyMax | I-2 | `druid/condition.lua`, `rogue/condition.lua` |
| Use the real time when recording proc windows in event handlers | I-3 | `warrior/event.lua`, `rogue/event.lua`, `druid/event.lua` |
| Guard PallyPower blessing lookups for paladins without an assignment | I-4 | `paladin/condition.lua`, `paladin/action.lua` |
| Fix the item set keys of the Genesis and Dreadnaught bonuses | M-1, M-4 | `druid/data.lua`, `warrior/data.lua` |
| Add no-op defaults for the shared slash commands | M-2 | `core/action.lua` |
| Use getglobal in GetWeaponSpeed | M-3 | `core/condition.lua` |
| Check that Revenge is learnt before comparing its cooldown | M-5 | `warrior/action.lua` |
| Match item names literally and use a single drink per press | m-1, m-2 | `core/action.lua`, `core/condition.lua` |
| Fix accidental globals and nil-unsafe debug strings in core/condition.lua | m-3, m-4, m-5, m-6 | `core/condition.lua` |
| Reject non-numeric values in /iwin numeric settings | m-9 | `*/setup.lua` |
| Small druid and rogue fixes | m-7, m-10, m-12 | `druid/action.lua`, `druid/rotation.lua`, `rogue/action.lua` |
| Do not keep targettarget in the target cache | m-12 | `core/condition.lua` |

## Taken from the author's feedback

- **I-5, Moonkin Starfire/Wrath: withdrawn, no code change.** Wrath is the best DPS spell and the filler, so Wrath winning whenever both Solstices are up is intended.
- **Pummel:** it is usable in Battle Stance on Turtle WoW, so swapping from Defensive to Battle Stance is correct. Removed from the open questions.
- **I-3, event timings: kept.** The window is *read* during a key press with a fresh time, but it is *written* when the event fires, from the time cached at the previous press. Example: last press at t = 100, dodge at t = 103, so the Overpower window ends at 104 instead of 107. With constant spamming the error is tiny, which is why it rarely shows. Details are in [CODE_REVIEW.md](CODE_REVIEW.md#i-3-event-handlers-record-windows-with-the-time-of-the-previous-key-press-fixed). It is a separate commit if you prefer to drop it.

## Not changed

- `queueTime` is passed to `IsSpellSkip` (about 80 calls) but never defined, so it is always `nil` unless another add-on defines it.
- Shield Wall talent (`core/data.lua:269, 309`) is read once at load, and the talent name needs checking against Turtle's rules.
- `overpower`, `berserkerrage` and `rend` accept any value, so a typo in `off` means "on". `rageinfo` computes values it never prints.
- Rogue `IWin_CombatVar["energyPerSecondPrediction"]` is never read, and the buff is probably "Adrenaline Rush", not "Adrenaline". Only the `nil * 2` error was fixed.
- English client only (combat log, tooltip and item subtype texts). This could be mentioned in the main README.
- Hunter, mage, priest, shaman and warlock remain skeletons. The shared commands no longer error there, but they do nothing.

## What was checked

- Every `.lua` file parses with `luac -p` (Lua 5.1, syntax only; the client runs Lua 5.0, and the new code uses only 5.0 functions: `ipairs`, `table.insert`, `table.sort`, `string.find` with `plain`).
- Windows line endings (CRLF) are kept in every modified file, and no other file was touched.

## In-game checklist

| Fix | How to check |
|---|---|
| I-1 | `/iwin consumableaoe off`, then pull a pack big enough for sappers or dynamite: none should be used. With `elite` or `boss`, only on those targets. |
| I-2 | Cat druid or rogue with `/iwin debug on`: "Time to maximum energy" shows a few seconds, not thousands. Energy should cap less often while pooling. |
| I-3 | Warrior: stop pressing for 2 to 3 seconds; when the target dodges, Overpower is still offered during the 4 seconds that follow. Same for rogue Riposte and Surprise Attack. |
| I-4 | Paladin with PallyPowerTW loaded and no assignment: no Lua error when spamming. With an assignment, the assigned blessing is still used. |
| M-1 | Druid with 3 Genesis (T2.5) pieces: Claw, Rake and Shred cost 3 energy less. With 3 Stormrage (T2) pieces only, no reduction. |
| M-2 | On a hunter, mage, priest, shaman or warlock: `/inuke`, `/itrinket`, `/iconsumable`, `/iconsumableaoe`, `/icdshort`, `/icdlong` give no Lua error. |
| M-3 | Paladin who knows Seal of Command: no Lua error, and the debug line "Weapon speed" shows the main hand speed. |
| M-4 | Warrior with 2 Dreadnaught pieces: Death Wish and Sweeping Strikes cost 10 rage less. |
| M-5 | Warrior who knows Shield Block but not Revenge, in Defensive Stance with a shield: no Lua error. |
| m-1, m-2 | `/ihydrate` uses Freshly-Squeezed Lemonade or Sun-Parched Waterskin. With several drinks in the bags, the highest level one is used (conjured first), and only one per press. |
| m-6 | A stacking buff on the player shows its real stack count in debug. |
| m-7 | Bear: auto-attack is not toggled right after Maul is queued. |
| m-9 | `/iwin sapper abc` prints "Possible values" instead of a Lua error. |
| m-12 | Druid `/ichase`, `/irun` and `/itaunt` still pick a new target when the current one is dead. Warrior Intervene follows the target's target when it changes. |
