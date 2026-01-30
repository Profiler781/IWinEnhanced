if UnitClass("player") ~= "Warrior" then return end

SLASH_IWINWARRIOR1 = "/iwin"
function SlashCmdList.IWINWARRIOR(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end

	if arguments[1] == "charge"then
		if arguments[2] ~= "raid"
			and arguments[2] ~= "group"
			and arguments[2] ~= "solo"
			and arguments[2] ~= "targetincombat"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: raid, group, solo, targetincombat, off.|r")
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
			and arguments[2] ~= "low"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: high, low, off.|r")
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
		if tonumber(arguments[2]) < 0
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more. 1.5 is the default parameter.|r")
				return
		end
	elseif arguments[1] == "ragegain" then
		if tonumber(arguments[2]) < 0
			and arguments[2] ~= nil then
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
	elseif arguments[1] == "burst" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	end

    if arguments[1] == "charge" then
        IWin_Settings["charge"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Charge: |r" .. IWin_Settings["charge"])
	elseif arguments[1] == "chargewl" then
        IWin_Settings["chargewl"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Charge whitelist: |r" .. IWin_Settings["chargewl"])
	elseif arguments[1] == "sunder" then
	    IWin_Settings["sunder"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Sunder Armor: |r" .. IWin_Settings["sunder"])
	elseif arguments[1] == "demo" then
	    IWin_Settings["demo"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Demoralizing Shout: |r" .. IWin_Settings["demo"])
	elseif arguments[1] == "dtbattle" then
	    IWin_Settings["dtBattle"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Battle Stance: |r" .. IWin_Settings["dtBattle"])
	elseif arguments[1] == "dtdefensive" then
	    IWin_Settings["dtDefensive"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Defensive Stance: |r" .. IWin_Settings["dtDefensive"])
	elseif arguments[1] == "dtberserker" then
	    IWin_Settings["dtBerserker"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Berserker Stance: |r" .. IWin_Settings["dtBerserker"])
	elseif arguments[1] == "ragebuffer" then
	    IWin_Settings["rageTimeToReserveBuffer"] = tonumber(arguments[2])
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Buffer: |r" .. tostring(IWin_Settings["rageTimeToReserveBuffer"]))
	elseif arguments[1] == "ragegain" then
	    IWin_Settings["ragePerSecondPrediction"] = tonumber(arguments[2])
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Gain per second: |r" .. tostring(IWin_Settings["ragePerSecondPrediction"]))
	elseif arguments[1] == "jousting" then
	    IWin_Settings["jousting"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Jousting: |r" .. IWin_Settings["jousting"])
	elseif arguments[1] == "burst" then
	    IWin_Settings["burst"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Auto-burst (Death Wish): |r" .. IWin_Settings["burst"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:|r")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin:|r Current setup")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin charge [|r" .. IWin_Settings["charge"] .. "|cff0066ff]:|r Setup for Charge and Intercept")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin chargewl [|r" .. IWin_Settings["chargewl"] .. "|cff0066ff]:|r Setup for Charge and Intercept whitelist")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin sunder [|r" .. IWin_Settings["sunder"] .. "|cff0066ff]:|r Setup for Sunder Armor priority as DPS")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin demo [|r" .. IWin_Settings["demo"] .. "|cff0066ff]:|r Setup for Demoralizing Shout")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin dtbattle [|r" .. IWin_Settings["dtBattle"] .. "|cff0066ff]:|r Setup for Battle Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin dtdefensive [|r" .. IWin_Settings["dtDefensive"] .. "|cff0066ff]:|r Setup for Defensive Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin dtberserker [|r" .. IWin_Settings["dtBerserker"] .. "|cff0066ff]:|r Setup for Berserker Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin ragebuffer [|r" .. tostring(IWin_Settings["rageTimeToReserveBuffer"]) .. "|cff0066ff]:|r Setup to save 100% required rage for spells X seconds before the spells are used. 1.5 is the default parameter.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin ragegain [|r" .. tostring(IWin_Settings["ragePerSecondPrediction"]) .. "|cff0066ff]:|r Setup to anticipate rage gain per second. Required rage will be saved gradually before the spells are used. 10 is the default parameter. Increase the value if rage is wasted.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin jousting [|r" .. IWin_Settings["jousting"] .. "|cff0066ff]:|r Setup for Jousting solo DPS")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin burst [|r" .. IWin_Settings["burst"] .. "|cff0066ff]:|r Setup for auto-burst cooldown (Death Wish) in /idps and /icleave")
    end
end