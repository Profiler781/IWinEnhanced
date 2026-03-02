-- IWinEnhanced by Agamemnoth/Profiler781

IWin_core = CreateFrame("frame", nil, UIParent)

IWin = CreateFrame("frame", nil, UIParent)
IWin.t = CreateFrame("GameTooltip", "IWin_T", UIParent, "GameTooltipTemplate")
IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")