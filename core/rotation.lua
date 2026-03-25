SLASH_IHYDRATE1 = "/ihydrate"
function SlashCmdList.IHYDRATE()
	IWin:InitializeRotation()
	IWin:UseItemDrink()
end

SLASH_INUKE1 = "/inuke"
function SlashCmdList.INUKE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:UseItemConsumableOffensiveNoGCD(true, true)
	IWin:UseItemTrinketOffensiveNoGCD(true, true)
	IWin:CastCDShortOffensiveNoGCD(true, true)
	IWin:UseItemTrinketOffensiveGCD(true, true)
	IWin:CastCDShortOffensiveGCD(true, true)
	IWin:CastCDLongOffensiveGCD(true, true)
	IWin:StartAttack()
end