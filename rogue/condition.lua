if UnitClass("player") ~= "Rogue" then return end

function IWin:IsSurpriseAttackAvailable()
	local surpriseAttackRemaining = IWin_RotationVar["surpriseAttackAvailable"] - GetTime()
 	local result = surpriseAttackRemaining > IWin:GetGCDRemaining(false)
 	IWin:Debug("Surprise attack available: "..tostring(result))
 	return result
end

function IWin:IsRiposteAvailable()
	local riposteRemaining = IWin_RotationVar["riposteAvailable"] - GetTime()
 	local result = riposteRemaining > IWin:GetGCDRemaining(false)
 	IWin:Debug("Riposte available: "..tostring(result))
 	return result
end

function IWin:IsMaxComboPoints(debugmsg)
	if GetComboPoints() == 5
		or (
				GetComboPoints() == 4
				and IWin:GetTalentRank(1, 17) == 5 --seal of fate
			) then
				IWin:Debug("Max combo: true", debugmsg)
				return true
	end
	IWin:Debug("Max combo: false", debugmsg)
	return false
end

function IWin:GetRuptureDuration(debugmsg)
	local cpDuration = 6 + GetComboPoints() * 2
	local tasteForBloodDuration = IWin:GetTalentRank(1, 10) * 2
	local result = cpDuration + tasteForBloodDuration
	IWin:Debug("Rupture full duration: "..tostring(result), debugmsg)
	return result
end

function IWin:GetMaxEnergy()
	local result = 100 + IWin:GetTalentRank(1, 16) * 5
	IWin:Debug("Max energy: "..tostring(result))
	return result
end