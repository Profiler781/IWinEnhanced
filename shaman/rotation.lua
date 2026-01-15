if UnitClass("player") ~= "Shaman" then return end

SLASH_IDPSSHAMAN1 = "/idps"
function SlashCmdList.IDPSSHAMAN()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	
	IWin:StartAttack()
end
