if UnitClass("player") ~= "Rogue" then return end

function IWin:IsSurpriseAttackAvailable()
	local surpriseAttackRemaining = IWin_CombatVar["surpriseAttackAvailable"] - GetTime()
 	return surpriseAttackRemaining > IWin:GetGCDRemaining()
end

function IWin:IsRiposteAvailable()
	local riposteRemaining = IWin_CombatVar["riposteAvailable"] - GetTime()
 	return riposteRemaining > IWin:GetGCDRemaining()
end

function IWin:IsMaxComboPoints()
	if GetComboPoints() == 5
		or (
				GetComboPoints() == 4
				and IWin:GetTalentRank(1, 17) == 5 --seal of fate
			) then
				return true
	end
	return false
end

function IWin:GetRuptureDuration()
	local cpDuration = 6 + GetComboPoints() * 2
	local tasteForBloodDuration = IWin:GetTalentRank(1, 10) * 2
	return cpDuration + tasteForBloodDuration
end

function IWin:GetMaxEnergy()
	return 100 + IWin:GetTalentRank(1, 16) * 5
end