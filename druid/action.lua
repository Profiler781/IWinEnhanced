if UnitClass("player") ~= "Druid" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
	if IWin_RotationVar["lastMoonkinSpellTime"] + 0.5 < IWin:GetTime(false) then
		if not IWin:IsExists("target", false) or IWin:IsAffectingCombat("target", false) then
			IWin_RotationVar["lastMoonkinSpell"] = "Starfire"
		else
			IWin_RotationVar["lastMoonkinSpell"] = "Wrath"
		end
	end
	IWin_CombatVar["energyPerSecondPrediction"] = IWin_Settings["energyPerSecondPrediction"]
	if IWin:IsBuffActive("player", "Tiger's Fury", nil, false) then
		IWin_CombatVar["energyPerSecondPrediction"] = IWin_CombatVar["energyPerSecondPrediction"] + 3.3
	end
	if IWin:IsBuffActive("player", "Berserk", nil, false) then
		IWin_CombatVar["energyPerSecondPrediction"] = IWin_CombatVar["energyPerSecondPrediction"] + IWin_Settings["energyPerSecondPrediction"]
	end
end

---- Class Actions ----
function IWin:CancelForm()
	IWin:CancelPlayerBuff("Bear Form")
	IWin:CancelPlayerBuff("Dire Bear Form")
	IWin:CancelPlayerBuff("Cat Form")
end

function IWin:Reshift()
	local spell = "Reshift"
	if IWin:IsSpellLearnt(spell)
		and (
				IWin:GetLevel("player") == 60
				or (
						IWin:IsTanking()
						and (
								IWin:IsStanceActive("Bear Form")
								or IWin:IsStanceActive("Dire Bear Form")
							)
					)
			) then
				IWin:Cast(spell)
	elseif not (
					IWin:IsTanking()
					and (
							IWin:IsStanceActive("Bear Form")
							or IWin:IsStanceActive("Dire Bear Form")
						)
				) then
					IWin:CancelForm()
	end
end

function IWin:CancelRoot()
	if not IWin:IsInRange(nil, nil, nil, false)
		or not IWin:IsTanking(false) then
			for root in IWin_Root do
				if IWin:IsBuffActive("player", IWin_Root[root], nil, false) then
					IWin:Reshift()
					break
				end
			end
	end
end

function IWin:CancelRootReact()
	for root in IWin_Root do
		if IWin:IsBuffActive("player", IWin_Root[root], nil, false) then
			IWin:Reshift()
			break
		end
	end
end

function IWin:CancelSnare()
	if not IWin:IsInRange(nil, nil, nil, false) then
		for snare in IWin_Snare do
			if IWin:IsBuffActive("player", IWin_Snare[snare], nil, false) then
				IWin:Reshift()
				break
			end
		end
	end
end

function IWin:CancelSnareReact()
	for snare in IWin_Snare do
		if IWin:IsBuffActive("player", IWin_Snare[snare], nil, false) then
			IWin:Reshift()
			break
		end
	end
end

function IWin:CastCDShortOffensiveGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Short Offensive CD with GCD")
	if not skipTargetControl and not IWin:IsCDShortOffensiveTarget(true) or not IWin_CombatVar["queueGCD"] then return end
	if IWin:IsStanceActive("Cat Form")
		and IWin:GetPower("player") <= 50
		and not IWin:IsBlacklistFear() then
			IWin:CastCDOffensive("Berserk", skipWindowControl, true)
	end
end

function IWin:CastCDShortOffensiveNoGCD(skipWindowControl, skipTargetControl)
	--none
end

function IWin:CastCDLongOffensiveGCD(skipWindowControl, skipTargetControl)
	--none
end

function IWin:MarkOfTheWild()
	local spell = "Mark of the Wild"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange(nil, "farranged", "target")
		and not IWin:IsAffectingCombat("player")
		and (
				(
					IWin:GetBuffRemaining("player", spell) < 60
					and not IWin:IsBuffActive("player", "Gift of the Wild")
				) or (
					IWin:GetBuffRemaining("player", "Gift of the Wild") < 60
					and not IWin:IsBuffActive("player", spell)
				)
			) then
				IWin:CancelForm()
				IWin:Cast(spell, nil, "player")
	end
end

function IWin:Thorns()
	local spell = "Thorns"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange(nil, "farranged", "target")
		and not IWin:IsAffectingCombat("player")
		and IWin:GetGroupSize() == 1
		and IWin:GetBuffRemaining("player", spell) < 60 then
			IWin:CancelForm()
			IWin:Cast(spell, nil ,"player")
	end
end

function IWin:NaturesGrasp()
	local spell = "Nature's Grasp"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange() then
		IWin:CancelForm()
		IWin:Cast(spell)
	end
end

function IWin:TravelForm()
	local spell = "Travel Form"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsStanceActive("Travel Form") then
		IWin:Cast(spell)
	end
end

function IWin:UseItemConsumableOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Consumable Offensive NoGCD")
	if not skipTargetControl and not IWin:IsItemConsumableOffensiveTarget(true) then return end
	IWin:UseItemConsumableOffensive("Juju Flurry", skipWindowControl)
	if IWin:GetPowerType("player") == "rage" then IWin:UseItemConsumableOffensive("Mighty Rage Potion", skipWindowControl) end
	IWin:UseItemConsumableOffensive("Potion of Quickness", skipWindowControl)
end

function IWin:UseItemConsumableAOEOffensiveNoGCD(skipTargetsControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: AOE Consumable Offensive")
	if not skipTargetControl and not IWin:IsItemConsumableAOEOffensiveTarget(true) then return end
	if not IWin:IsBuffActive("player", "Fire Shield", nil, false)
		and not IWin:IsImmune("target", "fire") then
			IWin:UseItemConsumableAOEOffensive("Oil of Immolation", skipTargetsControl, IWin_Settings["targetsOilOfImmolation"], "meleeAutoAttack")
	end
end

function IWin:UseItemConsumableAOEOffensiveGCD(skipTargetsControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: AOE Consumable Offensive")
	if not skipTargetControl and not IWin:IsItemConsumableAOEOffensiveTarget(true) then return end
	if IWin:IsCreatureType("Undead")
		and not IWin:IsImmune("target", "holy") then
			IWin:UseItemConsumableAOEOffensive("Stratholme Holy Water", skipTargetsControl, IWin_Settings["targetsHolyWater"], "meleeAutoAttack")
	end
	if not IWin:IsImmune("target", "fire") then
		IWin:UseItemConsumableAOEOffensive("Goblin Sapper Charge", skipTargetsControl, IWin_Settings["targetsSapper"], "meleeAutoAttack")
	end
	if not IWin:IsImmune("target", "fire") then
		IWin:UseItemConsumableAOEOffensive("Dense Dynamite", skipTargetsControl, IWin_Settings["targetsDenseDynamite"], "meleeAutoAttack")
	end
end

function IWin:UseItemTrinketOffensiveGCD(skipWindowControl, skipTargetControl)
	--none
end

function IWin:UseItemTrinketOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Trinket Offensive NoGCD")
	if not skipTargetControl and not IWin:IsItemTrinketOffensiveTarget(true) then return end
	IWin:UseItemTrinketOffensive("Badge of the Swarmguard", skipWindowControl)
	IWin:UseItemTrinketOffensive("Earthstrike", skipWindowControl)
	IWin:UseItemTrinketOffensive("Jom Gabbar", skipWindowControl)
	IWin:UseItemTrinketOffensive("Kiss of the Spider", skipWindowControl)
	IWin:UseItemTrinketOffensive("Molten Emberstone", skipWindowControl)
	IWin:UseItemTrinketOffensive("Slayer's Crest", skipWindowControl)
	IWin:UseItemTrinketOffensive("Zandalarian Hero Medallion", skipWindowControl)
end

function IWin:UseItemTrinketOffensivePrepull(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Offensive Trinket pre-pull")
	if not skipTargetControl and not IWin:IsItemTrinketOffensiveTarget(true, true) then return end
	IWin:UseItemTrinketOffensive("Gnomish Battle Chicken", skipWindowControl)
end

function IWin:UseItemConsumableOffensiveNoGCDRanged(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Consumable Offensive NoGCD Ranged")
	if not skipTargetControl and not IWin:IsItemConsumableOffensiveTarget() then return end
	IWin:UseItemConsumableOffensive("Juju Flurry", skipWindowControl)
	IWin:UseItemConsumableOffensive("Potion of Quickness", skipWindowControl)
end

function IWin:UseItemTrinketOffensiveGCDRanged(skipWindowControl, skipTargetControl)
	--none
end

function IWin:UseItemTrinketOffensiveNoGCDRanged(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Trinket Offensive NoGCD Ranged")
	if not skipTargetControl and  not IWin:IsItemTrinketOffensiveTarget() then return end
	IWin:UseItemTrinketOffensive("Draconic Infused Emblem", skipWindowControl)
	IWin:UseItemTrinketOffensive("Talisman of Ephemeral Power", skipWindowControl)
	IWin:UseItemTrinketOffensive("Zandalarian Hero Charm", skipWindowControl)
end

function IWin:UseItemTrinketOffensivePrepullRanged(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Offensive Trinket pre-pull Ranged")
	if not skipTargetControl and not IWin:IsItemTrinketOffensiveTarget(false, true) then return end
	IWin:UseItemTrinketOffensive("Gnomish Battle Chicken", skipWindowControl)
end

---- Feral Actions ----
function IWin:FaerieFireFeral(skipEnemyInRange)
	local spell = "Faerie Fire (Feral)"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", spell)
		and not IWin:IsImmune("target", "Faerie Fire (Feral)")
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") <= 1)
		and (
				IWin:IsStanceActive("Cat Form")
				or IWin:IsStanceActive("Bear Form")
				or IWin:IsStanceActive("Dire Bear Form")
			) then
				local spellNameMaxRank = IWin:GetSpellNameMaxRank(spell)
				IWin:Cast(spellNameMaxRank)
	end
end

function IWin:FaerieFireFeralRefresh()
	local spell = "Faerie Fire (Feral)"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetBuffRemaining("target", spell) < 10
		and not IWin:IsImmune("target", "Faerie Fire (Feral)")
		and (
				IWin:IsStanceActive("Cat Form")
				or IWin:IsStanceActive("Bear Form")
				or IWin:IsStanceActive("Dire Bear Form")
			) then
				local spellNameMaxRank = IWin:GetSpellNameMaxRank(spell)
				IWin:Cast(spellNameMaxRank)
	end
end

function IWin:FaerieFireFeralRanged()
	local spell = "Faerie Fire (Feral)"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsInRange()
		and not IWin:IsImmune("target", "Faerie Fire (Feral)")
		and (
				IWin:IsStanceActive("Cat Form")
				or IWin:IsStanceActive("Bear Form")
				or IWin:IsStanceActive("Dire Bear Form")
			) then
				local spellNameMaxRank = IWin:GetSpellNameMaxRank(spell)
				IWin:Cast(spellNameMaxRank)
	end
end

function IWin:Powershift()
	if not IWin_CombatVar["queueGCD"] then return end
	IWin:Debug("+++ checking conditions: Powershift", debugmsg)
	if IWin:GetTalentRank("Furor") ~= 0
		and (
				(
					IWin:GetPower("player") < 20
					and IWin:GetPowerType("player") == "energy"
				) or (
					IWin:GetPower("player") < 10
					and IWin:GetPowerType("player") == "rage"
				)
			)
		and IWin:GetBuffRemaining("player", "Tiger's Fury") < 7
		and (
					IWin:GetPlayerDruidManaPercent() > 70
				or (
						IWin:GetGroupSize() > 2
						and IWin:IsDruidManaAvailable("Reshift")
						and IWin:GetPlayerDruidManaPercent() > 20
					)
			) then
				IWin:Reshift()
	end
end

function IWin:BerserkFear()
	local spell = "Berserk"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsFeared() then
		IWin:Cast(spell)
	end
end

---- Bear Actions ----
function IWin:BearForm()
	local spell = "Bear Form"
	IWin:Debug("+++ checking conditions: "..spell, debugmsg)
	if not IWin:IsSpellSkip("Dire Bear Form", nil, true, queueTime, true)
		and not IWin:IsStanceActive("Dire Bear Form") then
			IWin:Cast("Dire Bear Form")
	elseif not IWin:IsSpellSkip(spell, nil, true, queueTime, true)
		and not IWin:IsStanceActive(spell) then
			IWin:Cast(spell)
	end
end

function IWin:DemoralizingRoar()
	local spell = "Demoralizing Roar"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", spell)
		and not IWin:IsBuffActive("target", "Demoralizing Shout")
		and IWin:GetTimeToDie() > 10
		and IWin:IsInRange()
		and not IWin:IsBlacklistAOEDebuff()
		and IWin:IsRageAvailable(spell) then
			IWin:Cast(spell)
	end
end

function IWin:Enrage(skipEnemyInRange)
	local spell = "Enrage"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin:GetPower("player") < 50
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") < 3)
		and not IWin:IsBuffActive("player", "Blood Frenzy") then
			IWin:Cast(spell, false)
	end
end

function IWin:FeralCharge()
	local spell = "Feral Charge"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin:IsInRange(spell, "ranged") then
		IWin:Cast(spell, false)
	end
end

function IWin:Growl()
	local spell = "Growl"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsTanking()
		and not IWin:IsImmune("target", "Growl")
		and not IWin:IsTaunted() then
			IWin:Cast(spell)
	end
end

function IWin:Maul()
	local spell = "Maul"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin:IsRageAvailable(spell) then
		IWin_CombatVar["swingAttackQueued"] = true
		IWin_CombatVar["startAttackThrottle"] = IWin:GetTime() + 0.2
		IWin:Cast(spell, false)
	end
end

function IWin:SavageBite(queueTime, skipEnemyInRange)
	local spell = "Savage Bite"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") <= 1)
		and IWin:IsRageAvailable(spell) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageSavageBite(skipEnemyInRange)
	local spell = "Savage Bite"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") <= 1) then
		IWin:SetReservedRage(spell, "nocooldown")
	end
end

function IWin:Swipe(skipEnemyInRange)
	local spell = "Swipe"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and not IWin:IsBlacklistAOEDamage()
		and IWin:IsRageAvailable(spell) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageSwipe(skipEnemyInRange)
	local spell = "Swipe"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and not IWin:IsBlacklistAOEDamage() then
			IWin:SetReservedRage(spell, "nocooldown")
	end
end

---- Cat Actions ----
function IWin:CatForm()
	local spell = "Cat Form"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsStanceActive(spell) then
		IWin:Cast(spell)
	end
end

function IWin:Claw()
	local spell = "Claw"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsEnergyAvailable(spell) then
		IWin:Cast(spell)
	end
end

function IWin:FerociousBite()
	local spell = "Ferocious Bite"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:GetComboPoints() == 5
			or (
					IWin:GetTimeToDie() < 3
					and GetComboPoints(false) >= 3
				)
		)
		and IWin:IsEnergyAvailable(spell) then
			IWin_CombatVar["queueGCD"] = false
			-- Energy pooling
			if IWin:GetTalentRank("Carnage") ~= 2
				or (
						IWin:GetBuffRemaining("target", "Rake", "player") < IWin_Settings["playerReactionDelay"]
						and not IWin:IsImmune("target", "bleed")
					)
				or IWin_RotationVar["energyNextTickTime"] - IWin:GetTime() < IWin_Settings["playerReactionDelay"]
				or IWin:GetTimeToEnergyMax() < IWin_Settings["playerReactionDelay"]
				or IWin:GetTimeToDie(false) < 3 then
					IWin:Cast(spell)
			end
	end
end

function IWin:SetReservedEnergyFerocious()
	local spell = "Ferocious Bite"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:GetComboPoints(false) == 5
		or (
				IWin:GetTimeToDie(false) < 3
				and IWin:GetComboPoints(false) >= 3
			) then
				IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:Pounce()
	local spell = "Pounce"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsBuffActive("player", "Prowl")
		and IWin:IsBehind()
		and (
				(
					IWin:GetTimeToDie() > 18
					and IWin:GetTalentRank("Open Wounds") == 3
				)
				or IWin:GetGroupSize() == 1
			)
		and not IWin:IsImmune("target", "bleed") then
			IWin:Cast(spell)
	end
end

function IWin:Rake()
	local spell = "Rake"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", spell, "player")
		and (
				not IWin:IsBehind() --shred wont be used. rake>claw
				or (
						IWin:GetTalentRank("Open Wounds") == 3 --open wounds needs rake bleed
						and (
								IWin:GetBleedCount() >= 1 --1 more bleed to claw
								or (
										IWin:GetComboPoints() == 4 --rip will be used after rake cp. 2 bleeds will allow claw
										and IWin:GetTimeToDie() > 15
									)
							)
					)
			)
		and IWin:GetTimeToDie() > 9
		and not IWin:IsImmune("target", "bleed")
		and IWin:IsEnergyAvailable(spell) then
			IWin_CombatVar["queueGCD"] = false
			-- Energy pooling
			if IWin:GetTalentRank("Carnage") ~= 2
				or IWin:GetComboPoints() < 4
				or not IWin:IsBuffActive("target", "Rip", "player")
				or (
						IWin:GetEnergyToReserve("Ferocious Bite", "nocooldown") == IWin_EnergyCost["Ferocious Bite"]
						and IWin_RotationVar["energyNextTickTime"] - IWin:GetTime() < IWin_Settings["playerReactionDelay"]
					)
				or IWin:GetTimeToEnergyMax() < IWin_Settings["playerReactionDelay"] then
					IWin:Cast(spell)
			end
	end
end

function IWin:SetReservedEnergyRake()
	local spell = "Rake"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (
			not IWin:IsBehind(false) --shred wont be used. rake>claw
			or (
					IWin:GetTalentRank("Open Wounds", false) == 3 --open wounds needs rake bleed
					and (
							IWin:GetBleedCount(false) >= 1 --1 more bleed to claw
							or (
									IWin:GetComboPoints(false) == 4 --rip will be used after rake cp. 2 bleeds will allow claw
									and IWin:GetTimeToDie(false) > 15
								)
						)
				)
		)
		and IWin:GetTimeToDie(false) > 9
		and not IWin:IsImmune("target", "bleed", false)
		and not (
					IWin:GetTalentRank("Carnage") == 2 --dont plan rake refresh if we will refresh it with carnage talent
					and IWin:GetComboPoints() == 4
				) then
					IWin:SetReservedEnergy(spell, "buff", "target")
	end
end

function IWin:Ravage()
	local spell = "Ravage"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsBuffActive("player", "Prowl")
		and IWin:IsBehind()
		and not (
					IWin:IsSpellLearnt("Shred", "Rank 6") --this rank scales better than ravage if talented
					and IWin:GetTalentRank("Improved Shred") == 2
				) then
					IWin:Cast(spell)
	end
end

function IWin:Rip()
	local spell = "Rip"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", spell, "player")
		and (
				(
					IWin:GetComboPoints() == 3
					and IWin:GetTimeToDie() > 10
					and IWin:GetTimeToDie() < 14
				) or (
					IWin:GetComboPoints() == 4
					and IWin:GetTimeToDie() > 12
					and IWin:GetTimeToDie() < 16
				) or (
					IWin:GetComboPoints() == 5
					and IWin:GetTimeToDie() > 14
				)
			)
		and not IWin:IsImmune("target", "bleed")
		and IWin:IsEnergyAvailable(spell) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyRip()
	local spell = "Rip"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if not IWin:IsBuffActive("target", spell, "player", false)
		and (
				(
					IWin:GetComboPoints(false) == 3
					and IWin:GetTimeToDie(false) > 10
					and IWin:GetTimeToDie(false) < 14
				) or (
					IWin:GetComboPoints(false) == 4
					and IWin:GetTimeToDie(false) > 12
					and IWin:GetTimeToDie(false) < 16
				) or (
					IWin:GetComboPoints(false) == 5
					and IWin:GetTimeToDie(false) > 14
				)
			)
		and not IWin:IsImmune("target", "bleed", false) then
			IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:Shred()
	local spell = "Shred"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsBehind()
			or (		
					IWin_Settings["frontShred"] == "on"
					and IWin:GetPower("player") < 100
				)
		)
		and (
				IWin:GetBleedCount() < 2
				or IWin:IsBuffActive("player", "Clearcasting")
				or IWin:IsBuffActive("player", "Berserk")
				or IWin:GetTalentRank("Open Wounds") == 0
			)
		and IWin:IsEnergyAvailable(spell) then
				IWin:Cast(spell)
	end
end

function IWin:SetReservedEnergyShred()
	local spell = "Shred"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (
			IWin:IsBehind(false)
			or (
					IWin_Settings["frontShred"] == "on"
					and IWin:GetPower("player", false) < 100
				)
		)
		and (
				IWin:GetBleedCount(false) < 2
				or IWin:IsBuffActive("player", "Clearcasting", nil, false)
				or IWin:GetTalentRank("Open Wounds", false) == 0
			) then
				IWin:SetReservedEnergy(spell, "nocooldown")
	end
end

function IWin:TigersFury()
	local spell = "Tiger's Fury"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if not IWin:IsBuffActive("player", spell)
		and IWin:GetTalentRank("Blood Frenzy") ~= 0
		and (
				IWin:GetTimeToDie() > 6
				or not IWin:IsExists("target")
			)
		and IWin:IsEnergyAvailable(spell) then
			IWin:Cast(spell, false)
	end
end

function IWin:SetReservedEnergyTigersFury()
	local spell = "Tiger's Fury"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:GetTalentRank("Blood Frenzy", false) ~= 0
		and (
				IWin:GetTimeToDie(false) > 6
				or not IWin:IsExists("target", false)
			) then
				IWin:SetReservedEnergy(spell, "buff", "player")
	end
end

---- Moonkin Actions ----
function IWin:InsectSwarm()
	local spell = "Insect Swarm"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsBuffActive("target", spell, "player")
			or (
					IWin:GetBuffRemaining("player", "Nature Eclipse") < IWin:GetCastTime("Wrath") + 0.5
					and IWin:IsBuffActive("player", "Nature Eclipse")
					and IWin:GetBuffRemaining("target", spell, "player") < 8
				)
		)
		and not IWin:IsBuffActive("player", "Arcane Eclipse")
		and IWin:GetTimeToDie() > 9 then
				IWin:Cast(spell)
	end
end

function IWin:InsectSwarmMoving()
	local spell = "Insect Swarm"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetBuffRemaining("target", spell, "player") < 8
		and IWin:GetTimeToDie() > 6 then
			IWin:Cast(spell)
	end
end

function IWin:Moonfire()
	local spell = "Moonfire"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			not IWin:IsBuffActive("target", spell, "player")
			or (
					IWin:GetBuffRemaining("player", "Arcane Eclipse") < IWin:GetCastTime("Starfire") + 0.5
					and IWin:IsBuffActive("player", "Arcane Eclipse")
					and IWin:GetBuffRemaining("target", spell, "player") < 8
				)
		)
		and not IWin:IsBuffActive("player", "Nature Eclipse")
		and IWin:GetTimeToDie() > 9 then
				IWin:Cast(spell)
	end
end

function IWin:MoonfireMoving()
	local spell = "Moonfire"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:MoonkinForm()
	local spell = "Moonkin Form"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsStanceActive(spell) then
		IWin:Cast(spell)
	end
end

function IWin:Starfire()
	local spell = "Starfire"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsBuffActive("player", "Arcane Eclipse")
			or (
					not IWin:IsBuffActive("player", "Nature Eclipse")
					and (
								(
									not IWin:IsBuffActive("player", "Arcane Solstice")
									and IWin:IsBuffActive("player", "Natural Solstice")
								)
							or (
									IWin_RotationVar["lastMoonkinSpell"] == "Wrath"
									and not IWin:IsBuffActive("player", "Arcane Eclipse")
									and not IWin:IsBuffActive("player", "Nature Eclipse")
									and (
											not IWin:IsBuffActive("player", "Arcane Solstice")
											and not IWin:IsBuffActive("player", "Natural Solstice")
										) or (
											IWin:IsBuffActive("player", "Arcane Solstice")
											and IWin:IsBuffActive("player", "Natural Solstice")
										)
										
								)
						)
				)
		)
		and not IWin:IsMoving() then
			IWin:Cast(spell)
	end
end

function IWin:StarfireOOC()
	local spell = "Starfire"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsAffectingCombat("player")
		and not IWin:IsAffectingCombat("target")
		and not IWin:IsPVP("target") then
			IWin:Starfire()
	end
end

function IWin:Wrath()
	local spell = "Wrath"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsBuffActive("player", "Nature Eclipse")
			or (
					not IWin:IsBuffActive("player", "Arcane Eclipse")
					and (
								(
									not IWin:IsBuffActive("player", "Natural Solstice")
									and IWin:IsBuffActive("player", "Arcane Solstice")
								)
							or (
									IWin_RotationVar["lastMoonkinSpell"] == "Starfire"
									and not IWin:IsBuffActive("player", "Arcane Eclipse")
									and not IWin:IsBuffActive("player", "Nature Eclipse")
									and (
											not IWin:IsBuffActive("player", "Arcane Solstice")
											and not IWin:IsBuffActive("player", "Natural Solstice")
										) or (
											IWin:IsBuffActive("player", "Arcane Solstice")
											and IWin:IsBuffActive("player", "Natural Solstice")
										)
										
								)
						)
				)
		)
		and not IWin:IsMoving() then
			IWin:Cast(spell)
	end
end

function IWin:WrathOOC()
	local spell = "Wrath"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsAffectingCombat("player")
		and not IWin:IsAffectingCombat("target")
		and not IWin:IsPVP("target") then
			IWin:Wrath()
	end
end