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

function IWin:GetMightDPS5P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["MightDPS"]) >= 5 then
			return 10
		end
	end
	return 0
end

function IWin:GetVindicator5P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["Vindicator"]) >= 5 then
			return 3
		end
	end
	return 0
end

function IWin:IsWrathDPS3P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["WrathDPS"]) >= 3 then
			return true
		end
	end
	return false
end

function IWin:GetUnyieldingStrength2P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["UnyieldingStrength"]) >= 2 then
			return 2
		end
	end
	return 0
end

function IWin:GetDreadnaught2P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["Dreadnaught"]) >= 2 then
			return 10
		end
	end
	return 0
end

function IWin:GetBrotherhood3P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["Brotherhood"]) >= 3 then
			return 5
		end
	end
	return 0
end

function IWin:UpdateSpellCost()
	local mightDPS5P = IWin:GetMightDPS5P()
	local dreadnaught2P = IWin:GetDreadnaught2P()
	local brotherhood3P = IWin:GetBrotherhood3P()
	local unyieldingStrength2P = IWin:GetUnyieldingStrength2P()
	IWin_RageCost = {
		["Battle Shout"] = 10,
		["Berserker Rage"] = 0 - IWin:GetTalentRank("Improved Berserker Rage") * 5,
		["Bloodrage"] = - 10 - IWin:GetBloodrageCostReduction(),
		["Bloodthirst"] = 30 - mightDPS5P,
		["Charge"] = - 15 - IWin:GetTalentRank("Improved Charge") * 5,
		["Cleave"] = 20 - IWin:GetTalentRank("Ravager"),
		["Concussion Blow"] = - 10,
		["Death Wish"] = 10 - dreadnaught2P,
		["Demoralizing Shout"] = 10,
		["Disarm"] = 20,
		["Execute"] = 15 - IWin:GetExecuteCostReduction(),
		["Hamstring"] = 10,
		["Heroic Strike"] = 15 - IWin:GetTalentRank("Improved Heroic Strike") - brotherhood3P,
		["Intercept"] = 10 - unyieldingStrength2P,
		["Intervene"] = 10 - unyieldingStrength2P,
		["Master Strike"] = 20,
		["Mocking Blow"] = 10,
		["Mortal Strike"] = 30 - mightDPS5P,
		["Overpower"] = 5,
		["Piercing Howl"] = 10,
		["Pummel"] = 10,
		["Rend"] = 10,
		["Revenge"] = 5,
		["Shield Bash"] = 10,
		["Shield Block"] = 10,
		["Shield Slam"] = 20,
		["Slam"] = 15,
		["Sunder Armor"] = 10 - brotherhood3P,
		["Sweeping Strikes"] = 20 - dreadnaught2P,
		["Thunder Clap"] = 20 - IWin:GetThunderClapCostReduction(),
		["Whirlwind"] = 25 - brotherhood3P - IWin:GetVindicator5P(),
	}
end