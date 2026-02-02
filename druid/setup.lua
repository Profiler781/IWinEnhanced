if UnitClass("player") ~= "Druid" then return end

SLASH_IWINDRUID1 = "/iwin"
function SlashCmdList.IWINDRUID(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end
	if arguments[1] == "frontshred" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("Unkown parameter. Possible values: on, off.")
				return
		end
	end
    if arguments[1] == "frontshred" then
        IWin_Settings["frontShred"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("Front Shred: " .. IWin_Settings["frontShred"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("Usage:")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin : Current setup")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin frontshred [" .. IWin_Settings["frontShred"] .. "] : Setup for Front Shredding")
    end
end