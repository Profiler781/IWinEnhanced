if UnitClass("player") ~= "Druid" then return end

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("PLAYER_REGEN_ENABLED")
IWin:RegisterEvent("PLAYER_REGEN_DISABLED")
IWin:RegisterEvent("PLAYER_ENTERING_WORLD")
IWin:RegisterEvent("SPELLCAST_START")
IWin:RegisterEvent("SPELLS_CHANGED")
IWin:RegisterEvent("UNIT_INVENTORY_CHANGED")
IWin:RegisterEvent("UNIT_RAGE_GUID")

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
		--init
		IWin_RotationVar["lastMoonkinSpell"] = "Starfire"
		IWin_RotationVar["lastMoonkinSpellTime"] = 0
		IWin_RLS = nil
		IWin_RLS_lastRage = nil
		IWin_RLS_lastValue = nil
		IWin:UpdateSpellCost()
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
	elseif event == "SPELLCAST_START" and (arg1 == "Wrath" or arg1 == "Starfire") then
		IWin_RotationVar["lastMoonkinSpell"] = arg1
		IWin_RotationVar["lastMoonkinSpellTime"] = IWin:GetTime(false) + (arg2 / 1000)
	elseif event == "SPELLS_CHANGED" then
		IWin:UpdateSpellCost()
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" and not UnitAffectingCombat("player") then
		IWin:UpdateSpellCost()
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