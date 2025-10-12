# IWinEnhanced v1.3

Smart macros for Turtle Warriors v1.18.0. Make macros with commands. Put them on your action bars. Enjoy!

Author: Agamemnoth (discord)

Special thanks to contributor: Vlad (discord tfw.vlad)

## Commands

    /idps        Single target DPS rotation
    /icleave     Multi target DPS rotation
    /itank       Single target threat rotation
    /ihodor      Multi target threat rotation
    /ichase      Stick to your target with Charge, Intercept, Hamstring
    /ikick       Kick with Pummel or Shield Bash
    /ifeardance  Use Berserker Rage if available
    /itaunt      Taunt or Mocking Blow if the target is not under another taunt effect
    /ishoot      Shoot with bow, crossbow, gun or throw

## Setup commands

    /iwin                             Current setup
    /iwin charge <partySize>          Setup for Charge and Intercept.
    /iwin sunder <priority>           Setup for Sunder Armor priority as DPS.
    /iwin demo <toggle>               Setup for Demoralizing Shout.
    /iwin dt <stance>                 Setup to allow stances with Defensive Tactics.
    /iwin ragebuffer <number>         Setup to save 100% required rage for spells X seconds before the spells are used.
    /iwin ragegain <number>           Setup to anticipate rage gain per second. Required rage will be saved gradually before the spells are used.
    /iwin jousting <toggle>           Setup for jousting solo DPS.

partySize possible values: raid, group, solo, off.

priority possible values: high, low, off.

toggle possible values: on, off.

stance possible values: battle, defensive, berserker.

number possible values: 0 or more.

Example: /iwin charge group
=> Will setup charge usable in rotations while in group or solo.

## Required Mods & Addons

Mandatory Mods:
* [SuperWoW](https://github.com/balakethelock/SuperWoW/), A mod made for fixing client bugs and expanding the lua-based API used by user interface addons. Used for debuff tracking.

Optionnal Mods:
* [Nampower](https://github.com/pepopo978/nampower/), A mod made to dramatically increase cast efficiency on the 1.12.1 client. Used for range checks.

You need one of the following addons:
* [pfUI](https://shagu.org/pfUI/), A full UI replacement.
* [ShaguTweaks](https://shagu.org/ShaguTweaks/), A non-intrusive quality of life addon.

Optionnal Addons:
* [SP_SwingTimer](https://github.com/Profiler781/SP_SwingTimer), An auto attack swing timer. Used for Slam.