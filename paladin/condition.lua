if UnitClass("player") ~= "Paladin" then return end

function IWin:IsDPSWindow(cooldown)
	if not IWin:IsInRange() then return false end
	local ttd = IWin:GetTimeToDie()
	--prevent waste
	local minBuffLenght = IWin_ItemBuffDuration[cooldown] * 0.3
	if ttd < minBuffLenght then return false end
	--burst short fight
	local lastDPSWindow = IWin_ItemBuffDuration[cooldown] + IWin_Settings["GCD"] * 2
	if ttd <= lastDPSWindow then return true end
	--wait max output
	if not IWin:IsBuffStack("player", "Vengeance", 3, nil, false) and IWin:GetTalentRank("Vengeance", false) then return false end
	if not IWin:IsBuffStack("player", "Zeal", 3, nil, false) and IWin:GetTalentRank("Vengeful Strikes", false) then return false end
	--go
	return true
end

function IWin:IsJudgementTarget(judgement, debugmsg)
	local targetClassification = IWin_Settings[judgement]
	if (
			targetClassification == "elite"
			and IWin:IsElite()
		) or (
			targetClassification == "boss"
			and IWin:IsBoss()
		) or targetClassification == "all" then
			IWin:Debug("Target classification for assigned judgement: true", debugmsg)
			return true
	end
	IWin:Debug("Target classification for assigned judgement: false", debugmsg)
	return false
end

function IWin:IsSealActive(debugmsg)
	local result = IWin:IsBuffActive("player","Seal of Righteousness", nil, false)
					or IWin:IsBuffActive("player","Seal of Wisdom", nil, false)
					or IWin:IsBuffActive("player","Seal of Light", nil, false)
					or IWin:IsBuffActive("player","Seal of Justice", nil, false)
					or IWin:IsBuffActive("player","Seal of the Crusader", nil, false)
					or IWin:IsBuffActive("player","Seal of Command", nil, false)
	IWin:Debug("Seal is active: "..tostring(result), debugmsg)
	return result
end

function IWin:IsJudgementOverwrite(judgement, seal, debugmsg)
	local result = IWin:IsBuffActive("target", judgement, nil, false) and IWin:IsBuffActive("player", seal, nil, false)
	IWin:Debug(judgement.." already applied: "..tostring(result), debugmsg)
	return result
end

function IWin:IsJudgementActive(debugmsg)
	local result = IWin:IsBuffActive("target","Judgement of Wisdom", "player", false)
					or IWin:IsBuffActive("target","Judgement of Light", "player", false)
					or IWin:IsBuffActive("target","Judgement of Justice", "player", false)
					or IWin:IsBuffActive("target","Judgement of the Crusader", "player", false)
	IWin:Debug("Player has an active judgement: "..tostring(result), debugmsg)
	return result
end

function IWin:IsAuraActive(debugmsg)
	local result = IWin:IsStanceActive("Devotion Aura", false)
					or IWin:IsStanceActive("Retribution Aura", false)
					or IWin:IsStanceActive("Concentration Aura", false)
					or IWin:IsStanceActive("Shadow Resistance Aura", false)
					or IWin:IsStanceActive("Frost Resistance Aura", false)
					or IWin:IsStanceActive("Fire Resistance Aura", false)
					or IWin:IsStanceActive("Sanctity Aura", false)
	IWin:Debug("Player has an active aura: "..tostring(result), debugmsg)
	return result
end

function IWin:IsBlessingActive(debugmsg)
	local result = IWin:IsBuffActive("player","Blessing of Sanctuary", nil, false)
					or IWin:IsBuffActive("player","Greater Blessing of Sanctuary", nil, false)
					or IWin:IsBuffActive("player","Blessing of Might", nil, false)
					or IWin:IsBuffActive("player","Greater Blessing of Might", nil, false)
					or IWin:IsBuffActive("player","Blessing of Wisdom", nil, false)
					or IWin:IsBuffActive("player","Greater Blessing of Wisdom", nil, false)
					or IWin:IsBuffActive("player","Blessing of Light", nil, false)
					or IWin:IsBuffActive("player","Greater Blessing of Light", nil, false)
					or IWin:IsBuffActive("player","Blessing of Kings", nil, false)
					or IWin:IsBuffActive("player","Greater Blessing of Kings", nil, false)
					or IWin:IsBuffActive("player","Blessing of Salvation", nil, false)
					or IWin:IsBuffActive("player","Greater Blessing of Salvation", nil, false)
	IWin:Debug("Player has an active blessing: "..tostring(result), debugmsg)
	return result
end

function IWin:IsHiddenSealUsed(seal, debugmsg) --fix for Doiteaura not removing used seal from hidden buff
	local result
	if seal then
		result = IWin:IsBuffActive("player", seal, nil, false) and (not IWin:IsActionUsable("Judgement", false)) and IWin:IsInRange("Judgement")
		IWin:Debug("Player has used hidden "..seal..": "..tostring(result), debugmsg)
	else
		result = IWin:IsSealActive(false) and (not IWin:IsActionUsable("Judgement", false)) and IWin:IsInRange("Judgement")
		IWin:Debug("Player has used hidden seal: "..tostring(result), debugmsg)
	end
	return result
end