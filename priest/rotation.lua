if UnitClass("player") ~= "Priest" then return end

SLASH_IDPSPRIEST1 = "/idps"
function SlashCmdList.IDPSPRIEST()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	
	IWin:StartAttack()
end
