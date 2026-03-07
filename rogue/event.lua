if UnitClass("player") ~= "Rogue" then return end

local string_find = string.find

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Rogue loaded.|r")
		--ttk
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		--energy
		if IWin_Settings["energyTimeToReserveBuffer"] == nil then IWin_Settings["energyTimeToReserveBuffer"] = 0 end
		if IWin_Settings["energyPerSecondPrediction"] == nil then IWin_Settings["energyPerSecondPrediction"] = 10 end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if string_find(arg1,"parry") then
			IWin_RotationVar["riposteAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string_find(arg1,"dodge") then
			IWin_RotationVar["surpriseAttackAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string_find(arg1,"dodged") then
			IWin_RotationVar["surpriseAttackAvailable"] = IWin:GetTime(false) + 4
		end
	end
end)