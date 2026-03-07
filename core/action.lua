local CastSpellByName = CastSpellByName


local UnitLevel = UnitLevel
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local UseContainerItem = UseContainerItem
local SpellStopCasting = SpellStopCasting

function IWin:InitializeRotationCore()
	IWin:Debug("=== Rotation processing ===")
	if not IWin.hasSuperwow then
    	DEFAULT_CHAT_FRAME:AddMessage("|cFF00FFFFbalakethelock's SuperWoW|r required:")
        DEFAULT_CHAT_FRAME:AddMessage("https://github.com/balakethelock/SuperWoW")
    	return 0
	end
	if not IWin.hasUnitXP then
    	DEFAULT_CHAT_FRAME:AddMessage("|cFF00FFFFUnitXP|r required:")
        DEFAULT_CHAT_FRAME:AddMessage("https://codeberg.org/konaka/UnitXP_SP3")
    	return 0
	end
	if not IWin.libdebuff then
		if not CleveRoids.libdebuff then
	    	DEFAULT_CHAT_FRAME:AddMessage("|cFF00FFFFSuperCleveRoidMacros|r required:")
	        DEFAULT_CHAT_FRAME:AddMessage("https://github.com/jrc13245/SuperCleveRoidMacros")
	    	return 0
	    end
		IWin.libdebuff = CleveRoids and CleveRoids.libdebuff
	end
	IWin_CombatVar = {
		["affectingCombat"] = {},
		["dead"] = {},
		["energyPerSecondPrediction"] = 0,
		["GCD"] = 0,
		["level"] = {},
		["queueGCD"] = true,
		["reservedEnergy"] = 0,
		["reservedRage"] = 0,
		["startAttackThrottle"] = 0,
		["swingAttackQueued"] = false,
	}
	IWin_CastTime = {}
end

function IWin:Cast(spell, gcd, unit)
	if gcd ~= false then
		IWin_CombatVar["queueGCD"] = false
	end
	IWin:Debug("=> Casting "..spell)
	if unit == nil then
		CastSpellByName(spell)
	else
		CastSpellByName(spell, unit)
	end
end

function IWin:SpellStopCasting()
	IWin:Debug("=> Stop casting!")
	SpellStopCasting()
end

function IWin:TargetEnemy()
	if not IWin:IsExists("target", false)
		or IWin:IsDead("target", false)
		or IWin:IsFriend("target", "player", false) then
			TargetNearestEnemy()
	end
end

function IWin:StartAttack()
	--IWin:Debug("+++ checking conditions: startattack")
	if IWin:IsBuffActive("player", "Prowl", nil, false) or IWin:IsBuffActive("player", "Stealth", nil, false) then return end
	if IWin_CombatVar["swingAttackQueued"] or IWin_RotationVar["startAttackThrottle"] and IWin_RotationVar["startAttackThrottle"] > IWin:GetTime(false) then return end
	local attackActionFound = false
	for action = 1, 172 do
		if IsAttackAction(action) then
			attackActionFound = true
			if not IsCurrentAction(action) then
				UseAction(action)
			end
		end
	end
	if not attackActionFound
		and not PlayerFrame.inCombat then
			AttackTarget()
	end
end

function IWin:PetAttack()
	if HasPetUI() then
		PetAttack()
	end
end

function IWin:MarkSkull()
	if IWin:IsExists("target", false)
		and GetRaidTargetIndex("target") ~= 8
		and not IWin:IsFriend("player", "target", false)
		and not UnitInRaid("player")
		and IWin:GetGroupSize(false) > 1 then
			IWin:Debug("=> MarkSkull")
			SetRaidTarget("target", 8)
	end
end

function IWin:Perception()
	local spell = "Perception"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, false) then return end
	if IWin:IsAffectingCombat("player", false)
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsGCDActive(false) then
			IWin:Cast(spell)
	end
end

function IWin:CancelPlayerBuff(spell)
	local index = IWin:GetPlayerBuffIndex(spell)
	if index then
		CancelPlayerBuff(index)
	end
end

function IWin:CancelSalvation()
	IWin:CancelPlayerBuff("Blessing of Salvation")
	IWin:CancelPlayerBuff("Greater Blessing of Salvation")
end

function IWin:UseItem(item)
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemName = GetContainerItemLink(bag, slot)
			if itemName and strfind(itemName,item) then
				UseContainerItem(bag, slot)
			end
		end
	end
end

function IWin:UseDrinkItem()
	local playerLevel = UnitLevel("player")
	for drinkItem in IWin_DrinkConjured do
		if IWin:IsBuffActive("player", "Drink") then break end
		if playerLevel >= IWin_DrinkConjured[drinkItem] then
			IWin:UseItem(drinkItem)
		end
	end
	for drinkItem in IWin_DrinkVendor do
		if IWin:IsBuffActive("player", "Drink") then break end
		if playerLevel >= IWin_DrinkVendor[drinkItem] then
			IWin:UseItem(drinkItem)
		end
	end
end

function IWin:Shoot()
	local spell = "Shoot"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsItemSubTypeEquipped("Wands") then
		IWin:Cast(spell)
		return
	end
	local spell = "Shoot Bow"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsItemSubTypeEquipped("Bows") then
		IWin:Cast(spell)
		return
	end
	local spell = "Shoot Gun"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsItemSubTypeEquipped("Guns") then
		IWin:Cast(spell)
		return
	end
	local spell = "Shoot Crossbow"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsItemSubTypeEquipped("Crossbows") then
		IWin:Cast(spell)
		return
	end
	local spell = "Throw"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsItemSubTypeEquipped("Thrown") then
		IWin:Cast(spell)
		return
	end
	IWin:MarkSkull()
end