if UnitClass("player") ~= "Mage" then return end

SLASH_IDPSMAGE1 = "/idps"
function SlashCmdList.IDPSMAGE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	
	IWin:StartAttack()
end
