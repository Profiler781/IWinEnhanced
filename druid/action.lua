if UnitClass("player") ~= "Druid" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedEnergy"] = 0
	IWin_CombatVar["swingAttackQueued"] = false
	if IWin_CombatVar["lastMoonkinSpellTime"] + 0.5 < GetTime() then
		if not UnitExists("target") or UnitAffectingCombat("target") then
			IWin_CombatVar["lastMoonkinSpell"] = "Starfire"
		else
			IWin_CombatVar["lastMoonkinSpell"] = "Wrath"
		end
	end
	IWin_CombatVar["energyPerSecondPrediction"] = IWin_Settings["energyPerSecondPrediction"]
	if IWin:IsBuffActive("player", "Tiger's Fury") then
		IWin_CombatVar["energyPerSecondPrediction"] = IWin_CombatVar["energyPerSecondPrediction"] + 3.3
	end
	if IWin:IsBuffActive("player", "Berserk") then
		IWin_CombatVar["energyPerSecondPrediction"] = IWin_CombatVar["energyPerSecondPrediction"] + IWin_Settings["energyPerSecondPrediction"]
	end
	IWin_CastTime = {
		["Wrath"] = nil,
		["Starfire"] = nil,
	}
end

---- Class Actions ----
function IWin:CancelForm()
	IWin:CancelPlayerBuff("Bear Form")
	IWin:CancelPlayerBuff("Dire Bear Form")
	IWin:CancelPlayerBuff("Cat Form")
end

function IWin:Reshift()
	if IWin:IsSpellLearnt("Reshift")
		and UnitLevel("player") == 60 then
			CastSpellByName("Reshift")
	else
		IWin:CancelForm()
	end
end

function IWin:CancelRoot()
	if not IWin:IsInRange()
		or not IWin:IsTanking() then
			for root in IWin_Root do
				if IWin:IsBuffActive("player", IWin_Root[root]) then
					IWin:Reshift()
					break
				end
			end
	end
end

function IWin:CancelRootReact()
	for root in IWin_Root do
		if IWin:IsBuffActive("player", IWin_Root[root]) then
			IWin:Reshift()
			break
		end
	end
end

function IWin:CancelSlow()
	if not IWin:IsInRange() then
		for slow in IWin_Slow do
			if IWin:IsBuffActive("player", IWin_Slow[slow]) then
				IWin:Reshift()
				break
			end
		end
	end
end

function IWin:CancelSlowReact()
	for slow in IWin_Slow do
		if IWin:IsBuffActive("player", IWin_Slow[slow]) then
			IWin:Reshift()
			break
		end
	end
end

function IWin:MarkOfTheWild()
	if IWin:IsSpellLearnt("Mark of the Wild")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Mark of the Wild")
		and not (CheckInteractDistance("target", 4) ~= nil)
		and (
				(
					IWin:GetBuffRemaining("player","Mark of the Wild") < 60
					and not IWin:IsBuffActive("player","Gift of the Wild")
				) or (
					IWin:GetBuffRemaining("player","Gift of the Wild") < 60
					and not IWin:IsBuffActive("player","Mark of the Wild")
				)
			)
		and not UnitAffectingCombat("player") then
			IWin_CombatVar["queueGCD"] = false
			IWin:CancelForm()
			CastSpellByName("Mark of the Wild","player")
	end
end

function IWin:Thorns()
	if IWin:IsSpellLearnt("Thorns")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Thorns")
		and not (CheckInteractDistance("target", 4) ~= nil)
		and IWin:GetBuffRemaining("player","Thorns") < 60
		and not UnitAffectingCombat("player")
		and GetNumPartyMembers() == 0 then
			IWin_CombatVar["queueGCD"] = false
			IWin:CancelForm()
			CastSpellByName("Thorns","player")
	end
end

function IWin:NaturesGrasp()

end

---- Feral Actions ----
function IWin:FaerieFireFeral()
	if IWin:IsSpellLearnt("Faerie Fire (Feral)")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Faerie Fire (Feral)")
		and not IWin:IsBuffActive("target", "Faerie Fire (Feral)")
		and (
				IWin:IsStanceActive("Cat Form")
				or IWin:IsStanceActive("Bear Form")
				or IWin:IsStanceActive("Dire Bear Form")
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Faerie Fire (Feral)(Rank 4)")
				CastSpellByName("Faerie Fire (Feral)(Rank 3)")
				CastSpellByName("Faerie Fire (Feral)(Rank 2)")
				CastSpellByName("Faerie Fire (Feral)(Rank 1)")
	end
end

function IWin:FaerieFireFeralRefresh()
	if IWin:IsSpellLearnt("Faerie Fire (Feral)")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Faerie Fire (Feral)")
		and IWin:GetBuffRemaining("target", "Faerie Fire (Feral)") < 10
		and (
				IWin:IsStanceActive("Cat Form")
				or IWin:IsStanceActive("Bear Form")
				or IWin:IsStanceActive("Dire Bear Form")
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Faerie Fire (Feral)(Rank 4)")
				CastSpellByName("Faerie Fire (Feral)(Rank 3)")
				CastSpellByName("Faerie Fire (Feral)(Rank 2)")
				CastSpellByName("Faerie Fire (Feral)(Rank 1)")
	end
end

function IWin:FaerieFireFeralRanged()
	if IWin:IsSpellLearnt("Faerie Fire (Feral)")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Faerie Fire (Feral)")
		and not IWin:IsInRange()
		and (
				IWin:IsStanceActive("Cat Form")
				or IWin:IsStanceActive("Bear Form")
				or IWin:IsStanceActive("Dire Bear Form")
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Faerie Fire (Feral)(Rank 4)")
				CastSpellByName("Faerie Fire (Feral)(Rank 3)")
				CastSpellByName("Faerie Fire (Feral)(Rank 2)")
				CastSpellByName("Faerie Fire (Feral)(Rank 1)")
	end
end

function IWin:Powershift()
	if IWin_CombatVar["queueGCD"]
		and IWin:GetTalentRank(3, 2) ~= 0
		and (
				(
					UnitMana("player") < 20
					and UnitPowerType("player") == 3 --energy
				) or (
					UnitMana("player") < 10
					and UnitPowerType("player") == 1 --rage
				)
			)
		and (
					IWin:GetPlayerDruidManaPercent() > 70
				or (
						GetNumPartyMembers() ~= 0
						and IWin:IsDruidManaAvailable("Reshift")
						and IWin:GetPlayerDruidManaPercent() > 20
					)
			) then
				IWin_CombatVar["queueGCD"] = false
				IWin:Reshift()
	end
end

---- Bear Actions ----
function IWin:BearForm()
	if IWin:IsSpellLearnt("Dire Bear Form")
		and not IWin:IsStanceActive("Dire Bear Form")
		and not IWin:IsOnCooldown("Dire Bear Form")
		and IWin_CombatVar["queueGCD"] then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Dire Bear Form")
	elseif IWin:IsSpellLearnt("Bear Form")
		and not IWin:IsStanceActive("Bear Form")
		and not IWin:IsOnCooldown("Bear Form")
		and IWin_CombatVar["queueGCD"] then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Bear Form")
	end
end

function IWin:DemoralizingRoar()
	if IWin:IsSpellLearnt("Demoralizing Roar")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Demoralizing Roar")
		and IWin:IsRageAvailable("Demoralizing Roar")
		and not IWin:IsBlacklistAOEDebuff()
		and IWin:IsInRange()
		and not IWin:IsBuffActive("target", "Demoralizing Roar")
		and IWin:GetTimeToDie() > 10 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Demoralizing Roar")
	end
end

function IWin:Enrage()
	if IWin:IsSpellLearnt("Enrage")
		and not IWin:IsOnCooldown("Enrage")
		and UnitMana("player") < 50 then
			CastSpellByName("Enrage")
	end
end

function IWin:FeralCharge()
	if IWin:IsSpellLearnt("Feral Charge")
		and not IWin:IsOnCooldown("Feral Charge")
		and IWin:IsInRange("Feral Charge","ranged") then
			CastSpellByName("Feral Charge")
	end
end

function IWin:Growl()
	if IWin:IsSpellLearnt("Growl")
		and not IWin:IsTanking()
		and not IWin:IsOnCooldown("Growl")
		and not IWin:IsTaunted() then
			CastSpellByName("Growl")
	end
end

function IWin:Maul()
	if IWin:IsSpellLearnt("Maul") then
		if IWin:IsRageAvailable("Maul") then
			IWin_CombatVar["swingAttackQueued"] = true
			IWin_CombatVar["startAttackThrottle"] = GetTime() + 0.2
			CastSpellByName("Maul")
		else
			--SpellStopCasting()
		end
	end
end

function IWin:SavageBite(queueTime)
	if IWin:IsSpellLearnt("Savage Bite")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetCooldownRemaining("Savage Bite") < queueTime
		and IWin:IsRageAvailable("Savage Bite") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Savage Bite")
	end
end

function IWin:Swipe()
	if IWin:IsSpellLearnt("Swipe")
		and not IWin:IsOnCooldown("Swipe")
		and IWin:IsRageAvailable("Swipe")
		and not IWin:IsBlacklistAOEDamage() then
			CastSpellByName("Swipe")
	end
end

---- Cat Actions ----
function IWin:BerserkCat()
	if IWin:IsSpellLearnt("Berserk")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBlacklistFear()
		and not IWin:IsOnCooldown("Berserk")
		and UnitMana("player") <= 50
		and UnitAffectingCombat("player") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Berserk")
	end
end

function IWin:CatForm()
	if IWin:IsSpellLearnt("Cat Form")
		and not IWin:IsStanceActive("Cat Form")
		and not IWin:IsOnCooldown("Cat Form")
		and IWin_CombatVar["queueGCD"] then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Cat Form")
	end
end

function IWin:Claw()
	if IWin:IsSpellLearnt("Claw")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Claw")
		and IWin:IsStanceActive("Cat Form")
		and IWin:IsEnergyAvailable("Claw") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Claw")
	end
end

function IWin:FerociousBite()
	if IWin:IsSpellLearnt("Ferocious Bite")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Ferocious Bite")
		and IWin:IsEnergyAvailable("Ferocious Bite")
		and (
				GetComboPoints() == 5
				or IWin:GetTimeToDie() < 3
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Ferocious Bite")
	end
end

function IWin:SetReservedEnergyFerocious()
	if 	GetComboPoints() == 5
			or IWin:GetTimeToDie() < 3 then
				IWin:SetReservedEnergy("Ferocious Bite", "nocooldown")
	end
end

function IWin:Rake()
	if IWin:IsSpellLearnt("Rake")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Rake")
		and IWin:IsEnergyAvailable("Rake")
		and not IWin:IsBuffActive("target", "Rake", "player")
		and not (
					UnitCreatureType("target") == "Undead"
					or UnitCreatureType("target") == "Mechanical"
					or UnitCreatureType("target") == "Elemental"
				) then
					IWin_CombatVar["queueGCD"] = false
					CastSpellByName("Rake")
	end
end

function IWin:SetReservedEnergyRake()
	if not (
				UnitCreatureType("target") == "Undead"
				or UnitCreatureType("target") == "Mechanical"
				or UnitCreatureType("target") == "Elemental"
			) then
				IWin:SetReservedEnergy("Rake", "buff", "target")
	end
end

function IWin:Rip()
	if IWin:IsSpellLearnt("Rip")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Rip")
		and IWin:IsEnergyAvailable("Rip")
		and not IWin:IsBuffActive("target","Rip","player")
		and (
				(
					GetComboPoints() == 3
					and IWin:GetTimeToDie() > 10
					and IWin:GetTimeToDie() < 14
				) or (
					GetComboPoints() == 4
					and IWin:GetTimeToDie() > 12
					and IWin:GetTimeToDie() < 16
				) or (
					GetComboPoints() == 5
					and IWin:GetTimeToDie() > 14
				)
			)
		and not (
					UnitCreatureType("target") == "Undead"
					or UnitCreatureType("target") == "Mechanical"
					or UnitCreatureType("target") == "Elemental"
				) then
					IWin_CombatVar["queueGCD"] = false
					CastSpellByName("Rip")
	end
end

function IWin:SetReservedEnergyRip()
	if not IWin:IsBuffActive("target","Rip","player")
		and (
				(
					GetComboPoints() == 3
					and IWin:GetTimeToDie() > 10
					and IWin:GetTimeToDie() < 14
				) or (
					GetComboPoints() == 4
					and IWin:GetTimeToDie() > 12
					and IWin:GetTimeToDie() < 16
				) or (
					GetComboPoints() == 5
					and IWin:GetTimeToDie() > 14
				)
			)
		and not (
					UnitCreatureType("target") == "Undead"
					or UnitCreatureType("target") == "Mechanical"
					or UnitCreatureType("target") == "Elemental"
				) then
			IWin:SetReservedEnergy("Rip", "nocooldown")
	end
end

function IWin:Shred()
	if IWin:IsSpellLearnt("Shred")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Shred")
		and IWin:IsEnergyAvailable("Shred")
		and (
				not IWin:IsBuffActive("target", "Rake", "player")
				or not IWin:IsBuffActive("target", "Rip", "player")
				or IWin:IsBuffActive("player", "Clearcasting")
			)
		and (
				(
					UnitMana("player") < 100
					and IWin_Settings["frontShred"] == "on"
				)
				or IWin:IsBehind()
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Shred")
	end
end

function IWin:SetReservedEnergyShred()
	if (
			not IWin:IsBuffActive("target", "Rake", "player")
			or not IWin:IsBuffActive("target", "Rip", "player")
			or IWin:IsBuffActive("player", "Clearcasting")
		)
		and (
				(
					UnitMana("player") < 100
					and IWin_Settings["frontShred"] == "on"
				)
				or IWin:IsBehind()
			) then
			IWin:SetReservedEnergy("Shred", "nocooldown")
	end
end

function IWin:TigersFury()
	if IWin:IsSpellLearnt("Tiger's Fury")
		and not IWin:IsOnCooldown("Tiger's Fury")
		and IWin:GetTalentRank(2,12) ~= 0
		and IWin:IsEnergyAvailable("Tiger's Fury")
		and not IWin:IsBuffActive("player", "Tiger's Fury")
		and IWin:GetTimeToDie() > 6 then
			CastSpellByName("Tiger's Fury")
	end
end

function IWin:SetReservedEnergyTigersFury()
	if IWin:GetTimeToDie() > 6
		and IWin:GetTalentRank(2,12) ~= 0 then
			IWin:SetReservedEnergy("Tiger's Fury", "buff", "player")
	end
end

---- Moonkin Actions ----
function IWin:InsectSwarm()
	if IWin:IsSpellLearnt("Insect Swarm")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Insect Swarm")
		and IWin:GetTimeToDie() > 6
		and not IWin:IsBuffActive("player", "Arcane Eclipse")
		and (
				not IWin:IsBuffActive("target", "Insect Swarm", "player")
				or (
						IWin:GetBuffRemaining("player", "Nature Eclipse") < IWin:GetCastTimeWrath() + 0.5
						and IWin:IsBuffActive("player", "Nature Eclipse")
						and IWin:GetBuffRemaining("target", "Insect Swarm", "player") < 8
					)
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Insect Swarm")
	end
end

function IWin:InsectSwarmMoving()
	if IWin:IsSpellLearnt("Insect Swarm")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Insect Swarm")
		and IWin:GetTimeToDie() > 6
		and IWin:GetBuffRemaining("target", "Insect Swarm", "player") < 8 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Insect Swarm")
	end
end

function IWin:Moonfire()
	if IWin:IsSpellLearnt("Moonfire")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Moonfire")
		and IWin:GetTimeToDie() > 6
		and not IWin:IsBuffActive("player", "Nature Eclipse")
		and (
				not IWin:IsBuffActive("target", "Moonfire", "player")
				or (
						IWin:GetBuffRemaining("player", "Arcane Eclipse") < IWin:GetCastTimeStarfire() + 0.5
						and IWin:IsBuffActive("player", "Arcane Eclipse")
						and IWin:GetBuffRemaining("target", "Moonfire", "player") < 8
					)
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Moonfire")
	end
end

function IWin:MoonfireMoving()
	if IWin:IsSpellLearnt("Moonfire")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Moonfire") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Moonfire")
	end
end

function IWin:MoonkinForm()
	if IWin:IsSpellLearnt("Moonkin Form")
		and not IWin:IsStanceActive("Moonkin Form")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Moonkin Form") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Moonkin Form")
	end
end

function IWin:Starfire()
	if IWin:IsSpellLearnt("Starfire")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsMoving()
		and not IWin:IsOnCooldown("Starfire")
		and (
				IWin:IsBuffActive("player", "Arcane Eclipse")
				or (
						not IWin:IsBuffActive("player", "Nature Eclipse")
						and (
									(
										not IWin:IsBuffActive("player", "Arcane Solstice")
										and IWin:IsBuffActive("player", "Natural Solstice")
									)
								or (
										IWin_CombatVar["lastMoonkinSpell"] == "Wrath"
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
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Starfire")
	end
end

function IWin:StarfireOOC()
	if not UnitAffectingCombat("player")
		and not UnitAffectingCombat("target")
		and not UnitIsPVP("target") then
			IWin:Starfire()
	end
end

function IWin:Wrath()
	if IWin:IsSpellLearnt("Wrath")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsMoving()
		and not IWin:IsOnCooldown("Wrath")
		and (
				IWin:IsBuffActive("player", "Nature Eclipse")
				or (
						not IWin:IsBuffActive("player", "Arcane Eclipse")
						and (
									(
										not IWin:IsBuffActive("player", "Natural Solstice")
										and IWin:IsBuffActive("player", "Arcane Solstice")
									)
								or (
										IWin_CombatVar["lastMoonkinSpell"] == "Starfire"
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
			) then
				IWin_CombatVar["queueGCD"] = false
				CastSpellByName("Wrath")
	end
end

function IWin:WrathOOC()
	if not UnitAffectingCombat("player")
		and not UnitAffectingCombat("target")
		and not UnitIsPVP("target") then
			IWin:Wrath()
	end
end