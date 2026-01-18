if UnitClass("player") ~= "Warlock" then return end

IWin:RegisterEvent("ADDON_LOADED")
IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Warlock loaded.|r")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		IWin.hasSuperwow = SetAutoloot and true or false
		IWin.hasUnitXP = pcall(UnitXP, "nop", "nop") and true or false
	elseif event == "ADDON_LOADED" and (arg1 == "SuperCleveRoidMacros" or arg1 == "IWinEnhanced") then
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	end
end)