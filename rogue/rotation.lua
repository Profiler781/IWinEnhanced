if UnitClass("player") ~= "Rogue" then return end

SLASH_IDPSROGUE1 = "/idps"
function SlashCmdList.IDPSROGUE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	
	IWin:StartAttack()
end
