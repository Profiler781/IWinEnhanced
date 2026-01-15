if UnitClass("player") ~= "Warlock" then return end

SLASH_IDPSWARLOCK1 = "/idps"
function SlashCmdList.IDPSWARLOCK()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	
	IWin:StartAttack()
end

SLASH_IECOWARLOCK1 = "/ieco"
function SlashCmdList.IECOWARLOCK()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:PetAttack()
	IWin:SummonVoidwalker()
	IWin:SummonImp()
	IWin:DemonArmor()
	IWin:Firestone()
	IWin:DrainSoul()
	IWin:Shoot()
	IWin:Immolate()
	IWin:ShadowBolt()
	IWin:StartAttack()
end