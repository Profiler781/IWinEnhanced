if UnitClass("player") ~= "Warrior" then return end

local string_find = string.find
local UnitAttackSpeed = UnitAttackSpeed

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
IWin:RegisterEvent("SPELLCAST_START")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Warrior loaded.|r")
		--ttk
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		--rage
		if IWin_Settings["rageTimeToReserveBuffer"] == nil then IWin_Settings["rageTimeToReserveBuffer"] = 1.5 end
		if IWin_Settings["ragePerSecondPrediction"] == nil then IWin_Settings["ragePerSecondPrediction"] = 10 end
		--setup
		if IWin_Settings["charge"] == nil then IWin_Settings["charge"] = "solo" end
		if IWin_Settings["chargewl"] == nil then IWin_Settings["chargewl"] = "off" end
		if IWin_Settings["sunder"] == nil then IWin_Settings["sunder"] = "off" end
		if IWin_Settings["demo"] == nil then IWin_Settings["demo"] = "off" end
		if IWin_Settings["dtBattle"] == nil then IWin_Settings["dtBattle"] = "on" end
		if IWin_Settings["dtDefensive"] == nil then IWin_Settings["dtDefensive"] = "on" end
		if IWin_Settings["dtBerserker"] == nil then IWin_Settings["dtBerserker"] = "off" end
		if IWin_Settings["jousting"] == nil then IWin_Settings["jousting"] = "off" end
		if IWin_Settings["thunderclap"] == nil then IWin_Settings["thunderclap"] = "on" end
		--init
		IWin_CombatVar["slamQueued"] = false
		IWin_RotationVar["overpowerAvailable"] = 0
		IWin_RotationVar["revengeAvailable"] = 0
		IWin_RotationVar["reservedRageStance"] = nil
		IWin_RotationVar["reservedRageStanceLast"] = 0
		IWin_RotationVar["charge"] = 0
		IWin_RotationVar["slamCasting"] = 0
		IWin_RotationVar["slamGCDAllowed"] = 0
		IWin_RotationVar["slamClipAllowedMax"] = 0
		IWin_RotationVar["slamClipAllowedMin"] = 0
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
		if string_find(arg1,"blocked") then
			IWin_RotationVar["revengeAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if string_find(arg1,"dodge") or string.find(arg1,"parry") then
			IWin_RotationVar["revengeAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string_find(arg1,"dodge") then
			IWin_RotationVar["overpowerAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string_find(arg1,"dodged") then
			IWin_RotationVar["overpowerAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "SPELLCAST_START" and arg1 == "Slam" then
		IWin_RotationVar["slamCasting"] = IWin:GetTime(false) + (arg2 / 1000)
		if st_timer and st_timer > UnitAttackSpeed("player") * 0.9 then
			IWin_RotationVar["slamGCDAllowed"] = IWin_RotationVar["slamCasting"] + 0.2
			IWin_RotationVar["slamClipAllowedMax"] = IWin_RotationVar["slamGCDAllowed"] + IWin_Settings["GCD"]
			IWin_RotationVar["slamClipAllowedMin"] = st_timer + IWin:GetTime(false)
		end
	end
end)