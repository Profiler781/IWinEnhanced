if UnitClass("player") ~= "Druid" then return end

function IWin:GetCastTimeWrath()
	if IWin_CastTime["Wrath"] == nil then
		IWin_CastTime["Wrath"] = IWin:GetCastTime("Wrath")
	end
	return IWin_CastTime["Wrath"]
end

function IWin:GetCastTimeStarfire()
	if IWin_CastTime["Starfire"] == nil then
		IWin_CastTime["Starfire"] = IWin:GetCastTime("Starfire")
	end
	return IWin_CastTime["Starfire"]
end