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
	local executeRank = IWin:GetTalentRank(2, 13)
	return IWin_ExecuteCostReduction[executeRank]
end

function IWin:GetBloodrageCostReduction()
	local bloodrageRank = IWin:GetTalentRank(3, 1)
	return IWin_BloodrageCostReduction[bloodrageRank]
end

function IWin:GetThunderClapCostReduction()
	local thunderClapRank = IWin:GetTalentRank(1, 6)
	return IWin_ThunderClapCostReduction[thunderClapRank]
end

IWin_RageCost = {
	["Battle Shout"] = 10,
	["Berserker Rage"] = 0 - IWin:GetTalentRank(2, 14) * 5,
	["Bloodrage"] = - 10 - IWin:GetBloodrageCostReduction(),
	["Bloodthirst"] = 30,
	["Charge"] = - 15 - IWin:GetTalentRank(1, 4) * 5,
	["Cleave"] = 20,
	["Concussion Blow"] = - 10,
	["Demoralizing Shout"] = 10,
	["Disarm"] = 20,
	["Execute"] = 15 - IWin:GetExecuteCostReduction(),
	["Hamstring"] = 10,
	["Heroic Strike"] = 15 - IWin:GetTalentRank(1, 1),
	["Intercept"] = 10,
	["Intervene"] = 10,
	["Death Wish"] = 10,
	["Master Strike"] = 20,
	["Mocking Blow"] = 10,
	["Mortal Strike"] = 30,
	["Overpower"] = 5,
	["Piercing Howl"] = 10,
	["Pummel"] = 10,
	["Recklessness"] = 0,
	["Shield Wall"] = 0,
	["Last Stand"] = 0,
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