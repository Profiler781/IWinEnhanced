# `/idefend` — Defensive Shield Swap Command

**Status**: Implemented — equip mechanism uses SuperCleveRoidMacros `/equipoh` via `RunSlashCmd`

## Feature Summary
A 3-phase deterministic warrior command: equip a shield, cast defensive cooldowns, and swap back to dual-wield on demand. The shield itself is the primary defensive tool — cooldowns are optional. Swap-back is always manual (shift + keybind), never automatic.

## Design Rationale
Furyprot warriors benefit from sword-and-board as a defensive posture independent of cooldowns. Equipping a shield gives +block chance, +armor, and access to Shield Block/Shield Bash. The addon should not auto-remove the shield based on buff expiry — the player decides when to return to DW.

## Confirmed Requirements
- **Shield config**: `/iwin shield <name>` — user configures shield name once. DW weapons auto-remembered on first swap.
- **Last Stand threshold**: `/iwin laststand <percent>` — configurable HP% below which Last Stand takes priority over Shield Wall.
- **Shield Wall**: Cast on Phase 2 press when off cooldown and shield is equipped.
- **Last Stand**: Cast on Phase 2 press. Takes priority over Shield Wall when HP < threshold.
- **Shield Block**: EXCLUDED — player manages manually.
- **Stance**: Auto-swap to Defensive Stance during Phase 1 (nearly always a no-op for furyprot).
- **Swap-back**: Only via shift + `/idefend`. Never automatic.
- **Normal rotations preserve shield**: `/ifuryprot` and `/ifuryprotaoe` do not touch equipment.
- **Error handling**: If no shield configured, print error and do nothing.

## `/idefend` Behavior (3-phase deterministic)

### Normal press (no modifier):

**Phase 1 — Shield not equipped:**
1. Save current MH (slot 16) and OH (slot 17) weapon names to `IWin_Settings` (persists across reloads)
2. Equip configured shield via SuperCleveRoidMacros `/equipoh`
3. Swap to Defensive Stance if not already there
4. May take 2 presses: press 1 = equip shield, press 2 = stance swap (follows existing 2-press pattern)

**Phase 2 — Shield equipped:**
Cast one defensive cooldown per press in priority order:
1. **Last Stand** — if `HP < /iwin laststand threshold` AND off cooldown AND buff not active
2. **Shield Wall** — if off cooldown AND buff not active
3. **Last Stand** — if off cooldown AND buff not active (normal priority when HP above threshold)

If all cooldowns are active or on CD, the press does nothing. Player uses `/ifuryprot` or `/ifuryprotaoe` for their rotation.

### Shift + press (modifier):

**Phase 3 — Swap back to DW:**
Re-equip saved OH weapon via SuperCleveRoidMacros `/equipoh`. Only fires when shift is held AND shield is currently equipped. MH is never changed (stays in slot 16 throughout). Stance left as-is (Defensive is already the furyprot default).

## State Detection
State is implicit — no flags or combat variables needed:
- `not IsShieldEquipped()` → Phase 1
- `IsShieldEquipped() and not IsShiftKeyDown()` → Phase 2
- `IsShieldEquipped() and IsShiftKeyDown()` → Phase 3

## Spam Protection
Built into the existing GCD system:
- Each phase sets `queueGCD = false`, preventing multiple actions per key press
- Equipment swap triggers ~1.5s GCD
- Shield Wall / Last Stand each consume a GCD
- Result: mashing the keybind naturally sequences through phases at ~1.5s intervals
- Shift must be deliberately held — accidental swap-back requires holding a modifier while panic-pressing

## Equipment Swap Mechanism
**Approach**: Call SuperCleveRoidMacros' `/equipoh` slash command handler from Lua via dynamic `SlashCmdList` lookup.

```lua
function IWin:RunSlashCmd(cmd, args)
    for name, handler in pairs(SlashCmdList) do
        local i = 1
        while _G["SLASH_" .. name .. i] do
            if _G["SLASH_" .. name .. i] == cmd then
                handler(args or "")
                return
            end
            i = i + 1
        end
    end
end
```

- Phase 1: `IWin:RunSlashCmd("/equipoh", IWin_Settings["shield"])`
- Phase 3: `IWin:RunSlashCmd("/equipoh", IWin_Settings["savedOH"])`

**Why this approach**: SuperCleveRoidMacros is a mandatory dependency that already provides proven, in-combat equip-by-name functionality via `/equip`, `/equipoh`, `/equipmh`. Calling its handler from Lua is reliable and avoids reimplementing bag search + cursor manipulation.

**Failed approaches** (do NOT revisit):
- `EquipItemByName(name, slot)` — Does not exist in WoW 1.12.1 API
- `PickupContainerItem` + `PickupInventoryItem` cursor swap — Silently fails for weapon equipping in practice

## Files Modified
- `warrior/data.lua` — Rage costs for Shield Wall (0), Last Stand (0)
- `warrior/event.lua` — Default settings: shield, laststand, savedMH, savedOH
- `warrior/setup.lua` — Settings validation + assignment + help text
- `warrior/action.lua` — Action functions: RunSlashCmd, SaveDualWieldWeapons, EquipShield, ReequipDualWield, DefensiveStanceDefend, LastStandDefend, ShieldWallDefend, LastStandDefendNormal
- `warrior/rotation.lua` — `/idefend` slash command
