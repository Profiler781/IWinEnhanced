if UnitClass("player") ~= "Druid" then return end

SLASH_IWINDRUID1 = "/iwin"
function SlashCmdList.IWINDRUID(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end

	if arguments[1] == "debug" then
		if arguments[2] ~= nil
			and arguments[2] ~= "on"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "consumableoffensive" then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: boss, elite, all, off.|r")
				return
		end
	elseif arguments[1] == "consumableaoe" then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: boss, elite, all, off.|r")
				return
		end
	elseif arguments[1] == "oilofimmolation" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more.|r")
				return
		end
	elseif arguments[1] == "holywater" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more.|r")
				return
		end
	elseif arguments[1] == "sapper" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more.|r")
				return
		end
	elseif arguments[1] == "densedynamite" then
		if arguments[2] ~= nil
			and tonumber(arguments[2]) < 0 then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more.|r")
				return
		end
	elseif arguments[1] == "trinketoffensive" then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: boss, elite, all, off.|r")
				return
		end
	elseif arguments[1] == "cdshortoffensive" then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: boss, elite, all, off.|r")
				return
		end
	elseif arguments[1] == "cdlongoffensive" then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: boss, elite, all, off.|r")
				return
		end
	elseif arguments[1] == "frontshred" then
		if arguments[2] ~= nil
			and arguments[2] ~= "on"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("Unkown parameter. Possible values: on, off.")
				return
		end
	end
	
    if arguments[1] == "debug" then
        if arguments[2] then IWin_Settings["debug"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Debug: |r" .. IWin_Settings["debug"])
	elseif arguments[1] == "consumableoffensive" then
        if arguments[2] then IWin_Settings["consumableOffensive"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Offensive Consumables target: |r" .. IWin_Settings["consumableOffensive"])
	elseif arguments[1] == "consumableaoe" then
        if arguments[2] then IWin_Settings["consumableAOE"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff AOE Consumables target: |r" .. IWin_Settings["consumableAOE"])
	elseif arguments[1] == "oilofimmolation" then
        if arguments[2] then IWin_Settings["targetsOilOfImmolation"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Oil of Immolation min targets: |r" .. tostring(IWin_Settings["targetsOilOfImmolation"]))
	elseif arguments[1] == "holywater" then
        if arguments[2] then IWin_Settings["targetsHolyWater"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Stratholme Holy Water min targets: |r" .. tostring(IWin_Settings["targetsHolyWater"]))
	elseif arguments[1] == "sapper" then
        if arguments[2] then IWin_Settings["targetsSapper"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Goblin Sapper Charge min targets: |r" .. tostring(IWin_Settings["targetsSapper"]))
	elseif arguments[1] == "densedynamite" then
        if arguments[2] then IWin_Settings["targetsDenseDynamite"] = tonumber(arguments[2]) end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Dense Dynamite min targets: |r" .. tostring(IWin_Settings["targetsDenseDynamite"]))
	elseif arguments[1] == "trinketoffensive" then
        if arguments[2] then IWin_Settings["trinketOffensive"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Offensive Trinkets target: |r" .. IWin_Settings["trinketOffensive"])
	elseif arguments[1] == "cdshortoffensive" then
        if arguments[2] then IWin_Settings["CDShortOffensive"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Short Offensive CDs target: |r" .. IWin_Settings["CDShortOffensive"])
	elseif arguments[1] == "cdlongoffensive" then
        if arguments[2] then IWin_Settings["CDLongOffensive"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Long Offensive CDs target: |r" .. IWin_Settings["CDLongOffensive"])
	elseif arguments[1] == "frontshred" then
        if arguments[2] then IWin_Settings["frontShred"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("Front Shred: " .. IWin_Settings["frontShred"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("Usage:")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin : Current setup")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin debug [|r" .. IWin_Settings["debug"] .. "|cff0066ff]:|r Enable/disable debug.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin consumableoffensive [|r" .. IWin_Settings["consumableOffensive"] .. "|cff0066ff]:|r Use consumables on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin consumableaoe [|r" .. IWin_Settings["consumableAOE"] .. "|cff0066ff]:|r Use AOE consumables on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin oilofimmolation [|r" .. IWin_Settings["targetsOilOfImmolation"] .. "|cff0066ff]:|r Minimum targets for Oil of Immolation. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin holywater [|r" .. IWin_Settings["targetsHolyWater"] .. "|cff0066ff]:|r Minimum targets for Stratholme Holy Water. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin sapper [|r" .. IWin_Settings["targetsSapper"] .. "|cff0066ff]:|r Minimum targets for Goblin Sapper Charge. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin densedynamite [|r" .. IWin_Settings["targetsDenseDynamite"] .. "|cff0066ff]:|r Minimum targets for Dense Dynamite. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin trinketoffensive [|r" .. IWin_Settings["trinketOffensive"] .. "|cff0066ff]:|r Use offensive trinkets on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin cdshortoffensive [|r" .. IWin_Settings["CDShortOffensive"] .. "|cff0066ff]:|r Use short offensive CDs on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin cdlongoffensive [|r" .. IWin_Settings["CDLongOffensive"] .. "|cff0066ff]:|r Use long offensive CDs on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin frontshred [|r" .. IWin_Settings["frontShred"] .. "|cff0066ff]:|r Attempt Front Shredding.")
    end
end