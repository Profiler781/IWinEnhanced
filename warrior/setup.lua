if UnitClass("player") ~= "Warrior" then return end

SLASH_IWINWARRIOR1 = "/iwin"
function SlashCmdList.IWINWARRIOR(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end

	if arguments[1] == "debug" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "chargepartysize" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more. 1 is the default parameter.|r")
				return
		end
	elseif arguments[1] == "chargenocombat"then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "chargewl"then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "sunder" then
		if arguments[2] ~= "high"
			and arguments[2] ~= "once"
			and arguments[2] ~= "low"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: high, once, low, off.|r")
				return
		end
	elseif arguments[1] == "demo" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "dtbattle" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "dtdefensive" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "dtberserker" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "ragebuffer" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more. 1.5 is the default parameter.|r")
				return
		end
	elseif arguments[1] == "ragegain" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more. 10 is the default parameter.|r")
				return
		end
	elseif arguments[1] == "jousting" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "thunderclap" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	end

    if arguments[1] == "debug" then
        if arguments[2] then IWin_Settings["debug"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Debug: |r" .. IWin_Settings["debug"])
	elseif arguments[1] == "chargepartysize" then
        if arguments[2] then IWin_Settings["chargepartysize"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Charge party size: |r" .. tostring(IWin_Settings["chargepartysize"]))
	elseif arguments[1] == "chargenocombat" then
        if arguments[2] then IWin_Settings["chargenocombat"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Charge if target is not in combat: |r" .. IWin_Settings["chargenocombat"])
	elseif arguments[1] == "chargewl" then
        if arguments[2] then IWin_Settings["chargewl"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Charge whitelist: |r" .. IWin_Settings["chargewl"])
	elseif arguments[1] == "sunder" then
	    if arguments[2] then IWin_Settings["sunder"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Sunder Armor: |r" .. tostring(IWin_Settings["sunder"]))
	elseif arguments[1] == "demo" then
	    if arguments[2] then IWin_Settings["demo"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Demoralizing Shout: |r" .. IWin_Settings["demo"])
	elseif arguments[1] == "dtbattle" then
	    if arguments[2] then IWin_Settings["dtBattle"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Battle Stance: |r" .. IWin_Settings["dtBattle"])
	elseif arguments[1] == "dtdefensive" then
	    if arguments[2] then IWin_Settings["dtDefensive"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Defensive Stance: |r" .. IWin_Settings["dtDefensive"])
	elseif arguments[1] == "dtberserker" then
	    if arguments[2] then IWin_Settings["dtBerserker"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Berserker Stance: |r" .. IWin_Settings["dtBerserker"])
	elseif arguments[1] == "ragebuffer" then
	    if arguments[2] then IWin_Settings["rageTimeToReserveBuffer"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Buffer: |r" .. tostring(IWin_Settings["rageTimeToReserveBuffer"]))
	elseif arguments[1] == "ragegain" then
	    if arguments[2] then IWin_Settings["ragePerSecondPrediction"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Gain per second (initial): |r" .. tostring(IWin_Settings["ragePerSecondPrediction"]))
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Gain per second (RLS): |r" .. tostring(IWin:GetRagePerSecond(false)))
	elseif arguments[1] == "jousting" then
	    if arguments[2] then IWin_Settings["jousting"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Jousting: |r" .. IWin_Settings["jousting"])
	elseif arguments[1] == "thunderclap" then
	    if arguments[2] then IWin_Settings["thunderclap"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Thunder Clap: |r" .. IWin_Settings["thunderclap"])
	elseif arguments[1] == "overpower" then
	    if arguments[2] then IWin_Settings["overpower"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Overpower: |r" .. IWin_Settings["overpower"])
	elseif arguments[1] == "berserkerrage" then
	    if arguments[2] then IWin_Settings["berserkerrage"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Berserker Rage: |r" .. IWin_Settings["berserkerrage"])
	elseif arguments[1] == "rend" then
	    if arguments[2] then IWin_Settings["rend"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rend: |r" .. IWin_Settings["rend"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:|r")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin:|r Current setup")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin debug [|r" .. IWin_Settings["debug"] .. "|cff0066ff]:|r Enable/disable debug.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin chargepartysize [|r" .. IWin_Settings["chargepartysize"] .. "|cff0066ff]:|r Use Charge, Intercept and Intervene if party member count is equal or below the setup value.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin chargenocombat [|r" .. IWin_Settings["chargenocombat"] .. "|cff0066ff]:|r Use Charge, Intercept and Intervene if the target is not in combat.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin chargewl [|r" .. IWin_Settings["chargewl"] .. "|cff0066ff]:|r Use Charge, Intercept and Intervene if the target is whitelisted.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin sunder [|r" .. IWin_Settings["sunder"] .. "|cff0066ff]:|r Use Sunder Armor priority as DPS.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin demo [|r" .. IWin_Settings["demo"] .. "|cff0066ff]:|r Use Demoralizing Shout.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin dtbattle [|r" .. IWin_Settings["dtBattle"] .. "|cff0066ff]:|r Use Battle stance with Defensive Tactics.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin dtdefensive [|r" .. IWin_Settings["dtDefensive"] .. "|cff0066ff]:|r Use Defensive stance with Defensive Tactics.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin dtberserker [|r" .. IWin_Settings["dtBerserker"] .. "|cff0066ff]:|r Use Berserker stance with Defensive Tactics.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin ragebuffer [|r" .. tostring(IWin_Settings["rageTimeToReserveBuffer"]) .. "|cff0066ff]:|r Save 100% required rage for spells X seconds before the spells are used. 1.5 is the default parameter.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin ragegain [|r" .. tostring(IWin_Settings["ragePerSecondPrediction"]) .. "|cff0066ff]:|r Initial rage per second estimate (seed for dynamic RLS tracking). Current dynamic value: " .. tostring(IWin:GetRagePerSecond(false)))
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin jousting [|r" .. IWin_Settings["jousting"] .. "|cff0066ff]:|r Use Hamstring to joust with target in solo DPS.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin thunderclap [|r" .. IWin_Settings["thunderclap"] .. "|cff0066ff]:|r Use Thunder Clap.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin overpower [|r" .. IWin_Settings["overpower"] .. "|cff0066ff]:|r Use Overpower.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin berserkerrage [|r" .. IWin_Settings["berserkerrage"] .. "|cff0066ff]:|r Use Berserker Rage for rage generation.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin rend [|r" .. IWin_Settings["rend"] .. "|cff0066ff]:|r Use Rend.")
    end
end