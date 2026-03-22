# IWinEnhanced v2.3

1-button rotation macros for Turtle Druids, Paladins and Warriors.

Updated for Turtle WoW 1.18.1.

Author: Agamemnoth - Ambershire

Contributors: Vlad/Goodnice - Tel'Abim, Jrc13245/Torio

## Latest features

- Trinkets auto-use with TTK windows for warriors. Setup command.
- Consumables auto-use with TTK windows for warriors. Setup command.

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

## Setup commands

    /iwin                             Current setup
    /iwin debug <toggle>              Enable/disable debug
    /iwin frontshred <toggle>         Setup for Front Shredding
    /iwin berserkcat <toggle>         Setup for Berserk in Cat Form

toggle possible values: on, off.

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

## Setup commands

    /iwin                                   Current setup
    /iwin debug <toggle>                    Enable/disable debug.
    /iwin consumable <classification>       Use consumables on target.
    /iwin trinket <classification>          Use trinkets on target.
    /iwin judgement <judgementName>         Use the Judgement to debuff target.
    /iwin wisdom <classification>           Use Seal of Wisdom debuff on target.
    /iwin crusader <classification>         Use Seal of the Crusader debuff on target.
    /iwin light <classification>            Use Seal of Light debuff on target.
    /iwin justice <classification>          Use Seal of Justice debuff on target.
    /iwin soc <socOption>                   Use Seal of Command over Seal of Righteousness.

judgementName possible values: wisdom, light, crusader, justice, off.

socOption possible values: auto, on, off.

classification possible values: boss, elite, all, off.

Example: /iwin wisdom boss
=> Judge wisdom on boss if it's the selected judgement debuff.

# Warrior Module

## Macros

    /idps           DPS rotation for both single target and multi target
    /idpsfocus      Single target DPS rotation
    /icleave        Multi target DPS rotation
    /itank          Single target threat rotation
    /ihodor         Multi target threat rotation
    /ichase         Stick to your target with Charge, Intercept, Hamstring
    /ikick          Kick with Pummel or Shield Bash
    /ifeardance     Use Berserker Rage if available
    /itaunt         Taunt or Mocking Blow if the target is not under another taunt effect
    /ishoot         Shoot with bow, crossbow, gun or throw

## Setup commands

    /iwin                             Current setup
    /iwin debug <toggle>              Enable/disable debug.
    /iwin consumable <classification> Use consumables on target.
    /iwin trinket <classification>    Use trinkets on target.
    /iwin chargepartysize <number>    Use Charge, Intercept and Intervene if party member count is equal or below the setup value.
    /iwin chargenocombat <toggle>     Use Charge, Intercept and Intervene if the target is not in combat.
    /iwin chargewl <toggle>           Use Charge, Intercept and Intervene if the target is whitelisted.
    /iwin sunder <priority>           Use Sunder Armor priority as DPS.
    /iwin demo <toggle>               Use Demoralizing Shout.
    /iwin dtbattle <toggle>           Use Battle stance with Defensive Tactics.
    /iwin dtdefensive <toggle>        Use Defensive stance with Defensive Tactics.
    /iwin dtberserker <toggle>        Use Berserker stance with Defensive Tactics.
    /iwin ragebuffer <number>         Save 100% required rage for spells X seconds before the spells are used.
    /iwin ragegain <number>           Initial rage per second estimate (seed for dynamic RLS tracking).
    /iwin jousting <toggle>           Use Hamstring to joust with target in solo DPS.
    /iwin thunderclap <toggle>        Use Thunder Clap.
    /iwin overpower <toggle>          Use Overpower.
    /iwin berserkerrage <toggle>      Use Berserker Rage for rage generation.
    /iwin rend <toggle>               Use Rend.

priority possible values: high, once, low, off.

toggle possible values: on, off.

number possible values: 0 or more.

classification possible values: boss, elite, all, off.

Example: /iwin chargepartysize 5
=> Allows charge if your party has 5 players or less.
