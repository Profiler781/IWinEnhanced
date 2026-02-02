# Furyprot Tank Rotations Design

## Overview

Add two new slash commands for Furyprot hybrid tank specialization: `/ifuryprot` (single-target) and `/ifuryprotaoe` (AoE). These are separate from the existing `/itank` and `/ihodor` commands which serve Defensive Tactics / Deep Protection specs.

Furyprot is locked into Defensive Stance full-time, dual-wields primarily, and relies on Bloodthirst + Sunder Armor for threat. Key differentiators: auto-taunt when aggro is lost, rage-gated Heroic Strike / Cleave as off-GCD next-swing abilities, and dynamic Sunder/BT priority based on Sunder stack count.

## Rotation Priorities

### `/ifuryprot` — Single-Target

| # | Function | Condition Notes |
|---|----------|-----------------|
| 1 | `InitializeRotation()` | Reset combat vars |
| 2 | `TargetEnemy()` | Auto-target |
| 3 | `CancelSalvation()` | Remove threat reduction |
| 4 | `BattleShoutRefreshOOC()` | Pre-pull shout |
| 5 | `ChargePartySize()` | Gap close |
| 6 | `IntervenePartySize()` | Party utility |
| 7 | `InterceptPartySize()` | Gap close |
| 8 | `TankStance()` | Lock Defensive Stance |
| 9 | `Bloodrage()` | Free rage + Enrage |
| 10 | `Taunt()` | Auto-taunt when `not IsTanking()` |
| 11 | `MockingBlow()` | Backup when Taunt on CD + `not IsTanking()` |
| 12 | `DeathWishBurst()` | Auto Death Wish via TTK logic, gated by `burst` setting |
| 13 | `HeroicStrikeFuryprot()` | **Off-GCD**, only when rage >= 50 |
| 14 | `SunderArmorFirstStack()` | Sunder if target has 0 stacks (top GCD priority) |
| 15 | `Bloodthirst()` | Keep on CD (top GCD priority when stacks >= 1) |
| 16 | `SunderArmor()` | Continue stacking to 5 / maintain |
| 17 | `Revenge()` | Use when proc'd |
| 18 | `BattleShoutRefresh()` | Maintain buff |
| 19 | `BerserkerRage()` | Rage gen / fear break |
| 20 | `Perception()` | Human racial |
| 21 | `StartAttack()` | Ensure auto-attack |

### `/ifuryprotaoe` — AoE

| # | Function | Condition Notes |
|---|----------|-----------------|
| 1 | `InitializeRotation()` | Reset combat vars |
| 2 | `TargetEnemy()` | Auto-target |
| 3 | `CancelSalvation()` | Remove threat reduction |
| 4 | `BattleShoutRefreshOOC()` | Pre-pull shout |
| 5 | `ChargePartySize()` | Gap close |
| 6 | `IntervenePartySize()` | Party utility |
| 7 | `InterceptPartySize()` | Gap close |
| 8 | `TankStance()` | Lock Defensive Stance |
| 9 | `Bloodrage()` | Free rage + Enrage |
| 10 | `Taunt()` | Auto-taunt when `not IsTanking()` |
| 11 | `MockingBlow()` | Backup when Taunt on CD + `not IsTanking()` |
| 12 | `DeathWishBurst()` | Auto Death Wish via TTK logic, gated by `burst` setting |
| 13 | `CleaveFuryprot()` | **Off-GCD**, only when rage >= 40 |
| 14 | `SunderArmorFirstStack()` | Sunder if target has 0 stacks |
| 15 | `DemoralizingShout()` | Snap AoE threat on pull |
| 16 | `BloodthirstFuryprotAOE()` | Only when rage >= 60 (preserve rage for Cleaves) |
| 17 | `SunderArmor()` | Continue stacking / maintain |
| 18 | `ThunderClap()` | AoE threat + attack speed debuff |
| 19 | `Revenge()` | Use when proc'd |
| 20 | `BattleShoutRefresh()` | Maintain buff |
| 21 | `BerserkerRage()` | Rage gen / fear break |
| 22 | `HeroicStrikeFuryprot()` | **Off-GCD**, fallback rage dump at >= 50 |
| 23 | `Perception()` | Human racial |
| 24 | `StartAttack()` | Ensure auto-attack |

## Key Design Decisions

### Sunder / Bloodthirst Dynamic Priority
- **0 Sunder stacks on target**: Sunder takes top GCD priority (frontload threat)
- **>= 1 Sunder stack**: Bloodthirst takes priority (keep on CD for sustained threat)
- Implemented via existing `SunderArmorFirstStack()` (checks `not IsBuffActive("target", "Sunder Armor")`) placed above `Bloodthirst()` in both rotations

### Heroic Strike / Cleave as Off-GCD Abilities
These queue on the next weapon swing and don't consume a GCD. They layer on top of the GCD-based rotation. Rage-gated to prevent starving core abilities:
- **Heroic Strike**: fires only at >= 50 rage (ensures 30+ left for Bloodthirst)
- **Cleave**: fires only at >= 40 rage (ensures 20+ left for Sunder + continued Cleaving)

### Bloodthirst Rage Gate (AoE only)
In AoE, Bloodthirst only fires at >= 60 rage. At 60 rage: BT costs 30, leaving 30 — enough for Cleave (20) + Sunder (10). Keeps Cleave uptime high on multi-target.

### Auto-Taunt
Both rotations include Taunt > Mocking Blow priority when `IsTanking()` is false. Uses existing `Taunt()` and `MockingBlow()` functions which already have the correct aggro-loss guards, stance-swap logic, and `IsTaunted()` duplicate prevention.

### Excluded Abilities (Manual Only)
- **Interrupts**: Shield Bash — reactive decision per target
- **Defensive CDs**: Shield Block, Shield Wall, Last Stand — require healer coordination
- **Challenging Shout**: excluded per user preference
- **Slam**: furyprot has no Improved Slam talent
- **Defensive Tactics stance-dance**: furyprot doesn't talent into DT
- **Mortal Strike / Shield Slam / Concussion Blow**: not in furyprot toolkit

### Death Wish
Reuses existing `DeathWishBurst()` + `IsDeathWishBurstAvailable()` TTK logic from `/idps` and `/icleave`. Gated by the existing `burst` setting (`/iwin burst on/off`).

## New Code

### New Action Functions (`warrior/action.lua`)

```lua
-- Heroic Strike with 50 rage threshold for furyprot
function IWin:HeroicStrikeFuryprot()
    if IWin:IsSpellLearnt("Heroic Strike")
        and UnitMana("player") >= 50
        and not IsCurrentAction(IWin:GetActionSlot("Heroic Strike")) then
            CastSpellByName("Heroic Strike")
    end
end

-- Cleave with 40 rage threshold for furyprot
function IWin:CleaveFuryprot()
    if IWin:IsSpellLearnt("Cleave")
        and UnitMana("player") >= 40
        and not IsCurrentAction(IWin:GetActionSlot("Cleave")) then
            CastSpellByName("Cleave")
    end
end

-- Bloodthirst with 60 rage gate for AoE (preserve rage for Cleaves)
function IWin:BloodthirstFuryprotAOE()
    if UnitMana("player") >= 60 then
        IWin:Bloodthirst(IWin_Settings["GCD"])
    end
end
```

> **Note**: The HS/Cleave functions above are pseudocode. The exact mechanism for checking if HS/Cleave is already queued and the rage check method need to match existing patterns in the codebase (e.g., `IsRageAvailable` vs raw `UnitMana`). Review existing `HeroicStrike()` and `Cleave()` implementations during implementation.

### New Rotation Commands (`warrior/rotation.lua`)

Two new `SlashCmdList` entries with the priority orders defined above.

## Files Modified

| File | Changes |
|------|---------|
| `warrior/action.lua` | Add `HeroicStrikeFuryprot()`, `CleaveFuryprot()`, `BloodthirstFuryprotAOE()` |
| `warrior/rotation.lua` | Add `/ifuryprot` and `/ifuryprotaoe` slash commands |

## Files NOT Modified

- `warrior/init.lua` — no new combat vars needed
- `warrior/data.lua` — all rage costs already exist in `IWin_RageCost`
- `warrior/condition.lua` — `IsTanking()` already exists
- `warrior/event.lua` — no new events needed
- `warrior/setup.lua` — reuses existing `burst` setting
- Existing `/itank` and `/ihodor` — preserved untouched

## Verification

After implementation, test in-game with `/reload`:

1. **Basic rotation**: `/ifuryprot` on a target dummy — verify BT and Sunder fire, HS queues at 50+ rage
2. **Sunder priority**: Target with 0 sunders — verify Sunder fires before BT. After 1+ stacks — verify BT fires first
3. **AoE rotation**: `/ifuryprotaoe` on multiple mobs — verify Cleave queues at 40+ rage, Demo Shout fires early
4. **AoE BT gate**: Watch rage bar — BT should only fire at 60+ rage in AoE
5. **Auto-taunt**: Have another player pull aggro — verify Taunt fires automatically, Mocking Blow fires if Taunt is on CD
6. **Death Wish**: Verify auto-burst triggers based on TTK thresholds with `/iwin burst on`
