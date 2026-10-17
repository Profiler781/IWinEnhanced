# IWinEnhanced code review

- Reviewed commit: `e5908a2` (2026-04-10), version 2.5. That's 60 Lua files and about 8,700 lines.
- Review date: 2026-10-17. All line numbers refer to `e5908a2`.
- Scope: `core/` and the four implemented classes (warrior, druid, paladin, rogue). The skeleton modules (hunter, mage, priest, shaman, warlock) were only checked for M-2.
- Method: code reading and checks against the 1.12 API. **Nothing was tested in game.**

Status legend:
- **Fixed**: a commit in this pull request changes the code.
- **Withdrawn**: not a bug after the author's feedback.
- **Not changed**: documented only.

## Summary

| # | Finding | Status |
|---|---|---|
| I-1 | `/iwin consumableaoe` has no effect | Fixed |
| I-2 | `GetTimeToEnergyMax` returns a timestamp, not a duration | Fixed |
| I-3 | Event handlers record windows with the time of the previous key press | Fixed |
| I-4 | Paladin Lua error with PallyPowerTW and no blessing assignment | Fixed |
| I-5 | Moonkin `and`/`or` precedence in Starfire/Wrath | Withdrawn (intended) |
| M-1 | Genesis (T2.5) bonus checked against the Stormrage (T2) pieces | Fixed |
| M-2 | Shared slash commands error on the skeleton classes | Fixed |
| M-3 | `_G` used in `GetWeaponSpeed` | Fixed |
| M-4 | Dreadnaught 2-piece bonus never detected | Fixed |
| M-5 | `GetCooldownRemaining` returns `false`, one unguarded comparison | Fixed |
| m-1 | Item names matched as Lua patterns | Fixed |
| m-2 | `/ihydrate` drink choice and double use | Fixed |
| m-3 | Accidental or undefined globals | Fixed (except `queueTime`) |
| m-4 | Debug strings are built even when debug is off | Fixed where a `nil` can occur |
| m-5 | `"BOOKTYPE_SPELL"` passed as a string | Fixed |
| m-6 | Player buff stacks and negative spell IDs | Fixed |
| m-7 | Druid Maul writes the start-attack throttle to the wrong table | Fixed |
| m-8 | Shield Wall talent read once at load | Not changed |
| m-9 | `/iwin` parameter validation | Partly fixed |
| m-10 | Rogue `energyPerSecondPrediction` | Error fixed, rest not changed |
| m-11 | Druid rage estimate at the end of combat | Withdrawn (same behavior as the warrior) |
| m-12 | `targettarget` kept in the target cache, druid command order | Fixed |

## Important: visible in game

### I-1 `/iwin consumableaoe` has no effect (Fixed)

`core/condition.lua:1484`, `core/event.lua:16`, the `consumableaoe` command in `*/setup.lua`

The command and the default value write `IWin_Settings["consumableAOE"]`. `IsItemConsumableAOEOffensiveTarget` reads `IWin_Settings["consumableAOEOffensive"]` instead, which is always `nil`. None of the `off`/`boss`/`elite` tests can match, so the function returns `true` for every target except training dummies.

The default `elite` setting is ignored too. Sapper charges, Oil of Immolation, Holy Water and Dense Dynamite are used on any pack that has enough enemies, even with the setting on `off`.

Fix: read `IWin_Settings["consumableAOE"]`.

### I-2 `GetTimeToEnergyMax` returns a timestamp, not a duration (Fixed)

`druid/condition.lua:78`, `rogue/condition.lua:72`. It is used in `druid/action.lua:445, 510` and `rogue/action.lua:112, 179, 300, 370, 402`.

`energyNextTickTime` is an absolute time (`GetTime() + tickTime`, set in the `UNIT_ENERGY` handler). `energyNextTickTime + ticks * tickTime` is therefore thousands of seconds as soon as the first tick has been seen. As a result:
- `GetTimeToEnergyMax() < playerReactionDelay` is never true, unless energy is already full.
- `> GCDEnergy` is always true.

The protection against capping energy does not work for cat druids and rogues. `druid/action.lua:444` already does the right subtraction.

Fix: compute the remaining time to the next tick first, `math.max(0, energyNextTickTime - IWin:GetTime(false))`, then add the remaining ticks.

### I-3 Event handlers record windows with the time of the previous key press (Fixed)

- `warrior/event.lua:60, 64, 68, 72, 89, 93`
- `rogue/event.lua:32, 36, 40, 50`
- `druid/event.lua:51, 60, 64`

`IWin:GetTime()` caches the time in `IWin_CombatVar["time"]`. That table is only rebuilt at the next key press, by `InitializeRotationCore`. In an `OnEvent` handler it therefore returns the time of the last key press, not the time of the event. These timings are affected:
- the Overpower, Revenge, Riposte and Surprise Attack windows;
- the Slam cast end;
- the next energy tick.

The rogue module mixes both: the windows are written with the cached time, and read with the real `GetTime()` in `rogue/condition.lua`.

**Author's feedback:** "to use the window, the player presses a key, which updates the time."

That is right for the *read*: the comparison runs during a key press, with a fresh time. The problem is the *write*: the end of the window is computed when the event fires, from the time cached at the previous press.

Example:
1. Last press at t = 100.
2. The target dodges at t = 103, and the player did not press during those 3 seconds.
3. The handler stores `overpowerAvailable = 100 + 4 = 104`, instead of 107.
4. The player presses at t = 104.5: Overpower is considered expired, although it is usable until 107.

When the key is spammed every 0.2 s, the error is at most 0.2 s, which is why it is rarely visible. It matters at the start of a fight, after a pause, or while pooling energy.

`GetTime()` returns the same value for the whole frame, so calling it directly in the handlers costs nothing. This fix is a separate commit and can be dropped on its own.

Fix: `GetTime()` instead of `IWin:GetTime(false)` in the three event files.

### I-4 Paladin Lua error with PallyPowerTW and no blessing assignment (Fixed)

`paladin/action.lua:33, 45, 61, 77, 90, 107`

The blessing functions read `PallyPower_Assignments[name][4]`. When PallyPowerTW is loaded but has no entry for this paladin yet, `PallyPower_Assignments[name]` is `nil` and indexing it raises an error on every key press. This happens on a fresh install, on a new character, or when no assignment was ever made. The aura checks (`PallyPower_AuraAssignments[name] == x`) do not have this problem.

Fix: a small helper, `IWin:GetPallyPowerBlessingAssignment()`, which returns `nil` when there is no entry.

### I-5 Moonkin `and`/`or` precedence in Starfire/Wrath (Withdrawn)

`druid/action.lua:753-765` (Starfire) and `796-808` (Wrath)

The condition reads `last == "Wrath" and A and B and (no Solstice) or (both Solstices)`. Since `and` binds tighter than `or`, the "both Solstices" clause is true on its own, whatever the last spell was. Wrath is tested first in `/iblast`, so it is cast every time while both Solstices are up. That only happens outside Arcane Eclipse, because of the outer `not Arcane Eclipse` guard.

**Author's feedback:** Wrath is the best DPS spell and the filler, so this is the intended behavior. No change.

To make the intent obvious to future readers, the "both Solstices" clause could be moved out of the parentheses as its own `or` branch.

## Medium: wrong bonuses, errors in specific cases

### M-1 Genesis (T2.5) bonus checked against the Stormrage (T2) pieces (Fixed)

`druid/data.lua:23`

`GetGenesisFeral3P` counts `IWin_ItemSet["StormrageFeral"]` instead of `["GenesisFeral"]`, probably copied from the function above. The T2.5 bonus is never seen, and 3 pieces of T2 trigger it by mistake, so the energy costs of Claw, Rake and Shred are wrong.

### M-2 Shared slash commands error on the skeleton classes (Fixed)

`core/rotation.lua`: `/inuke`, `/itrinket`, `/iconsumable`, `/iconsumableaoe`, `/icdshort`, `/icdlong`

These commands are registered for every class. They call functions that only the warrior, druid, paladin and rogue modules define, such as `UseItemTrinketOffensivePrepull` and `CastCDShortOffensiveGCD`. On a hunter, mage, priest, shaman or warlock they raise "attempt to call method ... (a nil value)".

Fix: empty defaults at the end of `core/action.lua`. The class action files are loaded after it, according to the `.toc`, and override them.

### M-3 `_G` used in `GetWeaponSpeed` (Fixed)

`core/condition.lua:1533-1534`

The 1.12 client does not guarantee a global `_G` table: SuperCleveRoidMacros itself uses `local _G = _G or getfenv(0)`. `GetWeaponSpeed` is reached on every paladin key press through Seal of Command (`paladin/action.lua:521`). If `_G` is `nil`, the first call errors before the result is cached, so the error repeats on every press. The rest of the code uses `getglobal`.

Fix: `getglobal("IWin_TTextLeft" .. i)` and `getglobal("IWin_TTextRight" .. i)`.

### M-4 Dreadnaught 2-piece bonus never detected (Fixed)

`warrior/data.lua:75` uses the key `"Dreadnaught"`, while `core/data.lua:325` defines `"DreadnaughtDPS"`.

`CountEquippedSetItems(nil)` returns 0 without an error (checked in SuperCleveRoidMacros), so the mistake is silent: Death Wish and Sweeping Strikes keep their full rage cost.

### M-5 `GetCooldownRemaining` returns `false`, one unguarded comparison (Fixed)

`core/condition.lua:320`, unguarded use in `warrior/action.lua:925`

Comparing `false` with a number raises an error. Almost every caller checks `IsSpellLearnt` first, except `ShieldBlock`, which compares the Revenge cooldown directly. Revenge (level 14) comes before Shield Block (level 16), so this only bites a warrior who skipped Revenge, but it is a trap.

Fix: `IWin:IsSpellLearnt("Revenge")` before the comparison.

## Minor: robustness and quality

### m-1 Item names matched as Lua patterns (Fixed)

`core/action.lua:135`, `core/condition.lua:1426, 1441`

`strfind(itemLink, item)` treats the name as a pattern. In "Freshly-Squeezed Lemonade" and "Sun-Parched Waterskin", `-` is a quantifier, so these items are never found. `GetItemCountInBag` also counted slots, not items.

Fix:
- plain substring search, `string.find(link, item, 1, true)`, which keeps partial names working, as in `IsItemInBag("Firestone")`;
- stack sizes are added up with `GetContainerItemInfo`;
- `UseItem` returns `true` when it used an item.

### m-2 `/ihydrate` drink choice and double use (Fixed)

`core/action.lua:147-161`

The drink tables are walked with `pairs` order, which is arbitrary. The "Drink" buff only appears after the server answers, so the loop could use a second drink in the same press.

Fix: conjured drinks first, then vendor drinks, highest required level first, and stop after the first drink used.

### m-3 Accidental or undefined globals (Fixed, except `queueTime`)

`core/condition.lua:87, 489-491, 654, 709`

- `spellID` (87) and `spellNameMaxRank` (489) were globals. For a spell without "Rank 1", `GetSpellNameMaxRank` returned the name computed for a previous spell, or errored on `nil`. Both are now locals.
- The `GetTimeToExecute` debug message printed `ttd` instead of `tte`.
- `IsPowerAvailable` used an undefined `unit` variable. That function is not called anywhere.
- **Not changed:** `queueTime` is passed to `IsSpellSkip` in about 80 calls but never defined, so it is `nil` unless another add-on creates a global with that name. It looks like a leftover parameter. It was left alone because the intent is not clear.

### m-4 Debug strings are built even when debug is off (Fixed where a `nil` can occur)

`core/condition.lua:662-667` and the power helpers

The message is concatenated before `IWin:Debug` is called. For a unit whose power type is not in `IWin_PowerType` (focus = 2, happiness = 4), `GetPowerType` concatenated `nil` and raised an error, whether debug was on or not.

Fix: `tostring()` around the power type in `GetPowerType`, `GetPower`, `GetPowerMax`, `GetPowerPercent` and `IsPowerAvailable`. Building every debug string only when debug is on would also save work on each press, but that touches every function and was not done.

### m-5 `"BOOKTYPE_SPELL"` passed as a string (Fixed)

`core/condition.lua:301, 303, 321, 425`

The constant `BOOKTYPE_SPELL` is `"spell"`. These lines passed the string `"BOOKTYPE_SPELL"`, which only works because the client falls back to the player spellbook. Line 370 already uses the constant.

### m-6 Player buff stacks and negative spell IDs (Fixed)

`core/condition.lua:43, 87-89, 210`

- The `GetBuffStack` fallback called `UnitBuff(unit, index)` with an index from `GetPlayerBuff`. That index starts at 0 and follows another list, so it returned the stacks of another buff, or 0. It now uses `GetPlayerBuffApplications(index)`.
- `GetBuffRemaining` did not adjust negative spell IDs (above 32767, which includes some Turtle spells), unlike `GetPlayerBuffIndex` at line 43. It now does.

### m-7 Druid Maul writes the start-attack throttle to the wrong table (Fixed)

`druid/action.lua:368`

Maul wrote `IWin_CombatVar["startAttackThrottle"]`. That table is reset at every press, and `StartAttack` reads `IWin_RotationVar["startAttackThrottle"]`, where the warrior's Heroic Strike and Cleave write it. The throttle after Maul had no effect.

### m-8 Shield Wall talent read once at load (Not changed)

`core/data.lua:269, 309`

`GetTalentRank("Shield Wall")` runs while the file loads, when talent data may not be available yet, and the value is never recomputed, even after a respec. In vanilla the talent is called "Improved Shield Wall" and it extends the duration rather than reducing the cooldown. Left alone because Turtle WoW's rules need checking first.

### m-9 `/iwin` parameter validation (Partly fixed)

`warrior/setup.lua`, and the druid, paladin and rogue setup files

Fixed:
- `tonumber(arguments[2]) < 0` raised an error when a non-numeric value was typed, for example `/iwin sapper abc`. Such values now get the "Possible values" message.
- The `dtbattle` and `dtberserker` messages now list `execute` and `whirlwind`, which they accept.

Not changed:
- `overpower`, `berserkerrage` and `rend` accept any value. Only `off` disables them, so a typo in `off` means "on".
- `rageinfo` computes reserve values that it never prints (lines 252-259).

### m-10 Rogue `energyPerSecondPrediction` (Error fixed, rest not changed)

`rogue/action.lua:5-8`

`IWin_Settings["energyPerSecondPrediction"]` is never initialized, so `nil * 2` would error while a buff named exactly "Adrenaline" is active. It now defaults to 0.

Not changed: the rogue ability's buff is called "Adrenaline Rush", and `IWin_CombatVar["energyPerSecondPrediction"]` is not read anywhere. These lines can probably be removed, or the buff name fixed, depending on what was intended.

### m-11 Druid rage estimate at the end of combat (Withdrawn)

`druid/event.lua:46-48`

Unlike the warrior, the druid does not set `IWin_RLS` to `nil` at the end of combat. On closer reading the result is the same: `IWin_RLS_lastRage = nil` stops the rage samples, so `IWin_RLS` keeps the last estimate. `GetRagePerSecond` then returns `max(setting, w1)`, exactly like the warrior's `IWin_RLS_lastValue`. No change.

### m-12 `targettarget` kept in the target cache, druid command order (Fixed)

`core/condition.lua:1260-1282`, `druid/rotation.lua:134, 144, 155`

- `IWin_Target["exists"]` and `["name"]` are only reset on `PLAYER_TARGET_CHANGED`. `IsInRange` also passes `"targettarget"` (warrior Intervene), which changes without the player changing target, so its existence stayed frozen at the first answer. `IsExists` and `GetName` now cache only `"target"` and `"player"`.
- The druid `/ichase`, `/irun` and `/itaunt` commands called `TargetEnemy` before `InitializeRotation`, so `TargetEnemy` read the cache of the previous key press. They now use the same order as every other command.

## What is done well

- Clear, consistent split per class: data, condition, action, event, setup, rotation.
- Systematic per-press caching, so few repeated API calls while spamming.
- A detailed debug mode, very useful to understand a rotation decision.
- Rage and energy reservation for the next big spells: real resource management rather than a plain priority list.
- Rage-per-second estimate with recursive least squares: nicely done.
- Lua 5.0 idioms are respected (`string.gfind`, `arg`, no `#` or `select`), and `IsSpellLearnt` checks are almost everywhere.

## Limits of this review

- Code reading only, at commit `e5908a2`. The behaviors described are deduced from the code and the 1.12 API; they were not observed in game.
- Syntax was checked with `luac -p` from Lua 5.1, since no Lua 5.0 compiler was available. That catches syntax errors only.
- Not every Turtle WoW rule was checked. The author confirmed that Pummel is usable in Battle Stance on Turtle WoW, so swapping from Defensive to Battle Stance before Pummel is correct.
- The add-on only works with an English client: combat log texts ("dodge", "parry", "blocked"), tooltips ("sec cast", "Speed"), item subtypes ("Shields", "Daggers") and spell names. That is not a bug, but it could be mentioned in the README.
- The hunter, mage, priest, shaman and warlock modules are skeletons and were not reviewed beyond M-2.
