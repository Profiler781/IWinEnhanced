SLASH_IHYDRATE1 = "/ihydrate"
function SlashCmdList.IHYDRATE()
	IWin:InitializeRotation()
	IWin:UseItemDrink()
end

SLASH_INUKE1 = "/inuke"
function SlashCmdList.INUKE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:UseItemTrinketOffensivePrepull(true, true)
	IWin:UseItemConsumableOffensiveNoGCD(true, true)
	IWin:UseItemTrinketOffensiveNoGCD(true, true)
	IWin:CastCDShortOffensiveNoGCD(true, true)
	IWin:UseItemTrinketOffensiveGCD(true, true)
	IWin:CastCDShortOffensiveGCD(true, true)
	IWin:CastCDLongOffensiveGCD(true, true)
	IWin:StartAttack()
end

SLASH_ICONSUMABLE1 = "/iconsumable"
function SlashCmdList.ICONSUMABLE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:UseItemConsumableOffensiveNoGCD(true, true)
	IWin:StartAttack()
end

SLASH_ICONSUMABLEAOE1 = "/iconsumableaoe"
function SlashCmdList.ICONSUMABLEAOE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:UseItemConsumableAOEOffensiveNoGCD(true, true, "meleeAutoAttack")
	IWin:UseItemConsumableAOEOffensiveGCD(true, true, "meleeAutoAttack")
	IWin:StartAttack()
end

SLASH_ITRINKET1 = "/itrinket"
function SlashCmdList.ITRINKET()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:UseItemTrinketOffensivePrepull(true, true)
	IWin:UseItemTrinketOffensiveNoGCD(true, true)
	IWin:UseItemTrinketOffensiveGCD(true, true)
	IWin:StartAttack()
end

SLASH_ICDSHORT1 = "/icdshort"
function SlashCmdList.ICDSHORT()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:CastCDShortOffensiveNoGCD(true, true)
	IWin:CastCDShortOffensiveGCD(true, true)
	IWin:StartAttack()
end

SLASH_ICDLONG1 = "/icdlong"
function SlashCmdList.ICDLONG()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:CastCDLongOffensiveGCD(true, true)
	IWin:StartAttack()
end