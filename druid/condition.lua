if UnitClass("player") ~= "Druid" then return end

function IWin:IsDPSWindow(cooldown)
	local ttd = IWin:GetTimeToDie()
	--prevent waste
	local minBuffLenght = IWin_ItemBuffDuration[cooldown] * 0.3
	if ttd < minBuffLenght then return false end
	--burst short fight
	local lastDPSWindow = IWin_ItemBuffDuration[cooldown] + IWin_Settings["GCD"] * 2
	if ttd < lastDPSWindow then return true end
	--wait max output
	if IWin:GetPowerType("player", false) == "energy" and IWin:GetComboPoints(false) < 5 then return false end
	if IWin:GetPowerType("player", false) == "mana" and IWin:GetBuffRemaining("player", "Nature Eclipse", nil, false) < 10 and IWin:GetBuffRemaining("player", "Arcane Eclipse", nil, false) < 10 then return false end
	--go
	return true
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