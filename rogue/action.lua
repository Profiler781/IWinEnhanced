if UnitClass("player") ~= "Rogue" then return end

local GetTime = GetTime
local UnitMana = UnitMana
local GetNumPartyMembers = GetNumPartyMembers
local CastSpellByName = CastSpellByName
local GetComboPoints = GetComboPoints

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
	IWin_CombatVar["energyPerSecondPrediction"] = IWin_Settings["energyPerSecondPrediction"]
	if IWin:IsBuffActive("player", "Adrenaline", nil, false) then
		IWin_CombatVar["energyPerSecondPrediction"] = IWin_CombatVar["energyPerSecondPrediction"] * 2
	end
end

function IWin:AdrenalineRush()
	local spell = "Adrenaline Rush"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and UnitMana("player") <= 60 then
			IWin:Cast(spell)
	end
end

function IWin:Ambush()
	local spell = "Ambush"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyCostAvailable(spell)
		and IWin:IsBehind()
		and IWin:IsDaggerEquipped()
		and IWin:IsBuffActive("player", "Stealth") then
			IWin:Cast(spell)
	end
end

function IWin:Backstab()
	local spell = "Backstab"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and IWin:IsBehind()
		and IWin:IsDaggerEquipped() then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyBackstab()
	local spell = "Backstab"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBehind(false)
		and IWin:IsDaggerEquipped(false) then
			IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:BladeFlurry()

end

function IWin:CheapShot()
	local spell = "Cheap Shot"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyCostAvailable(spell)
		and IWin:IsBuffActive("player", "Stealth") then
			IWin:Cast(spell)
	end
end

function IWin:DeadlyThrow()
	local spell = "Deadly Throw"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyCostAvailable(spell)
		and IWin:IsCasting("target")
		and IWin:IsInRange(spell) then
			IWin:Cast(spell)
	end
end

function IWin:Envenom()
	local spell = "Envenom"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and IWin:GetTimeToDie() > 6
		and IWin:GetBuffRemaining("player", spell) < 3
		and GetComboPoints() < 3
		and GetComboPoints() > 0 then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyEnvenom()
	local spell = "Envenom"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:GetTimeToDie(false) > 6
		and IWin:GetBuffRemaining("player", spell, nil, false) < 3
		and GetComboPoints() < 3
		and GetComboPoints() > 0 then
			IWin:SetReservedEnergy(spell, "buff", "player")
	end
end

function IWin:Evicerate()
	local spell = "Evicerate"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and (
				IWin:IsMaxComboPoints()
				or (
						GetComboPoints() > 2
						and IWin:GetTimeToDie() < 2
					)
			) then
				IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyEvicerate()
	local spell = "Evicerate"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsMaxComboPoints(false) then
		IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:ExposeArmor()
	local spell = "Expose Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and IWin:IsBoss()
		and IWin:GetTalentRank(3, 2) == 2
		and IWin:IsMaxComboPoints()
		and IWin:GetTimeToDie() > IWin:GetBuffRemaining("target", spell)
		and IWin:GetBuffRemaining("target", spell) < 3 then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyExposeArmor()
	local spell = "Expose Armor"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBoss(false)
		and IWin:GetTalentRank(3, 2, false) == 2
		and IWin:IsMaxComboPoints(false)
		and IWin:GetTimeToDie(false) > IWin:GetBuffRemaining("target", spell, nil, false)
		and IWin:GetBuffRemaining("target", spell, nil, false) < 3 then
			IWin:SetReservedEnergy(spell, "buff", "target")
	end
end

function IWin:Garrote()
	local spell = "Garrote"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyCostAvailable(spell)
		and IWin:IsBehind()
		and not IWin:IsImmune("target", "bleed")
		and IWin:IsBuffActive("player", "Stealth") then
			IWin:Cast(spell)
	end
end

function IWin:Gouge()
	local spell = "Gouge"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsSpellLearnt("Backstab")
		and not IWin:IsSpellLearnt("Noxious Assault")
		and not IWin:IsSpellLearnt("Hemorrhage")
		and IWin:IsEnergyAvailable(spell)
		and IWin:IsTanking()
		and not IWin:IsBoss()
		and not IWin:IsBuffActive("target", spell)
		and not IWin:IsBehind()
		and IWin:IsDaggerEquipped() then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyGouge()
	local spell = "Gouge"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsSpellLearnt("Backstab", nil, false)
		and not IWin:IsSpellLearnt("Noxious Assault", nil, false)
		and not IWin:IsSpellLearnt("Hemorrhage", nil, false)
		and IWin:IsTanking(false)
		and not IWin:IsBoss(false)
		and not IWin:IsBuffActive("target", spell, nil, false)
		and not IWin:IsBehind(false)
		and IWin:IsDaggerEquipped(false) then
			IWin:SetReservedEnergy(spell, "buff", "target")
	end
end

function IWin:Hemorrhage()
	local spell = "Hemorrhage"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell) then
		IWin:Cast(spell)
	end
end

function IWin:Kick()
	local spell = "Kick"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyCostAvailable(spell)
		and IWin:IsCasting("target")
		and IWin:IsInRange(spell) then
			IWin:Cast(spell)
	end
end

function IWin:NoxiousAssault()
	local spell = "Noxious Assault"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell) then
		IWin:Cast(spell)
	end
end

function IWin:PickPocket()
	local spell = "Pick Pocket"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsBuffActive("player", "Stealth")
		and IWin:IsCreatureType("Humanoid") then
			IWin:Cast(spell, false)
	end
end

function IWin:Riposte()
	local spell = "Riposte"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and IWin:IsRiposteAvailable() then
			IWin:Cast(spell)
	end
end

function IWin:Rupture()
	local spell = "Rupture"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and (
					(
						not IWin:IsImmune("target", "bleed")
						and IWin:GetTimeToDie() > IWin:GetRuptureDuration()
						and IWin:GetBuffRemaining("player", "Taste for Blood") < 3
					)
				or (
						IWin:GetBuffRemaining("player", "Taste for Blood") < 3
						and IWin:GetTalentRank(1, 10) ~= 0
					)
			)
		and IWin:IsMaxComboPoints() then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyRupture()
	local spell = "Rupture"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (
				(
					not IWin:IsImmune("target", "bleed", false)
					and IWin:GetTimeToDie(false) > IWin:GetRuptureDuration(false)
					and IWin:GetBuffRemaining("player", "Taste for Blood", nil, false) < 3
				)
			or (
					IWin:GetBuffRemaining("player", "Taste for Blood", nil, false) < 3
					and IWin:GetTalentRank(1, 10, false) ~= 0
				)
		)
		and IWin:IsMaxComboPoints(false) then
			IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:ShadowOfDeath()
	local spell = "Shadow of Death"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and IWin:IsMaxComboPoints() then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyShadowOfDeath()
	local spell = "Shadow of Death"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsMaxComboPoints(false) then
		IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:SinisterStrike()
	local spell = "Sinister Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell) then
		IWin:Cast(spell)
	end
end

function IWin:SliceAndDice()
	local spell = "Slice and Dice"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell)
		and (
				IWin:GetTimeToDie() > 6 --longer fight
				or ( --solo will engage next fight
						IWin:GetHealthPercent("player") > 50
						and GetNumPartyMembers() == 0
					)
				or ( --group will engage next pack
						not IWin:IsBoss()
						and GetNumPartyMembers() ~= 0
					)
			)
		and GetComboPoints() < 3
		and GetComboPoints() > 0
		and IWin:GetBuffRemaining("player", spell) < 3 then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergySliceAndDice()
	local spell = "Slice and Dice"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (
			IWin:GetTimeToDie(false) > 6 --longer fight
			or ( --solo will engage next fight
					IWin:GetHealthPercent("player", false) > 50
					and GetNumPartyMembers() == 0
				)
			or ( --group will engage next pack
					not IWin:IsBoss(false)
					and GetNumPartyMembers() ~= 0
				)
		)
		and GetComboPoints() < 3
		and GetComboPoints() > 0
		and IWin:GetBuffRemaining("player", spell, nil, false) < 3 then
			IWin:SetReservedEnergy(spell, "buff", "player")
	end
end

function IWin:SurpriseAttack()
	local spell = "Surprise Attack"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsSurpriseAttackAvailable()
		and IWin:IsEnergyAvailable(spell)
		and UnitMana("player") < IWin:GetMaxEnergy() - IWin_CombatVar["energyPerSecondPrediction"] * 2 then
			IWin:Cast(spell)
	end
end