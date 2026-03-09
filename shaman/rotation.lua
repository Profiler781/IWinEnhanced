if UnitClass("player") ~= "Shaman" then return end

SLASH_IDPSSHAMAN1 = "/idps"
function SlashCmdList.IDPSSHAMAN()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:MoltenBlast()
	IWin:Earthquake()
	IWin:ChainLightning()
	IWin:LightningBolt()
	IWin:StartAttack()
end
