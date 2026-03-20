if UnitClass("player") ~= "Rogue" then return end

IWin_HemorrhageCostReduction = {
	[0] = 0,
	[1] = 2,
	[2] = 5,
}

IWin_RuptureDurationIncrease = {
	[0] = 0,
	[1] = 4,
	[2] = 6,
}

function IWin:GetHemorrhageCostReduction()
	local rank = IWin:GetTalentRank("Bloody Mess", false)
	return IWin_HemorrhageCostReduction[rank]
end

IWin_EnergyCost = {
	["Adrenaline Rush"] = 0,
	["Ambush"] = 60,
	["Backstab"] = 60,
	["Blade Flurry"] = 25,
	["Cheap Shot"] = 60 - IWin:GetTalentRank("Dirty Deeds", false) * 10,
	["Deadly Throw"] = 40,
	["Envenom"] = 20,
	["Eviscerate"] = 30,
	["Expose Armor"] = 20,
	["Garrote"] = 50 - IWin:GetTalentRank("Dirty Deeds", false) * 10,
	["Gouge"] = 45,
	["Hemorrhage"] = 40 - IWin:GetHemorrhageCostReduction(),
	["Kick"] = 25,
	["Noxious Assault"] = 45,
	["Riposte"] = 10,
	["Rupture"] = 20,
	["Shadow of Death"] = 30,
	["Sinister Strike"] = 40,
	["Slice and Dice"] = 20,
	["Surprise Attack"] = 10,
}