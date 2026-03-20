if UnitClass("player") ~= "Warrior" then return end

IWin_ExecuteCostReduction = {
	[0] = 0,
	[1] = 2,
	[2] = 5,
}

IWin_BloodrageCostReduction = {
	[0] = 0,
	[1] = 2,
	[2] = 5,
}

IWin_ThunderClapCostReduction = {
	[0] = 0,
	[1] = 1,
	[2] = 2,
	[3] = 4,
}

function IWin:GetExecuteCostReduction()
	local rank = IWin:GetTalentRank("Improved Execute")
	return IWin_ExecuteCostReduction[rank]
end

function IWin:GetBloodrageCostReduction()
	local rank = IWin:GetTalentRank("Improved Bloodrage")
	return IWin_BloodrageCostReduction[rank]
end

function IWin:GetThunderClapCostReduction()
	local rank = IWin:GetTalentRank("Improved Thunder Clap")
	return IWin_ThunderClapCostReduction[rank]
end

IWin_BrotherhoodItems = { 47270, 47271, 47272, 47273, 47274, 47275 }

function IWin:GetBrotherhoodCostReduction()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_BrotherhoodItems) >= 3 then
			return 5
		end
	end
	return 0
end

function IWin:UpdateRageCosts()
	local brotherhood = IWin:GetBrotherhoodCostReduction()
	IWin_RageCost = {
		["Battle Shout"] = 10,
		["Berserker Rage"] = 0 - IWin:GetTalentRank("Improved Berserker Rage") * 5,
		["Bloodrage"] = - 10 - IWin:GetBloodrageCostReduction(),
		["Bloodthirst"] = 30,
		["Charge"] = - 15 - IWin:GetTalentRank("Improved Charge") * 5,
		["Cleave"] = 20 - IWin:GetTalentRank("Ravager"),
		["Concussion Blow"] = - 10,
		["Death Wish"] = 10,
		["Demoralizing Shout"] = 10,
		["Disarm"] = 20,
		["Execute"] = 15 - IWin:GetExecuteCostReduction(),
		["Hamstring"] = 10,
		["Heroic Strike"] = 15 - IWin:GetTalentRank("Improved Heroic Strike"),
		["Intercept"] = 10,
		["Intervene"] = 10,
		["Master Strike"] = 20,
		["Mocking Blow"] = 10,
		["Mortal Strike"] = 30,
		["Overpower"] = 5,
		["Piercing Howl"] = 10,
		["Pummel"] = 10,
		["Rend"] = 10,
		["Revenge"] = 5,
		["Shield Bash"] = 10,
		["Shield Block"] = 10,
		["Shield Slam"] = 20,
		["Slam"] = 15,
		["Sunder Armor"] = 10,
		["Sweeping Strikes"] = 20,
		["Thunder Clap"] = 20 - IWin:GetThunderClapCostReduction(),
		["Whirlwind"] = 25,
	}
end