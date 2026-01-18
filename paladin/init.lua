if UnitClass("player") ~= "Paladin" then return end

IWin.hasPallyPower = PallyPower_SealAssignments and true or false

IWin_CombatVar = {
	["startAttackThrottle"] = 0,
	["weaponAttackSpeed"] = 0,
}

IWin_Target = {
	["trainingDummy"] = false,
	["whitelistBoss"] = false,
	["elite"] = false,
	["boss"] = false,
}