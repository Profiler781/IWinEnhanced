if UnitClass("player") ~= "Paladin" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
end

function IWin:BlessingOfKings()
	local spell = "Blessing of Kings"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsBuffActive("player", spell, nil, false)
		and not IWin:IsBuffActive("player", "Greater Blessing of Kings", nil, false)
		and IWin:GetGroupSize(false) == 1
		and IWin.hasPallyPower
		and PallyPower_Assignments[IWin:GetName("player", false)][4] == 4 then
			IWin:Cast(spell)
	end
end

function IWin:BlessingOfLight()
	local spell = "Blessing of Light"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsBuffActive("player", spell, nil, false)
		and not IWin:IsBuffActive("player", "Greater Blessing of Light", nil, false)
		and IWin:GetGroupSize(false) == 1
		and IWin.hasPallyPower
		and PallyPower_Assignments[IWin:GetName("player", false)][4] == 3 then
			IWin:Cast(spell)
	end
end

function IWin:BlessingOfMight()
	local spell = "Blessing of Might"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:GetGroupSize(false) == 1
		and (
				(
					not IWin.hasPallyPower
					and not IWin:IsBlessingActive(false)
				)
			or (
					IWin.hasPallyPower
					and PallyPower_Assignments[IWin:GetName("player", false)][4] == 1
					and not IWin:IsBuffActive("player", spell, nil, false)
					and not IWin:IsBuffActive("player", "Greater Blessing of Might", nil, false)
				)
			) then
				IWin:Cast(spell)
	end
end

function IWin:BlessingOfSalvation()
	local spell = "Blessing of Salvation"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsBuffActive("player", spell, nil, false)
		and not IWin:IsBuffActive("player", "Greater Blessing of Salvation", nil, false)
		and IWin:GetGroupSize(false) == 1
		and IWin.hasPallyPower
		and PallyPower_Assignments[IWin:GetName("player", false)][4] == 2 then
			IWin:Cast(spell)
	end
end

function IWin:BlessingOfSanctuary()
	local spell = "Blessing of Sanctuary"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsBuffActive("player", spell, nil, false)
		and not IWin:IsBuffActive("player", "Greater Blessing of Sanctuary", nil, false)
		and IWin:GetGroupSize(false) == 1
		and (
				not IWin.hasPallyPower
				or PallyPower_Assignments[IWin:GetName("player", false)][4] == 5
			) then
				IWin:Cast(spell)
	end
end

function IWin:BlessingOfWisdom()
	local spell = "Blessing of Wisdom"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:GetGroupSize(false) == 1
		and (
				(
					not IWin.hasPallyPower
					and not IWin:IsBlessingActive(false)
				)
			or (
					IWin.hasPallyPower
					and PallyPower_Assignments[IWin:GetName("player", false)][4] == 0
					and not IWin:IsBuffActive("player", spell, nil, false)
					and not IWin:IsBuffActive("player", "Greater Blessing of Wisdom", nil, false)
				)
			) then
				IWin:Cast(spell)
	end
end

function IWin:CastCDShortOffensiveGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Short Offensive CD with GCD")
	if not skipTargetControl and not IWin:IsCDShortOffensiveTarget(true) or not IWin_CombatVar["queueGCD"] then return end
	IWin:CastCDOffensive("Perception", skipWindowControl, true)
end

function IWin:CastCDShortOffensiveNoGCD(skipWindowControl, skipTargetControl)
	--none
end

function IWin:CastCDLongOffensiveGCD(skipWindowControl, skipTargetControl)
	--none
end

function IWin:Cleanse()
	local spell = "Cleanse"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not HasFullControl() then
		IWin:Cast(spell)
	end
end

function IWin:ConcentrationAura()
	local spell = "Concentration Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 2 then
			IWin:Cast(spell)
	end
end

function IWin:Consecration(manaPercent)
	local spell = "Consecration"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent then
		IWin:Cast(spell)
	end
end

function IWin:ConsecrationFocus(manaPercent)
	local spell = "Consecration"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsMoving()
		and IWin:GetTimeToDie() > 6 then
			IWin:Consecration(manaPercent)
	end
end

function IWin:CrusaderStrike(manaPercent, queueTime)
	local spell = "Crusader Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent
		and (
				IWin:GetBuffRemaining("player","Zeal") < 13
				or IWin:GetPowerPercent("player") > 80
			) then
				IWin:Cast(spell)
	end
end

function IWin:DevotionAura()
	local spell = "Devotion Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 0 then
			IWin:Cast(spell)
	end
end

function IWin:DivineShield()
	local spell = "Divine Shield"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsAffectingCombat("player") then
		IWin:Cast(spell)
	end
end

function IWin:Exorcism(manaPercent)
	local spell = "Exorcism"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent
		and (
				IWin:IsCreatureType("Undead")
				or IWin:IsCreatureType("Demon")
			) then
				IWin:Cast(spell)
	end
end

function IWin:ExorcismRanged(manaPercent)
	local spell = "Exorcism"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent
		and (
				IWin:IsCreatureType("Undead")
				or IWin:IsCreatureType("Demon")
			)
		and not IWin:IsInRange("Holy Strike")
		and IWin:IsInRange(spell) then
			IWin:Cast(spell)
	end
end

function IWin:FireResistanceAura()
	local spell = "Fire Resistance Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 5 then
			IWin:Cast(spell)
	end
end

function IWin:FrostResistanceAura()
	local spell = "Frost Resistance Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 4 then
			IWin:Cast(spell)
	end
end

function IWin:HammerOfJustice()
	local spell = "Hammer of Justice"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:HammerOfWrath(manaPercent)
	local spell = "Hammer of Wrath"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsExecutePhase()
		and (
				(
					IWin:IsElite()
					and IWin:GetTimeToDie() > IWin:GetCastTime(spell) + IWin_TravelTime[spell]
					and not IWin:IsTanking()
					and IWin:GetPowerPercent("player") > manaPercent
				)
				or IWin:IsPVP("target")
			)
		and not IWin:IsMoving() then
			IWin:Cast(spell)
	end
end

function IWin:HammerOfWrathRanged(manaPercent)
	local spell = "Hammer of Wrath"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsInRange("Holy Strike")
		and IWin:IsInRange(spell)
		and IWin:IsExecutePhase()
		and (
				(
					IWin:IsElite()
					and IWin:GetPowerPercent("player") > manaPercent
				)
				or IWin:IsPVP("target")
			)
		and not IWin:IsMoving() then
			IWin:Cast(spell)
	end
end

function IWin:HandOfFreedom()
	local spell = "Hand of Freedom"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not HasFullControl() then
		IWin:Cast(spell)
	end
end

function IWin:HandOfReckoning()
	local spell = "Hand of Reckoning"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsTanking()
		--and not IWin:IsImmune("target", spell)
		and not IWin:IsTaunted() then
			IWin:Cast(spell)
	end
end

function IWin:HolyShield(manaPercent, minParty)
	local spell = "Holy Shield"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent
		and IWin:IsShieldEquipped()
		and IWin:GetGroupSize() >= minParty
		and (
				not IWin:IsAffectingCombat("target")
				or IWin:IsTanking()
			) then
				IWin:Cast(spell)
	end
end

function IWin:HolyShock(manaPercent)
	local spell = "Holy Shock"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsTanking()
		and not IWin:IsBuffActive("player", "Mortal Strike")
		and IWin:GetHealthPercent("player") < 80
		and IWin:GetPowerPercent("player") > manaPercent then
			IWin:Cast(spell, nil, "player")
	end
end

function IWin:HolyShockPull(manaPercent)
	local spell = "Holy Shock"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange(spell)
		and IWin:IsExists("target")
		and IWin:GetPowerPercent("player") > manaPercent
		and not IWin:IsAffectingCombat("target") then
			IWin:Cast(spell)
	end
end

function IWin:HolyStrike(queueTime)
	local spell = "Holy Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:HolyStrikeHolyMight(queueTime)
	local spell = "Holy Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetBuffRemaining("player", "Holy Might") < 4
		and IWin:GetTalentRank("Vengeful Strikes") ~= 0 then
			IWin:Cast(spell)
	end
end

function IWin:HolyWrath(manaPercent)
	local spell = "Holy Wrath"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsMoving()
		and not IWin:IsTanking()
		and (
				IWin:IsCreatureType("Undead")
				or IWin:IsCreatureType("Demon")
			)
		and IWin:GetPowerPercent("player") > manaPercent then
			IWin:Cast(spell)
	end
end

function IWin:Judgement(manaPercent,queueTime)
	local spell = "Judgement"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsSealActive()
		and (
				(
					IWin:GetTalentRank("Holy Judgement") == 3
					and not IWin:IsBuffActive("player","Holy Judgement")
					and IWin:GetPowerPercent("player") > manaPercent
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
								or IWin:GetPowerPercent("player") > manaPercent
							)
					)
			)
		and not IWin:IsGCDActive() then
			IWin:Cast(spell)
	end
end

function IWin:JudgementReact()
	local spell = "Judgement"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if (
			IWin:IsBuffActive("player","Seal of Wisdom")
			or IWin:IsBuffActive("player","Seal of Light")
			or IWin:IsBuffActive("player","Seal of the Crusader")
			or IWin:IsBuffActive("player","Seal of Justice")
		)
		and (
				not IWin:IsJudgementOverwrite("Judgement of Wisdom","Seal of Wisdom")
				or IWin:GetPowerPercent("player") > 60
			)
		and IWin:IsInRange(spell) then
				IWin:Cast(spell, false)
	end
end

function IWin:JudgementRanged(manaPercent, queueTime)
	local spell = "Judgement"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsInRange("Holy Strike")
		and IWin:IsInRange(spell) then
			IWin:Judgement(manaPercent, queueTime)
	end
end

function IWin:Purify()
	local spell = "Purify"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not HasFullControl() then
		IWin:Cast(spell)
	end
end

function IWin:Repentance()
	local spell = "Repentance"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:RepentanceRaid()
	local spell = "Repentance"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", "Repent")
		and IWin:GetTimeToDie() > 10
		and IWin:GetGroupSize() > 5
		and IWin:IsElite() then
			IWin:Cast(spell)
	end
end

function IWin:RetributionAura()
	local spell = "Retribution Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and (
				(
					IWin.hasPallyPower
					and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 1
				)
				or not IWin.hasPallyPower
			) then
				IWin:Cast(spell)
	end
end

function IWin:RighteousFury()
	local spell = "Righteous Fury"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsBuffActive("player" ,spell) then
		IWin:Cast(spell)
	end
end

function IWin:SanctityAura()
	local spell = "Sanctity Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 6 then
			IWin:Cast(spell)
	end
end

function IWin:SealOfCommand(manaPercent)
	local spell = "Seal of Command"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent
		and (
				(
					IWin:GetWeaponSpeed() > 3.39
					and IWin_Settings["soc"] == "auto"
				)
				or IWin_Settings["soc"] == "on"
			)
		and (
				not IWin:IsSealActive()
				or IWin:IsHiddenSealUsed()
				or IWin:GetPowerPercent("player") > 95
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfJustice()
	local spell = "Seal of Justice"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", "Judgement of Justice")
		and (
				not IWin:IsBuffActive("player", spell)
				or IWin:IsHiddenSealUsed("Seal of Justice")
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfJusticeElite()
	local spell = "Seal of Justice"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsBuffActive("player", spell)
			or IWin:IsHiddenSealUsed("Seal of Justice")
		)
		and not IWin:IsBuffActive("target","Judgement of Justice")
		and IWin:IsJudgementTarget("justice")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and (
				(
					IWin.hasPallyPower
					and PallyPower_SealAssignments[IWin:GetName("player", false)] == 3
				) or (
					not IWin.hasPallyPower
					and IWin_Settings["judgement"] == "justice"
				)
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfLightElite()
	local spell = "Seal of Light"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsBuffActive("player", spell)
			or IWin:IsHiddenSealUsed("Seal of Light")
		)
		and not IWin:IsBuffActive("target","Judgement of Light")
		and IWin:IsJudgementTarget("light")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and (
				(
					IWin.hasPallyPower
					and PallyPower_SealAssignments[IWin:GetName("player", false)] == 2
				) or (
					not IWin.hasPallyPower
					and IWin_Settings["judgement"] == "light"
				)
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfRighteousness(manaPercent)
	local spell = "Seal of Righteousness"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetPowerPercent("player") > manaPercent
		and (
				not IWin:IsSealActive()
				or IWin:IsHiddenSealUsed()
				or (
						IWin:GetPowerPercent("player") > 95
						and (
								not IWin:IsBuffActive("player", spell)
								or IWin:IsHiddenSealUsed("Seal of Righteousness")
							)
						and IWin:IsBuffActive("target","Judgement of Wisdom")
						and (
								IWin:IsBuffActive("player","Seal of Wisdom")
								or IWin:IsHiddenSealUsed("Seal of Wisdom")
							)
					)
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfTheCrusaderElite()
	local spell = "Seal of the Crusader"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsBuffActive("player", spell)
			or IWin:IsHiddenSealUsed("Seal of the Crusader")
		)
		and not IWin:IsBuffActive("target","Judgement of the Crusader")
		and IWin:IsJudgementTarget("crusader")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and (
				(
					IWin.hasPallyPower
					and PallyPower_SealAssignments[IWin:GetName("player", false)] == 1
				) or (
					not IWin.hasPallyPower
					and IWin_Settings["judgement"] == "crusader"
				)
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfWisdom(manaPercent)
	local spell = "Seal of Wisdom"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsSealActive()
			or IWin:IsHiddenSealUsed()
		)
		and (
				IWin:GetPowerPercent("player") < manaPercent
				or (
						IWin:GetPowerPercent("player") < 70
						and not IWin:IsBuffActive("target","Judgement of Wisdom")
						and IWin:GetTimeToDie() > 20
						and not IWin:IsElite()
					)
				or (
						IWin:GetGroupSize() == 1
						and not IWin:IsElite()
						and not IWin:IsAffectingCombat("player")
					)
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfWisdomElite()
	local spell = "Seal of Wisdom"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsBuffActive("player", spell)
			or IWin:IsHiddenSealUsed("Seal of Wisdom")
		)
		and not IWin:IsBuffActive("target","Judgement of Wisdom")
		and IWin:IsJudgementTarget("wisdom")
		and IWin:GetCooldownRemaining("Judgement") <= IWin_Settings["GCD"]
		and (
				(
					IWin.hasPallyPower
					and PallyPower_SealAssignments[IWin:GetName("player", false)] == 0
				) or (
					not IWin.hasPallyPower
					and IWin_Settings["judgement"] == "wisdom"
				)
			)
		and IWin:IsExists("target") then
				IWin:Cast(spell)
	end
end

function IWin:SealOfWisdomEco()
	local spell = "Seal of Wisdom"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsSealActive()
			or IWin:IsHiddenSealUsed()
		)
		and IWin:IsExists("target") then
			IWin:Cast(spell)
	end
end

function IWin:ShadowResistanceAura()
	local spell = "Shadow Resistance Aura"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if not IWin:IsAuraActive(false)
		and IWin.hasPallyPower
		and PallyPower_AuraAssignments[IWin:GetName("player", false)] == 3 then
			IWin:Cast(spell)
	end
end

function IWin:UseItemConsumableOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Consumable Offensive NoGCD")
	if not skipTargetControl and not IWin:IsItemConsumableOffensiveTarget(true) then return end
	IWin:UseItemConsumableOffensive("Juju Flurry", skipWindowControl)
	IWin:UseItemConsumableOffensive("Potion of Quickness", skipWindowControl)
end

function IWin:UseItemTrinketOffensiveGCD(skipWindowControl, skipTargetControl)
	--none
end

function IWin:UseItemTrinketOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Trinket Offensive NoGCD")
	if not skipTargetControl and not IWin:IsItemTrinketOffensiveTarget(true) then return end
	IWin:UseItemTrinketOffensive("Badge of the Swarmguard", skipWindowControl)
	IWin:UseItemTrinketOffensive("Draconic Infused Emblem", skipWindowControl)
	IWin:UseItemTrinketOffensive("Earthstrike", skipWindowControl)
	IWin:UseItemTrinketOffensive("Jom Gabbar", skipWindowControl)
	IWin:UseItemTrinketOffensive("Kiss of the Spider", skipWindowControl)
	IWin:UseItemTrinketOffensive("Molten Emberstone", skipWindowControl)
	IWin:UseItemTrinketOffensive("Scrolls of Blinding Light", skipWindowControl)
	IWin:UseItemTrinketOffensive("Slayer's Crest", skipWindowControl)
	IWin:UseItemTrinketOffensive("Talisman of Ephemeral Power", skipWindowControl)
	IWin:UseItemTrinketOffensive("Zandalarian Hero Charm", skipWindowControl)
	IWin:UseItemTrinketOffensive("Zandalarian Hero Medallion", skipWindowControl)
end