if UnitClass("player") ~= "Druid" then return end

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("SPELLCAST_START")
IWin:RegisterEvent("PLAYER_TARGET_CHANGED")
IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Druid loaded.|r")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["GCD"] == nil then IWin_Settings["GCD"] = 1.5 end
		if IWin_Settings["GCDEnergy"] == nil then IWin_Settings["GCDEnergy"] = 1 end
		if IWin_Settings["rageTimeToReserveBuffer"] == nil then IWin_Settings["rageTimeToReserveBuffer"] = 1.5 end
		if IWin_Settings["energyTimeToReserveBuffer"] == nil then IWin_Settings["energyTimeToReserveBuffer"] = 0 end
		if IWin_Settings["ragePerSecondPrediction"] == nil then IWin_Settings["ragePerSecondPrediction"] = 10 end
		if IWin_Settings["energyPerSecondPrediction"] == nil then IWin_Settings["energyPerSecondPrediction"] = 10 end
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		if IWin_Settings["frontShred"] == nil then IWin_Settings["frontShred"] = "off" end
		IWin.hasSuperwow = SetAutoloot and true or false
		IWin.hasUnitXP = pcall(UnitXP, "nop", "nop") and true or false
	elseif event == "ADDON_LOADED" and (arg1 == "SuperCleveRoidMacros" or arg1 == "IWinEnhanced") then
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	elseif event == "SPELLCAST_START" and (arg1 == "Wrath" or arg1 == "Starfire") then
		IWin_CombatVar["lastMoonkinSpell"] = arg1
		IWin_CombatVar["lastMoonkinSpellTime"] = GetTime() + (arg2 / 1000)
	elseif event == "PLAYER_TARGET_CHANGED" or (event == "ADDON_LOADED" and arg1 == "IWinEnhanced") then
		IWin:SetBlacklistFear()
		IWin:SetBlacklistAOEDebuff()
		IWin:SetBlacklistAOEDamage()
	end
end)