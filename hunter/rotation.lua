if UnitClass("player") ~= "Hunter" then return end

SLASH_IDPSHUNTER1 = "/idps"
function SlashCmdList.IDPSHUNTER()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	
	IWin:StartAttack()
end
