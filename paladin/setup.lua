if UnitClass("player") ~= "Paladin" then return end

SLASH_IWINPALADIN1 = "/iwin"
function SlashCmdList.IWINPALADIN(command)
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
	elseif arguments[1] == "judgement"then
		if IWin.hasPallyPower then
			DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Judgements are managed by your Pally Power.|r")
			return
		elseif arguments[2] ~= nil
			and arguments[2] ~= "wisdom"
			and arguments[2] ~= "light"
			and arguments[2] ~= "crusader"
			and arguments[2] ~= "justice"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: wisdom, light, crusader, justice, off.|r")
				return
		end
	elseif arguments[1] == "wisdom"then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "crusader"then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "light"then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "justice"then
		if arguments[2] ~= nil
			and arguments[2] ~= "boss"
			and arguments[2] ~= "elite"
			and arguments[2] ~= "all"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "soc" then
		if arguments[2] ~= nil
			and arguments[2] ~= "auto"
			and arguments[2] ~= "on"
			and arguments[2] ~= "off" then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: auto, on, off.|r")
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
    elseif arguments[1] == "judgement" then
        if arguments[2] then IWin_Settings["judgement"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Judgement: |r" .. IWin_Settings["judgement"])
	elseif arguments[1] == "wisdom" then
	    if arguments[2] then IWin_Settings["wisdom"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Wisdom target classification: |r" .. IWin_Settings["wisdom"])
	elseif arguments[1] == "crusader" then
	    if arguments[2] then IWin_Settings["crusader"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of the Crusader target classification: |r" .. IWin_Settings["crusader"])
	elseif arguments[1] == "light" then
	    if arguments[2] then IWin_Settings["light"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Light target classification: |r" .. IWin_Settings["light"])
	elseif arguments[1] == "justice" then
	    if arguments[2] then IWin_Settings["justice"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Justice target classification: |r" .. IWin_Settings["justice"])
	elseif arguments[1] == "soc" then
	    if arguments[2] then IWin_Settings["soc"] = arguments[2] end
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Command: |r" .. IWin_Settings["soc"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:|r")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin:|r Current setup")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin debug [|r" .. IWin_Settings["debug"] .. "|cff0066ff]:|r Enable/disable debug.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin consumable [|r" .. IWin_Settings["consumable"] .. "|cff0066ff]:|r Use consumables on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin trinket [|r" .. IWin_Settings["trinket"] .. "|cff0066ff]:|r Use trinkets on target.")
		if IWin.hasPallyPower then
			DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Judgements managed by PallyPowerTW|r")
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin judgement [|r" .. IWin_Settings["judgement"] .. "|cff0066ff]:|r Use the Judgement to debuff target.")
		end
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin wisdom [|r" .. IWin_Settings["wisdom"] .. "|cff0066ff]:|r Use Seal of Wisdom debuff on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin crusader [|r" .. IWin_Settings["crusader"] .. "|cff0066ff]:|r Use Seal of the Crusader debuff on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin light [|r" .. IWin_Settings["light"] .. "|cff0066ff]:|r Use Seal of Light debuff on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin justice [|r" .. IWin_Settings["justice"] .. "|cff0066ff]:|r Use Seal of Justice debuff on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin soc [|r" .. IWin_Settings["soc"] .. "|cff0066ff]:|r Use Seal of Command over Seal of Righteousness.")
    end
end