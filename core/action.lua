local CastSpellByName = CastSpellByName
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local UseContainerItem = UseContainerItem
local SpellStopCasting = SpellStopCasting

function IWin:InitializeRotationCore()
	IWin:Debug("")
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
		IWin.API = CleveRoids and CleveRoids.NampowerAPI
	end
	IWin_CombatVar = {
		["affectingCombat"] = {},
		["buffRemaining"] = {},
		["buffStack"] = {},
		["casting"] = {},
		["cooldown"] = {},
		["dead"] = {},
		["enemyInFront"] = {},
		["enemyInRange"] = {},
		["energyPerSecondPrediction"] = 0,
		["GCD"] = 0,
		["health"] = {},
		["healthMax"] = {},
		["healthPercent"] = {},
		["inRange"] = {},
		["level"] = {},
		["power"] = {},
		["powerMax"] = {},
		["powerPercent"] = {},
		["powerType"] = {},
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
				local start, duration = GetContainerItemCooldown(bag, slot)
				if start == 0 or duration == 0 then
					IWin:Debug("=> Using: "..item)
					UseContainerItem(bag, slot)
					return
				end
			end
		end
	end
end

function IWin:UseItemDrink()
	local playerLevel = IWin:GetLevel("player")
	for drinkItem in IWin_DrinkConjured do
		if IWin:IsBuffActive("player", "Drink", nil, false) then break end
		if playerLevel >= IWin_DrinkConjured[drinkItem] then
			IWin:UseItem(drinkItem)
		end
	end
	for drinkItem in IWin_DrinkVendor do
		if IWin:IsBuffActive("player", "Drink", nil, false) then break end
		if playerLevel >= IWin_DrinkVendor[drinkItem] then
			IWin:UseItem(drinkItem)
		end
	end
end

function IWin:UseItemConsumableOffensive(item, skipWindowControl)
	if not skipWindowControl and not IWin:IsDPSWindow(item) then return end
	IWin:UseItem(item)
end

function IWin:UseItemConsumableDefensive(item, subzone)
	if not string.find(GetSubZoneText() or "", subzone) then return end
	IWin:UseItem(item)
end

function IWin:UseItemTrinket(item, gcd)
	for _, slot in ipairs({13, 14}) do
		if IWin:IsItemEquipped(slot, item, false) then
			local start, duration = GetInventoryItemCooldown("player", slot)
			if start == 0 or duration == 0 or duration == 1.5 then
				if gcd then IWin_CombatVar["queueGCD"] = false end
				IWin:Debug("=> Using: "..item)
				UseInventoryItem(slot)
				return
			end
		end
	end
end

function IWin:UseItemTrinketOffensive(item, skipWindowControl, gcd)
	if not skipWindowControl and not IWin:IsDPSWindow(item) then return end
	IWin:UseItemTrinket(item, gcd)
end

function IWin:RangedAttack(spell, rangedWeapon)
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:IsItemSubTypeEquipped(rangedWeapon) then
		IWin:Cast(spell)
	end
end

function IWin:RangedAttackAny()
	IWin:RangedAttack("Shoot", "Wands")
	IWin:RangedAttack("Shoot Bow", "Bows")
	IWin:RangedAttack("Shoot Gun", "Guns")
	IWin:RangedAttack("Shoot Crossbow", "Crossbows")
	IWin:RangedAttack("Throw", "Thrown")
end