if UnitClass("player") ~= "Druid" then return end

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("SPELLCAST_START")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Druid loaded.|r")
		--ttk
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		--rage
		if IWin_Settings["rageTimeToReserveBuffer"] == nil then IWin_Settings["rageTimeToReserveBuffer"] = 1.5 end
		if IWin_Settings["ragePerSecondPrediction"] == nil then IWin_Settings["ragePerSecondPrediction"] = 10 end
		--eneregy
		if IWin_Settings["energyTimeToReserveBuffer"] == nil then IWin_Settings["energyTimeToReserveBuffer"] = 0 end
		if IWin_Settings["energyPerSecondPrediction"] == nil then IWin_Settings["energyPerSecondPrediction"] = 10 end
		--setup
		if IWin_Settings["frontShred"] == nil then IWin_Settings["frontShred"] = "off" end
		if IWin_Settings["berserkCat"] == nil then IWin_Settings["berserkCat"] = "on" end
	elseif event == "SPELLCAST_START" and (arg1 == "Wrath" or arg1 == "Starfire") then
		IWin_RotationVar["lastMoonkinSpell"] = arg1
		IWin_RotationVar["lastMoonkinSpellTime"] = IWin:GetTime(false) + (arg2 / 1000)
	end
end)