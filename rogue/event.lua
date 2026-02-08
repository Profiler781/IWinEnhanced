if UnitClass("player") ~= "Rogue" then return end

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
IWin:RegisterEvent("PLAYER_TARGET_CHANGED")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Rogue loaded.|r")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["GCDEnergy"] == nil then IWin_Settings["GCDEnergy"] = 1 end
		if IWin_Settings["energyTimeToReserveBuffer"] == nil then IWin_Settings["energyTimeToReserveBuffer"] = 0 end
		if IWin_Settings["energyPerSecondPrediction"] == nil then IWin_Settings["energyPerSecondPrediction"] = 10 end
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		IWin.hasSuperwow = SetAutoloot and true or false
		IWin.hasUnitXP = pcall(UnitXP, "nop", "nop") and true or false
	elseif event == "ADDON_LOADED" and (arg1 == "SuperCleveRoidMacros" or arg1 == "IWinEnhanced") then
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1,"dodge") then
			IWin_CombatVar["surpriseAttackAvailable"] = GetTime() + 5
		end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string.find(arg1,"dodged") then
			IWin_CombatVar["surpriseAttackAvailable"] = GetTime() + 5
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if string.find(arg1,"parry") then
			IWin_CombatVar["riposteAvailable"] = GetTime() + 5
		end
	elseif event == "PLAYER_TARGET_CHANGED" or (event == "ADDON_LOADED" and arg1 == "IWinEnhanced") then
		IWin:SetBoss()
	end
end)