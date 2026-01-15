if UnitClass("player") ~= "Priest" then return end

SLASH_IWINPRIEST1 = "/iwin"
function SlashCmdList.IWINPRIEST(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end

	DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:|r")
	DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff /iwin:|r Current setup")
end