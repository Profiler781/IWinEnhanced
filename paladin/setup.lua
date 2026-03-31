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
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin consumableoffensive [|r" .. IWin_Settings["consumableOffensive"] .. "|cff0066ff]:|r Use consumables on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin consumableaoe [|r" .. IWin_Settings["consumableAOE"] .. "|cff0066ff]:|r Use AOE consumables on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin oilofimmolation [|r" .. IWin_Settings["targetsOilOfImmolation"] .. "|cff0066ff]:|r Minimum targets for Oil of Immolation. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin holywater [|r" .. IWin_Settings["targetsHolyWater"] .. "|cff0066ff]:|r Minimum targets for Stratholme Holy Water. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin sapper [|r" .. IWin_Settings["targetsSapper"] .. "|cff0066ff]:|r Minimum targets for Goblin Sapper Charge. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin densedynamite [|r" .. IWin_Settings["targetsDenseDynamite"] .. "|cff0066ff]:|r Minimum targets for Dense Dynamite. 0 to disable.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin trinketoffensive [|r" .. IWin_Settings["trinketOffensive"] .. "|cff0066ff]:|r Use offensive trinkets on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin cdshortoffensive [|r" .. IWin_Settings["CDShortOffensive"] .. "|cff0066ff]:|r Use short offensive CDs on target.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin cdlongoffensive [|r" .. IWin_Settings["CDLongOffensive"] .. "|cff0066ff]:|r Use long offensive CDs on target.")
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