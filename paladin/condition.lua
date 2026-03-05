if UnitClass("player") ~= "Paladin" then return end

function IWin:IsJudgementTarget(judgement)
	if (
			IWin_Settings[judgement] == "elite"
			and IWin:IsElite()
		) or (
			IWin_Settings[judgement] == "boss"
			and IWin:IsBoss()
		) then
			IWin:Debug("Target classification for assigned judgement: true")
			return true
	end
	IWin:Debug("Target classification for assigned judgement: false")
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

function IWin:IsJudgementOverwrite(judgement, seal)
	local result = IWin:IsBuffActive("target", judgement, nil, false) and IWin:IsBuffActive("player", seal, nil, false)
	IWin:Debug(judgement.." already applied: "..tostring(result))
	return result
end

function IWin:IsJudgementActive()
	local result = IWin:IsBuffActive("target","Judgement of Wisdom", "player", false)
					or IWin:IsBuffActive("target","Judgement of Light", "player", false)
					or IWin:IsBuffActive("target","Judgement of Justice", "player", false)
					or IWin:IsBuffActive("target","Judgement of the Crusader", "player", false)
	IWin:Debug("Player has an active judgement: "..tostring(result))
	return result
end

function IWin:IsAuraActive()
	local result = IWin:IsStanceActive("Devotion Aura", false)
					or IWin:IsStanceActive("Retribution Aura", false)
					or IWin:IsStanceActive("Concentration Aura", false)
					or IWin:IsStanceActive("Shadow Resistance Aura", false)
					or IWin:IsStanceActive("Frost Resistance Aura", false)
					or IWin:IsStanceActive("Fire Resistance Aura", false)
					or IWin:IsStanceActive("Sanctity Aura", false)
	IWin:Debug("Player has an active aura: "..tostring(result), false)
	return result
end

function IWin:IsBlessingActive()
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
	IWin:Debug("Player has an active blessing: "..tostring(result), false)
	return result
end

function IWin:IsHiddenSealUsed(seal) --fix for Doiteaura not removing used seal from hidden buff
	local result
	if seal then
		result = IWin:IsBuffActive("player", seal, nil, false) and (not IWin:IsActionUsable("Judgement", false))
		IWin:Debug("Player has used hidden "..seal..": "..tostring(result))
	else
		result = IWin:IsSealActive(false) and (not IWin:IsActionUsable("Judgement", false))
		IWin:Debug("Player has used hidden seal: "..tostring(result))
	end
	return result
end