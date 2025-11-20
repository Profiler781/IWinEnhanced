function IWin:GetTalentRank(tabIndex, talentIndex)
	local _, _, _, _, currentRank = GetTalentInfo(tabIndex, talentIndex)
	return currentRank
end

IWin_Taunt = {
	-- Warrior
	"Taunt",
	"Mocking Blow",
	"Challenging Shout",
	-- Druid
	"Growl",
	"Challenging Roar",
	-- Paladin
	"Hand of Reckoning",
}

IWin_Root = {
	"Encasing Webs",
	"Entangling Roots",
	"Enveloping Web",
	"Frost Nova",
	"Hooked Net",
	"Net",
	"Ret",
	"Web",
	"Web Explosion",
	"Web Spray",
}

IWin_Slow = {
	"Chilled",
	"Frostbolt",
	"Hamstring",
}

IWin_UnitClassification = {
	["worldboss"] = true,
	["rareelite"] = true,
	["elite"] = true,
	["rare"] = false,
	["normal"] = false,
	["trivial"] = false,
}

IWin_PartySize = {
	["raid"] = 40,
	["group"] = 5,
	["solo"] = 1,
	["combat"] = 0,
	["off"] = 0,
}

IWin_BlacklistAOEDebuff = {
	"Vek'lor",
	"Vek'nilash",
	"Qiraji Scarab",
	"Qiraji Scorpion",
}

IWin_BlacklistAOEDamage = {
	"Vek'lor",
	"Vek'nilash",
	"Qiraji Scarab",
	"Qiraji Scorpion",
}

IWin_BlacklistKick = {
	-- Karazhan
	"Echo of Medivh",
	"Shadowclaw Darkbringer",
	"Blue Owl",
	"Red Owl",
	-- Naxxramas
	"Kel'Thuzad",
	"Spectral Rider",
	"Naxxramas Acolyte",
	"Stitched Spewer",
	-- Ahn'Qiraj
	"Eye of C'Thun",
	"Eye Tentacle",
	"Claw Tentacle",
	"Giant Claw Tentacle",
	"Giant Eye Tentacle",
	-- Molten Core
	"Flamewaker Priest",
}

IWin_BlacklistFear = {
	"Magmadar",
	"Onyxia",
	"Nefarian",
}

IWin_WhitelistCharge = {
	-- Karazhan

	-- Naxxramas

	-- Ahn'Qiraj

	-- Molten Core
	"Ragnaros",
}

IWin_WhitelistBoss = {
	-- Molten Core
	"Flamewaker Protector",
	"Flamewaker Elite",
}

IWin_DrinkVendor = {
	["Hyjal Nectar"] = 55,
	["Morning Glory Dew"] = 45,
	["Freshly-Squeezed Lemonade"] = 45,
	["Bottled Winterspring Water"] = 35,
	["Moonberry Juice"] = 35,
	["Enchanted Water"] = 25,
	["Goldthorn Tea"] = 25,
	["Green Garden Tea"] = 25,
	["Sweet Nectar"] = 25,
	["Bubbling Water"] = 15,
	["Fizzy Faire Drink"] = 15,
	["Melon Juice"] = 15,
	["Blended Bean Brew"] = 5,
	["Ice Cold Milk"] = 5,
	["Kaja'Cola"] = 1,
	["Refreshing Spring Water"] = 1,
	["Sun-Parched Waterskin"] = 1,
}

IWin_DrinkConjured = {
	["Conjured Crystal Water"] = 55,
	["Conjured Sparkling Water"] = 45,
	["Conjured Mineral Water"] = 35,
	["Conjured Spring Water"] = 25,
	["Conjured Purified Water"] = 15,
	["Conjured Fresh Water"] = 5,
	["Conjured Water"] = 1,
}