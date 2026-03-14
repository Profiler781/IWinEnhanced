if UnitClass("player") ~= "Druid" then return end

IWin_RageCost = {
	["Bash"] = 10,
	["Challenging Roar"] = 15,
	["Demoralizing Roar"] = 10,
	["Enrage"] = 0 - IWin:GetTalentRank("Blood Frenzy") * 5,
	["Feral Charge"] = 5,
	["Maul"] = 15 - IWin:GetTalentRank("Ferocity"),
	["Savage Bite"] = 30 - IWin:GetTalentRank("Ferocity"),
	["Swipe"] = 20 - IWin:GetTalentRank("Ferocity"),
}

IWin_EnergyCost = {
	["Claw"] = 45 - IWin:GetTalentRank("Ferocity"),
	["Cower"] = 20,
	["Ferocious Bite"] = 35,
	["Pounce"] = 50,
	["Rake"] = 40 - IWin:GetTalentRank("Ferocity"),
	["Ravage"] = 60,
	["Rip"] = 30,
	["Shred"] = 60 - IWin:GetTalentRank("Improved Shred") * 6,
	["Tiger's Fury"] = 30,
}

IWin_ManaCost = {
	["Reshift"] = 348,
}

IWin_Bleed = {
	"Pounce Bleed",
	"Rake",
	"Rip",
}