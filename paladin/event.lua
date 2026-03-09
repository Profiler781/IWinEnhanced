if UnitClass("player") ~= "Paladin" then return end

local UnitAttackSpeed = UnitAttackSpeed

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("UNIT_INVENTORY_CHANGED")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Paladin loaded.|r")
		--ttk
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		--setup
		if IWin_Settings["judgement"] == nil then IWin_Settings["judgement"] = "wisdom" end
		if IWin_Settings["wisdom"] == nil then IWin_Settings["wisdom"] = "elite" end
		if IWin_Settings["crusader"] == nil then IWin_Settings["crusader"] = "boss" end
		if IWin_Settings["light"] == nil then IWin_Settings["light"] = "boss" end
		if IWin_Settings["justice"] == nil then IWin_Settings["justice"] = "boss" end
		if IWin_Settings["soc"] == nil then IWin_Settings["soc"] = "auto" end
		--init
		IWin_CombatVar["weaponAttackSpeed"] = UnitAttackSpeed("player")
		IWin.hasPallyPower = PallyPower_SealAssignments and true or false
	elseif event == "ADDON_LOADED" and arg1 == "PallyPowerTW" then
		IWin.hasPallyPower = PallyPower_SealAssignments and true or false
	end
end)