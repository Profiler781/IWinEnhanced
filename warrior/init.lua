if UnitClass("player") ~= "Warrior" then return end

IWin_CombatVar = {
	["slamQueued"] = false
}

IWin_RotationVar = {
	["overpowerAvailable"] = 0,
	["revengeAvailable"] = 0,
	["reservedRageStance"] = nil,
	["reservedRageStanceLast"] = 0,
	["charge"] = 0,
	["slamCasting"] = 0,
	["slamGCDAllowed"] = 0,
	["slamClipAllowedMax"] = 0,
	["slamClipAllowedMin"] = 0,
}