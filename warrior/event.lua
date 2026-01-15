if UnitClass("player") ~= "Warrior" then return end

IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
IWin:RegisterEvent("SPELLCAST_START")
IWin:RegisterEvent("ACTIONBAR_UPDATE_STATE")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("PLAYER_TARGET_CHANGED")
IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Warrior loaded.|r")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["GCD"] == nil then IWin_Settings["GCD"] = 1.5 end
		if IWin_Settings["rageTimeToReserveBuffer"] == nil then IWin_Settings["rageTimeToReserveBuffer"] = 1.5 end
		if IWin_Settings["ragePerSecondPrediction"] == nil then IWin_Settings["ragePerSecondPrediction"] = 10 end
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		if IWin_Settings["charge"] == nil then IWin_Settings["charge"] = "solo" end
		if IWin_Settings["chargewl"] == nil then IWin_Settings["chargewl"] = "off" end
		if IWin_Settings["sunder"] == nil then IWin_Settings["sunder"] = "off" end
		if IWin_Settings["demo"] == nil then IWin_Settings["demo"] = "off" end
		if IWin_Settings["dtBattle"] == nil then IWin_Settings["dtBattle"] = "on" end
		if IWin_Settings["dtBattle"] == true then IWin_Settings["dtBattle"] = "on" end
		if IWin_Settings["dtBattle"] == false then IWin_Settings["dtBattle"] = "off" end
		if IWin_Settings["dtDefensive"] == nil then IWin_Settings["dtDefensive"] = "on" end
		if IWin_Settings["dtDefensive"] == true then IWin_Settings["dtDefensive"] = "on" end
		if IWin_Settings["dtDefensive"] == false then IWin_Settings["dtDefensive"] = "off" end
		if IWin_Settings["dtBerserker"] == nil then IWin_Settings["dtBerserker"] = "off" end
		if IWin_Settings["dtBerserker"] == true then IWin_Settings["dtBerserker"] = "on" end
		if IWin_Settings["dtBerserker"] == false then IWin_Settings["dtBerserker"] = "off" end
		if IWin_Settings["jousting"] == nil then IWin_Settings["jousting"] = "off" end
		IWin.hasSuperwow = SetAutoloot and true or false
		IWin.hasUnitXP = pcall(UnitXP, "nop", "nop") and true or false
	elseif event == "ADDON_LOADED" and (arg1 == "SuperCleveRoidMacros" or arg1 == "IWinEnhanced") then
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1,"dodge") then
			IWin_CombatVar["overpowerAvailable"] = GetTime() + 5
		end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string.find(arg1,"dodged") then
			IWin_CombatVar["overpowerAvailable"] = GetTime() + 5
		end
	elseif event == "ACTIONBAR_UPDATE_STATE" and arg1 == nil then
		IWin_CombatVar["GCD"] = GetTime()
	elseif event == "SPELLCAST_START" and arg1 == "Slam" then
		IWin_CombatVar["slamCasting"] = GetTime() + (arg2 / 1000)
		if st_timer and st_timer > UnitAttackSpeed("player") * 0.9 then
			IWin_CombatVar["slamGCDAllowed"] = IWin_CombatVar["slamCasting"] + 0.2
			IWin_CombatVar["slamClipAllowedMax"] = IWin_CombatVar["slamGCDAllowed"] + IWin_Settings["GCD"]
			IWin_CombatVar["slamClipAllowedMin"] = st_timer + GetTime()
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
		if string.find(arg1,"blocked") then
			IWin_CombatVar["revengeAvailable"] = GetTime() + 5
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if string.find(arg1,"dodge") or string.find(arg1,"parry") then
			IWin_CombatVar["revengeAvailable"] = GetTime() + 5
		end
	elseif event == "PLAYER_TARGET_CHANGED" or (event == "ADDON_LOADED" and arg1 == "IWinEnhanced") then
		IWin:SetTrainingDummy()
		IWin:SetElite()
		IWin:SetBlacklistFear()
		IWin:SetBlacklistAOEDebuff()
		IWin:SetBlacklistAOEDamage()
		IWin:SetBlacklistKick()
		IWin:SetWhitelistCharge()
	end
end)