if UnitClass("player") ~= "Rogue" then return end

function IWin:IsSurpriseAttackAvailable()
	local surpriseAttackRemaining = IWin_CombatVar["surpriseAttackAvailable"] - GetTime()
 	return surpriseAttackRemaining > IWin:GetGCDRemaining()
end

function IWin:IsRiposteAvailable()
	local riposteRemaining = IWin_CombatVar["riposteAvailable"] - GetTime()
 	return riposteRemaining > IWin:GetGCDRemaining()
end