if UnitClass("player") ~= "Warrior" then return end

local UnitAttackPower = UnitAttackPower

function IWin:IsOverpowerAvailable(debugmsg)
	local overpowerRemaining = IWin_RotationVar["overpowerAvailable"] - IWin:GetTime(false) - 0.2
 	local result = overpowerRemaining > IWin:GetGCDRemaining(false)
 	IWin:Debug("Overpower available: "..tostring(result), debugmsg)
 	return result
end

function IWin:IsRevengeAvailable(debugmsg)
	local revengeRemaining = IWin_RotationVar["revengeAvailable"] - IWin:GetTime(false)
 	local result = revengeRemaining > IWin:GetGCDRemaining(false)
 	IWin:Debug("Revenge available: "..tostring(result), debugmsg)
 	return result
end

function IWin:IsCharging(debugmsg)
	local chargeTimeActive = IWin:GetTime(false) - IWin_RotationVar["charge"]
	local result = chargeTimeActive < 1
	IWin:Debug("Player is charging: "..tostring(result), debugmsg)
	return result
end

function IWin:GetStanceSwapRageRetain(debugmsg)
	local result = math.min(IWin:GetTalentRank("Tactical Mastery", false) * 5, IWin:GetPower("player", false))
	IWin:Debug("Rage kept after next stance swap: "..tostring(result), debugmsg)
	return result
end

function IWin:IsStanceSwapMaxRageLoss(maxRageLoss, spell, debugmsg)
	if IWin_Settings["ragePerSecondPrediction"] > 29 then return true end
	local spellCost = 0
	if spell then
		spellCost = IWin_RageCost[spell]
	end
	local result = maxRageLoss >= math.max(0, IWin:GetPower("player", false) - IWin:GetStanceSwapRageRetain(false) + IWin_CombatVar["reservedRage"] + spellCost)
	IWin:Debug("Maximum "..maxRageLoss.." rage lost after next stance swap: "..tostring(result), debugmsg)
	return result
end

function IWin:IsReservedRageStance(stance, debugmsg)
	if IWin_RotationVar["reservedRageStance"] then
		local result = IWin_RotationVar["reservedRageStance"] == stance
		IWin:Debug(stance.." is reserved: "..tostring(result), debugmsg)
		return result
	end
	IWin:Debug("No stance is reserved", debugmsg)
	return true
end

function IWin:SetReservedRageStance(stance, debugmsg)
	if IWin_RotationVar["reservedRageStanceLast"] + IWin_Settings["GCD"] < IWin:GetTime(false) then
		IWin:Debug(stance.." has been reserved", debugmsg)
		IWin_RotationVar["reservedRageStance"] = stance
	end
end

function IWin:IsReservedRageStanceCast(debugmsg)
	local result = IWin_RotationVar["reservedRageStanceLast"] > IWin:GetTime(false)
	IWin:Debug("Stance is locked: "..tostring(result), debugmsg)
	return result
end

function IWin:SetReservedRageStanceCast(debugmsg)
	IWin:Debug("Stance locked for 1 GCD", debugmsg)
	IWin_RotationVar["reservedRageStanceLast"] = IWin:GetTime(false) + IWin_Settings["GCD"]
end

function IWin:IsDefensiveTacticsAvailable(debugmsg)
	if IWin:GetTalentRank("Defensive Tactics", false) ~= 0
		and IWin:IsShieldEquipped(false) then
			IWin:Debug("Defensive Tactics available: true", debugmsg)
			return true
	end
	IWin:Debug("Defensive Tactics available: false", debugmsg)
	return false
end

function IWin:IsDefensiveTacticsActive(stance, debugmsg)
	local dtStance = stance or IWin:GetStance(false)
	if IWin:IsDefensiveTacticsAvailable(false)
		and (
				(
					IWin_Settings["dtBattle"] == "on"
					and dtStance == "Battle Stance"
				) or (
					IWin_Settings["dtDefensive"] == "on"
					and dtStance == "Defensive Stance"
					and IWin:IsSpellLearnt("Defensive Stance", nil, false)
				) or (
					IWin_Settings["dtBerserker"] == "on"
					and dtStance == "Berserker Stance"
					and IWin:IsSpellLearnt("Berserker Stance", nil, false)
				)
			) then
				IWin:Debug(stance.." allowed for Defensive Tactics: true", debugmsg)
				return true
	end
	IWin:Debug(stance.." allowed for Defensive Tactics: false", debugmsg)
	return false
end

function IWin:IsDefensiveTacticsStanceAvailable(stance, debugmsg)
	if IWin:IsDefensiveTacticsAvailable(false)
		and (
				(
					IWin_Settings["dtBattle"] == "on"
					and stance == "Battle Stance"
				) or (
					IWin_Settings["dtDefensive"] == "on"
					and stance == "Defensive Stance"
					and IWin:IsSpellLearnt("Defensive Stance", nil, false)
				) or (
					IWin_Settings["dtBerserker"] == "on"
					and stance == "Berserker Stance"
					and IWin:IsSpellLearnt("Berserker Stance", nil, false)
				)
			) then
				IWin:Debug(stance.." allowed for Defensive Tactics: true", debugmsg)
				return true
	end
	IWin:Debug(stance.." allowed for Defensive Tactics: false", debugmsg)
	return false
end

function IWin:IsHighAP(debugmsg)
	local APbase, APpos, APneg = UnitAttackPower("player")
	local result = (APbase + APpos - APneg) * 0.35 + 200
	IWin:Debug("Attack power : "..tostring(result), debugmsg)
	return result > 600 + 20 * 15
end