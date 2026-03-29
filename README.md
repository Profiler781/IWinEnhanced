# IWinEnhanced v2.4

1-button rotation macros for Turtle Druids, Paladins, Rogues and Warriors.

Updated for Turtle WoW 1.18.1.

Author: Agamemnoth - Ambershire

Contributors: Vlad/Goodnice - Tel'Abim, Jrc13245/Torio

## Latest features

- /iconsumableaoe macro to use AOE Consumables. Minimum target setup per consumable.
- Rogue module!
- /iconsumable macro to use Consumables.
- /itrinket macro to use Trinkets.
- /icdshort macro to use Short Cooldowns.
- /icdlong macro to use Long Cooldowns (> 5min).
- Energy pooling for rogue and druid

## Mods Dependencies

Mandatory Mods:
* [SuperWoW](https://github.com/balakethelock/SuperWoW), A mod made for fixing client bugs and expanding the lua-based API used by user interface addons. Used for debuff tracking.
* [UnitXP](https://codeberg.org/konaka/UnitXP_SP3/releases), Advanced macro conditions and syntax.
* [Nampower](https://gitea.com/avitasia/nampower/releases), Increase cast efficiency on the 1.12.1 client. Used for range checks.

## Addons Dependencies

Mandatory Addons:
* [SuperCleveRoidMacros](https://github.com/jrc13245/SuperCleveRoidMacros), Even more advanced macro conditions and syntax.

Optionnal Addons:
* [SP_SwingTimer](https://github.com/MarcelineVQ/SP_SwingTimer), An auto attack swing timer. Used for Slam.
* [PallyPowerTW](https://github.com/ivanovlk/PallyPowerTW), Paladin blessings, auras and judgements assignements.
* [LibramSwap](https://github.com/Profiler781/Libramswap), Automatically swap librams based on cast.
* [TimeToKill](https://github.com/jrc13245/TimeToKill), Advanced time-to-kill estimation using RLS (Recursive Least Squares) algorithm. Used for raid targets.
* [MonkeySpeed](https://github.com/Profiler781/MonkeySpeed), Track player's movement speed. Used to postpone casted spells.
* [DoiteAura](https://github.com/Player-Doite/DoiteAuras), Ability, buff, debuff & item tracker for Vanilla WoW. Used to track player's buff above buff cap.

# Druid Module

## Macros

    /iblast         Single target caster rotation
    /iruetoo        Single target cat rotation
    /itank          Single target bear rotation
    /ihodor         Multi target bear rotation
    /itaunt         Growl if the target is not under another taunt effect
    /ihydrate       Use conjured or vendor water
    /inuke          Use cooldowns, trinkets and consumables
    /iconsumable    Use consumables
    /itrinket       Use trinkets
    /icdshort       Use short cooldowns

## Setup commands

    /iwin                                       Current setup
    /iwin debug <toggle>                        Enable/disable debug.
    /iwin consumableoffensive <classification>  Use offensive consumables on target: Juju Flurry, Mighty Rage Potion, Potion of Quickness.
    /iwin consumableaoe <classification>        Use AOE consumables on target: Oil of Immolation, Stratholme Holy Water, Goblin Sapper Charge, Dense Dynamite.
    /iwin oilofimmolation <number>              Minimum targets for Oil of Immolation. 0 to disable.
    /iwin holywater <number>                    Minimum targets for Stratholme Holy Water. 0 to disable.
    /iwin sapper <number>                       Minimum targets for Goblin Sapper Charge. 0 to disable.
    /iwin densedynamite <number>                Minimum targets for Dense Dynamite. 0 to disable.
    /iwin trinketoffensive <classification>     Use offensive trinkets on target.
    /iwin cdshortoffensive <classification>     Use short offensive CDs on target: Berserk.
    /iwin cdlongoffensive <classification>      Use long offensive CDs on target: N/A.
    /iwin frontshred <toggle>                   Attempt Front Shredding.

toggle possible values: on, off.

classification possible values: boss, elite, all, off.

number possible values: 0 or more.

Example: /iwin frontshred on
=> Use shred while in front of the target. You must strafe through the mob and spam the macro.

# Paladin Module

## Macros

    /idps           Single target DPS rotation
    /icleave        Multi target DPS rotation
    /itank          Single target Prot rotation
    /ihodor         Multi target Prot rotation
    /ieco           Mana regeneration rotation
    /ijudge         Seal and Judgement only
    /istun          Stun with Hammer of Justice or Repentance
    /itaunt         Hand of Reckoning if the target is not under another taunt effect
    /ibubblehearth  Divine Shield and Hearthstone. Shame!
    /ihydrate       Use conjured or vendor water
    /inuke          Use cooldowns, trinkets and consumables
    /iconsumable    Use consumables
    /itrinket       Use trinkets
    /icdshort       Use short cooldowns

## Setup commands

    /iwin                                       Current setup
    /iwin debug <toggle>                        Enable/disable debug.
    /iwin consumableoffensive <classification>  Use offensive consumables on target: Juju Flurry, Potion of Quickness.
    /iwin consumableaoe <classification>        Use AOE consumables on target: Oil of Immolation, Stratholme Holy Water, Goblin Sapper Charge, Dense Dynamite.
    /iwin oilofimmolation <number>              Minimum targets for Oil of Immolation. 0 to disable.
    /iwin holywater <number>                    Minimum targets for Stratholme Holy Water. 0 to disable.
    /iwin sapper <number>                       Minimum targets for Goblin Sapper Charge. 0 to disable.
    /iwin densedynamite <number>                Minimum targets for Dense Dynamite. 0 to disable.
    /iwin trinketoffensive <classification>     Use offensive trinkets on target.
    /iwin cdshortoffensive <classification>     Use short offensive CDs on target: Perception.
    /iwin cdlongoffensive <classification>      Use long offensive CDs on target: N/A.
    /iwin judgement <judgementName>             Use the Judgement to debuff target.
    /iwin wisdom <classification>               Use Seal of Wisdom debuff on target.
    /iwin crusader <classification>             Use Seal of the Crusader debuff on target.
    /iwin light <classification>                Use Seal of Light debuff on target.
    /iwin justice <classification>              Use Seal of Justice debuff on target.
    /iwin soc <socOption>                       Use Seal of Command over Seal of Righteousness.

judgementName possible values: wisdom, light, crusader, justice, off.

socOption possible values: auto, on, off.

classification possible values: boss, elite, all, off.

toggle possible values: on, off.

number possible values: 0 or more.

Example: /iwin wisdom boss
=> Judge wisdom on boss if it's the selected judgement debuff.

# Rogue Module

## Macros

    /idps           Single + Multi target DPS rotation
    /idpsfocus      Single target DPS rotation
    /ikick          Use Kick or Deadly Throw while the target is casting
    /inuke          Use cooldowns, trinkets and consumables
    /iconsumable    Use consumables
    /itrinket       Use trinkets
    /icdshort       Use short cooldowns

## Setup commands

    /iwin                                       Current setup
    /iwin debug <toggle>                        Enable/disable debug.
    /iwin consumableoffensive <classification>  Use offensive consumables on target: Juju Flurry, Potion of Quickness.
    /iwin consumableaoe <classification>        Use AOE consumables on target: Oil of Immolation, Stratholme Holy Water, Goblin Sapper Charge, Dense Dynamite.
    /iwin oilofimmolation <number>              Minimum targets for Oil of Immolation. 0 to disable.
    /iwin holywater <number>                    Minimum targets for Stratholme Holy Water. 0 to disable.
    /iwin sapper <number>                       Minimum targets for Goblin Sapper Charge. 0 to disable.
    /iwin densedynamite <number>                Minimum targets for Dense Dynamite. 0 to disable.
    /iwin trinketoffensive <classification>     Use offensive trinkets on target.
    /iwin cdshortoffensive <classification>     Use short offensive CDs on target: Adrenaline Rush, Bloodfury, Berserking, Perception.
    /iwin cdlongoffensive <classification>      Use long offensive CDs on target: N/A.
    /iwin bladeflurry <toggle>                  Use Blade Flurry.

toggle possible values: on, off.

number possible values: 0 or more.

Example: /iwin bladeflurry off
=> Does not toggle Blade Flurry.

# Warrior Module

## Macros

    /idps           Single + Multi target DPS rotation
    /idpsfocus      Single target DPS rotation
    /itank          Single target threat rotation
    /ihodor         Multi target threat rotation
    /ichase         Stick to your target with Charge, Intercept, Hamstring
    /ikick          Use Pummel or Shield Bash while the target is casting
    /ifeardance     Use Berserker Rage if available
    /itaunt         Use Taunt or Mocking Blow if the target is not under another taunt effect
    /ishoot         Shoot with bow, crossbow, gun or throw
    /inuke          Use cooldowns, trinkets and consumables
    /iconsumable    Use consumables
    /itrinket       Use trinkets
    /icdshort       Use short cooldowns
    /icdlong        Use long cooldowns

## Setup commands

    /iwin                                       Current setup
    /iwin debug <toggle>                        Enable/disable debug.
    /iwin consumableoffensive <classification>  Use offensive consumables on target: Juju Flurry, Mighty Rage Potion, Potion of Quickness.
    /iwin consumableaoe <classification>        Use AOE consumables on target: Oil of Immolation, Stratholme Holy Water, Goblin Sapper Charge, Dense Dynamite.
    /iwin oilofimmolation <number>              Minimum targets for Oil of Immolation. 0 to disable.
    /iwin holywater <number>                    Minimum targets for Stratholme Holy Water. 0 to disable.
    /iwin sapper <number>                       Minimum targets for Goblin Sapper Charge. 0 to disable.
    /iwin densedynamite <number>                Minimum targets for Dense Dynamite. 0 to disable.
    /iwin trinketoffensive <classification>     Use offensive trinkets on target.
    /iwin cdshortoffensive <classification>     Use short offensive CDs on target: Death Wish, Bloodfury, Berserking, Perception.
    /iwin cdlongoffensive <classification>      Use long offensive CDs on target: Recklessness.
    /iwin chargepartysize <number>              Use Charge, Intercept and Intervene if party member count is equal or below the setup value.
    /iwin chargenocombat <toggle>               Use Charge, Intercept and Intervene if the target is not in combat.
    /iwin chargewl <toggle>                     Use Charge, Intercept and Intervene if the target is whitelisted.
    /iwin sunder <priority>                     Use Sunder Armor priority as DPS.
    /iwin demo <toggle>                         Use Demoralizing Shout.
    /iwin dtbattle <toggle>                     Use Battle stance with Defensive Tactics.
    /iwin dtdefensive <toggle>                  Use Defensive stance with Defensive Tactics.
    /iwin dtberserker <toggle>                  Use Berserker stance with Defensive Tactics.
    /iwin ragebuffer <number>                   Save 100% required rage for spells X seconds before the spells are used.
    /iwin ragegain <number>                     Initial rage per second estimate (seed for dynamic RLS tracking).
    /iwin jousting <toggle>                     Use Hamstring to joust with target in solo DPS.
    /iwin thunderclap <toggle>                  Use Thunder Clap.
    /iwin overpower <toggle>                    Use Overpower.
    /iwin berserkerrage <toggle>                Use Berserker Rage for rage generation.
    /iwin rend <toggle>                         Use Rend.

priority possible values: high, once, low, off.

toggle possible values: on, off.

number possible values: 0 or more.

classification possible values: boss, elite, all, off.

Example: /iwin chargepartysize 5
=> Allows charge if your party has 5 players or less.
