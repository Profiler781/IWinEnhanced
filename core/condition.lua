-- Buff #######################################################################################################################################
function IWin:GetPlayerBuffIndex(spell)
	local index = 0
    spell = string.lower(string.gsub(spell, "_"," "))
	while true do
		local auraIndex = GetPlayerBuff(index,"HELPFUL")
		index = index + 1
		if auraIndex == -1 then break end
		local buffIndex = GetPlayerBuffID(auraIndex)
		buffIndex = (buffIndex < -1) and (buffIndex + 65536) or buffIndex
		if string.lower(SpellInfo(buffIndex)) == spell then
			return auraIndex
		end
	end
	return nil
end

function IWin:GetDebuffIndex(unit, spell)
	local index = 1
	while UnitDebuff(unit, index) do
		IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")
		IWin_T:ClearLines()
		IWin_T:SetUnitDebuff(unit, index)
		local tooltipText = IWin_TTextLeft1:GetText()
		if spell and tooltipText and string.find(tooltipText, spell) then 
			return index
		end
		index = index + 1
	end	
	return nil
end

function IWin:GetBuffRemaining(unit, spell, owner)
	-- Debuff scan
	for index = 1, 16 do
	    local effect, _, texture, stacks, dtype, duration, timeLeft, caster = IWin.libdebuff:UnitDebuff(unit, index)
	    if not effect then break end
	    if effect and effect == spell and ((not owner) or (caster == owner)) then
	        return timeLeft or 9999
	    end
	end
	-- Buff scan only for player
	if unit == "player" then
		for index = 0, 31 do
	        spellID = GetPlayerBuffID(index)
	        if not spellID then break end
	        if spell == SpellInfo(spellID) then
	        	local timeLeft = GetPlayerBuffTimeLeft(index)
	        	if timeLeft and timeLeft ~= 0 then
	        		return timeLeft
	        	else
	        		return 9999
	        	end
	        end
	    end
	    if DoitePlayerAuras then
			local timeLeft = DoitePlayerAuras.GetHiddenBuffRemaining(spell)
			if timeLeft then
				return timeLeft
			end
			if DoitePlayerAuras.HasBuff(spell) then
		        return 9999
		    end
		end
    end
    -- Debuff scan overflow as buff
	for index = 1, 64 do
	    local effect, _, texture, stacks, dtype, duration, timeLeft, caster = IWin.libdebuff:UnitBuff(unit, index)
	    if not effect then break end
	    if effect == spell and ((not owner) or (caster == owner)) then
	        return timeLeft or 9999
	    end
	end
	-- Not found
	return 0
end

function IWin:IsBuffActive(unit, spell, owner)
	return IWin:GetBuffRemaining(unit, spell, owner) ~= 0
end

function IWin:GetBuffStack(unit, spell, owner)
	-- Debuff scan
	for index = 1, 16 do
	    local effect, _, texture, stacks, dtype, duration, timeLeft, caster = IWin.libdebuff:UnitDebuff(unit, index)
	    if not effect then break end
	    if effect == spell and ((not owner) or (caster == owner)) then
	        return stacks
	    end
	end
	-- Player buff scan
	if unit == "player" then
		if DoitePlayerAuras then
			local stacks = DoitePlayerAuras.GetBuffStacks(spell)
   			if stacks then return stacks end
		end
		local index = IWin:GetPlayerBuffIndex(spell)
		if index then
			local _, stack = UnitBuff(unit, index)
			return stack or 0
		end
	end
	-- Debuff scan overflow as buff
	for index = 1, 64 do
	    local effect, _, texture, stacks, dtype, duration, timeLeft, caster = IWin.libdebuff:UnitBuff(unit, index)
	    if not effect then break end
	    if effect == spell and ((not owner) or (caster == owner)) then
	        return stacks
	    end
	end
	-- Not found
	return 0
end

function IWin:IsBuffStack(unit, spell, stack, owner)
	return IWin:GetBuffStack(unit, spell, owner) == stack
end

function IWin:IsTaunted()
	local index = 1
	while IWin_Taunt[index] do
		local taunt = IWin:IsBuffActive("target", IWin_Taunt[index])
		if taunt then
			return true
		end
		index = index + 1
	end
	return false
end

-- Spell #######################################################################################################################################
function IWin:GetSpellSpellbookID(spell, rank)
    local spellID = 1
    while true do
        local spellName, spellRank = GetSpellName(spellID, "BOOKTYPE_SPELL")
        if not spellName then break end
        if spellName == spell and ((not rank) or spellRank == rank) and (rank ~= nil or spellName ~= GetSpellName(spellID + 1, "BOOKTYPE_SPELL")) then
            return spellID
        end
        spellID = spellID + 1
    end
    return nil
end

function IWin:GetCooldownRemaining(spell)
	local spellID = IWin:GetSpellSpellbookID(spell)
	if not spellID then return false end
	local start, duration = GetSpellCooldown(spellID, "BOOKTYPE_SPELL")
	if start ~= 0 and duration ~=  IWin_Settings["GCD"] then
		return duration - (GetTime() - start)
	else
		return 0
	end
end

function IWin:IsOnCooldown(spell)
	return IWin:GetCooldownRemaining(spell) ~= 0
end

function IWin:IsSpellLearnt(spell, rank)
	local spellID = IWin:GetSpellSpellbookID(spell, rank)
	if not spellID then return false end
	return true
end

function IWin:GetGCDRemaining()
	if IWin_CombatVar["GCD"] ~= nil then
		return IWin_CombatVar["GCD"]
	end
	local info = GetCastInfo()
	if info and info.gcdRemainingMs then
		IWin_CombatVar["GCD"] = info.gcdRemainingMs
		return IWin_CombatVar["GCD"]
	end
	IWin_CombatVar["GCD"] = 0
	return 0
end

function IWin:IsGCDActive()
	if IWin:GetGCDRemaining() ~= 0 then
		return true
	end
	return false
end

function IWin:ParseCastTimeFromText(text)
    if not text then return nil end
    -- Match patterns like "1.5 sec cast", "1.59 sec cast", "2 sec cast"
    local castTime = string.match(text, "(%d+%.?%d*) sec cast")
    if castTime then
        return tonumber(castTime)
    end
    return nil
end

function IWin:GetCastTime(spell)
	local spellID = IWin:GetSpellSpellbookID(spell)
    if not spellID then return nil end

    IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")
    IWin_T:ClearLines()
	IWin_T:SetSpell(spellID, "BOOKTYPE_SPELL")

    -- Scan tooltip lines for cast time
    for i = 1, IWin_T:NumLines() do
        local leftText = getglobal("IWin_TTextLeft" .. i)
        if leftText then
            local text = leftText:GetText()
            local castTime = IWin:ParseCastTimeFromText(text)
            if castTime then
                return castTime
            end
        end
        local rightText = getglobal("IWin_TTextRight" .. i)
        if rightText then
            local text = rightText:GetText()
            local castTime = IWin:ParseCastTimeFromText(text)
            if castTime then
                return castTime
            end
        end
    end
    return nil
end

function IWin:GetSpellSlot(spell)
	for slot = 1, 172 do
		local actionTexture = GetActionTexture(slot)
		if actionTexture then
			local actionName = IWin_Texture[actionTexture]
			if actionName and actionName == spell then
				return slot
			end
		end
	end
	return nil
end

-- requires IWin_Texture data
function IWin:IsActionUsable(spell)
	local slot = IWin:GetSpellSlot(spell)
	if slot and IsUsableAction(slot) == 1 then
		return true
	end
	return false
end

function IWin:GetSpellNameMaxRank(spell)
	if not IWin:IsSpellLearnt(spell) then return nil end
	local rank = 1
	while true do
		local rankName = "Rank " .. tostring(rank)
		if IWin:IsSpellLearnt(spell, rankName) then
			spellNameMaxRank = spell .. "(" .. rankName .. ")"
		else
			return spellNameMaxRank
		end
		rank = rank + 1
	end
end

function IWin:IsCasting(unit, spell)
	return CleveRoids.CheckSpellCast(unit, spell)
end

-- Stance #######################################################################################################################################
function IWin:IsStanceActive(stance)
	local forms = GetNumShapeshiftForms()
	for index = 1, forms do
		local _, name, active = GetShapeshiftFormInfo(index)
		if name == stance then
			return active == 1
		end
	end
	return false
end

function IWin:GetStance()
	local forms = GetNumShapeshiftForms()
	for index = 1, forms do
		local _, name, active = GetShapeshiftFormInfo(index)
		if active == 1 then
			return name
		end
	end
	return nil
end

-- Health #######################################################################################################################################
function IWin:GetTimeToDie()
	local ttd = 0
	local numPartyMembers = math.max(2, GetNumPartyMembers(), GetNumRaidMembers())
	if (not UnitInRaid("player")) or type(TimeToKill) ~= "table" or type(TimeToKill.GetTTK) ~= "function" or TimeToKill.GetTTK() == nil then
		ttd = UnitHealth("target") / UnitHealthMax("player") * IWin_Settings["playerToNPCHealthRatio"] * IWin_Settings["outOfRaidCombatLength"] / numPartyMembers * 2
	else
		ttd = TimeToKill.GetTTK() - 1
	end
	return ttd
end

function IWin:GetHealthPercent(unit)
	return UnitHealth(unit) / UnitHealthMax(unit) * 100
end

function IWin:IsExecutePhase()
	return IWin:GetHealthPercent("target") <= 20
end

-- Mana #######################################################################################################################################
function IWin:GetManaPercent(unit)
	return UnitMana(unit) / UnitManaMax(unit) * 100
end

function IWin:IsManaAvailable(spell)
	return UnitMana("player") >= IWin_ManaCost[spell]
end

function IWin:GetPlayerDruidMana()
	local _, casterMana = UnitMana("player")
	return casterMana
end

function IWin:GetPlayerDruidManaPercent()
	local _, casterManaMax = UnitManaMax("player")
	return IWin:GetPlayerDruidMana() / casterManaMax * 100
end

function IWin:IsDruidManaAvailable(spell)
	return IWin:GetPlayerDruidMana() >= IWin_ManaCost[spell]
end

-- Rage #######################################################################################################################################
function IWin:IsRageAvailable(spell)
	local rageRequired = IWin_RageCost[spell] + IWin_CombatVar["reservedRage"]
	-- Replacing auto attack will prevent getting rage from next swing, so rage cost is higher.
	if spell == "Heroic Strike" or spell == "Cleave" or spell == "Maul" then
		rageRequired = rageRequired + 20 --fix before rework
	end
	return UnitMana("player") >= rageRequired or IWin:IsBuffActive("player", "Clearcasting")
end

function IWin:IsRageCostAvailable(spell)
	return UnitMana("player") >= IWin_RageCost[spell] or IWin:IsBuffActive("player", "Clearcasting")
end

function IWin:GetRageToReserve(spell, trigger, unit)
	local spellTriggerTime = 0
	local rageCost = IWin_RageCost[spell]
	-- Replacing auto attack will prevent getting rage from next swing, so rage cost is higher.
	if spell == "Heroic Strike" or spell == "Cleave" or spell == "Maul" then
		rageCost = rageCost + 20 --fix before rework
	end
	if trigger == "nocooldown" and IWin:IsSpellLearnt(spell) then
		return rageCost
	elseif trigger == "cooldown" then
		spellTriggerTime = IWin:GetCooldownRemaining(spell) or 0
	elseif trigger == "buff" or trigger == "partybuff" then
		spellTriggerTime = IWin:GetBuffRemaining(unit, spell) or 0
	end
	local reservedRageTime = 0
	if IWin_Settings["ragePerSecondPrediction"] > 0 then
		reservedRageTime = IWin_CombatVar["reservedRage"] / IWin_Settings["ragePerSecondPrediction"]
	end
	local timeToReserveRage = math.max(0, spellTriggerTime - IWin_Settings["rageTimeToReserveBuffer"] - reservedRageTime)
	if trigger == "partybuff" or IWin:IsSpellLearnt(spell) then
		return math.max(0, rageCost - IWin_Settings["ragePerSecondPrediction"] * timeToReserveRage)
	end
	return 0
end

function IWin:IsTimeToReserveRage(spell, trigger, unit)
	return IWin:GetRageToReserve(spell, trigger, unit) ~= 0
end

function IWin:SetReservedRage(spell, trigger, unit)
	IWin_CombatVar["reservedRage"] = IWin_CombatVar["reservedRage"] + IWin:GetRageToReserve(spell, trigger, unit)
end

-- Energy #######################################################################################################################################
function IWin:IsEnergyAvailable(spell)
	local energyRequired = IWin_EnergyCost[spell] + IWin_CombatVar["reservedEnergy"]
	return (UnitMana("player") >= energyRequired) or IWin:IsBuffActive("player", "Clearcasting") or (UnitMana("player") > (100 - IWin_CombatVar["energyPerSecondPrediction"] * 2))
end

function IWin:IsEnergyCostAvailable(spell)
	return UnitMana("player") >= IWin_EnergyCost[spell] or IWin:IsBuffActive("player", "Clearcasting")
end

function IWin:GetEnergyToReserve(spell, trigger, unit)
	local spellTriggerTime = 0
	if trigger == "nocooldown" and IWin:IsSpellLearnt(spell) then
		return IWin_EnergyCost[spell]
	elseif trigger == "cooldown" then
		spellTriggerTime = IWin:GetCooldownRemaining(spell) or 0
	elseif trigger == "buff" or trigger == "partybuff" then
		spellTriggerTime = IWin:GetBuffRemaining(unit, spell) or 0
	end
	local reservedEnergyTime = 0
	if IWin_CombatVar["energyPerSecondPrediction"] > 0 then
		reservedEnergyTime = IWin_CombatVar["reservedEnergy"] / IWin_CombatVar["energyPerSecondPrediction"]
	end
	local timeToReserveEnergy = math.max(0, spellTriggerTime - IWin_Settings["energyTimeToReserveBuffer"] - reservedEnergyTime)
	if trigger == "partybuff" or IWin:IsSpellLearnt(spell) then
		return math.max(0, IWin_EnergyCost[spell] - IWin_CombatVar["energyPerSecondPrediction"] * timeToReserveEnergy)
	end
	return 0
end

function IWin:IsTimeToReserveEnergy(spell, trigger, unit)
	return IWin:GetEnergyToReserve(spell, trigger, unit) ~= 0
end

function IWin:SetReservedEnergy(spell, trigger, unit)
	IWin_CombatVar["reservedEnergy"] = IWin_CombatVar["reservedEnergy"] + IWin:GetEnergyToReserve(spell, trigger, unit)
end

-- Range #######################################################################################################################################
function IWin:IsInRange(spell, distance, unit)
	if unit == nil then unit = "target" end
	if not UnitExists(unit) then return false end
	if not IsSpellInRange
		or not spell
		or not IWin:IsSpellLearnt(spell) then
			if distance == "ranged" then
				return not (CheckInteractDistance(unit, 3) ~= nil)
			else
        		return CheckInteractDistance(unit, 3) ~= nil
        	end
	else
		return IsSpellInRange(spell, unit) == 1
	end
end

function IWin:GetEnemyInRange(range)
	-- body
end

-- Target #######################################################################################################################################
function IWin:IsTanking()
	return UnitIsUnit("targettarget", "player")
end

function IWin:IsBehind()
	if not UnitExists("target") then return false end
    return UnitXP("behind", "player", "target")
end

function IWin:GetTrainingDummy()
	local name = UnitName("target")
	if name and string.find(name,"Training Dummy") then
		return true
	else
		return false
	end
end

function IWin:SetTrainingDummy()
	IWin_Target["trainingDummy"] = IWin:GetTrainingDummy()
end

function IWin:IsTrainingDummy()
	if IWin_Target["trainingDummy"] == nil then IWin:SetTrainingDummy() end
	return IWin_Target["trainingDummy"]
end

function IWin:GetElite()
	local classification = UnitClassification("target")
	if IWin_UnitClassification[classification]
		or IWin:IsTrainingDummy() then
			return true
	else
		return false
	end
end

function IWin:SetElite()
	IWin_Target["elite"] = IWin:GetElite()
end

function IWin:IsElite()
	return IWin_Target["elite"]
end

function IWin:GetBoss()
	if UnitClassification("target") == "worldboss"
		or IWin:IsTrainingDummy()
		or IWin:IsWhitelistBoss() then
			return true
	end
	return false
end

function IWin:SetBoss()
	IWin_Target["boss"] = IWin:GetBoss()
end

function IWin:IsBoss()
	return IWin_Target["boss"]
end

function IWin:GetBlacklistAOEDebuff()
	if not UnitExists("target") then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_BlacklistAOEDebuff do
		if IWin_BlacklistAOEDebuff[unit] == name then
			return true
		end
	end
	return false
end

function IWin:SetBlacklistAOEDebuff()
	IWin_Target["blacklistAOEDebuff"] = IWin:GetBlacklistAOEDebuff()
end

function IWin:IsBlacklistAOEDebuff()
	return IWin_Target["blacklistAOEDebuff"]
end

function IWin:GetBlacklistAOEDamage()
	if not UnitExists("target") then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_BlacklistAOEDamage do
		if IWin_BlacklistAOEDamage[unit] == name then
			return true
		end
	end
	return false
end

function IWin:SetBlacklistAOEDamage()
	IWin_Target["blacklistAOEDamage"] = IWin:GetBlacklistAOEDamage()
end

function IWin:IsBlacklistAOEDamage()
	return IWin_Target["blacklistAOEDamage"]
end

function IWin:GetBlacklistKick()
	if not UnitExists("target") then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_BlacklistKick do
		if IWin_BlacklistKick[unit] == name then
			return true
		end
	end
	return false
end

function IWin:SetBlacklistKick()
	IWin_Target["blacklistKick"] = IWin:GetBlacklistKick()
end

function IWin:IsBlacklistKick()
	return IWin_Target["blacklistKick"]
end

function IWin:GetBlacklistFear()
	if not UnitExists("target") then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_BlacklistFear do
		if IWin_BlacklistFear[unit] == name then
			return true
		end
	end
	return false
end

function IWin:SetBlacklistFear()
	IWin_Target["blacklistFear"] = IWin:GetBlacklistFear()
end

function IWin:IsBlacklistFear()
	return IWin_Target["blacklistFear"]
end

function IWin:GetWhitelistCharge()
	if not UnitExists("target") then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_WhitelistCharge do
		if IWin_WhitelistCharge[unit] == name then
			return true
		end
	end
	return false
end

function IWin:SetWhitelistCharge()
	IWin_Target["whitelistCharge"] = IWin:GetWhitelistCharge()
end

function IWin:IsWhitelistCharge()
	return IWin_Target["whitelistCharge"]
end

function IWin:GetWhitelistBoss()
	if not UnitExists("target") then
		return false
	end
	if IWin:IsTrainingDummy() then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_WhitelistBoss do
		if IWin_WhitelistBoss[unit] == name then
			return true
		end
	end
	return false
end

function IWin:SetWhitelistBoss()
	IWin_Target["whitelistBoss"] = IWin:GetWhitelistBoss()
end

function IWin:IsWhitelistBoss()
	return IWin_Target["whitelistBoss"]
end

function IWin:IsImmune(unit, school)
	return CleveRoids.CheckImmunity(unit, school)
end

-- Item #######################################################################################################################################
function IWin:GetItemID(itemLink)
	for itemID in string.gfind(itemLink, "|c%x+|Hitem:(%d+):%d+:%d+:%d+|h%[(.-)%]|h|r$") do
		return itemID
	end
end

function IWin:IsShieldEquipped()
	local offHandLink = GetInventoryItemLink("player", 17)
	if offHandLink then
		local _, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(offHandLink)))
		return itemSubType == "Shields"
	end
	return false
end

function IWin:IsWandEquipped()
	local rangedLink = GetInventoryItemLink("player", 18)
	if rangedLink then
		local _, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(rangedLink)))
		return itemSubType == "Wands"
	end
	return false
end

function IWin:IsDaggerEquipped()
	local mainHandLink = GetInventoryItemLink("player", 16)
	if mainHandLink then
		local _, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(mainHandLink)))
		return itemSubType == "Daggers"
	end
	return false
end

function IWin:Is2HanderEquipped()
	local offHandLink = GetInventoryItemLink("player", 17)
	return not offHandLink
end

function IWin:IsItemEquipped(slot, name)
	local itemLink = GetInventoryItemLink("player", slot)
	if itemLink then
		local itemName = GetItemInfo(tonumber(IWin:GetItemID(itemLink)))
		return itemName == name
	end
	return false
end

function IWin:IsItemInBag(item)
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemName = GetContainerItemLink(bag, slot)
			if itemName and strfind(itemName,item) then
				return true
			end
		end
	end
	return false
end

function IWin:GetItemCountInBag(item)
	local itemCount = 0
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemName = GetContainerItemLink(bag, slot)
			if itemName and strfind(itemName,item) then
				itemCount = itemCount + 1
			end
		end
	end
	return itemCount
end

-- Movement #######################################################################################################################################
function IWin:IsMoving()
	if MonkeySpeed and MonkeySpeed.m_fSpeed and MonkeySpeed.m_fSpeed ~= 0 then
		return true
	end
	return false
end