if UnitClass("player") ~= "Hunter" then return end

SLASH_IWINHUNTER1 = "/iwin"
function SlashCmdList.IWINHUNTER(command)
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
	end

	if arguments[1] == "debug" then
        IWin_Settings["debug"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Debug: |r" .. IWin_Settings["debug"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:|r")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin:|r Current setup")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin debug [|r" .. IWin_Settings["debug"] .. "|cff0066ff]:|r Enable/disable debug.")
	end
end