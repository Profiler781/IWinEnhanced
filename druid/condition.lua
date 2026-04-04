if UnitClass("player") ~= "Druid" then return end

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
	if IWin:GetPowerType("player", false) == "energy" and IWin:GetComboPoints(false) < 5 then return false end
	if IWin:GetPowerType("player", false) == "mana" and IWin:GetTalentRank("Eclipse", false) == 1 and IWin:GetBuffRemaining("player", "Nature Eclipse", nil, false) < 10 and IWin:GetBuffRemaining("player", "Arcane Eclipse", nil, false) < 10 then return false end
	--go
	return true
end

function IWin:GetBleedCount(debugmsg)
	local cached = IWin_CombatVar["bleedCount"]
	if cached ~= nil then
		IWin:Debug("Bleed count: "..tostring(cached), debugmsg)
		return cached
	end
	local result = 0
	for bleed in IWin_Bleed do
		if IWin:IsBuffActive("target", IWin_Bleed[bleed], "player") then
			result = result + 1
		end
	end
	IWin_CombatVar["bleedCount"] = result
	IWin:Debug("Bleed count: "..tostring(result), debugmsg)
	return result
end

function IWin:GetEnergyTickTime(debugmsg)
	local result = IWin:IsBuffActive("player", "Berserk", nil, false) and 1 or 2
	IWin:Debug("Energy tick time: "..tostring(result), debugmsg)
	return result
end

function IWin:GetEnergyTickTigersFury(debugmsg)
	local result = IWin:IsBuffActive("player", "Tiger's Fury", nil, false) and 10 or 0
	IWin:Debug("Energy tick Tiger's Fury: "..tostring(result), debugmsg)
	return result
end

function IWin:GetEnergyTickAncientBrutality(debugmsg)
	local result = ((IWin:GetTalentRank("Ancient Brutality", false) == 2) and (IWin:GetBleedCount(false) * 5)) or 0
	IWin:Debug("Energy tick Ancient Brutality: "..tostring(result), debugmsg)
	return result
end

function IWin:GetEnergyPerSecond(debugmsg)
	local energyNatural = 20 / IWin:GetEnergyTickTime(false)
	local energyTigersFury = IWin:GetEnergyTickTigersFury(false) / 3
	local energyAncientBrutality = IWin:GetEnergyTickAncientBrutality(false) / 3
	local result = energyNatural + energyTigersFury + energyAncientBrutality
	IWin:Debug("Energy per second: "..tostring(result), debugmsg)
	return result
end

function IWin:GetTimeToEnergyMax(debugmsg)
	local energyToMax = IWin:GetPowerMax("player", false) - IWin:GetPower("player", false) - IWin:GetEnergyTickTigersFury(false) - IWin:GetEnergyTickAncientBrutality(false)
	if energyToMax <= 0 then
		IWin:Debug("Time to maximum energy: 0", debugmsg)
		return 0
	end
	local energyTicksToMax = math.floor(energyToMax / 20)
	local result = IWin_RotationVar["energyNextTickTime"] + energyTicksToMax * IWin:GetEnergyTickTime(false)
	IWin:Debug("Time to maximum energy: "..tostring(result), debugmsg)
	return result
end

function IWin:IsPowershiftManaAvailable(debugmsg)
	local result = IWin:GetPlayerDruidManaPercent(false) > 60
					or (
							IWin:GetGroupSize(false) > 2
							and IWin:IsDruidManaAvailable("Reshift", false)
							and IWin:GetPlayerDruidManaPercent(false) > 20
						)
	IWin:Debug("Mana available for powershift: "..tostring(result), debugmsg)
	return result
end

function IWin:IsShredBurstAvailable(debugmsg)
	local result = IWin:IsSpellLearnt("Shred", nil, false)
					and IWin:IsExists("target", false)
					and IWin:IsBehind(false)
					and IWin:IsPowershiftManaAvailable(false)
					and (
							IWin:GetTimeToDie(false) < 20
							or IWin:IsImmune("target", "bleed", false)
						)
	IWin:Debug("Shred burst available: "..tostring(result), debugmsg)
	return result
end