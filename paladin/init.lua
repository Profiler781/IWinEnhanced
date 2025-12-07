if UnitClass("player") ~= "Paladin" then return end

IWin.hasPallyPower = PallyPower_SealAssignments and true or false

IWin_CombatVar = {
	["GCD"] = 0,
	["startAttackThrottle"] = 0,
	["weaponAttackSpeed"] = 0,
	["queueGCD"] = true,
}

IWin_Target = {
	["trainingDummy"] = false,
	["whitelistBoss"] = false,
	["elite"] = false,
	["boss"] = false,
}