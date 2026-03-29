if UnitClass("player") ~= "Rogue" then return end

function IWin:IsDPSWindow(cooldown)
	local ttd = IWin:GetTimeToDie()
	local buffDuration = IWin_BuffDuration[cooldown]
	--prevent waste
	local minBuffLenght = buffDuration * 0.3
	if ttd < minBuffLenght then return false end
	--burst short fight
	local lastDPSWindow = buffDuration + IWin_Settings["GCD"] * 2
	if ttd < lastDPSWindow then return true end
	--wait max output
	if not IWin:IsMaxComboPoints(false) then return false end
	--go
	return true
end

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

function IWin:GetEnergyPerSecond(debugmsg)
	local result = IWin_RotationVar["energyTick"] / IWin_RotationVar["energyTickTime"]
	IWin:Debug("Energy per second: "..tostring(result), debugmsg)
	return result
end

function IWin:GetTimeToEnergyMax(debugmsg)
	local energyToMax = IWin:GetPowerMax("player", false) - IWin:GetPower("player", false)
	if energyToMax == 0 then
		IWin:Debug("Time to maximum energy: 0", debugmsg)
		return 0
	end
	local energyTicksToMax = math.floor(energyToMax / IWin_RotationVar["energyTick"])
	local result = IWin_RotationVar["energyNextTickTime"] + energyTicksToMax * IWin_RotationVar["energyTickTime"]
	IWin:Debug("Time to maximum energy: "..tostring(result), debugmsg)
	return result
end