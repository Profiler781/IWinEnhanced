if UnitClass("player") ~= "Mage" then return end

IWin:RegisterEvent("ADDON_LOADED")

IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced for Mage loaded.|r")
		
	end
end)