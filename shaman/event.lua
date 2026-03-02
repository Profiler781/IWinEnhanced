if UnitClass("player") ~= "Shaman" then return end

IWin:RegisterEvent("ADDON_LOADED")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Shaman loaded.|r")
		
	end
end)