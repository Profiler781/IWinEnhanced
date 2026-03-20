if UnitClass("player") ~= "Warrior" then return end

local string_find = string.find
local UnitAttackSpeed = UnitAttackSpeed

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
IWin:RegisterEvent("PLAYER_REGEN_ENABLED")
IWin:RegisterEvent("PLAYER_REGEN_DISABLED")
IWin:RegisterEvent("PLAYER_ENTERING_WORLD")
IWin:RegisterEvent("SPELLCAST_START")
IWin:RegisterEvent("SPELLS_CHANGED")
IWin:RegisterEvent("UNIT_INVENTORY_CHANGED")
IWin:RegisterEvent("UNIT_RAGE_GUID")

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
		if IWin_Settings["chargepartysize"] == nil then IWin_Settings["chargepartysize"] = 1 end
		if IWin_Settings["chargenocombat"] == nil then IWin_Settings["chargenocombat"] = "on" end
		if IWin_Settings["chargewl"] == nil then IWin_Settings["chargewl"] = "off" end
		if IWin_Settings["sunder"] == nil then IWin_Settings["sunder"] = "off" end
		if IWin_Settings["demo"] == nil then IWin_Settings["demo"] = "off" end
		if IWin_Settings["dtBattle"] == nil then IWin_Settings["dtBattle"] = "on" end
		if IWin_Settings["dtDefensive"] == nil then IWin_Settings["dtDefensive"] = "on" end
		if IWin_Settings["dtBerserker"] == nil then IWin_Settings["dtBerserker"] = "off" end
		if IWin_Settings["jousting"] == nil then IWin_Settings["jousting"] = "off" end
		if IWin_Settings["thunderclap"] == nil then IWin_Settings["thunderclap"] = "on" end
		if IWin_Settings["overpower"] == nil then IWin_Settings["overpower"] = "on" end
		if IWin_Settings["berserkerrage"] == nil then IWin_Settings["berserkerrage"] = "on" end
		if IWin_Settings["rend"] == nil then IWin_Settings["rend"] = "on" end
		if IWin_Settings["preattack"] == nil then IWin_Settings["preattack"] = "off" end
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
		IWin_RotationVar["combatStart"] = GetTime()
		IWin_RLS = nil
		IWin_RLS_lastRage = nil
		IWin_RLS_lastValue = nil
		IWin:UpdateRageCosts()
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
	elseif event == "PLAYER_ENTERING_WORLD" then
		if UnitAffectingCombat("player") then
			IWin:ResetRageRLS()
			IWin_RLS_lastRage = UnitMana("player")
			IWin_RotationVar["combatStart"] = GetTime()
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		IWin:ResetRageRLS()
		IWin_RLS_lastRage = UnitMana("player")
		IWin_RotationVar["combatStart"] = GetTime()
	elseif event == "PLAYER_REGEN_ENABLED" then
		IWin_RLS_lastValue = nil
		IWin_RLS_lastRage = nil
	elseif event == "SPELLCAST_START" and arg1 == "Slam" then
		IWin_RotationVar["slamCasting"] = IWin:GetTime(false) + (arg2 / 1000)
		if st_timer and st_timer > UnitAttackSpeed("player") * 0.9 then
			IWin_RotationVar["slamGCDAllowed"] = IWin_RotationVar["slamCasting"] + 0.2
			IWin_RotationVar["slamClipAllowedMax"] = IWin_RotationVar["slamGCDAllowed"] + IWin_Settings["GCD"]
			IWin_RotationVar["slamClipAllowedMin"] = st_timer + IWin:GetTime(false)
		end
	elseif event == "SPELLS_CHANGED" then
		IWin:UpdateRageCosts()
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" and not UnitAffectingCombat("player") then
		IWin:UpdateRageCosts()
	elseif event == "UNIT_RAGE_GUID" and arg2 == 1 and IWin_RLS_lastRage then
		local currentRage = UnitMana("player")
		local delta = currentRage - IWin_RLS_lastRage
		if delta > 0 then
			IWin_RLS_pendingGain = (IWin_RLS_pendingGain or 0) + delta
		end
		IWin_RLS_lastRage = currentRage
	end
end)

IWin:SetScript("OnUpdate", function()
	IWin_RLS_updateTimer = (IWin_RLS_updateTimer or 0) + arg1
	if IWin_RLS_updateTimer < 0.5 then return end
	IWin_RLS_updateTimer = 0
	if not IWin_RLS then return end
	local gain = IWin_RLS_pendingGain or 0
	IWin_RLS_pendingGain = 0
	if gain > 0 then
		IWin:UpdateRageRLS(gain)
	end
end)