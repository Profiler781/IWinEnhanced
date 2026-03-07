if UnitClass("player") ~= "Druid" then return end

function IWin:GetCastTimeWrath(debugmsg)
	local cached = IWin_CastTime["Wrath"]
	if cached ~= nil then
		IWin:Debug("Wrath cast time: "..cached, debugmsg)
		return cached
	end
	local result = IWin:GetCastTime("Wrath")
	IWin_CastTime["Wrath"] = result
	IWin:Debug("Wrath cast time: "..result, debugmsg)
	return result
end

function IWin:GetCastTimeStarfire(debugmsg)
	local cached = IWin_CastTime["Starfire"]
	if cached ~= nil then
		IWin:Debug("Starfire cast time: "..cached, debugmsg)
		return cached
	end
	local result = IWin:GetCastTime("Starfire")
	IWin_CastTime["Starfire"] = result
	IWin:Debug("Starfire cast time: "..result, debugmsg)
	return result
end

function IWin:GetBleedCount(debugmsg)
	local cached = IWin_CombatVar["bleedCount"]
	if cached ~= nil then
		IWin:Debug("Bleed count: "..tostring(cached), debugmsg)
		return cached
	end
	local result = 0
	for bleed in IWin_Bleed do
		if IWin:IsBuffActive("target", IWin_Bleed[bleed], "player") then
			result = result + 1
		end
	end
	IWin_CombatVar["bleedCount"] = result
	IWin:Debug("Bleed count: "..tostring(result), debugmsg)
	return result
end