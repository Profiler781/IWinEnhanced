if UnitClass("player") ~= "Warrior" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
	IWin_CombatVar["slamQueued"] = false
	if IWin_RotationVar["reservedRageStanceLast"] < IWin:GetTime(false) then
		IWin:Debug("Stance unlocked", debugmsg)
		IWin_RotationVar["reservedRageStance"] = nil
	end
end

function IWin:BattleShout()
	local spell = "Battle Shout"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("player", spell)
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:BattleShoutRefresh(skipEnemyInRange)
	local spell = "Battle Shout"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetBuffRemaining("player", spell) < 9
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageBattleShoutRefresh(skipEnemyInRange)
	local spell = "Battle Shout"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:GetBuffRemaining("player", spell) < 9
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack", false) > 2) then 
			IWin:SetReservedRage(spell, "buff", "player")
	end
end

function IWin:BattleShoutRefreshOOC()
	local spell = "Battle Shout"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsAffectingCombat("player")
		and IWin:GetBuffRemaining("player", spell) < 30
		and IWin:GetPower("player") > 60
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:BerserkerRage()
	local spell = "Berserker Rage"
	if IWin_Settings["berserkerrage"] == "off" then return end
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsTanking()
			or IWin:GetTalentRank("Improved Berserker Rage") ~= 0
		)
		and IWin:IsStanceActive("Berserker Stance")
		and not IWin:IsBlacklistFear()
		and IWin:IsAffectingCombat("player")
		and IWin:GetPower("player") < 70
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:BerserkerRageImmune()
	local spell = "Berserker Rage"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin_CombatVar["slamQueued"] then
		if not IWin:IsStanceActive("Berserker Stance") then
			IWin:Cast("Berserker Stance", false)
		else
			IWin:Cast(spell)
		end
	end
end

function IWin:Bloodthirst(queueTime)
	local spell = "Bloodthirst"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageBloodthirst()
	local spell = "Bloodthirst"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if not IWin:IsHighAP(false) then 
		IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:BloodthirstHighAP(queueTime)
	local spell = "Bloodthirst"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsBoss() and IWin:GetTimeToDie() < IWin_Settings["GCD"] then return end
	if IWin:IsHighAP()
		and IWin:GetPower("player") < 60
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageBloodthirstHighAP()
	local spell = "Bloodthirst"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBoss() and IWin:GetTimeToDie() < IWin_Settings["GCD"] then return end
	if IWin:IsHighAP(false) then 
		IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:CastCDShortOffensiveGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Short Offensive CD with GCD")
	if not skipTargetControl and not IWin:IsCDShortOffensiveTarget(true) or not IWin_CombatVar["queueGCD"] then return end
	if (
			IWin:IsExecutePhase()
			or (
					(
						not IWin:IsSpellLearnt("Bloodthirst")
						or (
								IWin:GetCooldownRemaining("Bloodthirst") <= IWin_Settings["GCD"] * 2
								and IWin:GetCooldownRemaining("Bloodthirst") >= IWin_Settings["GCD"]
							)
					) and (
						not IWin:IsSpellLearnt("Mortal Strike")
						or (
								IWin:GetCooldownRemaining("Mortal Strike") <= IWin_Settings["GCD"] * 2
								and IWin:GetCooldownRemaining("Mortal Strike") >= IWin_Settings["GCD"]
							)
					) and (
						not IWin:IsSpellLearnt("Shield Slam")
						or (
								IWin:GetCooldownRemaining("Shield Slam") <= IWin_Settings["GCD"] * 2
								and IWin:GetCooldownRemaining("Shield Slam") >= IWin_Settings["GCD"]
							)
					)
				)
		) then
			IWin:CastCDOffensive("Death Wish", skipWindowControl, true)
	end
	if not IWin:IsBuffActive("player", "Recklessness", nil, false) then IWin:CastCDOffensive("Perception", skipWindowControl, true) end
end

function IWin:CastCDShortOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Short Offensive CD with no GCD")
	if not IWin:IsBuffActive("player", "Enrage")
		and IWin:GetPower("player") < 50
		and IWin:GetHealthPercent("player") > 25
		and (
					(
						IWin:IsStanceActive("Defensive Stance")
						and not IWin:IsInRange("Charge", "ranged")
					)
				or (
					IWin:IsAffectingCombat("player")
					and (
							IWin:IsSpellLearnt("Mortal Strike")
							or IWin:IsSpellLearnt("Bloodthirst")
							or IWin:IsSpellLearnt("Shield Slam")
							or IWin:GetTalentRank("Enrage") ~= 0
							or IWin:GetGroupSize() > 1
						)
					)
			) then
				IWin:CastCDOffensive("Bloodrage", skipWindowControl)
	end
	if not skipTargetControl and not IWin:IsCDShortOffensiveTarget(true) then return end
	IWin:CastCDOffensive("Blood Fury", skipWindowControl)
	IWin:CastCDOffensive("Berserking", skipWindowControl)
end

function IWin:CastCDLongOffensiveGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Long Offensive CD with GCD")
	if not skipTargetControl and not IWin:IsCDLongOffensiveTarget(true) or not IWin_CombatVar["queueGCD"] then return end
	if IWin:GetHealthPercent("player") > 25
		and (
				IWin:IsExecutePhase()
				or (
						(
							not IWin:IsSpellLearnt("Bloodthirst")
							or (
									IWin:GetCooldownRemaining("Bloodthirst") <= IWin_Settings["GCD"] * 2
									and IWin:GetCooldownRemaining("Bloodthirst") >= IWin_Settings["GCD"]
								)
						) and (
							not IWin:IsSpellLearnt("Mortal Strike")
							or (
									IWin:GetCooldownRemaining("Mortal Strike") <= IWin_Settings["GCD"] * 2
									and IWin:GetCooldownRemaining("Mortal Strike") >= IWin_Settings["GCD"]
								)
						) and (
							not IWin:IsSpellLearnt("Shield Slam")
							or (
									IWin:GetCooldownRemaining("Shield Slam") <= IWin_Settings["GCD"] * 2
									and IWin:GetCooldownRemaining("Shield Slam") >= IWin_Settings["GCD"]
								)
						)
					)
			) then
				IWin:CastCDOffensive("Recklessness", skipWindowControl, true)
	end
end

function IWin:Charge()
	local spell = "Charge"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange(spell, "ranged")
		and not IWin:IsAffectingCombat("player") then
			if not IWin:IsStanceActive("Battle Stance")
				and (
						IWin:IsStanceSwapMaxRageLoss(25, spell)
						or IWin:IsPVP("target")
					) then
						IWin:Cast("Battle Stance", false)
			end
			if IWin:IsStanceActive("Battle Stance") then
				IWin_RotationVar["charge"] = IWin:GetTime(false)
				IWin:MarkSkull()
				IWin:Cast(spell)
			end
	end
end

function IWin:ChargePartySize()
	local spell = "Charge"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsChargeTargetAvailable() then
		IWin:Charge()
	end
end

function IWin:Cleave(skipEnemyInFront)
	local spell = "Cleave"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin_CombatVar["swingAttackQueued"] then return end
	if (skipEnemyInFront or IWin:GetEnemyInFront("meleeAutoAttack") > 1)
		and (
				IWin:IsRageAvailable(spell)
				or IWin:GetPower("player") > IWin:GetPowerMax("player") - IWin:GetRagePerSecond(false) * IWin_Settings["GCD"]
			) then
				IWin_CombatVar["swingAttackQueued"] = true
				IWin_RotationVar["startAttackThrottle"] = IWin:GetTime(false) + 0.2
				IWin:Cast(spell, false)
	end
end

function IWin:SetReservedRageCleave(skipEnemyInFront)
	local spell = "Cleave"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (skipEnemyInFront or IWin:GetEnemyInFront("meleeAutoAttack", false) > 1) then
		IWin:SetReservedRage(spell, "nocooldown")
	end
end


function IWin:ConcussionBlow()
	local spell = "Concussion Blow"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin_CombatVar["slamQueued"] then
		IWin:Cast(spell)
	end
end

function IWin:ConcussionBlowThreat()
	local spell = "Concussion Blow"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetRagePerSecond() >= 20
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:DemoralizingShout(skipEnemyInRange)
	local spell = "Demoralizing Shout"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin_Settings["demo"] == "on"
		and not IWin:IsBuffActive("target", spell)
		and not IWin:IsBuffActive("target", "Demoralizing Roar")
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and not IWin:IsBlacklistAOEDebuff()
		and IWin:GetTimeToDie() > 10
		and IWin:IsInRange("Intimidating Shout")
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageDemoralizingShout(skipEnemyInRange)
	local spell = "Demoralizing Shout"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin_Settings["demo"] == "on"
		and not IWin:IsBuffActive("target", spell, nil, false)
		and not IWin:IsBuffActive("target", "Demoralizing Roar", nil, false)
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and not IWin:IsBlacklistAOEDebuff(false)
		and IWin:GetTimeToDie(false) > 10 then
			IWin:SetReservedRage(spell, "buff", "target")
	end
end

function IWin:DPSStance(skipEnemyInRange)
	local spell = "Berserker Stance"
	IWin:Debug("+++ checking conditions: "..spell, debugmsg)
	if IWin:IsInRange("Rend")
		and IWin:IsExists("target")
		and not IWin:IsStanceActive(spell) then
			if IWin:IsSpellLearnt(spell)
				and IWin:IsReservedRageStance(spell)
				and IWin:IsExists("target")
				and (
						IWin:IsAffectingCombat("player")
						or IWin:IsInRange()
					)
				and (
						not IWin:IsSpellLearnt("Sweeping Strikes")
						or IWin:IsOnCooldown("Sweeping Strikes")
						or skipEnemyInRange
						or IWin:GetEnemyInRange("meleeAutoAttack") <= 1
					) then
						IWin:SetReservedRageStanceCast()
						IWin:Cast(spell, false)
			elseif not IWin:IsStanceActive("Battle Stance")
				and IWin:IsSpellLearnt("Battle Stance")
				and IWin:IsReservedRageStance("Battle Stance") then
					IWin:SetReservedRageStanceCast()
					IWin:Cast("Battle Stance", false)
			end
	end
end

function IWin:Execute(queueTime, skipEnemyInRange)
	local spell = "Execute"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsExecutePhase()
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") <= 1)
		and (
				IWin:IsPVP("target")
				or IWin:GetHealthPercent("player") < 40
				or IWin:IsElite()
				or (
						not IWin:Is2HanderEquipped()
						and (
								IWin:GetGroupSize() > 5
								or IWin:GetPower("player") < 40
							)
					)
				or IWin:GetTimeToDie() < 4
			)
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Defensive Stance") then
				IWin:Cast("Battle Stance", false)
			else
				IWin:Cast(spell)
			end
	end
end

function IWin:SetReservedRageExecute(skipEnemyInRange)
	local spell = "Execute"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	local lowHealthTarget = (IWin:GetHealthMax("player", false) * 0.3 > IWin:GetHealth("target", false))
	if (
			lowHealthTarget
			or IWin:IsExecutePhase(false)
		)
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack", false) <= 1)
		and (
				IWin:IsPVP("target", false)
				or IWin:GetHealthPercent("player", false) < 40
				or IWin:IsElite(false)
				or (
						not IWin:Is2HanderEquipped(false)
						and (
								IWin:GetGroupSize(false) > 5
								or IWin:GetPower("player", false) < 40
							)
					)
				or IWin:GetTimeToDie(false) < 4
			) then 
				IWin:SetReservedRage(spell, "nocooldown")
	end
end

function IWin:Execute2Hander(skipEnemyInRange)
	local spell = "Execute"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsExecutePhase(false)
		and IWin:Is2HanderEquipped()
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") <= 1)
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Defensive Stance") then
				IWin:Cast("Battle Stance", false)
			else
				IWin:Cast(spell)
			end
	end
end

function IWin:ExecuteDefensiveTactics()
	local spell = "Execute"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsExecutePhase()
		and IWin:IsDefensiveTacticsAvailable()
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Defensive Stance")
				and IWin:IsDefensiveTacticsActive("Berserker Stance") then
					IWin:Cast("Berserker Stance", false)
			elseif IWin:IsStanceActive("Defensive Stance")
				and IWin:IsDefensiveTacticsActive("Battle Stance") then
					IWin:Cast("Battle Stance", false)
			end
			if IWin:IsStanceActive("Battle Stance")
				or IWin:IsStanceActive("Berserker Stance") then
					IWin:Cast(spell)
			end
	end
end

function IWin:SetReservedRageExecuteDefensiveTactics()
	local spell = "Execute"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	local lowHealthTarget = (IWin:GetHealthMax("player", false) * 0.3 > IWin:GetHealth("target", false))
	if (
			lowHealthTarget
			or IWin:IsExecutePhase(false)
		)
		and (
				IWin:IsDefensiveTacticsActive("Battle Stance", false)
				or IWin:IsDefensiveTacticsActive("Berserker Stance", false)
			) then 
				IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:Hamstring()
	local spell = "Hamstring"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange(spell)
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:HamstringJousting(skipEnemyInRange)
	local spell = "Hamstring"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin_Settings["jousting"] == "on"
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") <= 1)
		and IWin:IsInRange(spell)
		and IWin:GetGroupSize() == 1
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:HamstringWindfury()
	local spell = "Hamstring"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false)
		and not IWin:IsStanceActive("Defensive Stance", false)
		and IWin:IsRageAvailable(spell, false) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageHamstringWindfury()
	local spell = "Hamstring"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false)
		and not IWin:IsStanceActive("Defensive Stance", false) then
			IWin:SetReservedRage(spell, "cooldown", nil, false)
	end
end

function IWin:HeroicStrike(skipEnemyInFront)
	local spell = "Heroic Strike"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin_CombatVar["swingAttackQueued"] then return end
	if (
			skipEnemyInFront
			or IWin:GetEnemyInFront("meleeAutoAttack") <= 1
			or not IWin:IsSpellLearnt("Cleave")
		)
		and (
				IWin:IsRageAvailable(spell)
				or (
						IWin:GetPower("player") > IWin:GetPowerMax("player") - IWin:GetRagePerSecond(false) * IWin_Settings["GCD"]
						and (
								not IWin:IsSpellLearnt("Whirlwind")
								or IWin:GetCooldownRemaining("Whirlwind") > 0
							)
					)
			) then
				IWin_CombatVar["swingAttackQueued"] = true
				IWin_RotationVar["startAttackThrottle"] = IWin:GetTime(false) + 0.2
				IWin:Cast(spell, false)
	end
end

function IWin:SetReservedRageHeroicStrike(skipEnemyInRange)
	local spell = "Heroic Strike"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if skipEnemyInRange
		or IWin:GetEnemyInFront("meleeAutoAttack", false) <= 1
		or not IWin:IsSpellLearnt("Cleave") then
			IWin:SetReservedRage(spell, "nocooldown")
	end
end

function IWin:Intercept()
	local spell = "Intercept"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange(spell, "ranged")
		and not IWin:IsCharging()
		and (
				(
					not IWin:IsAffectingCombat("player")
					and IWin:IsOnCooldown("Charge")
				)
				or IWin:IsAffectingCombat("player")
				or (
						IWin:IsStanceActive("Berserker Stance")
						and not IWin:IsStanceSwapMaxRageLoss(25)
						and not IWin:IsPVP("target")
					)
			)
		and (
				(
					IWin:IsRageCostAvailable(spell)
					and (
							IWin:IsStanceActive("Berserker Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost[spell]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Battle Stance")
				or (
						IWin:IsStanceActive("Defensive Stance")
						and not IWin:IsTanking()
					) then
				IWin:Cast("Berserker Stance", false)
			end
			if not IWin:IsRageCostAvailable(spell) then
				IWin:Cast("Bloodrage", false)
			end
			if IWin:IsStanceActive("Berserker Stance") then
				IWin:Cast(spell)
			end
	end
end

function IWin:InterceptPartySize()
	local spell = "Intercept"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsChargeTargetAvailable() then
		IWin:Intercept()
	end
end

function IWin:Intervene()
	local spell = "Intervene"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			(
				IWin:IsInRange(spell, "ranged", "target")
				and IWin:IsFriend("player", "target")
			) or (
				IWin:IsInRange(spell, "ranged", "targettarget")
				and IWin:IsFriend("player", "targettarget")
			)
		)
		and not IWin:IsCharging()
		and IWin:IsBehind()
		and not IWin:IsTanking()
		and not IWin:IsInRange()
		and (
				(
					IWin:IsRageCostAvailable(spell)
					and (
							IWin:IsStanceActive("Defensive Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost[spell]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and not IWin_CombatVar["slamQueued"] then
			if not IWin:IsStanceActive("Defensive Stance") then
				IWin:Cast("Defensive Stance", false)
			end
			if not IWin:IsRageCostAvailable(spell) then
				IWin:Cast("Bloodrage", false)
			end
			if IWin:IsStanceActive("Defensive Stance") then
				if IWin:IsInRange(spell, "ranged", "target")
					and IWin:IsFriend("player", "target") then
						IWin:Cast(spell, true, "target")
				elseif IWin:IsInRange(spell, "ranged", "targettarget")
					and IWin:IsFriend("player", "targettarget") then
						IWin:Cast(spell, true, "targettarget")
				end
			end
	end
end

function IWin:IntervenePartySize()
	local spell = "Intervene"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsChargeTargetAvailable() then
		IWin:Intervene()
	end
end

function IWin:MasterStrike()
	local spell = "Master Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsTanking()
			or IWin:IsPVP("target")
		)
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageMasterStrike()
	local spell = "Master Strike"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsTanking(false)
		or IWin:IsPVP("target", false) then
			IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:MasterStrikeWindfury()
	local spell = "Master Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false)
		and IWin:IsRageAvailable(spell, false) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageMasterStrikeWindfury()
	local spell = "Master Strike"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false) then
		IWin:SetReservedRage(spell, "cooldown", nil, false)
	end
end

function IWin:MockingBlow()
	local spell = "Mocking Blow"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsTanking()
		and IWin:IsOnCooldown("Taunt")
		and not IWin:IsImmune("target", "Mocking Blow")
		and not IWin:IsTaunted() then
			if not IWin:IsStanceActive("Battle Stance") then
				IWin:Cast("Battle Stance", false)
			else
				IWin:Cast(spell)
			end
	end
end

function IWin:MortalStrike(queueTime)
	local spell = "Mortal Strike"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:Overpower()
	local spell = "Overpower"
	if IWin_Settings["overpower"] == "off" then return end
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsRageAvailable(spell)
			or IWin:IsStanceActive("Battle Stance")
		)
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsReservedRageStance("Battle Stance") then
			if IWin:IsOverpowerAvailable(1)
				and not IWin:IsStanceActive("Battle Stance")
				and (
						(
							IWin:IsStanceSwapMaxRageLoss(25 + (IWin:IsWrathDPS3P() and 25 or 0))
							and IWin:GetStanceSwapRageRetain() >= IWin_RageCost[spell]
						)
						or IWin:IsPVP("target")
					) then
						IWin:SetReservedRageStance("Battle Stance")
						IWin:SetReservedRageStanceCast()
						IWin:Cast("Battle Stance", false)
			end
			if IWin:IsOverpowerAvailable(0)
				and IWin:IsStanceActive("Battle Stance") then
				IWin:SetReservedRageStance("Battle Stance")
				IWin:Cast(spell)
			end
	end
end

function IWin:OverpowerDefensiveTactics()
	local spell = "Overpower"
	if IWin_Settings["overpower"] == "off" then return end
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin:IsRageAvailable(spell)
			or IWin:IsStanceActive("Battle Stance")
		)
		and IWin:IsRageCostAvailable(spell)
		and IWin:IsReservedRageStance("Battle Stance")
		and IWin:IsDefensiveTacticsActive("Battle Stance")
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsOverpowerAvailable(1)
				and not IWin:IsStanceActive("Battle Stance")
				and (
						IWin:IsStanceSwapMaxRageLoss(15)
						or IWin:IsPVP("target")
					) then
						IWin:SetReservedRageStance("Battle Stance")
						IWin:SetReservedRageStanceCast()
						IWin:Cast("Battle Stance", false)
			end
			if IWin:IsOverpowerAvailable(0)
				and IWin:IsStanceActive("Battle Stance") then
				IWin:SetReservedRageStance("Battle Stance")
				IWin:Cast(spell)
			end
	end
end

function IWin:OverpowerReact()
	local spell = "Overpower"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsOverpowerAvailable(0)
		and IWin:IsStanceActive("Battle Stance")
		and IWin:IsReservedRageStanceCast()
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:PiercingHowl()
	local spell = "Piercing Howl"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsInRange("Intimidating Shout")
		and IWin:IsRageCostAvailable(spell) then
			IWin:Cast(spell)
	end
end

function IWin:Pummel()
	local spell = "Pummel"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsCasting("target")
		and (
				(
					IWin:IsRageCostAvailable(spell)
					and (
							IWin:IsStanceActive("Berserker Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost[spell]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and (
				not IWin:IsShieldEquipped()
				or not IWin:IsStanceActive("Defensive Stance")
			) then
				if IWin:IsStanceActive("Defensive Stance") then
					IWin:Cast("Battle Stance", false)
				else
					if not IWin:IsRageCostAvailable(spell) then
						IWin:Cast("Bloodrage", false)
					end
					if IWin_RotationVar["slamCasting"] > IWin:GetTime(false) then
						IWin:SpellStopCasting()
					end
					IWin:Cast(spell)
				end
	end
end

function IWin:PummelWindfury()
	local spell = "Pummel"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false)
		and not IWin:IsStanceActive("Defensive Stance", false)
		and not IWin:IsBlacklistKick(false)
		and IWin:IsRageAvailable(spell, false) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRagePummelWindfury()
	local spell = "Pummel"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false)
		and not IWin:IsStanceActive("Defensive Stance", false)
		and not IWin:IsBlacklistKick(false) then
			IWin:SetReservedRage(spell, "cooldown", nil, false)
	end
end

function IWin:Rend()
	local spell = "Rend"
	if IWin_Settings["rend"] == "off" then return end
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", spell, "player")
		and IWin:GetTimeToDie() > 9
		and IWin:GetGroupSize() < 6
		and not IWin:IsImmune("target", "bleed")
		and not IWin:IsStanceActive("Berserker Stance")
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:Revenge()
	local spell = "Revenge"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsReservedRageStance("Defensive Stance")
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsDefensiveTacticsActive("Defensive Stance") then
			if IWin:IsRevengeAvailable(1)
				and not IWin:IsStanceActive("Defensive Stance")
				and (
						IWin:IsStanceSwapMaxRageLoss(5)
						or IWin:IsPVP("target")
					) then
						IWin:SetReservedRageStance("Defensive Stance")
						IWin:SetReservedRageStanceCast()
						IWin:Cast("Defensive Stance", false)
			end
			if IWin:IsRevengeAvailable(0)
				and IWin:IsStanceActive("Defensive Stance") then
					IWin:SetReservedRageStance("Defensive Stance")
					IWin:Cast(spell)
			end
	end
end

function IWin:SetReservedRageRevenge()
	local spell = "Revenge"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsTanking(false) then
		IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:RevengeReact()
	local spell = "Revenge"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsRevengeAvailable(0)
		and IWin:IsStanceActive("Defensive Stance")
		and IWin:IsReservedRageStanceCast()
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:ShieldBash()
	local spell = "Shield Bash"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsCasting("target")
		and IWin:IsShieldEquipped() 
		and (
				(
					IWin:IsRageCostAvailable(spell)
					and (
							not IWin:IsStanceActive("Berserker Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost[spell]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Berserker Stance") then
				IWin:Cast("Defensive Stance", false)
			else
				if not IWin:IsRageCostAvailable(spell) then
					IWin:Cast("Bloodrage", false)
				end
				IWin:Cast(spell)
			end
	end
end

function IWin:ShieldBlock()
	local spell = "Shield Block"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin:IsStanceActive("Defensive Stance")
		and IWin:IsShieldEquipped()
		and IWin:IsTanking()
		and IWin:IsBuffStack("target", "Sunder Armor", 5)
		and not IWin:IsBuffActive("player", "Improved Shield Slam")
		and not IWin:IsBuffActive("player", spell)
		and IWin:GetCooldownRemaining("Revenge") < IWin_Settings["GCD"]
		and not IWin:IsRevengeAvailable(0)
		and IWin:IsRageAvailable(spell) then
			IWin:Cast(spell, false)
	end
end

function IWin:ShieldBlockFRD(skipEnemyInRange)
	local spell = "Shield Block"
	if IWin:IsSpellSkip(spell, nil, false, queueTime, true) then return end
	if IWin:IsStanceActive("Defensive Stance")
		and IWin:IsShieldEquipped()
		and IWin:IsTanking()
		and IWin:IsItemEquipped(17, "Force Reactive Disk")
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and IWin:IsRageAvailable(spell) then
			IWin:Cast(spell, false)
	end
end

function IWin:ShieldSlam(queueTime)
	local spell = "Shield Slam"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsShieldEquipped()
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:Slam()
	local spell = "Slam"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin_RotationVar["reservedRageStanceLast"] + 0.2 < IWin:GetTime(false)
		and IWin:Is2HanderEquipped()
		and (
				not st_timer
				or st_timer > IWin:GetAttackSpeed("player") * 0.5
				--or st_timer > IWin:GetCastTime("Slam")
				--or (
				--		IWin_RotationVar["slamClipAllowedMax"] > IWin:GetTime(false)
				--		and IWin_RotationVar["slamClipAllowedMin"] < IWin:GetTime(false)
				--	)
			)
		and (
				not IWin:IsStanceActive("Battle Stance")
				or not IWin:IsSpellLearnt("Berserker Stance")
			)
		and IWin:IsRageAvailable(spell) then
			IWin:Cast(spell)
	end
end

function IWin:SlamThreat()
	local spell = "Slam"
	if IWin:IsSpellSkip(spell, "Rank 5", true, queueTime, true) then return end
	IWin:Slam()
end

function IWin:SetSlamQueued()
	local spell = "Slam"
	if not st_timer then return end
	if IWin:IsSpellLearnt(spell, nil, false)
		and IWin:Is2HanderEquipped(false) then
			local nextSwing = st_timer + IWin:GetAttackSpeed("player", false)
			local nextSlam = IWin_Settings["GCD"] + IWin:GetCastTime(spell, false)
			if nextSlam > nextSwing
				and IWin_RotationVar["slamGCDAllowed"] < IWin:GetTime(false) then
					IWin_CombatVar["slamQueued"] = true
			end
	end
end

function IWin:SetSlamQueuedThreat()
	local spell = "Slam"
	if (not st_timer) or (not IWin:IsSpellLearnt(spell, "Rank 5", false)) then return end
	IWin:SetSlamQueued()
end

function IWin:SetReservedRageSlam()
	local spell = "Slam"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:Is2HanderEquipped(false) then
		IWin:SetReservedRage(spell, "nocooldown")
	end
	if IWin_RotationVar["slamCasting"] > IWin:GetTime(false) then
		IWin:SetReservedRage(spell, "nocooldown")
	end
end

function IWin:SetReservedRageSlamThreat()
	local spell = "Slam"
	if not IWin:IsSpellLearnt(spell, "Rank 5", false) then return end
	IWin:SetReservedRageSlam()
end

function IWin:SunderArmor()
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SunderArmorFirstStack()
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsBuffActive("target", "Sunder Armor")
		and not IWin:IsBuffActive("target", "Expose Armor")
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SunderArmorDPS()
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin_Settings["sunder"] == "low"
			or IWin_Settings["sunder"] == "high"
			or (
					IWin_Settings["sunder"] == "once"
					and not IWin_Target["sundered"]
				)
		)
		and not IWin:IsBuffStack("target", spell, 5)
		and not IWin:IsBuffActive("target", "Expose Armor")
		and IWin:GetTimeToDie() > 5
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin_Target["sundered"] = true
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageSunderArmorDPS()
	local spell = "Sunder Armor"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (
			IWin_Settings["sunder"] == "low"
			or IWin_Settings["sunder"] == "high"
			or (
					IWin_Settings["sunder"] == "once"
					and not IWin_Target["sundered"]
				)
		)
		and not IWin:IsBuffStack("target", spell, 5, nil, false)
		and not IWin:IsBuffActive("target", "Expose Armor", nil, false)
		and IWin:GetTimeToDie(false) > 5
		and not IWin:Is2HanderEquipped(false) then
			IWin:SetReservedRage(spell, "nocooldown")
	end
end

function IWin:SunderArmorDPS2Hander()
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:Is2HanderEquipped() then
		IWin:SunderArmorDPS()
	end
end

function IWin:SetReservedRageSunderArmorDPS2Hander()
	local spell = "Sunder Armor"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (
			IWin_Settings["sunder"] == "low"
			or IWin_Settings["sunder"] == "high"
			or (
					IWin_Settings["sunder"] == "once"
					and not IWin_Target["sundered"]
				)
		)
		and not IWin:IsBuffStack("target", spell, 5, nil, false)
		and not IWin:IsBuffActive("target", "Expose Armor", nil, false)
		and IWin:GetTimeToDie(false) > 5
		and IWin:Is2HanderEquipped(false) then
			IWin:SetReservedRage(spell, "nocooldown")
	end
end

function IWin:SunderArmorElite()
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin_Settings["sunder"] == "high"
		and not IWin:IsBuffStack("target", spell, 5)
		and not IWin:IsBuffActive("target", "Expose Armor")
		and IWin:GetTimeToDie() > 5
		and IWin:IsElite()
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SunderArmorDPSRefresh(timeLeft)
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if (
			IWin_Settings["sunder"] == "low"
			or IWin_Settings["sunder"] == "high"
			or (
					IWin_Settings["sunder"] == "once"
					and not IWin_Target["sundered"]
				)
		)
		and IWin:IsBuffActive("target", spell)
		and IWin:GetBuffRemaining("target", spell) < timeLeft
		and IWin:GetBuffRemaining("target", spell) < IWin:GetTimeToDie()
		and IWin:IsRageCostAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:SunderArmorWindfury()
	local spell = "Sunder Armor"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false)
		and IWin:IsRageAvailable(spell, false) then
			IWin:Cast(spell)
	end
end

function IWin:SetReservedRageSunderArmorWindfury()
	local spell = "Sunder Armor"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin:IsBuffActive("player", "Windfury Totem", nil, false) then
		IWin:SetReservedRage(spell, "nocooldown", nil, false)
	end
end

function IWin:SweepingStrikes(skipEnemyInRange)
	local spell = "Sweeping Strikes"
	if IWin:IsSpellLearnt(spell)
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 1)
		and IWin:IsReservedRageStance("Battle Stance")
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsTimeToReserveRage(spell, "cooldown") then
			if not IWin:IsStanceActive("Battle Stance")
				and IWin:IsAffectingCombat("player") then
					IWin:SetReservedRageStance("Battle Stance")
					IWin:SetReservedRageStanceCast()
					IWin:Cast("Battle Stance", false)
			end
			if IWin:IsStanceActive("Battle Stance") then
				IWin:SetReservedRageStance("Battle Stance")
				if IWin:IsRageAvailable(spell) then
					IWin:Cast(spell)
				end
			end
	end
end

function IWin:SetReservedRageSweepingStrikes(skipEnemyInRange)
	local spell = "Sweeping Strikes"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if skipEnemyInRange
		or IWin:GetEnemyInRange("meleeAutoAttack", false) > 1 then
			IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:TankStance()
	local spell = "Defensive Stance"
	IWin:Debug("+++ checking conditions: "..spell, debugmsg)
	if IWin:IsSpellLearnt(spell)
		and (
				not IWin:IsDefensiveTacticsAvailable()
				or (
						not IWin:IsDefensiveTacticsActive()
						and IWin:IsDefensiveTacticsActive(spell)
					)
			)
		and IWin:IsAffectingCombat("player")
		and not IWin:IsStanceActive(spell) then
			IWin:Cast(spell, false)
	elseif IWin:IsSpellLearnt("Battle Stance")
		and (
					(
						not IWin:IsDefensiveTacticsAvailable()
						and not IWin:IsSpellLearnt(spell)
					)
				or (
						not IWin:IsDefensiveTacticsActive()
						and IWin:IsDefensiveTacticsActive("Battle Stance")
					)
			)
		and not IWin:IsStanceActive("Battle Stance") then
			IWin:Cast("Battle Stance", false)
	elseif IWin:IsSpellLearnt("Berserker Stance")
		and not IWin:IsDefensiveTacticsActive()
		and IWin:IsDefensiveTacticsActive("Berserker Stance")
		and not IWin:IsStanceActive("Berserker Stance") then
			IWin:Cast("Berserker Stance", false)
	end
end

function IWin:Taunt()
	local spell = "Taunt"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if not IWin:IsTanking()
		and not IWin:IsImmune("target", "Taunt")
		and not IWin:IsTaunted() then
			if not IWin:IsStanceActive("Defensive Stance") then
				IWin:Cast("Defensive Stance", false)
			else
				IWin:Cast(spell)
			end
	end
end

function IWin:ThunderClap(queueTime, skipEnemyInRange)
	local spell = "Thunder Clap"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin_Settings["thunderclap"] == "on"
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and IWin:IsInRange()
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Berserker Stance") then
				IWin:Cast("Defensive Stance", false)
			else
				IWin:Cast(spell)
			end
	end
end

function IWin:SetReservedRageThunderClap(skipEnemyInRange)
	local spell = "Thunder Clap"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if IWin_Settings["thunderclap"] == "on"
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack", false) > 2)
		and IWin:IsInRange() then
			IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:ThunderClapDPS(skipEnemyInRange)
	local spell = "Thunder Clap"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin_Settings["thunderclap"] == "on"
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 2)
		and IWin:IsInRange()
		and not IWin:IsStanceActive("Berserker Stance")
		and IWin:IsRageAvailable(spell)
		and not IWin_CombatVar["slamQueued"] then
			IWin:Cast(spell)
	end
end

function IWin:UseItemConsumableOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Offensive Consumable with no GCD")
	if not skipTargetControl and not IWin:IsItemConsumableOffensiveTarget(true) then return end
	IWin:UseItemConsumableOffensive("Juju Flurry", skipWindowControl)
	IWin:UseItemConsumableOffensive("Mighty Rage Potion", skipWindowControl)
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
	IWin:Debug("+++ checking conditions: Offensive Trinket with GCD")
	if not skipTargetControl and not IWin:IsItemTrinketOffensiveTarget(true) or not IWin_CombatVar["queueGCD"] then return end
	IWin:UseItemTrinketOffensive("Diamond Flask", skipWindowControl, true)
end

function IWin:UseItemTrinketOffensiveNoGCD(skipWindowControl, skipTargetControl)
	IWin:Debug("+++ checking conditions: Offensive Trinket with no GCD")
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

function IWin:Whirlwind(queueTime, skipEnemyInRange)
	local spell = "Whirlwind"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsAffectingCombat("player")
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 1)
		and IWin:IsReservedRageStance("Berserker Stance")
		and not IWin:IsBlacklistAOEDamage()
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsTimeToReserveRage(spell, "cooldown") then
			if not IWin:IsStanceActive("Berserker Stance") then
				IWin:SetReservedRageStance("Berserker Stance")
				IWin:SetReservedRageStanceCast()
				IWin:Cast("Berserker Stance", false)
			end
			if IWin:IsInRange("Rend")
				and IWin:IsStanceActive("Berserker Stance") then
					IWin:SetReservedRageStance("Berserker Stance")
					if IWin:IsRageAvailable(spell) then
						IWin:Cast(spell)
					end
			end
	end
end

function IWin:SetReservedRageWhirlwind(skipEnemyInRange)
	local spell = "Whirlwind"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if not IWin:IsBlacklistAOEDamage()
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack", false) > 1) then
			IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:SetReservedRageWhirlwindNotEnemyInRange(skipEnemyInRange)
	local spell = "Whirlwind"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if not IWin:IsBlacklistAOEDamage()
		and (skipEnemyInRange or not (IWin:GetEnemyInRange("meleeAutoAttack", false) > 1)) then
			IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:WhirlwindDefensiveTactics(queueTime, skipEnemyInRange)
	local spell = "Whirlwind"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsAffectingCombat("player")
		and (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack") > 1)
		and IWin:IsReservedRageStance("Berserker Stance")
		and not IWin:IsBlacklistAOEDamage()
		and IWin:IsDefensiveTacticsActive("Berserker Stance")
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsTimeToReserveRage(spell, "cooldown") then
			if not IWin:IsStanceActive("Berserker Stance") then
				IWin:SetReservedRageStance("Berserker Stance")
				IWin:SetReservedRageStanceCast()
				IWin:Cast("Berserker Stance", false)
			end
			if IWin:IsInRange("Rend")
				and IWin:IsStanceActive("Berserker Stance") then
					IWin:SetReservedRageStance("Berserker Stance")
					if IWin:IsRageAvailable(spell) then
						IWin:Cast(spell)
					end
			end
	end
end

function IWin:SetReservedRageWhirlwindDefensiveTactics(skipEnemyInRange)
	local spell = "Whirlwind"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if (skipEnemyInRange or IWin:GetEnemyInRange("meleeAutoAttack", false) > 1)
		and not IWin:IsBlacklistAOEDamage()
		and IWin:IsDefensiveTacticsActive("Berserker Stance") then
			IWin:SetReservedRage(spell, "cooldown")
	end
end

function IWin:SetReservedRageWhirlwindDefensiveTacticsNotEnemyInRange(skipEnemyInRange)
	local spell = "Whirlwind"
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	if not IWin:IsBlacklistAOEDamage()
		and (skipEnemyInRange or not (IWin:GetEnemyInRange("meleeAutoAttack", false) > 1))
		and IWin:IsDefensiveTacticsActive("Berserker Stance") then
			IWin:SetReservedRage(spell, "cooldown")
	end
end