if UnitClass("player") ~= "Druid" then return end

function IWin:GetCenarionFeral5P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["CenarionFeral"]) >= 5 then
			return 5
		end
	end
	return 0
end

function IWin:GetStormrageFeral5P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["StormrageFeral"]) >= 5 then
			return 5
		end
	end
	return 0
end

function IWin:GetGenesisFeral3P()
	if CleveRoids and CleveRoids.CountEquippedSetItems then
		if CleveRoids.CountEquippedSetItems(IWin_ItemSet["StormrageFeral"]) >= 3 then
			return 3
		end
	end
	return 0
end

function IWin:UpdateSpellCost()
	IWin_RageCost = {
		["Bash"] = 10,
		["Challenging Roar"] = 15,
		["Demoralizing Roar"] = 10,
		["Enrage"] = 0 - IWin:GetTalentRank("Blood Frenzy") * 5,
		["Feral Charge"] = 5,
		["Maul"] = 15 - IWin:GetTalentRank("Ferocity"),
		["Savage Bite"] = 30 - IWin:GetTalentRank("Ferocity") - IWin:GetStormrageFeral5P(),
		["Swipe"] = 20 - IWin:GetTalentRank("Ferocity"),
	}

	local genesisFeral3P = IWin:GetGenesisFeral3P()
	IWin_EnergyCost = {
		["Claw"] = 45 - IWin:GetTalentRank("Ferocity") - genesisFeral3P,
		["Cower"] = 20,
		["Ferocious Bite"] = 35,
		["Pounce"] = 50,
		["Rake"] = 40 - IWin:GetTalentRank("Ferocity") - genesisFeral3P,
		["Ravage"] = 60,
		["Rip"] = 30,
		["Shred"] = 60 - IWin:GetTalentRank("Improved Shred") * 6 - genesisFeral3P,
		["Tiger's Fury"] = 30 - IWin:GetCenarionFeral5P(),
	}

	IWin_ManaCost = {
		["Reshift"] = 348,
	}
end

IWin_Bleed = {
	"Pounce Bleed",
	"Rake",
	"Rip",
}