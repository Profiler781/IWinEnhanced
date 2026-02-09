if UnitClass("player") ~= "Rogue" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
	IWin_CombatVar["reservedEnergy"] = 0
	IWin_CombatVar["swingAttackQueued"] = false
	IWin_CombatVar["energyPerSecondPrediction"] = IWin_Settings["energyPerSecondPrediction"]
	if IWin:IsBuffActive("player", "Adrenaline") then
		IWin_CombatVar["energyPerSecondPrediction"] = IWin_CombatVar["energyPerSecondPrediction"] * 2
	end
end

function IWin:AdrenalineRush()
	if IWin:IsSpellLearnt("Adrenaline Rush")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Adrenaline Rush")
		and IWin:IsEnergyAvailable("Adrenaline Rush")
		and UnitMana("player") <= 60 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Adrenaline Rush")
	end
end

function IWin:Ambush()
	if IWin:IsSpellLearnt("Ambush")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Ambush")
		and IWin:IsEnergyCostAvailable("Ambush")
		and IWin:IsBehind()
		and IWin:IsDaggerEquipped()
		and IWin:IsBuffActive("player", "Stealth") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Ambush")
	end
end

function IWin:Backstab()
	if IWin:IsSpellLearnt("Backstab")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Backstab")
		and IWin:IsEnergyAvailable("Backstab")
		and IWin:IsBehind()
		and IWin:IsDaggerEquipped() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Backstab")
	end
end

function IWin:SetReservedEnergyBackstab()
	if IWin:IsBehind()
		and IWin:IsDaggerEquipped() then
			IWin:SetReservedEnergy("Backstab", "nocooldown")
	end
end

function IWin:BladeFlurry()

end

function IWin:CheapShot()
	if IWin:IsSpellLearnt("Cheap Shot")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Cheap Shot")
		and IWin:IsEnergyCostAvailable("Cheap Shot")
		and IWin:IsBuffActive("player", "Stealth") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Cheap Shot")
	end
end

function IWin:DeadlyThrow()
	if IWin:IsSpellLearnt("Deadly Throw")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Deadly Throw")
		and IWin:IsEnergyCostAvailable("Deadly Throw")
		and IWin:IsInRange("Deadly Throw") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Deadly Throw")
	end
end

function IWin:Envenom()
	if IWin:IsSpellLearnt("Envenom")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Envenom")
		and IWin:IsEnergyAvailable("Envenom")
		and IWin:GetTimeToDie() > 6
		and (
				(
					GetComboPoints() ~= 0
					and not IWin:IsBuffActive("target", "Envenom", "player")
				) or (
					GetComboPoints() == 5
					and IWin:GetBuffRemaining("target", "Envenom", "player") < 6
				)
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Envenom")
	end
end

function IWin:SetReservedEnergyEnvenom()
	if IWin:GetTimeToDie() > 6
		and (
				(
					GetComboPoints() ~= 0
					and not IWin:IsBuffActive("target", "Envenom", "player")
				) or (
					GetComboPoints() == 5
					and IWin:GetBuffRemaining("target", "Envenom", "player") < 6
				)
			) then
				IWin:SetReservedEnergy("Envenom", "buff", "target")
	end
end

function IWin:Evicerate()
	if IWin:IsSpellLearnt("Evicerate")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Evicerate")
		and IWin:IsEnergyAvailable("Evicerate")
		and GetComboPoints() == 5 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Evicerate")
	end
end

function IWin:SetReservedEnergyEvicerate()
	if GetComboPoints() == 5 then
		IWin:SetReservedEnergy("Evicerate", "nocooldown")
	end
end

function IWin:ExposeArmor()
	if IWin:IsSpellLearnt("Expose Armor")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Expose Armor")
		and IWin:IsEnergyAvailable("Expose Armor")
		and IWin:IsBoss()
		and IWin:GetTalentRank(3, 2) == 2
		and GetComboPoints() == 5
		and IWin:GetTimeToDie() > IWin:GetBuffRemaining("target", "Expose Armor")
		and IWin:GetBuffRemaining("target", "Expose Armor") < 6 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Expose Armor")
	end
end

function IWin:SetReservedEnergyExposeArmor()
	if IWin:IsBoss()
		and IWin:GetTalentRank(3, 2) == 2
		and GetComboPoints() == 5
		and IWin:GetTimeToDie() > IWin:GetBuffRemaining("target", "Expose Armor")
		and IWin:GetBuffRemaining("target", "Expose Armor") < 6 then
			IWin:SetReservedEnergy("Expose Armor", "buff", "target")
	end
end

function IWin:Garrote()
	if IWin:IsSpellLearnt("Garrote")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Garrote")
		and IWin:IsEnergyCostAvailable("Garrote")
		and IWin:IsBehind()
		and IWin:IsBuffActive("player", "Stealth") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Garrote")
	end
end

function IWin:Gouge()
	if IWin:IsSpellLearnt("Gouge")
		and IWin:IsSpellLearnt("Backstab")
		and not IWin:IsSpellLearnt("Noxious Assault")
		and not IWin:IsSpellLearnt("Hemorrhage")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Gouge")
		and IWin:IsEnergyAvailable("Gouge")
		and IWin:IsTanking()
		and not IWin:IsBoss()
		and not IWin:IsBuffActive("target", "Gouge")
		and not IWin:IsBehind()
		and IWin:IsDaggerEquipped() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Gouge")
	end
end

function IWin:SetReservedEnergyGouge()
	if IWin:IsSpellLearnt("Backstab")
		and not IWin:IsSpellLearnt("Noxious Assault")
		and not IWin:IsSpellLearnt("Hemorrhage")
		and IWin:IsTanking()
		and not IWin:IsBoss()
		and not IWin:IsBuffActive("target", "Gouge")
		and not IWin:IsBehind()
		and IWin:IsDaggerEquipped() then
			IWin:SetReservedEnergy("Gouge", "buff", "target")
	end
end

function IWin:Hemorrhage()
	if IWin:IsSpellLearnt("Hemorrhage")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Hemorrhage")
		and IWin:IsEnergyAvailable("Hemorrhage") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Hemorrhage")
	end
end

function IWin:Kick()
	if IWin:IsSpellLearnt("Kick")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Kick")
		and IWin:IsEnergyCostAvailable("Kick")
		and IWin:IsInRange("Kick") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Kick")
	end
end

function IWin:NoxiousAssault()
	if IWin:IsSpellLearnt("Noxious Assault")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Noxious Assault")
		and IWin:IsEnergyAvailable("Noxious Assault") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Noxious Assault")
	end
end

function IWin:PickPocket()
	if IWin:IsSpellLearnt("Pick Pocket")
		and IWin:IsBuffActive("player", "Stealth")
		and UnitCreatureType("target") == "Humanoid" then
			CastSpellByName("Pick Pocket")
	end
end

function IWin:Riposte()
	if IWin:IsSpellLearnt("Riposte")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Riposte")
		and IWin:IsEnergyAvailable("Riposte")
		and IWin:IsRiposteAvailable() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Riposte")
	end
end

function IWin:Rupture()
	if IWin:IsSpellLearnt("Rupture")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Rupture")
		and IWin:IsEnergyAvailable("Rupture")
		and (
				IWin:GetTalentRank(1, 10) == 3
				or (
						IWin:GetTimeToDie() > 13
						and not IWin:IsBuffActive("Rupture", "target", "player")
					)
			)
		and GetComboPoints() == 5
		and IWin:GetBuffRemaining("player", "Taste for Blood") < 6 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Rupture")
	end
end

function IWin:SetReservedEnergyRupture()
	if (
			IWin:GetTalentRank(1, 10) == 3
			or (
					IWin:GetTimeToDie() > 13
					and not IWin:IsBuffActive("Rupture", "target", "player")
				)
		)
		and GetComboPoints() == 5
		and IWin:GetBuffRemaining("player", "Taste for Blood") < 6 then
			IWin:SetReservedEnergy("Rupture", "nocooldown")
	end
end

function IWin:ShadowOfDeath()
	if IWin:IsSpellLearnt("Shadow of Death")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Shadow of Death")
		and IWin:IsEnergyAvailable("Shadow of Death")
		and GetComboPoints() == 5 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Shadow of Death")
	end
end

function IWin:SetReservedEnergyShadowOfDeath()
	if GetComboPoints() == 5 then
		IWin:SetReservedEnergy("Shadow of Death", "nocooldown")
	end
end

function IWin:SinisterStrike()
	if IWin:IsSpellLearnt("Sinister Strike")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Sinister Strike")
		and IWin:IsEnergyAvailable("Sinister Strike") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Sinister Strike")
	end
end

function IWin:SliceAndDice()
	if IWin:IsSpellLearnt("Slice and Dice")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Slice and Dice")
		and IWin:IsEnergyAvailable("Slice and Dice")
		and (
				IWin:GetTimeToDie() > 6
				or not IWin:IsBoss()
				or IWin:GetHealthPercent("player") > 50
				or GetNumPartyMembers() ~= 0
			)
		and (
				(
					GetComboPoints() ~= 0
					and not IWin:IsBuffActive("player", "Slice and Dice")
				) or (
					GetComboPoints() == 5
					and IWin:GetBuffRemaining("player", "Slice and Dice") < 6
				)
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Slice and Dice")
	end
end

function IWin:SetReservedEnergySliceAndDice()
	if (
				IWin:GetTimeToDie() > 6
				or not IWin:IsBoss()
				or IWin:GetHealthPercent("player") > 50
				or GetNumPartyMembers() ~= 0
			)
		and (
				(
					GetComboPoints() ~= 0
					and not IWin:IsBuffActive("player", "Slice and Dice")
				) or (
					GetComboPoints() == 5
					and IWin:GetBuffRemaining("player", "Slice and Dice") < 6
				)
			) then
				IWin:SetReservedEnergy("Slice and Dice", "buff", "player")
	end
end

function IWin:SurpriseAttack()
	if IWin:IsSpellLearnt("Surprise Attack")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Surprise Attack")
		and IWin:IsSurpriseAttackAvailable()
		and IWin:IsEnergyAvailable("Surprise Attack") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Surprise Attack")
	end
end