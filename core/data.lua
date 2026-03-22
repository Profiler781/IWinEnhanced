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

IWin_BlacklistCooldown = {
	-- Karazhan
	["Mephistroth"] = true,
	["Blue Owl"] = true,
	["Red Owl"] = true,
	-- Naxxramas
	["Feugen"] = true,
	["Stalagg"] = true,
	["Noth the Plaguebringer"] = true,
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

IWin_ItemCooldownDuration = {
	-- consumables
	["Juju Flurry"] = 60,
	["Mighty Rage Potion"] = 120,
	["Potion of Quickness"] = 120,
	-- trinkets
	["Badge of the Swarmguard"] = 180,
	["Diamond Flask"] = 240,
	["Earthstrike"] = 120,
	["Jom Gabbar"] = 120,
	["Kiss of the Spider"] = 120,
	["Molten Emberstone"] = 120,
	["Slayer's Crest"] = 120,
	["Zandalarian Hero Medallion"] = 120,
}

IWin_ItemBuffDuration = {
	-- consumables
	["Juju Flurry"] = 20,
	["Mighty Rage Potion"] = 20,
	["Potion of Quickness"] = 30,
	-- trinkets
	["Badge of the Swarmguard"] = 30,
	["Diamond Flask"] = 60,
	["Earthstrike"] = 20,
	["Jom Gabbar"] = 20,
	["Kiss of the Spider"] = 15,
	["Molten Emberstone"] = 20,
	["Slayer's Crest"] = 20,
	["Zandalarian Hero Medallion"] = 20,
}