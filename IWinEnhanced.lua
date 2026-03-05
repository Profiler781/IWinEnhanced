-- IWinEnhanced by Agamemnoth/Profiler781

IWin_core = CreateFrame("frame", nil, UIParent)

IWin = CreateFrame("frame", nil, UIParent)
IWin.t = CreateFrame("GameTooltip", "IWin_T", UIParent, "GameTooltipTemplate")
IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")

function IWin:Print(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff"..message.."|r")
end

function IWin:Debug(message, debugmsg)
	if IWin_Settings
		and IWin_Settings["debug"] == "on"
		and (
				debugmsg
				or debugmsg == nil
			) then
		IWin:Print(message)
	end
end