if UnitClass("player") ~= "Druid" then return end

IWin_RageCost = {
	["Bash"] = 10,
	["Challenging Roar"] = 15,
	["Demoralizing Roar"] = 10,
	["Enrage"] = 0 - IWin:GetTalentRank(2, 12) * 5,
	["Feral Charge"] = 5,
	["Maul"] = 15 - IWin:GetTalentRank(2, 1),
	["Savage Bite"] = 30 - IWin:GetTalentRank(2, 1),
	["Swipe"] = 20 - IWin:GetTalentRank(2, 1),
}

IWin_EnergyCost = {
	["Claw"] = 45 - IWin:GetTalentRank(2, 1),
	["Cower"] = 20,
	["Ferocious Bite"] = 35,
	["Mangle"] = 45,
	["Pounce"] = 50,
	["Rake"] = 40 - IWin:GetTalentRank(2, 1),
	["Ravage"] = 60,
	["Rip"] = 30,
	["Shred"] = 60 - IWin:GetTalentRank(2, 13) * 6,
	["Tiger's Fury"] = 30,
}

IWin_ManaCost = {
	["Reshift"] = 348,
}