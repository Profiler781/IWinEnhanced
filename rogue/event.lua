if UnitClass("player") ~= "Rogue" then return end

IWin:RegisterEvent("ADDON_LOADED")
IWin:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
IWin:RegisterEvent("UNIT_ENERGY")
IWin:RegisterEvent("SPELLS_CHANGED")
IWin:RegisterEvent("UNIT_INVENTORY_CHANGED")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Rogue loaded.|r")
		--ttk
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		--energy
		if IWin_Settings["energyTimeToReserveBuffer"] == nil then IWin_Settings["energyTimeToReserveBuffer"] = 0 end
		--setup
		if IWin_Settings["bladeFlurry"] == nil then IWin_Settings["bladeFlurry"] = "off" end
		--init
		IWin_RotationVar["energyLastTick"] = UnitMana("player")
		IWin_RotationVar["energyNextTickTime"] = 0
		IWin_RotationVar["energyTick"] = 20
		IWin_RotationVar["energyTickTime"] = 2
		IWin_RotationVar["riposteAvailable"] = 0
		IWin_RotationVar["surpriseAttackAvailable"] = 0
		IWin:UpdateSpellCost()
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		if string.find(arg1,"parry") then
			IWin_RotationVar["riposteAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1,"dodge") then
			IWin_RotationVar["surpriseAttackAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string.find(arg1,"dodged") then
			IWin_RotationVar["surpriseAttackAvailable"] = IWin:GetTime(false) + 4
		end
	elseif event == "UNIT_ENERGY" and arg1 == "player" then
		local currentEnergy = UnitMana("player")
		local energyDelta = currentEnergy - IWin_RotationVar["energyLastTick"]
		IWin_RotationVar["energyLastTick"] = currentEnergy
		if energyDelta > 10 then
			IWin_RotationVar["energyTick"] = energyDelta
			local playerAgility = UnitStat("player", 2)
			IWin_RotationVar["energyTickTime"] = 2 / (1 + IWin:GetTalentRank("Blade Rush", false) * 0.000375 * playerAgility) 
			IWin_RotationVar["energyNextTickTime"] = IWin:GetTime(false) + IWin_RotationVar["energyTickTime"]
		end
	elseif event == "SPELLS_CHANGED" then
		IWin:UpdateSpellCost()
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" and not UnitAffectingCombat("player") then
		IWin:UpdateSpellCost()
	end
end)
