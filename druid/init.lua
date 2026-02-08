if UnitClass("player") ~= "Druid" then return end

IWin_CombatVar = {
	["energyPerSecondPrediction"] = 0,
	["lastMoonkinSpell"] = "Starfire",
	["lastMoonkinSpellTime"] = 0,
	["queueGCD"] = true,
	["reservedEnergy"] = 0,
	["reservedRage"] = 0,
	["startAttackThrottle"] = 0,
	["swingAttackQueued"] = false,
}

IWin_Target = {
	["blacklistAOEDamage"] = false,
	["blacklistAOEDebuff"] = false,
	["blacklistFear"] = false,
}

IWin_CastTime = {}