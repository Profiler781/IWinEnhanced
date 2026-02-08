if UnitClass("player") ~= "Rogue" then return end

IWin_CombatVar = {
	["energyPerSecondPrediction"] = 0,
	["GCD"] = 0,
	["queueGCD"] = true,
	["reservedEnergy"] = 0,
	["riposteAvailable"] = 0,
	["startAttackThrottle"] = 0,
	["surpriseAttackAvailable"] = 0,
	["swingAttackQueued"] = false,
}

IWin_Target = {
	["boss"] = false,
}