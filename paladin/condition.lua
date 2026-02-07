if UnitClass("player") ~= "Paladin" then return end

function IWin:IsJudgementTarget(judgement)
	if (
			IWin_Settings[judgement] == "elite"
			and IWin:IsElite()
		) or (
			IWin_Settings[judgement] == "boss"
			and IWin:IsBoss()
		) then
			return true
	end
	return false
end

function IWin:IsSealActive()
	return IWin:IsBuffActive("player","Seal of Righteousness")
		or IWin:IsBuffActive("player","Seal of Wisdom")
		or IWin:IsBuffActive("player","Seal of Light")
		or IWin:IsBuffActive("player","Seal of Justice")
		or IWin:IsBuffActive("player","Seal of the Crusader")
		or IWin:IsBuffActive("player","Seal of Command")
end

function IWin:IsJudgementOverwrite(judgement, seal)
	return IWin:IsBuffActive("target",judgement) and IWin:IsBuffActive("player",seal)
end

function IWin:IsJudgementActive()
	return IWin:IsBuffActive("target","Judgement of Wisdom")
		or IWin:IsBuffActive("target","Judgement of Light")
		or IWin:IsBuffActive("target","Judgement of Justice")
		or IWin:IsBuffActive("target","Judgement of the Crusader")
end

function IWin:IsAuraActive()
	return IWin:IsStanceActive("Devotion Aura")
		or IWin:IsStanceActive("Retribution Aura")
		or IWin:IsStanceActive("Concentration Aura")
		or IWin:IsStanceActive("Shadow Resistance Aura")
		or IWin:IsStanceActive("Frost Resistance Aura")
		or IWin:IsStanceActive("Fire Resistance Aura")
		or IWin:IsStanceActive("Sanctity Aura")
end

function IWin:IsBlessingActive()
	return IWin:IsBuffActive("player","Blessing of Sanctuary")
		or IWin:IsBuffActive("player","Greater Blessing of Sanctuary")
		or IWin:IsBuffActive("player","Blessing of Might")
		or IWin:IsBuffActive("player","Greater Blessing of Might")
		or IWin:IsBuffActive("player","Blessing of Wisdom")
		or IWin:IsBuffActive("player","Greater Blessing of Wisdom")
		or IWin:IsBuffActive("player","Blessing of Light")
		or IWin:IsBuffActive("player","Greater Blessing of Light")
		or IWin:IsBuffActive("player","Blessing of Kings")
		or IWin:IsBuffActive("player","Greater Blessing of Kings")
		or IWin:IsBuffActive("player","Blessing of Salvation")
		or IWin:IsBuffActive("player","Greater Blessing of Salvation")
end

function IWin:IsSealHidden()
	return false
	--return (not IWin:IsSealActive()) and IWin:IsActionUsable("Judgement")
end