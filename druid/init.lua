if UnitClass("player") ~= "Druid" then return end

IWin_CombatVar = {
	["reservedRage"] = 0,
	["startAttackThrottle"] = 0,
	["reservedEnergy"] = 0,
	["queueGCD"] = true,
	["swingAttackQueued"] = false,
	["lastMoonkinSpell"] = "Starfire",
	["lastMoonkinSpellTime"] = 0,
	["energyPerSecondPrediction"] = 0,
}

IWin_Target = {
	["blacklistFear"] = false,
	["blacklistAOEDebuff"] = false,
	["blacklistAOEDamage"] = false,
}