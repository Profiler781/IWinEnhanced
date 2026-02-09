if UnitClass("player") ~= "Rogue" then return end

SLASH_IDPSROGUE1 = "/idps"
function SlashCmdList.IDPSROGUE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()

	--openers
	IWin:PickPocket()
	IWin:Ambush()
	IWin:Garrote()
	IWin:CheapShot()

	--cooldowns
	--IWin:AdrenalineRush()
	--IWin:BladeFlurry()

	--finishers
	IWin:SliceAndDice()
	IWin:SetReservedEnergySliceAndDice()
	IWin:ExposeArmor()
	IWin:SetReservedEnergyExposeArmor()
	IWin:ShadowOfDeath()
	IWin:SetReservedEnergyShadowOfDeath()
	IWin:Rupture()
	IWin:SetReservedEnergyRupture()
	IWin:Envenom()
	IWin:SetReservedEnergyEnvenom()
	IWin:Evicerate()
	IWin:SetReservedEnergyEvicerate()

	--utilities
	IWin:Riposte()
	IWin:Gouge()
	IWin:SetReservedEnergyGouge()

	--combo builders
	IWin:SurpriseAttack()
	IWin:SetReservedEnergy("Surprise Attack", "cooldown")
	IWin:NoxiousAssault()
	IWin:SetReservedEnergy("Noxious Assault", "nocooldown")
	IWin:Hemorrhage()
	IWin:SetReservedEnergy("Hemorrhage", "nocooldown")
	IWin:Backstab()
	IWin:SetReservedEnergyBackstab()
	IWin:SinisterStrike()

	IWin:StartAttack()
end

SLASH_IKICKROGUE1 = "/ikick"
function SlashCmdList.IKICKROGUE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()

	IWin:Kick()
	IWin:DeadlyThrow()

	IWin:StartAttack()
end
