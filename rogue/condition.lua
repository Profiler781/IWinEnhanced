if UnitClass("player") ~= "Rogue" then return end

function IWin:IsSurpriseAttackAvailable(debugmsg)
	local surpriseAttackRemaining = IWin_RotationVar["surpriseAttackAvailable"] - GetTime()
 	local result = surpriseAttackRemaining > IWin:GetGCDRemaining(false)
 	IWin:Debug("Surprise attack available: "..tostring(result), debugmsg)
 	return result
end

function IWin:IsRiposteAvailable(debugmsg)
	local riposteRemaining = IWin_RotationVar["riposteAvailable"] - GetTime()
 	local result = riposteRemaining > IWin:GetGCDRemaining(false)
 	IWin:Debug("Riposte available: "..tostring(result), debugmsg)
 	return result
end

function IWin:IsMaxComboPoints(debugmsg)
	if GetComboPoints(false) == 5
		or (
				IWin:GetComboPoints(false) == 4
				and IWin:GetTalentRank("Seal Fate", false) == 5
			) then
				IWin:Debug("Max combo: true", debugmsg)
				return true
	end
	IWin:Debug("Max combo: false", debugmsg)
	return false
end

function IWin:GetRuptureDuration(debugmsg)
	local cpDuration = 6 + IWin:GetComboPoints(false) * 2
	local tasteForBloodDuration = IWin_RuptureDurationIncrease[IWin:GetTalentRank("Taste for Blood", false)]
	local result = cpDuration + tasteForBloodDuration
	IWin:Debug("Rupture full duration: "..tostring(result), debugmsg)
	return result
end