if UnitClass("player") ~= "Warrior" then return end

function IWin:IsOverpowerAvailable()
	local overpowerRemaining = IWin_CombatVar["overpowerAvailable"] - GetTime() - 0.2
 	return overpowerRemaining > IWin:GetGCDRemaining()
end

function IWin:IsRevengeAvailable()
	local revengeRemaining = IWin_CombatVar["revengeAvailable"] - GetTime()
 	return revengeRemaining > IWin:GetGCDRemaining()
end

function IWin:IsCharging()
	local chargeTimeActive = GetTime() - IWin_CombatVar["charge"]
	return chargeTimeActive < 1
end

function IWin:GetStanceSwapRageRetain()
	return math.min(IWin:GetTalentRank(1, 2) * 5, UnitMana("player"))
end

function IWin:IsStanceSwapMaxRageLoss(maxRageLoss, spell)
	if IWin_Settings["ragePerSecondPrediction"] > 29 then return true end
	local spellCost = 0
	if spell then
		spellCost = IWin_RageCost[spell]
	end
	return maxRageLoss >= math.max(0, UnitMana("player") - IWin:GetStanceSwapRageRetain() + IWin_CombatVar["reservedRage"] + spellCost)
end

function IWin:IsReservedRageStance(stance)
	if IWin_CombatVar["reservedRageStance"] then
		return IWin_CombatVar["reservedRageStance"] == stance
	end
	return true
end

function IWin:SetReservedRageStance(stance)
	if IWin_CombatVar["reservedRageStanceLast"] +  IWin_Settings["GCD"] < GetTime() then
		IWin_CombatVar["reservedRageStance"] = stance
	end
end

function IWin:SetReservedRageStanceCast()
	IWin_CombatVar["reservedRageStanceLast"] = GetTime()
end

function IWin:IsDefensiveTacticsAvailable()
	if IWin:GetTalentRank(3, 18) ~= 0
		and IWin:IsShieldEquipped() then
			return true
	end
	return false
end

function IWin:IsDefensiveTacticsActive(stance)
	local dtStance = stance or IWin:GetStance()
	if IWin:IsDefensiveTacticsAvailable()
		and (
				(
					IWin_Settings["dtBattle"] == "on"
					and dtStance == "Battle Stance"
				) or (
					IWin_Settings["dtDefensive"] == "on"
					and dtStance == "Defensive Stance"
					and IWin:IsSpellLearnt("Defensive Stance")
				) or (
					IWin_Settings["dtBerserker"] == "on"
					and dtStance == "Berserker Stance"
					and IWin:IsSpellLearnt("Berserker Stance")
				)
			) then
			return true
	else
		return false
	end
end

function IWin:IsDefensiveTacticsStanceAvailable(stance)
	if IWin:IsDefensiveTacticsAvailable()
		and (
				(
					IWin_Settings["dtBattle"] == "on"
					and stance == "Battle Stance"
				) or (
					IWin_Settings["dtDefensive"] == "on"
					and stance == "Defensive Stance"
					and IWin:IsSpellLearnt("Defensive Stance")
				) or (
					IWin_Settings["dtBerserker"] == "on"
					and stance == "Berserker Stance"
					and IWin:IsSpellLearnt("Berserker Stance")
				)
			) then
				return true
	else
		return false
	end
end

function IWin:IsHighAP()
	local APbase, APpos, APneg = UnitAttackPower("player")
	return (APbase + APpos - APneg) * 0.35 + 200 > 600 + 20 * 15
end

-- Returns estimated time-to-kill from TimeToKill addon, or nil if unavailable.
function IWin:GetTimeToKill()
	if type(TimeToKill) == "table"
		and type(TimeToKill.GetTTK) == "function" then
			return TimeToKill.GetTTK()
	end
	return nil
end

-- Gates auto Death Wish in /idps and /icleave. Requires burst setting on,
-- combat, 50+ rage, and non-nil TTK (defers until TimeToKill has samples).
-- Boss: fires during execute (HP<=20%), TTK<=35s (buff covers kill),
--   or TTK>=60s (long fight). Holds at TTK 35-60s for execute phase.
-- Elite/normal: fires when TTK>=30s.
function IWin:IsDeathWishBurstAvailable()
	if IWin_Settings["burst"] ~= "on" then return false end
	if not UnitAffectingCombat("player") then return false end
	if UnitMana("player") < 50 then return false end

	local ttk = IWin:GetTimeToKill()
	if ttk == nil then return false end

	if IWin:IsBoss() then
		if IWin:IsExecutePhase() then return true end
		if ttk <= 35 then return true end
		if ttk >= 60 then return true end
		return false
	end

	return ttk >= 30
end