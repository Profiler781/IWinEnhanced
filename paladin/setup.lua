if UnitClass("player") ~= "Paladin" then return end

SLASH_IWINPALADIN1 = "/iwin"
function SlashCmdList.IWINPALADIN(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end
	if arguments[1] == "judgement"then
		if IWin.hasPallyPower then
			DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Judgements are managed by your Pally Power.|r")
			return
		elseif arguments[2] ~= "wisdom"
			and arguments[2] ~= "light"
			and arguments[2] ~= "crusader"
			and arguments[2] ~= "justice"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: wisdom, light, crusader, justice, off.|r")
				return
		end
	elseif arguments[1] == "wisdom"then
		if arguments[2] ~= "elite"
			and arguments[2] ~= "boss"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "crusader"then
		if arguments[2] ~= "elite"
			and arguments[2] ~= "boss"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "light"then
		if arguments[2] ~= "elite"
			and arguments[2] ~= "boss"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "justice"then
		if arguments[2] ~= "elite"
			and arguments[2] ~= "boss"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown judgement. Possible values: elite, boss.|r")
				return
		end
	elseif arguments[1] == "soc" then
		if arguments[2] ~= "auto"
			and arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: auto, on, off.|r")
				return
		end
	end
    if arguments[1] == "judgement" then
        IWin_Settings["judgement"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Judgement: |r" .. IWin_Settings["judgement"])
	elseif arguments[1] == "wisdom" then
	    IWin_Settings["wisdom"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Wisdom target classification: |r" .. IWin_Settings["wisdom"])
	elseif arguments[1] == "crusader" then
	    IWin_Settings["crusader"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of the Crusader target classification: |r" .. IWin_Settings["crusader"])
	elseif arguments[1] == "light" then
	    IWin_Settings["light"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Light target classification: |r" .. IWin_Settings["light"])
	elseif arguments[1] == "justice" then
	    IWin_Settings["justice"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Justice target classification: |r" .. IWin_Settings["justice"])
	elseif arguments[1] == "soc" then
	    IWin_Settings["soc"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Seal of Command: |r" .. IWin_Settings["soc"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:|r")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin : Current setup|r")
		if IWin.hasPallyPower then
			DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Judgements managed by PallyPowerTW|r")
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin judgement [" .. IWin_Settings["judgement"] .. "] : |r Setup for Judgement on elites and worldbosses")
		end
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin wisdom [" .. IWin_Settings["wisdom"] .. "] : |r Setup for Seal of Wisdom target classification")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin crusader [" .. IWin_Settings["crusader"] .. "] : |r Setup for Seal of the Crusader target classification")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin light [" .. IWin_Settings["light"] .. "] : |r Setup for Seal of Light target classification")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin justice [" .. IWin_Settings["justice"] .. "] : |r Setup for Seal of Justice target classification")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin soc [" .. IWin_Settings["soc"] .. "] : |r Setup for Seal of Command")
    end
end