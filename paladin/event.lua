if UnitClass("player") ~= "Paladin" then return end

IWin:RegisterEvent("ACTIONBAR_UPDATE_STATE")
IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("UNIT_INVENTORY_CHANGED")
IWin:RegisterEvent("PLAYER_TARGET_CHANGED")
IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Paladin loaded.|r")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["GCD"] == nil then  IWin_Settings["GCD"] = 1.5 end
		if IWin_Settings["judgement"] == nil then IWin_Settings["judgement"] = "wisdom" end
		if IWin_Settings["wisdom"] == nil then IWin_Settings["wisdom"] = "elite" end
		if IWin_Settings["crusader"] == nil then IWin_Settings["crusader"] = "boss" end
		if IWin_Settings["light"] == nil then IWin_Settings["light"] = "boss" end
		if IWin_Settings["justice"] == nil then IWin_Settings["justice"] = "boss" end
		if IWin_Settings["soc"] == nil then IWin_Settings["soc"] = "auto" end
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		IWin_CombatVar["weaponAttackSpeed"] = UnitAttackSpeed("player")
		IWin.hasSuperwow = SetAutoloot and true or false
		IWin.hasUnitXP = pcall(UnitXP, "nop", "nop")
	elseif event == "ADDON_LOADED" and arg1 == "PallyPowerTW" then
		IWin.hasPallyPower = PallyPower_SealAssignments and true or false
	elseif event == "ADDON_LOADED" and (arg1 == "SuperCleveRoidMacros" or arg1 == "IWinEnhanced") then
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	elseif event == "ACTIONBAR_UPDATE_STATE" and arg1 == nil then
		IWin_CombatVar["GCD"] = GetTime()
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		if not IWin.libdebuff then
			IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	    	if not IWin.libdebuff then return 0 end
		end
		IWin_CombatVar["weaponAttackSpeed"] = UnitAttackSpeed("player") * (1 + IWin:GetBuffStack("player","Zeal") * 0.05)
	elseif event == "PLAYER_TARGET_CHANGED" or (event == "ADDON_LOADED" and arg1 == "IWinEnhanced") then
		IWin:SetTrainingDummy()
		IWin:SetWhitelistBoss()
		IWin:SetElite()
		IWin:SetBoss()
	end
end)