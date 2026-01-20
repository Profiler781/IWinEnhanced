if UnitClass("player") ~= "Paladin" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
end

function IWin:BlessingOfKings()
	if IWin:IsSpellLearnt("Blessing of Kings")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBuffActive("player","Blessing of Kings")
		and not IWin:IsBuffActive("player","Greater Blessing of Kings")
		and GetNumPartyMembers() == 0
		and IWin.hasPallyPower
		and PallyPower_Assignments[UnitName("player")][4] == 4 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Blessing of Kings")
	end
end

function IWin:BlessingOfLight()
	if IWin:IsSpellLearnt("Blessing of Light")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBuffActive("player","Blessing of Light")
		and not IWin:IsBuffActive("player","Greater Blessing of Light")
		and GetNumPartyMembers() == 0
		and IWin.hasPallyPower
		and PallyPower_Assignments[UnitName("player")][4] == 3 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Blessing of Light")
	end
end

function IWin:BlessingOfMight()
	if IWin:IsSpellLearnt("Blessing of Might")
		and IWin_CombatVar["queueGCD"]
		and GetNumPartyMembers() == 0
		and (
				(
					not IWin.hasPallyPower
					and not IWin:IsBlessingActive()
				)
			or (
					IWin.hasPallyPower
					and PallyPower_Assignments[UnitName("player")][4] == 1
					and not IWin:IsBuffActive("player","Blessing of Might")
					and not IWin:IsBuffActive("player","Greater Blessing of Might")
				)
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Blessing of Might")
	end
end

function IWin:BlessingOfSalvation()
	if IWin:IsSpellLearnt("Blessing of Salvation")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBuffActive("player","Blessing of Salvation")
		and not IWin:IsBuffActive("player","Greater Blessing of Salvation")
		and GetNumPartyMembers() == 0
		and IWin.hasPallyPower
		and PallyPower_Assignments[UnitName("player")][4] == 2 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Blessing of Salvation")
	end
end

function IWin:BlessingOfSanctuary()
	if IWin:IsSpellLearnt("Blessing of Sanctuary")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBuffActive("player","Blessing of Sanctuary")
		and not IWin:IsBuffActive("player","Greater Blessing of Sanctuary")
		and GetNumPartyMembers() == 0
		and (
				not IWin.hasPallyPower
				or PallyPower_Assignments[UnitName("player")][4] == 5
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Blessing of Sanctuary")
	end
end

function IWin:BlessingOfWisdom()
	if IWin:IsSpellLearnt("Blessing of Wisdom")
		and IWin_CombatVar["queueGCD"]
		and GetNumPartyMembers() == 0
		and (
				(
					not IWin.hasPallyPower
					and not IWin:IsBlessingActive()
				)
			or (
					IWin.hasPallyPower
					and PallyPower_Assignments[UnitName("player")][4] == 0
					and not IWin:IsBuffActive("player","Blessing of Wisdom")
					and not IWin:IsBuffActive("player","Greater Blessing of Wisdom")
				)
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Blessing of Wisdom")
	end
end

function IWin:Cleanse()
	if IWin:IsSpellLearnt("Cleanse")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Cleanse")
		and not HasFullControl() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Cleanse")
	end
end

function IWin:ConcentrationAura()
	if IWin:IsSpellLearnt("Concentration Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[UnitName("player")] == 2 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Concentration Aura")
	end
end

function IWin:Consecration(manaPercent)
	if IWin:IsSpellLearnt("Consecration")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetManaPercent("player") > manaPercent
		and not IWin:IsOnCooldown("Consecration") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Consecration")
	end
end

function IWin:CrusaderStrike(manaPercent,queueTime)
	if IWin:IsSpellLearnt("Crusader Strike")
		and IWin_CombatVar["queueGCD"]
		and (
				IWin:GetCooldownRemaining("Crusader Strike") < queueTime
				or not IWin:IsOnCooldown("Crusader Strike")
			)
		and IWin:GetManaPercent("player") > manaPercent
		and (
				IWin:GetBuffRemaining("player","Zeal") < 13
				or IWin:GetManaPercent("player") > 80
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Crusader Strike")
	end
end

function IWin:DevotionAura()
	if IWin:IsSpellLearnt("Devotion Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[UnitName("player")] == 0 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Devotion Aura")
	end
end

function IWin:DivineShield()
	if IWin:IsSpellLearnt("Divine Shield")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Divine Shield")
		and UnitAffectingCombat("player") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Divine Shield")
	end
end

function IWin:Exorcism(manaPercent)
	if IWin:IsSpellLearnt("Exorcism")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Exorcism")
		and IWin:GetManaPercent("player") > manaPercent
		and (
				UnitCreatureType("target") == "Undead"
				or UnitCreatureType("target") == "Demon"
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Exorcism")
	end
end

function IWin:ExorcismRanged(manaPercent)
	if IWin:IsSpellLearnt("Exorcism")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Exorcism")
		and IWin:GetManaPercent("player") > manaPercent
		and (
				UnitCreatureType("target") == "Undead"
				or UnitCreatureType("target") == "Demon"
			)
		and not IWin:IsInRange("Holy Strike") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Exorcism")
	end
end

function IWin:FireResistanceAura()
	if IWin:IsSpellLearnt("Fire Resistance Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[UnitName("player")] == 5 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Fire Resistance Aura")
	end
end

function IWin:FrostResistanceAura()
	if IWin:IsSpellLearnt("Frost Resistance Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[UnitName("player")] == 4 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Frost Resistance Aura")
	end
end

function IWin:HammerOfJustice()
	if IWin:IsSpellLearnt("Hammer of Justice")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Hammer of Justice") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Hammer of Justice")
	end
end

function IWin:HammerOfWrath(manaPercent)
	if IWin:IsSpellLearnt("Hammer of Wrath")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsMoving()
		and not IWin:IsOnCooldown("Hammer of Wrath")
		and (
				(
					IWin:IsElite()
					and not IWin:IsTanking()
					and IWin:GetManaPercent("player") > manaPercent
				)
				or UnitIsPVP("target")
			)
		and IWin:IsExecutePhase() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Hammer of Wrath")
	end
end

function IWin:HandOfFreedom()
	if IWin:IsSpellLearnt("Hand of Freedom")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Hand of Freedom")
		and not HasFullControl() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Hand of Freedom")
	end
end

function IWin:HandOfReckoning()
	if IWin:IsSpellLearnt("Hand of Reckoning")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsTanking()
		and not IWin:IsOnCooldown("Hand of Reckoning")
		and not IWin:IsTaunted() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Hand of Reckoning")
	end
end

function IWin:HolyShield(manaPercent, minParty)
	if IWin:IsSpellLearnt("Holy Shield")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Holy Shield")
		and IWin:GetManaPercent("player") > manaPercent
		and IWin:IsShieldEquipped()
		and GetNumPartyMembers() >= minParty
		and (
				not UnitAffectingCombat("target")
				or IWin:IsTanking()
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Holy Shield")
	end
end

function IWin:HolyShock(manaPercent)
	if IWin:IsSpellLearnt("Holy Shock")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Holy Shock")
		and IWin:IsTanking()
		and not IWin:IsBuffActive("player","Mortal Strike")
		and IWin:GetHealthPercent("player") < 80
		and IWin:GetManaPercent("player") > manaPercent then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Holy Shock","player")
	end
end

function IWin:HolyShockPull(manaPercent)
	if IWin:IsSpellLearnt("Holy Shock")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsInRange("Holy Shock")
		and not IWin:IsOnCooldown("Holy Shock")
		and UnitExists("target")
		and IWin:GetManaPercent("player") > manaPercent
		and not UnitAffectingCombat("target") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Holy Shock")
	end
end

function IWin:HolyStrike(queueTime)
	if IWin:IsSpellLearnt("Holy Strike")
		and IWin_CombatVar["queueGCD"]
		and (
				IWin:GetCooldownRemaining("Holy Strike") < queueTime
				or not IWin:IsOnCooldown("Holy Strike")
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Holy Strike")
	end
end

function IWin:HolyStrikeHolyMight(queueTime)
	if IWin:IsSpellLearnt("Holy Strike")
		and IWin_CombatVar["queueGCD"]
		and (
				IWin:GetCooldownRemaining("Holy Strike") < queueTime
				or not IWin:IsOnCooldown("Holy Strike")
			)
		and IWin:GetBuffRemaining("player","Holy Might") < 4
		and IWin:GetTalentRank(3 ,15) ~= 0 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Holy Strike")
	end
end

function IWin:HolyWrath(manaPercent)
	if IWin:IsSpellLearnt("Holy Wrath")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsMoving()
		and not IWin:IsOnCooldown("Holy Wrath")
		and not IWin:IsTanking()
		and (
				UnitCreatureType("target") == "Undead"
				or UnitCreatureType("target") == "Demon"
			)
		and IWin:GetManaPercent("player") > manaPercent then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Holy Wrath")
	end
end

function IWin:Judgement(manaPercent,queueTime)
	if IWin:IsSpellLearnt("Judgement")
		and IWin_CombatVar["queueGCD"]
		and (
				IWin:GetCooldownRemaining("Judgement") < queueTime
				or not IWin:IsOnCooldown("Judgement")
			)
		and IWin:IsSealActive()
		and (
				(
					IWin:GetTalentRank(1, 3) == 3
					and not IWin:IsBuffActive("player","Holy Judgement")
					and IWin:GetManaPercent("player") > manaPercent
				)
				or (
						not IWin:IsJudgementOverwrite("Judgement of Wisdom","Seal of Wisdom")
						and not IWin:IsJudgementOverwrite("Judgement of Light","Seal of Light")
						and not IWin:IsJudgementOverwrite("Judgement of the Crusader","Seal of the Crusader")
						and not IWin:IsJudgementOverwrite("Judgement of Justice","Seal of Justice")
						and (
								IWin:GetTimeToDie() > 10
								or IWin:IsBuffActive("player","Seal of Righteousness")
								or IWin:IsBuffActive("player","Seal of Command")
								or IWin:IsBuffActive("player","Seal of Justice")
							)
						and (
								(
									not IWin:IsBuffActive("player","Seal of Righteousness")
									and not IWin:IsBuffActive("player","Seal of Command")
								)
								or (
										IWin:GetBuffRemaining("player","Seal of Righteousness") < 5
										and IWin:IsBuffActive("player","Seal of Righteousness")
									)
								or (
										IWin:GetBuffRemaining("player","Seal of Command") < 5
										and IWin:IsBuffActive("player","Seal of Command")
									)
								or IWin:GetManaPercent("player") > manaPercent
							)
					)
			)
		and not IWin:IsGCDActive() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Judgement")
	end
end

function IWin:JudgementReact()
	if IWin:IsSpellLearnt("Judgement")
		and not IWin:IsOnCooldown("Judgement")
		and (
				IWin:IsBuffActive("player","Seal of Wisdom")
				or IWin:IsBuffActive("player","Seal of Light")
				or IWin:IsBuffActive("player","Seal of the Crusader")
				or IWin:IsBuffActive("player","Seal of Justice")
			)
		and (
				not IWin:IsJudgementOverwrite("Judgement of Wisdom","Seal of Wisdom")
				or IWin:GetManaPercent("player") > 60
			) then
			CastSpellByName("Judgement")
	end
end

function IWin:JudgementRanged(manaPercent,queueTime)
	if not IWin:IsInRange("Holy Strike") then
		IWin:Judgement(manaPercent,queueTime)
	end
end

function IWin:Purify()
	if IWin:IsSpellLearnt("Purify")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Purify")
		and not HasFullControl() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Purify")
	end
end

function IWin:Repentance()
	if IWin:IsSpellLearnt("Repentance")
		and not IWin:IsOnCooldown("Repentance") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Repentance")
	end
end

function IWin:RepentanceRaid()
	if IWin:IsSpellLearnt("Repentance")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Repentance")
		and not IWin:IsBuffActive("player", "Repentance")
		and UnitInRaid("player")
		and IWin:IsElite() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Repentance")
	end
end

function IWin:RetributionAura()
	if IWin:IsSpellLearnt("Retribution Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and (
				(
					IWin.hasPallyPower
					and PallyPower_AuraAssignments[UnitName("player")] == 1
				)
				or not IWin.hasPallyPower
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Retribution Aura")
	end
end

function IWin:RighteousFury()
	if IWin:IsSpellLearnt("Righteous Fury")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBuffActive("player","Righteous Fury") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Righteous Fury")
	end
end

function IWin:SanctityAura()
	if IWin:IsSpellLearnt("Sanctity Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[UnitName("player")] == 6 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Sanctity Aura")
	end
end

function IWin:SealOfCommand(manaPercent)
	if IWin:IsSpellLearnt("Seal of Command")
		and IWin:GetManaPercent("player") > manaPercent
		and (
				(
					IWin_CombatVar["weaponAttackSpeed"] > 3.49
					and IWin_Settings["soc"] == "auto"
				)
				or IWin_Settings["soc"] == "on"
			)
		and (
				not IWin:IsSealActive()
				or IWin:GetManaPercent("player") > 95
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Seal of Command")
	end
end

function IWin:SealOfJustice()
	if IWin:IsSpellLearnt("Seal of Justice")
		and not IWin:IsBuffActive("target", "Judgement of Justice")
		and not IWin:IsBuffActive("player", "Seal of Justice") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Seal of Justice")
	end
end

function IWin:SealOfJusticeElite()
	if IWin:IsSpellLearnt("Seal of Justice")
		and not IWin:IsBuffActive("player","Seal of Justice")
		and not IWin:IsBuffActive("target","Judgement of Justice")
		and IWin:IsJudgementTarget("justice")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and ((
				IWin.hasPallyPower
				and PallyPower_SealAssignments[UnitName("player")] == 3
			) or (
				not IWin.hasPallyPower
				and IWin_Settings["judgement"] == "justice"
			)) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Seal of Justice")
	end
end

function IWin:SealOfLightElite()
	if IWin:IsSpellLearnt("Seal of Light")
		and not IWin:IsBuffActive("player","Seal of Light")
		and not IWin:IsBuffActive("target","Judgement of Light")
		and IWin:IsJudgementTarget("light")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and (
				(
					IWin.hasPallyPower
					and PallyPower_SealAssignments[UnitName("player")] == 2
				) or (
					not IWin.hasPallyPower
					and IWin_Settings["judgement"] == "light"
				)
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Seal of Light")
	end
end

function IWin:SealOfRighteousness(manaPercent)
	if IWin:IsSpellLearnt("Seal of Righteousness")
		and IWin:GetManaPercent("player") > manaPercent
		and (
				not IWin:IsSealActive()
				or (
						IWin:GetManaPercent("player") > 95
						and not IWin:IsBuffActive("player","Seal of Righteousness")
						and IWin:IsBuffActive("target","Judgement of Wisdom")
						and IWin:IsBuffActive("player","Seal of Wisdom")
					)
			) then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Seal of Righteousness")
	end
end

function IWin:SealOfTheCrusaderElite()
	if IWin:IsSpellLearnt("Seal of the Crusader")
		and not IWin:IsBuffActive("player","Seal of the Crusader")
		and not IWin:IsBuffActive("target","Judgement of the Crusader")
		and IWin:IsJudgementTarget("crusader")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and ((
				IWin.hasPallyPower
				and PallyPower_SealAssignments[UnitName("player")] == 1
			) or (
				not IWin.hasPallyPower
				and IWin_Settings["judgement"] == "crusader"
			)) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Seal of the Crusader")
	end
end

function IWin:SealOfWisdom(manaPercent)
	if IWin:IsSpellLearnt("Seal of Wisdom")
		and not IWin:IsSealActive()
		and (
				IWin:GetManaPercent("player") < manaPercent
				or (
						IWin:GetManaPercent("player") < 70
						and not IWin:IsBuffActive("target","Judgement of Wisdom")
						and IWin:GetTimeToDie() > 20
						and not IWin:IsElite()
					)
				or (
						GetNumPartyMembers() == 0
						and not IWin:IsElite()
						and not UnitAffectingCombat("player")
					)
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Seal of Wisdom")
	end
end

function IWin:SealOfWisdomElite()
	if IWin:IsSpellLearnt("Seal of Wisdom")
		and not IWin:IsBuffActive("player","Seal of Wisdom")
		and not IWin:IsBuffActive("target","Judgement of Wisdom")
		and IWin:IsJudgementTarget("wisdom")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and ((
				IWin.hasPallyPower
				and PallyPower_SealAssignments[UnitName("player")] == 0
			) or (
				not IWin.hasPallyPower
				and IWin_Settings["judgement"] == "wisdom"
			)) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Seal of Wisdom")
	end
end

function IWin:SealOfWisdomEco()
	if IWin:IsSpellLearnt("Seal of Wisdom")
		and not IWin:IsSealActive() then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Seal of Wisdom")
	end
end

function IWin:ShadowResistanceAura()
	if IWin:IsSpellLearnt("Shadow Resistance Aura")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsAuraActive()
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[UnitName("player")] == 3 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Shadow Resistance Aura")
	end
end