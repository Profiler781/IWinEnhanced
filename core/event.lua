IWin_core:RegisterEvent("ADDON_LOADED")
IWin_core:RegisterEvent("PLAYER_TARGET_CHANGED")
IWin_core:RegisterEvent("SPELLS_CHANGED")
IWin_core:RegisterEvent("UNIT_INVENTORY_CHANGED")
IWin_core:RegisterEvent("UNIT_MANA")
IWin_core:RegisterEvent("UNIT_MAXMANA")

IWin_core:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		--DEFAULT_CHAT_FRAME:AddMessage("")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["debug"] == nil then IWin_Settings["debug"] = "off" end
		if IWin_Settings["GCD"] == nil then IWin_Settings["GCD"] = 1.5 end
		if IWin_Settings["GCDEnergy"] == nil then IWin_Settings["GCDEnergy"] = 1 end

		IWin.hasSuperwow = SetAutoloot and true or false
		IWin.hasUnitXP = pcall(UnitXP, "nop", "nop") and true or false

		IWin_CastTime = {}--combat var
		IWin_CombatVar = {
			["affectingCombat"] = {},
			["dead"] = {},
			["enemyInFront"] = {},
			["enemyInRange"] = {},
			["energyPerSecondPrediction"] = 0,
			["GCD"] = 0,
			["level"] = {},
			["queueGCD"] = true,
			["reservedEnergy"] = 0,
			["reservedRage"] = 0,
			["startAttackThrottle"] = 0,
			["swingAttackQueued"] = false,
		}
		IWin_Inventory = {}
		IWin_Mana = {}
		IWin_RotationVar = {
			["startAttackThrottle"] = 0,
		}
		IWin_Spellbook = {
			["talent"] = {},
		}
		IWin_Stance = {}--rotation var
		IWin_Target = {
			["exists"] = {},
			["name"] = {},
			["pvp"] = {},
		}
	elseif event == "ADDON_LOADED" and (arg1 == "SuperCleveRoidMacros" or arg1 == "IWinEnhanced") then
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
		IWin.API = CleveRoids and CleveRoids.NampowerAPI
	elseif event == "PLAYER_TARGET_CHANGED" then
		IWin_Target = {
			["exists"] = {},
			["name"] = {},
			["pvp"] = {},
		}
	elseif event == "SPELLS_CHANGED" then
		IWin_Spellbook = {
			["talent"] = {},
		}
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		IWin_Inventory = {}
	elseif (event == "UNIT_MANA" or event == "UNIT_MAXMANA") and arg1 == "player" then
		IWin_Mana = {}
	end
end)