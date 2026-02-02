if UnitClass("player") ~= "Warrior" then return end

IWin_CombatVar = {
	["GCD"] = 0,
	["startAttackThrottle"] = 0,
	["overpowerAvailable"] = 0,
	["revengeAvailable"] = 0,
	["reservedRage"] = 0,
	["reservedRageStance"] = nil,
	["reservedRageStanceLast"] = 0,
	["charge"] = 0,
	["queueGCD"] = true,
	["slamQueued"] = false,
	["swingAttackQueued"] = false,
	["slamCasting"] = 0,
	["slamGCDAllowed"] = 0,
	["slamClipAllowedMax"] = 0,
	["slamClipAllowedMin"] = 0,
}

IWin_Target = {
	["trainingDummy"] = false,
	["elite"] = false,
	["boss"] = false,
	["whitelistBoss"] = false,
	["blacklistFear"] = false,
	["blacklistAOEDebuff"] = false,
	["blacklistAOEDamage"] = false,
	["blacklistKick"] = false,
	["whitelistCharge"] = false,
	["creatureType"] = nil,
}