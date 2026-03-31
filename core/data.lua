IWin_Spellbook = {
	["talent"] = {},
}

function IWin:GetTalentRank(talentName, debugmsg)
	local cached = IWin_Spellbook["talent"][talentName]
    if cached ~= nil then
    	IWin:Debug(talentName.." talent points: "..tostring(cached), debugmsg)
        return cached
    end
	for tabIndex = 1, GetNumTalentTabs() do
        for talentIndex = 1, GetNumTalents(tabIndex) do
            local name, _, _, _, rank = GetTalentInfo(tabIndex, talentIndex)
            if name and name == talentName then
            	IWin_Spellbook["talent"][talentName] = tonumber(rank)
            	IWin:Debug(talentName.." talent points: "..rank, debugmsg)
        		return tonumber(rank)
            end
        end
    end
    IWin:Debug("Unknown talent: "..talentName, debugmsg)
    return 0
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

IWin_Snare = {
	"Chilled",
	"Frostbolt",
	"Hamstring",
	"Wing Clip",
}

IWin_Fear = {
	"Fear",
	"Psychic Scream",
	"Howl of Terror",
}

IWin_UnitClassification = {
	["worldboss"] = true,
	["rareelite"] = true,
	["elite"] = true,
	["rare"] = false,
	["normal"] = false,
	["trivial"] = false,
}

IWin_BlacklistAOEDebuff = {
	["Vek'lor"] = true,
	["Vek'nilash"] = true,
	["Qiraji Scarab"] = true,
	["Qiraji Scorpion"] = true,
}

IWin_BlacklistAOEDamage = {
	["Vek'lor"] = true,
	["Vek'nilash"] = true,
	["Qiraji Scarab"] = true,
	["Qiraji Scorpion"] = true,
}

IWin_BlacklistKick = {
	-- Karazhan
	["Echo of Medivh"] = true,
	["Shadowclaw Darkbringer"] = true,
	["Blue Owl"] = true,
	["Red Owl"] = true,
	-- Naxxramas
	["Kel'Thuzad"] = true,
	["Spectral Rider"] = true,
	["Naxxramas Acolyte"] = true,
	["Stitched Spewer"] = true,
	-- Ahn'Qiraj
	["Eye of C'Thun"] = true,
	["Eye Tentacle"] = true,
	["Claw Tentacle"] = true,
	["Giant Claw Tentacle"] = true,
	["Giant Eye Tentacle"] = true,
	-- Molten Core
	["Flamewaker Priest"] = true,
}

IWin_BlacklistCooldownMelee = {
	-- Karazhan
	["Mephistroth"] = true,
	["Blue Owl"] = true,
	["Red Owl"] = true,
	-- Naxxramas
	["Feugen"] = true,
	["Stalagg"] = true,
	["Noth the Plaguebringer"] = true,
	["Heigan the Unclean"] = true,
	["Loatheb"] = true,
	["Gothik the Harvester"] = true,
	["Thane Korth'azz"] = true,
	["Lady Blaumeux"] = true,
	["Highlord Mograine"] = true,
	["Sir Zeliek"] = true,
	["Sapphiron"] = true,
	-- Ahn'Qiraj
	["Emperor Vek'lor"] = true,
	["Emperor Vek'nilash"] = true,
	-- Blackwing Lair
	["Firemaw"] = true,
	["Chromaggus"] = true,
	-- Emerald Sanctum
	["Solnius"] = true,
	-- Onyxia's Lair
	["Onyxia"] = true,
	-- Molten Core
	["Baron Geddon"] = true,
	["Ragnaros"] = true,
}

IWin_BlacklistCooldownRanged = {
	-- Karazhan
	["Mephistroth"] = true,
	["Blue Owl"] = true,
	["Red Owl"] = true,
	-- Naxxramas
	["Feugen"] = true,
	["Stalagg"] = true,
	["Noth the Plaguebringer"] = true,
	["Heigan the Unclean"] = true,
	["Gothik the Harvester"] = true,
	["Thane Korth'azz"] = true,
	["Lady Blaumeux"] = true,
	["Highlord Mograine"] = true,
	["Sir Zeliek"] = true,
	["Sapphiron"] = true,
	-- Ahn'Qiraj
	["Emperor Vek'lor"] = true,
	["Emperor Vek'nilash"] = true,
	-- Blackwing Lair
	["Firemaw"] = true,
	["Chromaggus"] = true,
	-- Emerald Sanctum
	["Solnius"] = true,
	-- Onyxia's Lair
	["Onyxia"] = true,
	-- Molten Core
}

IWin_BlacklistFear = {
	["Magmadar"] = true,
	["Onyxia"] = true,
	["Nefarian"] = true,
}

IWin_WhitelistCharge = {
	-- Karazhan

	-- Naxxramas

	-- Ahn'Qiraj

	-- Molten Core
	["Ragnaros"] = true,
}

IWin_WhitelistBoss = {
	-- Molten Core
	["Flamewaker Protector"] = true,
	["Flamewaker Elite"] = true,
}

IWin_DrinkVendor = {
	["Hyjal Nectar"] = 55,
	["Alterac Manna Biscuit"] = 51,
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

IWin_Texture = {
	["Interface\\Icons\\Spell_Holy_RighteousFury"] = "Judgement",
}

IWin_PowerType = {
	[0] = "mana",
	[1] = "rage",
	[3] = "energy",
}

IWin_CooldownDuration = {
	-- consumables
	["Juju Flurry"] = 60,
	["Mighty Rage Potion"] = 120,
	["Potion of Quickness"] = 120,
	-- trinkets
	---- physical
	["Badge of the Swarmguard"] = 180,
	["Earthstrike"] = 120,
	["Jom Gabbar"] = 120,
	["Kiss of the Spider"] = 120,
	["Molten Emberstone"] = 120,
	["Slayer's Crest"] = 120,
	["Zandalarian Hero Medallion"] = 120,
	---- caster
	["Draconic Infused Emblem"] = 75,
	["Talisman of Ephemeral Power"] = 90,
	["Zandalarian Hero Charm"] = 120,
	---- paladin
	["Scrolls of Blinding Light"] = 300,
	---- rogue
	["Venomous Totem"] = 300,
	---- warrior
	["Diamond Flask"] = 240,
	-- racials
	["Berserking"] = 180,
	["Blood Fury"] = 120,
	["Perception"] = 180,
	-- druid
	["Berserk"] = 300,
	-- rogue
	["Adrenaline Rush"] = 180,
	-- warrior
	["Bloodrage"] = 60,
	["Death Wish"] = 180,
	["Recklessness"] = 1800,
	["Retaliation"] = 1800,
	["Shield Wall"] = 1800 - IWin:GetTalentRank("Shield Wall", false) * 300,
}

IWin_BuffDuration = {
	-- consumables
	["Juju Flurry"] = 20,
	["Mighty Rage Potion"] = 20,
	["Potion of Quickness"] = 30,
	-- trinkets
	---- physical
	["Badge of the Swarmguard"] = 30,
	["Earthstrike"] = 20,
	["Jom Gabbar"] = 20,
	["Kiss of the Spider"] = 15,
	["Molten Emberstone"] = 20,
	["Slayer's Crest"] = 20,
	["Zandalarian Hero Medallion"] = 20,
	---- caster
	["Draconic Infused Emblem"] = 15,
	["Talisman of Ephemeral Power"] = 15,
	["Zandalarian Hero Charm"] = 20,
	---- paladin
	["Scrolls of Blinding Light"] = 20,
	---- rogue
	["Venomous Totem"] = 20,
	---- warrior
	["Diamond Flask"] = 60,
	-- racials
	["Berserking"] = 10,
	["Blood Fury"] = 15,
	["Perception"] = 20,
	-- druid
	["Berserk"] = 20,
	-- rogue
	["Adrenaline Rush"] = 15,
	-- warrior
	["Bloodrage"] = 8,--enrage buff
	["Death Wish"] = 30,
	["Recklessness"] = 15,
	["Retaliation"] = 15,
	["Shield Wall"] = 10 + IWin:GetTalentRank("Shield Wall", false),
}

IWin_ItemSet = {
	-- druid
	["CenarionFeral"] = { 47338, 47339, 47340, 47341, 47342, 47343, 47344, 47345 }, --T1
	["StormrageFeral"] = { 47354, 47355, 47356, 47357, 47358, 47359, 47360, 47361 }, --T2
	["GenesisFeral"] = { 47367, 47368, 47369, 47370, 47371 }, --T2.5
	-- rogue
	["Madcap"] = { 19835, 19834, 19836 }, --ZG TODO
	["VeiledShadows"] = { 21406, 21404 }, --AQ Ruins TODO
	-- warrior
	["MightDPS"] = { 47240, 47241, 47242, 47243, 47244, 47245, 47246, 47247 }, --T1
	["Vindicator"] = { 19822, 19824, 19823 }, --ZG TODO
	["WrathDPS"] = { 47248, 47249, 47250, 47251, 47252, 47253, 47254, 47255 }, --T2
	["UnyieldingStrength"] = { 21394, 21392 }, --AQ Ruins TODO
	["DreadnaughtDPS"] = { 47261, 47262, 47263, 47264, 47265, 47266, 47267, 47268 }, --T3 TODO
	["Brotherhood"] = { 47270, 47271, 47272, 47273, 47274, 47275 }, --T3.5
}