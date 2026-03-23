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
	elseif arguments[1] == "consumable" then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: boss, elite, all, off.|r")
				return
		end
	elseif arguments[1] == "trinket" then
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
	elseif arguments[1] == "consumable" then
        if arguments[2] then IWin_Settings["consumable"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Consumables target: |r" .. IWin_Settings["consumable"])
	elseif arguments[1] == "trinket" then
        if arguments[2] then IWin_Settings["trinket"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Trinkets target: |r" .. IWin_Settings["trinket"])
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
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin consumable [|r" .. IWin_Settings["consumable"] .. "|cff0066ff]:|r Use consumables on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin trinket [|r" .. IWin_Settings["trinket"] .. "|cff0066ff]:|r Use trinkets on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin cdshortoffensive [|r" .. IWin_Settings["CDShortOffensive"] .. "|cff0066ff]:|r Use short offensive CDs on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin cdlongoffensive [|r" .. IWin_Settings["CDLongOffensive"] .. "|cff0066ff]:|r Use long offensive CDs on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin frontshred [|r" .. IWin_Settings["frontShred"] .. "|cff0066ff]:|r Attempt Front Shredding.")
    end
end