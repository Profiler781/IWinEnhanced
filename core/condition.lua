local CheckInteractDistance = CheckInteractDistance
local GetComboPoints = GetComboPoints
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local GetNumShapeshiftForms = GetNumShapeshiftForms
local GetPlayerBuff = GetPlayerBuff
local GetPlayerBuffID = GetPlayerBuffID
local GetPlayerBuffTimeLeft = GetPlayerBuffTimeLeft
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetSpellCooldown = GetSpellCooldown
local GetSpellName = GetSpellName
local GetTime = GetTime
local SpellInfo = SpellInfo
local UnitAffectingCombat = UnitAffectingCombat
local UnitBuff = UnitBuff
local UnitClassification = UnitClassification
local UnitCreatureType = UnitCreatureType
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDead = UnitIsDead
local UnitIsPVP = UnitIsPVP
local UnitIsUnit = UnitIsUnit
local UnitMana = UnitMana
local UnitManaMax = UnitManaMax
local UnitName = UnitName

-- Buff #######################################################################################################################################
--helper
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

--helper
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

function IWin:GetBuffRemaining(unit, spell, owner, debugmsg)
	local cacheKey = unit.."|"..spell.."|"..(owner or "nil")
	local cached = IWin_CombatVar["buffRemaining"][cacheKey]
	if cached ~= nil then
		IWin:Debug("Buff remaining "..spell.." on "..unit..": "..tostring(cached), debugmsg)
		return cached
	end
	-- Debuff scan
	  if not owner then
	    local targetGuid = CleveRoids.GetGUID(unit)
	    if targetGuid then
	    	local timeLeft = CleveRoids.FindAllCasterAuraByName(targetGuid, spell)
	    	if timeLeft then
	    		IWin:Debug("Debuff remaining "..spell.." on "..unit..": "..tostring(timeLeft), debugmsg)
	    		IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft
	    		return timeLeft
	    	end
	    end
	end
	for index = 1, 48 do
	    local effect, _, _, _, _, _, timeLeft = IWin.libdebuff:UnitDebuff(unit, index, owner)
	    if effect and effect == spell then
	    	timeLeft = timeLeft or 9999
	    	IWin:Debug("Debuff remaining "..spell.." on "..unit..": "..tostring(timeLeft), debugmsg)
	    	IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft
	        return timeLeft
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
	        		IWin:Debug("Player buff remaining "..spell.." on "..unit..": "..tostring(timeLeft), debugmsg)
	        		IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft
	        		return timeLeft
	        	else
	        		IWin:Debug("Player buff remaining "..spell.." on "..unit..": "..tostring(9999), debugmsg)
	        		IWin_CombatVar["buffRemaining"][cacheKey] = 9999
	        		return 9999
	        	end
	        end
	    end
	    if DoitePlayerAuras then
			local timeLeft = DoitePlayerAuras.GetHiddenBuffRemaining(spell)
			if timeLeft then
				IWin:Debug("Hidden player buff remaining "..spell.." on "..unit..": "..tostring(timeLeft), debugmsg)
				IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft
				return timeLeft
			end
			if DoitePlayerAuras.HasBuff(spell) then
				IWin:Debug("Hidden player buff remaining "..spell.." on "..unit..": "..tostring(9999), debugmsg)
				IWin_CombatVar["buffRemaining"][cacheKey] = 9999
		        return 9999
		    end
		end
    end
    -- Nampower aura slot scan
	if unit == "player" and GetPlayerAuraDuration and GetSpellIdForName then
		local targetSpellId = GetSpellIdForName(spell)
		if targetSpellId and targetSpellId ~= 0 then
			for slot = 0, 31 do
				local spellId, remainingMs = GetPlayerAuraDuration(slot)
				if spellId and spellId == targetSpellId then
					local timeLeft = remainingMs / 1000
					if timeLeft > 0 then
						IWin:Debug("Nampower buff remaining "..spell.." on "..unit..": "..tostring(timeLeft), debugmsg)
						IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft
						return timeLeft
					else
						IWin_CombatVar["buffRemaining"][cacheKey] = 9999
						return 9999
					end
				end
			end
		end
	end
    -- SCRM overflow buff scan
		if CleveRoids and CleveRoids.OverflowBuffs then
			for spellId, data in pairs(CleveRoids.OverflowBuffs) do
				if SpellInfo(spellId) == spell then
					local timeLeft = data.durationSec - (GetTime() - data.timestamp)
					if timeLeft > 0 then
						IWin:Debug("Overflow buff remaining "..spell.." on "..unit..": "..tostring(timeLeft), debugmsg)
						IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft
						return timeLeft
					end
				end
			end
		end
    -- Debuff scan overflow as buff
	for index = 1, 64 do
	    local effect, _, _, _, _, _, timeLeft, caster = IWin.libdebuff:UnitBuff(unit, index)
	    if not effect then break end
	    if effect == spell and ((not owner) or (caster == owner)) then
	    	IWin:Debug("Debuff overflow remaining "..spell.." on "..unit..": "..tostring(timeLeft or 9999), debugmsg)
	    	IWin_CombatVar["buffRemaining"][cacheKey] = timeLeft or 9999
	        return timeLeft or 9999
	    end
	end
	-- Not found
	IWin:Debug("Buff "..spell.." on "..unit.." not found", debugmsg)
	IWin_CombatVar["buffRemaining"][cacheKey] = 0
	return 0
end

function IWin:IsBuffActive(unit, spell, owner, debugmsg)
	local result = IWin:GetBuffRemaining(unit, spell, owner, false) ~= 0
	IWin:Debug("Buff "..spell.." active: "..tostring(result), debugmsg)
	return result
end

function IWin:GetBuffStack(unit, spell, owner, debugmsg)
	local cacheKey = unit.."|"..spell.."|"..(owner or "nil")
	local cached = IWin_CombatVar["buffStack"][cacheKey]
	if cached ~= nil then
		IWin:Debug("Buff "..spell.." stacks on "..unit..": "..tostring(cached), debugmsg)
		return cached
	end
	-- Nampower API
	local _, _, stacks = IWin.API.FindUnitAuraInfo(unit, nil, string.lower(spell))
	if stacks ~= nil then
		stacks = stacks or 0
		IWin:Debug("API Debuff "..spell.." stacks on "..unit..": "..tostring(stacks), debugmsg)
		IWin_CombatVar["buffStack"][cacheKey] = stacks
	    return stacks
	end
	-- Debuff scan
	for index = 1, 16 do
	    local effect, _, texture, stacks, dtype, duration, timeLeft, caster = IWin.libdebuff:UnitDebuff(unit, index)
	    if not effect then break end
	    if effect == spell and ((not owner) or (caster == owner)) then
	    	IWin:Debug("Debuff "..spell.." stacks on "..unit..": "..tostring(stacks), debugmsg)
	    	IWin_CombatVar["buffStack"][cacheKey] = stacks
	        return stacks
	    end
	end
	-- Player buff scan
	if unit == "player" then
		if DoitePlayerAuras then
			local stacks = DoitePlayerAuras.GetBuffStacks(spell)
   			if stacks then
   				IWin:Debug("Hidden Player Buff "..spell.." stacks on "..unit..": "..tostring(stacks), debugmsg)
   				IWin_CombatVar["buffStack"][cacheKey] = stacks
   				return stacks
   			end
		end
		local index = IWin:GetPlayerBuffIndex(spell)
		if index then
			local _, stack = UnitBuff(unit, index)
			local result = stack or 0
			IWin:Debug("Player Buff "..spell.." stacks on "..unit..": "..tostring(result), debugmsg)
			IWin_CombatVar["buffStack"][cacheKey] = result
			return result
		end
	end
	-- SCRM overflow buff scan
		if CleveRoids and CleveRoids.OverflowBuffs then
			for spellId, data in pairs(CleveRoids.OverflowBuffs) do
				if SpellInfo(spellId) == spell then
					local timeLeft = data.durationSec - (GetTime() - data.timestamp)
					if timeLeft > 0 then
						IWin:Debug("Overflow buff "..spell.." on "..unit..": 1 stack", debugmsg)
						IWin_CombatVar["buffStack"][cacheKey] = 1
						return 1
					end
				end
			end
		end
	-- Debuff scan overflow as buff
	for index = 1, 64 do
	    local effect, _, texture, stacks, dtype, duration, timeLeft, caster = IWin.libdebuff:UnitBuff(unit, index)
	    if not effect then break end
	    if effect == spell and ((not owner) or (caster == owner)) then
	    	IWin:Debug("Debuff overflow "..spell.." stacks on "..unit..": "..tostring(stacks), debugmsg)
	    	IWin_CombatVar["buffStack"][cacheKey] = stacks
	        return stacks
	    end
	end
	-- Not found
	IWin:Debug("Buff "..spell.." on "..unit.." not found", debugmsg)
	IWin_CombatVar["buffStack"][cacheKey] = 0
	return 0
end

function IWin:IsBuffStack(unit, spell, stack, owner, debugmsg)
	local result = IWin:GetBuffStack(unit, spell, owner, false) == stack
	IWin:Debug("Buff "..spell.." with "..stack.." stacks on "..unit..": "..tostring(result), debugmsg)
	return result
end

function IWin:IsTaunted(debugmsg)
	local cached = IWin_CombatVar["taunted"]
	if cached ~= nil then
		IWin:Debug("Target under taunt effect: "..tostring(cached), debugmsg)
		return cached
	end
	local index = 1
	while IWin_Taunt[index] do
		local taunt = IWin:IsBuffActive("target", IWin_Taunt[index])
		if taunt then
			IWin:Debug("Target under taunt effect: true", debugmsg)
			IWin_CombatVar["taunted"] = true
			return true
		end
		index = index + 1
	end
	IWin:Debug("Target under taunt effect: false", debugmsg)
	IWin_CombatVar["taunted"] = false
	return false
end

function IWin:IsFeared(debugmsg)
	local cached = IWin_CombatVar["feared"]
	if cached ~= nil then
		IWin:Debug("Player is feared: "..tostring(cached), debugmsg)
		return cached
	end
	for fear in IWin_Fear do
		if IWin:IsBuffActive("player", IWin_Fear[fear], nil, false) then
			IWin:Debug("Player is feared: true", debugmsg)
			IWin_CombatVar["feared"] = true
			return true
		end
	end
	IWin:Debug("Player is feared: false", debugmsg)
	IWin_CombatVar["feared"] = false
	return false
end

-- Spell #######################################################################################################################################
--helper
function IWin:GetSpellSpellbookID(spell, rank)
	local cacheKey = rank and (spell .. "|" .. rank) or spell
    local cached = IWin_Spellbook[cacheKey]
    if cached ~= nil then
        return cached ~= false and cached or nil
    end
    local spellID = 1
    while true do
        local spellName, spellRank = GetSpellName(spellID, "BOOKTYPE_SPELL")
        if not spellName then break end
        if spellName == spell and ((not rank) or spellRank == rank) and (rank ~= nil or spellName ~= GetSpellName(spellID + 1, "BOOKTYPE_SPELL")) then
        	IWin_Spellbook[cacheKey] = spellID
            return spellID
        end
        spellID = spellID + 1
    end
    IWin_Spellbook[cacheKey] = false
    return nil
end

function IWin:GetCooldownRemaining(spell, debugmsg)
	local cached = IWin_CombatVar["cooldown"][spell]
	if cached ~= nil then
		IWin:Debug("Cooldown "..spell.." remaining: "..tostring(cached), debugmsg)
		return cached
	end
	local spellID = IWin:GetSpellSpellbookID(spell)
	if not spellID then return false end
	local start, duration = GetSpellCooldown(spellID, "BOOKTYPE_SPELL")
	if start ~= 0 and duration ~= IWin_Settings["GCD"] then
		local result = duration - (IWin:GetTime(false) - start)
		IWin:Debug("Cooldown "..spell.." remaining: "..tostring(result), debugmsg)
		IWin_CombatVar["cooldown"][spell] = result
		return result
	else
		IWin:Debug("Cooldown "..spell.." ready", debugmsg)
		IWin_CombatVar["cooldown"][spell] = 0
		return 0
	end
end

function IWin:IsOnCooldown(spell, debugmsg)
	local result = IWin:GetCooldownRemaining(spell, false) ~= 0
	IWin:Debug("Cooldown "..spell.." ready: "..tostring(result), debugmsg)
	return result
end

function IWin:IsSpellLearnt(spell, rank, debugmsg)
	local spellID = IWin:GetSpellSpellbookID(spell, rank)
	if not spellID then
		IWin:Debug("Unknown spell: "..spell, debugmsg)
		return false
	end
	IWin:Debug("Spell found: "..spell, debugmsg)
	return true
end

function IWin:GetGCDRemaining(debugmsg)
	local cached = IWin_CombatVar["GCD"]
	if cached ~= nil then return cached end
    -- Get GCD remaining in seconds
    local gcdRemaining = 0

    -- Try Nampower API first (most accurate)
    if CleveRoids.NampowerAPI and CleveRoids.NampowerAPI.GetGCDRemainingMs then
        local gcdMs = CleveRoids.NampowerAPI.GetGCDRemainingMs()
        if gcdMs and gcdMs > 0 then
            gcdRemaining = gcdMs / 1000
        end
    else
        -- Fallback: check the first spell in spellbook for GCD
        -- GCD shows as cooldown <= 1.5s on any GCD-triggering spell
        for i = 1, 200 do
            local spellName = GetSpellName(i, BOOKTYPE_SPELL)
            if not spellName then break end
            local start, duration = GetSpellCooldown(i, BOOKTYPE_SPELL)
            if start and duration and duration > 0 and duration <= 1.5 then
                gcdRemaining = (start + duration) - GetTime()
                if gcdRemaining < 0 then gcdRemaining = 0 end
                break
            end
        end
    end
    if gcdRemaining ~= 0 then
    	IWin_CombatVar["GCD"] = gcdRemaining
		IWin:Debug("GCD remaining: "..tostring(gcdRemaining), debugmsg)
		return gcdRemaining
	end
	--[[local info = GetCastInfo()
	if info and info.gcdRemainingMs then
		IWin_CombatVar["GCD"] = info.gcdRemainingMs
		IWin:Debug("GCD remaining: "..tostring(IWin_CombatVar["GCD"]), debugmsg)
		return IWin_CombatVar["GCD"]
	end]]
	IWin:Debug("GCD ready", debugmsg)
	IWin_CombatVar["GCD"] = 0
	return 0
end

function IWin:IsGCDActive(debugmsg)
	local cached = IWin_CombatVar["GCDActive"]
	if cached ~= nil then return cached end
	if IWin:GetGCDRemaining(false) ~= 0 then
		IWin:Debug("GCD not ready", debugmsg)
		IWin_CombatVar["GCDActive"] = true
		return true
	end
	IWin:Debug("GCD ready", debugmsg)
	IWin_CombatVar["GCDActive"] = false
	return false
end

--helper
function IWin:ParseCastTimeFromText(text)
    if not text then return nil end
    -- Match patterns like "1.5 sec cast", "1.59 sec cast", "2 sec cast"
    --local castTime = string.match(text, "(%d+%.?%d*) sec cast")
    local _, _, castTime = string.find(text, "(%d+%.?%d*) sec cast")
    if castTime then
        return tonumber(castTime)
    end
    return nil
end

function IWin:GetCastTime(spell, debugmsg)
	local cached = IWin_CastTime[spell]
    if cached ~= nil then
    	local result = cached ~= false and cached or nil
    	IWin:Debug(spell.." cast time: "..tostring(result), debugmsg)
        return result
    end
	local spellID = IWin:GetSpellSpellbookID(spell)
    if not spellID then
        IWin_CastTime[spell] = false
        return nil
    end

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
            	IWin_CastTime[spell] = castTime
            	IWin:Debug(spell.." cast time: "..castTime, debugmsg)
                return castTime
            end
        end
        local rightText = getglobal("IWin_TTextRight" .. i)
        if rightText then
            local text = rightText:GetText()
            local castTime = IWin:ParseCastTimeFromText(text)
            if castTime then
            	IWin_CastTime[spell] = castTime
            	IWin:Debug(spell.." cast time: "..castTime, debugmsg)
                return castTime
            end
        end
    end
    IWin_CastTime[spell] = false
    IWin:Debug(spell.." cast time unknown", debugmsg)
    return nil
end

--helper
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
function IWin:IsActionUsable(spell, debugmsg)
	local slot = IWin:GetSpellSlot(spell)
	if slot and IsUsableAction(slot) == 1 then
		IWin:Debug(spell.." usable", debugmsg)
		return true
	end
	IWin:Debug(spell.." not usable or not in action bar", debugmsg)
	return false
end

function IWin:GetSpellNameMaxRank(spell, debugmsg)
	if not IWin:IsSpellLearnt(spell, nil, false) then
		IWin:Debug("Unknown spell: "..spell, debugmsg)
		return nil
	end
	local rank = 1
	while true do
		local rankName = "Rank " .. tostring(rank)
		if IWin:IsSpellLearnt(spell, rankName, false) then
			spellNameMaxRank = spell .. "(" .. rankName .. ")"
		else
			IWin:Debug(spell.." max rank: "..spellNameMaxRank, debugmsg)
			return spellNameMaxRank
		end
		rank = rank + 1
	end
end

function IWin:IsCasting(unit, spell, debugmsg)
	local cacheKey = unit.."|"..(spell or "nil")
	local cached = IWin_CombatVar["casting"][cacheKey]
	if cached ~= nil then
		IWin:Debug(unit.." is casting "..(spell or "")..": "..tostring(cached), debugmsg)
		return cached
	end
	local result = CleveRoids.CheckSpellCast(unit, spell)
	IWin_CombatVar["casting"][cacheKey] = result
	IWin:Debug(unit.." is casting "..(spell or "")..": "..tostring(result), debugmsg)
	return result
end

function IWin:IsSpellSkip(spell, rank, gcd, queueTime, debugmsg)
	if (not IWin_CombatVar["queueGCD"]) and gcd then
		return true
	end
	if not IWin:IsSpellLearnt(spell, rank, false) then
		IWin:Debug("Unknown spell: "..spell, debugmsg)
		return true
	end
	IWin:Debug("+++ checking conditions: "..spell, debugmsg)
	if queueTime ~= nil then
		if IWin:GetCooldownRemaining(spell, false) >= queueTime then
			IWin:Debug("Spell on cooldown: "..spell, debugmsg)
			return true
		end
	else
		if IWin:IsOnCooldown(spell, false) then
			IWin:Debug("Spell on cooldown: "..spell, debugmsg)
			return true
		end
	end
	return false
end

function IWin:GetAttackSpeed(unit, debugmsg)
	local cached = IWin_CombatVar["attackSpeed"]
	if cached ~= nil then
		IWin:Debug("Attack Speed: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitAttackSpeed(unit)
	IWin_CombatVar["attackSpeed"] = result
	IWin:Debug("Attack Speed: "..tostring(result), debugmsg)
	return result
end

-- Stance #######################################################################################################################################
--helper
function IWin:GetStance()
	local forms = GetNumShapeshiftForms()
	for index = 1, forms do
		local _, name, active = GetShapeshiftFormInfo(index)
		if active == 1 then
			return name
		end
	end
	return "no stance"
end

function IWin:IsStanceActive(stance, debugmsg)
	local cached = IWin_CombatVar["stance"]
	if cached ~= nil then
		local result = cached == stance
		IWin:Debug("Stance "..stance.." active: "..tostring(result), debugmsg)
		return result
	end
	local stanceActive = IWin:GetStance()
	IWin_CombatVar["stance"] = stanceActive
	local result = stanceActive == stance
	IWin:Debug("Stance "..stance.." active: "..tostring(result), debugmsg)
	return result
end

-- Health #######################################################################################################################################
function IWin:GetHealth(unit, debugmsg)
	local cached = IWin_CombatVar["health"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." health: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitHealth(unit)
	IWin_CombatVar["health"][unit] = result
	IWin:Debug(unit.." health: "..tostring(result), debugmsg)
	return result
end

function IWin:GetHealthMax(unit, debugmsg)
	local cached = IWin_CombatVar["healthMax"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." max health: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitHealthMax(unit)
	IWin_CombatVar["healthMax"][unit] = result
	IWin:Debug(unit.." max health: "..tostring(result), debugmsg)
	return result
end

function IWin:GetHealthPercent(unit, debugmsg)
	local cached = IWin_CombatVar["healthPercent"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." health %: "..tostring(cached), debugmsg)
		return cached
	end
	local result = IWin:GetHealth(unit, false) / IWin:GetHealthMax(unit, false) * 100
	IWin_CombatVar["healthPercent"][unit] = result
	IWin:Debug(unit.." health %: "..tostring(result), debugmsg)
	return result
end

function IWin:IsExecutePhase(debugmsg)
	local cached = IWin_CombatVar["executePhase"]
	if cached ~= nil then
		IWin:Debug("Execute phase: "..tostring(cached), debugmsg)
		return cached
	end
	local result = IWin:GetHealthPercent("target", false) <= 20
	IWin_CombatVar["executePhase"] = result
	IWin:Debug("Execute phase: "..tostring(result), debugmsg)
	return result
end

function IWin:GetTimeToDie(debugmsg)
	local cached = IWin_CombatVar["timeToDie"]
	if cached ~= nil then
		IWin:Debug("Target time to die: "..tostring(cached), debugmsg)
		return cached
	end
	local ttd = 0
	local numPartyMembers = math.max(2, GetNumPartyMembers(), GetNumRaidMembers())
	if type(TimeToKill) ~= "table" or type(TimeToKill.GetTTK) ~= "function" or TimeToKill.GetTTK() == nil or TimeToKill.GetTTK() == -1 then
		ttd = IWin:GetHealth("target", false) / IWin:GetHealthMax("player", false) * IWin_Settings["playerToNPCHealthRatio"] * IWin_Settings["outOfRaidCombatLength"] / numPartyMembers * 2
	else
		ttd = TimeToKill.GetTTK() - 1
	end
	IWin_CombatVar["timeToDie"] = ttd
	IWin:Debug("Target time to die: "..tostring(ttd), debugmsg)
	return ttd
end

function IWin:GetTimeToExecute(debugmsg)
	local cached = IWin_CombatVar["timeToExecute"]
	if cached ~= nil then
		IWin:Debug("Target time to execute: "..tostring(cached), debugmsg)
		return cached
	end
	local tte = 0
	local numPartyMembers = math.max(2, GetNumPartyMembers(), GetNumRaidMembers())
	if type(TimeToKill) ~= "table" or type(TimeToKill.GetTTE) ~= "function" or TimeToKill.GetTTE() == nil or TimeToKill.GetTTE() == -1 then
		tte = (IWin:GetHealth("target", false) - 0.2 * IWin:GetHealthMax("target", false)) / IWin:GetHealthMax("player", false) * IWin_Settings["playerToNPCHealthRatio"] * IWin_Settings["outOfRaidCombatLength"] / numPartyMembers * 2
	else
		tte = TimeToKill.GetTTE() - 1
	end
	IWin_CombatVar["timeToExecute"] = tte
	IWin:Debug("Target time to execute: "..tostring(ttd), debugmsg)
	return tte
end

-- Power #######################################################################################################################################
function IWin:GetPowerType(unit, debugmsg)
	local cached = IWin_CombatVar["powerType"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." power type: "..cached, debugmsg)
		return cached
	end
	local result = IWin_PowerType[UnitPowerType(unit)]
	IWin_CombatVar["powerType"][unit] = result
	IWin:Debug(unit.." power type: "..result, debugmsg)
	return result
end

function IWin:GetPower(unit, debugmsg)
	local cached = IWin_CombatVar["power"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." "..IWin:GetPowerType(unit, false)..": "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitMana(unit)
	IWin_CombatVar["power"][unit] = result
	IWin:Debug(unit.." "..IWin:GetPowerType(unit, false)..": "..tostring(result), debugmsg)
	return result
end

function IWin:GetPowerMax(unit, debugmsg)
	local cached = IWin_CombatVar["powerMax"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." "..IWin:GetPowerType(unit, false)..": "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitManaMax(unit)
	IWin_CombatVar["powerMax"][unit] = result
	IWin:Debug(unit.." "..IWin:GetPowerType(unit, false)..": "..tostring(result), debugmsg)
	return result
end

function IWin:GetPowerPercent(unit, debugmsg)
	local cached = IWin_CombatVar["powerPercent"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." "..IWin:GetPowerType(unit, false).." %: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitMana(unit) / UnitManaMax(unit) * 100
	IWin_CombatVar["powerPercent"][unit] = result
	IWin:Debug(unit.." "..IWin:GetPowerType(unit, false).." %: "..tostring(result), debugmsg)
	return result
end

function IWin:IsPowerAvailable(spell, debugmsg)
	local result = UnitMana("player") >= IWin_ManaCost[spell]
	IWin:Debug(IWin:GetPowerType(unit, false).." available for "..spell..": "..tostring(result), debugmsg)
	return result
end

-- Mana #######################################################################################################################################
function IWin:GetPlayerDruidMana(debugmsg)
	local cached = IWin_Mana["playerDruidMana"]
	if cached ~= nil then
		IWin:Debug("Druid mana: "..tostring(cached), debugmsg)
		return cached
	end
	local _, casterMana = UnitMana("player")
	IWin_Mana["playerDruidMana"] = casterMana
	IWin:Debug("Druid mana: "..tostring(casterMana), debugmsg)
	return casterMana
end

function IWin:GetPlayerDruidManaPercent(debugmsg)
	local cached = IWin_Mana["playerDruidManaPercent"]
	if cached ~= nil then
		IWin:Debug("Druid mana %: "..tostring(cached), debugmsg)
		return cached
	end
	local _, casterManaMax = UnitManaMax("player")
	local result = IWin:GetPlayerDruidMana() / casterManaMax * 100
	IWin_Mana["playerDruidManaPercent"] = result
	IWin:Debug("Druid mana %: "..tostring(result), debugmsg)
	return result
end

--todo
function IWin:IsDruidManaAvailable(spell, debugmsg)
	local result = IWin:GetPlayerDruidMana() >= IWin_ManaCost[spell]
	IWin:Debug("Druid mana available for "..spell..": "..tostring(result), debugmsg)
	return result
end

-- Rage #######################################################################################################################################
function IWin:IsRageAvailable(spell, debugmsg)
	local rageRequired = IWin_RageCost[spell] + IWin_CombatVar["reservedRage"]
	-- Replacing auto attack will prevent getting rage from next swing, so rage cost is higher.
	if spell == "Heroic Strike" or spell == "Cleave" then
		rageRequired = rageRequired + 20 --fix before rework
	end
	local result = IWin:GetPower("player", false) >= rageRequired or IWin:IsBuffActive("player", "Clearcasting", nil, false)
	IWin:Debug("Rage available for "..spell..": "..tostring(result), debugmsg)
	return result
end

function IWin:IsRageCostAvailable(spell, debugmsg)
	local result = IWin:GetPower("player", false) >= IWin_RageCost[spell] or IWin:IsBuffActive("player", "Clearcasting", nil, false)
	IWin:Debug("Rage cost available for "..spell..": "..tostring(result), debugmsg)
	return result
end

function IWin:GetRageToReserve(spell, trigger, unit, debugmsg)
	local spellTriggerTime = 0
	local rageCost = IWin_RageCost[spell]
	-- Replacing auto attack will prevent getting rage from next swing, so rage cost is higher.
	if spell == "Heroic Strike" or spell == "Cleave" then
		rageCost = rageCost + 20 --fix before rework
	end
	if trigger == "nocooldown" and IWin:IsSpellLearnt(spell, nil, false) then
		IWin:Debug("Reserving rage for "..spell..": "..tostring(rageCost), debugmsg)
		return rageCost
	elseif trigger == "cooldown" then
		spellTriggerTime = IWin:GetCooldownRemaining(spell, false) or 0
	elseif trigger == "buff" or trigger == "partybuff" then
		spellTriggerTime = IWin:GetBuffRemaining(unit, spell, nil, false) or 0
	end
	local ragePerSecond = IWin:GetRagePerSecond(false)
	local reservedRageTime = 0
	if ragePerSecond > 0 then
		reservedRageTime = IWin_CombatVar["reservedRage"] / ragePerSecond
	end
	local timeToReserveRage = math.max(0, spellTriggerTime - IWin_Settings["rageTimeToReserveBuffer"] - reservedRageTime)
	if trigger == "partybuff" or IWin:IsSpellLearnt(spell, nil, false) then
		local result = math.max(0, rageCost - ragePerSecond * timeToReserveRage)
		IWin:Debug("Reserving rage for "..spell..": "..tostring(result), debugmsg)
		return result
	end
	IWin:Debug("Not reserving rage for "..spell, debugmsg)
	return 0
end

function IWin:IsTimeToReserveRage(spell, trigger, unit, debugmsg)
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	local result = IWin:GetRageToReserve(spell, trigger, unit, false) ~= 0
	IWin:Debug("Reserving rage required for "..spell..": "..tostring(result), debugmsg)
	return result
end

function IWin:SetReservedRage(spell, trigger, unit, debugmsg)
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	IWin_CombatVar["reservedRage"] = IWin_CombatVar["reservedRage"] + IWin:GetRageToReserve(spell, trigger, unit, false)
	IWin:Debug("New reserved rage value: "..IWin_CombatVar["reservedRage"], debugmsg)
end

-- RLS (Recursive Least Squares) for dynamic rage per second estimation
-- Models cumulative rage gained as a linear function of time: rage(t) = slope * t + offset
-- The slope is the estimated rage per second
function IWin:UpdateRageRLS(rageGained)
	local now = GetTime()
	if not IWin_RLS then return end
	-- Accumulate total rage gained
	IWin_RLS["totalRage"] = IWin_RLS["totalRage"] + rageGained
	-- Input vector: [time, 1]
	local t = now - IWin_RLS["startTime"]
	local y = IWin_RLS["totalRage"]
	local lambda = IWin_RLS["lambda"]
	-- P matrix (2x2 symmetric): p11, p12, p22
	local p11 = IWin_RLS["p11"]
	local p12 = IWin_RLS["p12"]
	local p22 = IWin_RLS["p22"]
	-- Gain vector: k = P * x / (lambda + x' * P * x)
	local px1 = p11 * t + p12
	local px2 = p12 * t + p22
	local denom = lambda + t * px1 + px2
	if denom == 0 then return end
	local k1 = px1 / denom
	local k2 = px2 / denom
	-- Prediction error
	local w1 = IWin_RLS["w1"]
	local w2 = IWin_RLS["w2"]
	local err = y - (w1 * t + w2)
	-- Update weights
	IWin_RLS["w1"] = w1 + k1 * err
	IWin_RLS["w2"] = w2 + k2 * err
	-- Update P matrix: P = (P - k * x' * P) / lambda
	local invLambda = 1 / lambda
	IWin_RLS["p11"] = (p11 - k1 * px1) * invLambda
	IWin_RLS["p12"] = (p12 - k1 * px2) * invLambda
	IWin_RLS["p22"] = (p22 - k2 * px2) * invLambda
end

function IWin:ResetRageRLS()
	IWin_RLS = {
		["startTime"] = GetTime(),
		["totalRage"] = 0,
		["lambda"] = 0.8,
		-- P matrix initialized to large values (high uncertainty)
		["p11"] = 1000,
		["p12"] = 0,
		["p22"] = 1000,
		-- Weight vector: w1 = slope (rage/sec), w2 = offset
		["w1"] = IWin_Settings["ragePerSecondPrediction"],
		["w2"] = 0,
	}
end

function IWin:GetRagePerSecond(debugmsg)
	if IWin_RLS then
		local result = math.max(IWin_Settings["ragePerSecondPrediction"], IWin_RLS["w1"])
		IWin:Debug("Dynamic rage per second: "..tostring(result), debugmsg)
		return result
	end
	if IWin_RLS_lastValue then
		local result = math.max(IWin_Settings["ragePerSecondPrediction"], IWin_RLS_lastValue)
		IWin:Debug("Last combat rage per second: "..tostring(result), debugmsg)
		return result
	end
	IWin:Debug("RLS not initialized, using setting: "..tostring(IWin_Settings["ragePerSecondPrediction"]), debugmsg)
	return IWin_Settings["ragePerSecondPrediction"]
end

-- Energy #######################################################################################################################################
function IWin:IsEnergyAvailable(spell, debugmsg)
	local energyRequired = IWin_EnergyCost[spell] + IWin_CombatVar["reservedEnergy"]
	local result = (IWin:GetPower("player", false) >= energyRequired) or IWin:IsBuffActive("player", "Clearcasting", nil, false) or (IWin:GetPower("player", false) > (100 - IWin:GetEnergyPerSecond() * 2))
	IWin:Debug("Energy available for "..spell..": "..tostring(result), debugmsg)
	return result
end

function IWin:IsEnergyCostAvailable(spell, debugmsg)
	local result = IWin:GetPower("player", false) >= IWin_EnergyCost[spell] or IWin:IsBuffActive("player", "Clearcasting", nil, false)
	IWin:Debug("Energy cost available for "..spell..": "..tostring(result), debugmsg)
	return result
end

function IWin:GetEnergyToReserve(spell, trigger, unit, debugmsg)
	local spellTriggerTime = 0
	if trigger == "nocooldown" and IWin:IsSpellLearnt(spell, nil, false) then
		IWin:Debug("Reserving energy for "..spell..": "..tostring(IWin_EnergyCost[spell]), debugmsg)
		return IWin_EnergyCost[spell]
	elseif trigger == "cooldown" then
		spellTriggerTime = IWin:GetCooldownRemaining(spell, false) or 0
	elseif trigger == "buff" or trigger == "partybuff" then
		spellTriggerTime = IWin:GetBuffRemaining(unit, spell, nil, false) or 0
	end
	local reservedEnergyTime = 0
	if IWin:GetEnergyPerSecond() > 0 then
		reservedEnergyTime = IWin_CombatVar["reservedEnergy"] / IWin:GetEnergyPerSecond()
	end
	local timeToReserveEnergy = math.max(0, spellTriggerTime - IWin_Settings["energyTimeToReserveBuffer"] - reservedEnergyTime)
	if trigger == "partybuff" or IWin:IsSpellLearnt(spell, nil, false) then
		local result = math.max(0, IWin_EnergyCost[spell] - IWin:GetEnergyPerSecond() * timeToReserveEnergy)
		IWin:Debug("Reserving energy for "..spell..": "..tostring(result), debugmsg)
		return result
	end
	IWin:Debug("Not reserving energy for "..spell, debugmsg)
	return 0
end

function IWin:IsTimeToReserveEnergy(spell, trigger, unit, debugmsg)
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	local result = IWin:GetEnergyToReserve(spell, trigger, unit, false) ~= 0
	IWin:Debug("Reserving energy required for "..spell..": "..tostring(result), debugmsg)
	return result
end

function IWin:SetReservedEnergy(spell, trigger, unit, debugmsg)
	if not IWin:IsSpellLearnt(spell, nil, false) then return end
	IWin_CombatVar["reservedEnergy"] = IWin_CombatVar["reservedEnergy"] + IWin:GetEnergyToReserve(spell, trigger, unit)
	IWin:Debug("New reserved energy value: "..IWin_CombatVar["reservedEnergy"], debugmsg)
end

-- Range #######################################################################################################################################
function IWin:IsInRange(spell, distance, unit, debugmsg)
	if unit == nil then unit = "target" end
	local cacheKey = (spell or "nil").."|"..(distance or "nil").."|"..unit
	local cached = IWin_CombatVar["inRange"][cacheKey]
	if cached ~= nil then
		IWin:Debug("In range "..cacheKey..": "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists(unit, false) then
		IWin:Debug("No range for unkown "..unit, debugmsg)
		IWin_CombatVar["inRange"][cacheKey] = false
		return false
	end
	if not IsSpellInRange
		or not spell
		or not IWin:IsSpellLearnt(spell, nil, false) then
			if distance == "farranged" then
				local result = not (CheckInteractDistance(unit, 4) ~= nil)
				IWin:Debug("Far range for "..unit..": "..tostring(result), debugmsg)
				IWin_CombatVar["inRange"][cacheKey] = result
				return result
			elseif distance == "ranged" then
				local result = not (CheckInteractDistance(unit, 3) ~= nil)
				IWin:Debug("Mid range for "..unit..": "..tostring(result), debugmsg)
				IWin_CombatVar["inRange"][cacheKey] = result
				return result
			else
        		local result = CheckInteractDistance(unit, 3) ~= nil
        		IWin:Debug("Close range for "..unit..": "..tostring(result), debugmsg)
        		IWin_CombatVar["inRange"][cacheKey] = result
				return result
        	end
	else
		local spellId = GetSpellIdForName and GetSpellIdForName(spell)
		if spellId and spellId ~= 0 then
			local result = IsSpellInRange(spellId, unit) == 1
			IWin:Debug("In range for "..unit.." with "..spell.." (id:"..spellId.."): "..tostring(result), debugmsg)
			IWin_CombatVar["inRange"][cacheKey] = result
			return result
		else
			local result = CheckInteractDistance(unit, 3) ~= nil
			IWin:Debug("Fallback range for "..unit..": "..tostring(result), debugmsg)
			IWin_CombatVar["inRange"][cacheKey] = result
			return result
		end
	end
end

-- range values: static number, meleeAutoAttack
function IWin:GetEnemyInRange(range, debugmsg)
	if type(range) == "number" then return range end
	local cached = IWin_CombatVar["enemyInRange"][range]
	if cached ~= nil then
		IWin:Debug("Enemies in "..range.." range: "..tostring(cached), debugmsg)
		return cached
	end
    local result = CleveRoids.CountEnemiesMatching(function(unit)
        local distance = UnitXP("distanceBetween", "player", unit, range)
        return distance and distance <= 5
    end)
    IWin_CombatVar["enemyInRange"][range] = result
	IWin:Debug("Enemies in "..range.." range: "..tostring(result), debugmsg)
	return result
end

-- range values: static number, meleeAutoAttack
function IWin:GetEnemyInFront(range, debugmsg)
	if staticReturn then return staticReturn end
	local cached = IWin_CombatVar["enemyInFront"][range]
	if cached ~= nil then
		IWin:Debug("Enemies in front in "..tostring(range)..": "..tostring(cached), debugmsg)
		return cached
	end
    local result = CleveRoids.CountEnemiesMatching(function(unit)
    	local distance = UnitXP("distanceBetween", "player", unit, range)
    	local facing = UnitXP("behind", unit, "player") ~= true
        return distance and distance <= 5 and facing
    end)
    IWin_CombatVar["enemyInFront"][range] = result
	IWin:Debug("Enemies in front in "..tostring(range)..": "..tostring(result), debugmsg)
	return result
end

-- Target #######################################################################################################################################
function IWin:IsTanking(debugmsg)
	local cached = IWin_CombatVar["tanking"]
	if cached ~= nil then
		IWin:Debug("Player is tanking target: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitIsUnit("targettarget", "player") and true or false
	IWin_CombatVar["tanking"] = result
	IWin:Debug("Player is tanking target: "..tostring(result), debugmsg)
	return result
end

function IWin:IsBehind(debugmsg)
	local cached = IWin_CombatVar["behind"]
	if cached ~= nil then
		IWin:Debug("Player is behind target: "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists("target", false) then
		IWin:Debug("Player is behind target: false", debugmsg)
		IWin_CombatVar["behind"] = false
		return false
	end
    local result = UnitXP("behind", "player", "target")
    IWin_CombatVar["behind"] = result
    IWin:Debug("Player is behind target: "..tostring(result), debugmsg)
    return result
end

function IWin:IsTrainingDummy(debugmsg)
	local cached = IWin_Target["trainingDummy"]
	if cached ~= nil then
		IWin:Debug("Target is Training Dummy: "..tostring(cached), debugmsg)
		return cached
	end
	local name = IWin:GetName("target", false)
	if name and string.find(name,"Training Dummy") then
		IWin_Target["trainingDummy"] = true
		IWin:Debug("Target is Training Dummy: true", debugmsg)
		return true
	end
	IWin_Target["trainingDummy"] = false
	IWin:Debug("Target is Training Dummy: false", debugmsg)
	return false
end

function IWin:IsElite(debugmsg)
	local cached = IWin_Target["elite"]
	if cached ~= nil then
		IWin:Debug("Target is Elite: "..tostring(cached), debugmsg)
		return cached
	end
	local classification = UnitClassification("target")
	if IWin:IsTrainingDummy()
		or (
				classification
				and IWin_UnitClassification[classification]
			) then
				IWin_Target["elite"] = true
				IWin:Debug("Target is Elite: true", debugmsg)
				return true
	end
	IWin_Target["elite"] = false
	IWin:Debug("Target is Elite: false", debugmsg)
	return false
end

function IWin:IsBoss(debugmsg)
	local cached = IWin_Target["boss"]
	if cached ~= nil then
		IWin:Debug("Target is Boss: "..tostring(cached), debugmsg)
		return cached
	end
	if UnitClassification("target") == "worldboss"
		or IWin:IsTrainingDummy()
		or IWin:IsWhitelistBoss() then
			IWin_Target["boss"] = true
			IWin:Debug("Target is Boss: true", debugmsg)
			return true
	end
	IWin_Target["boss"] = false
	IWin:Debug("Target is Boss: false", debugmsg)
	return false
end

function IWin:IsBlacklistCooldownMelee(debugmsg)
	local cached = IWin_Target["blacklistCooldownMelee"]
	if cached ~= nil then
		IWin:Debug("Target is blacklisted for melee cooldowns: "..tostring(cached), debugmsg)
		return cached
	end
	if IWin_BlacklistCooldownMelee[IWin:GetName("target", false)] then
		IWin_Target["blacklistCooldownMelee"] = true
		IWin:Debug("Target is blacklisted for melee cooldowns: true", debugmsg)
		return true
	end
	IWin_Target["blacklistCooldownMelee"] = false
	IWin:Debug("Target is blacklisted for melee cooldowns: false", debugmsg)
	return false
end

function IWin:IsBlacklistCooldownRanged(debugmsg)
	local cached = IWin_Target["blacklistCooldownRanged"]
	if cached ~= nil then
		IWin:Debug("Target is blacklisted for ranged cooldowns: "..tostring(cached), debugmsg)
		return cached
	end
	if IWin_BlacklistCooldownRanged[IWin:GetName("target", false)] then
		IWin_Target["blacklistCooldownRanged"] = true
		IWin:Debug("Target is blacklisted for ranged cooldowns: true", debugmsg)
		return true
	end
	IWin_Target["blacklistCooldownRanged"] = false
	IWin:Debug("Target is blacklisted for ranged cooldowns: false", debugmsg)
	return false
end

function IWin:IsBlacklistAOEDebuff(debugmsg)
	local cached = IWin_Target["blacklistAOEDebuff"]
	if cached ~= nil then
		IWin:Debug("Target is blacklisted for aoe debuff: "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists("target", false)
		or IWin_BlacklistAOEDebuff[IWin:GetName("target", false)] then
			IWin_Target["blacklistAOEDebuff"] = true
			IWin:Debug("Target is blacklisted for aoe debuff: true", debugmsg)
			return true
	end
	IWin_Target["blacklistAOEDebuff"] = false
	IWin:Debug("Target is blacklisted for aoe debuff: false", debugmsg)
	return false
end

function IWin:IsBlacklistAOEDamage(debugmsg)
	local cached = IWin_Target["blacklistAOEDamage"]
	if cached ~= nil then
		IWin:Debug("Target is blacklisted for aoe damage: "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists("target", false)
		or IWin_BlacklistAOEDamage[IWin:GetName("target", false)] then
			IWin_Target["blacklistAOEDamage"] = true
			IWin:Debug("Target is blacklisted for aoe damage: true", debugmsg)
			return true
	end
	IWin_Target["blacklistAOEDamage"] = false
	IWin:Debug("Target is blacklisted for aoe damage: false", debugmsg)
	return false
end

function IWin:IsBlacklistKick(debugmsg)
	local cached = IWin_Target["blacklistKick"]
	if cached ~= nil then
		IWin:Debug("Target is blacklisted for kick: "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists("target", false)
		or IWin_BlacklistKick[IWin:GetName("target", false)] then
			IWin_Target["blacklistKick"] = true
			IWin:Debug("Target is blacklisted for kick: true", debugmsg)
			return true
	end
	IWin_Target["blacklistKick"] = false
	IWin:Debug("Target is blacklisted for kick: false", debugmsg)
	return false
end

function IWin:IsBlacklistFear(debugmsg)
	local cached = IWin_Target["blacklistFear"]
	if cached ~= nil then
		IWin:Debug("Target can cast fear: "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists("target", false)
		or IWin_BlacklistFear[IWin:GetName("target", false)] then
			IWin_Target["blacklistFear"] = true
			IWin:Debug("Target can cast fear: true", debugmsg)
			return true
	end
	IWin_Target["blacklistFear"] = false
	IWin:Debug("Target can cast fear: false", debugmsg)
	return false
end

function IWin:IsWhitelistCharge(debugmsg)
	local cached = IWin_Target["whitelistCharge"]
	if cached ~= nil then
		IWin:Debug("Target can be charged: "..tostring(cached), debugmsg)
		return cached
	end
	if not IWin:IsExists("target", false)
		or IWin_WhitelistCharge[IWin:GetName("target", false)] then
			IWin_Target["whitelistCharge"] = true
			IWin:Debug("Target can be charged: true", debugmsg)
			return true
	end
	IWin_Target["whitelistCharge"] = false
	IWin:Debug("Target can be charged: false", debugmsg)
	return false
end

function IWin:IsWhitelistBoss(debugmsg)
	local cached = IWin_Target["whitelistBoss"]
	if cached ~= nil then
		IWin:Debug("Target is considered Boss: "..tostring(cached), debugmsg)
		return cached
	end
	if IWin:IsExists("target", false)
		and IWin_WhitelistBoss[IWin:GetName("target", false)] then
			IWin_Target["whitelistBoss"] = true
			IWin:Debug("Target is considered Boss: true", debugmsg)
			return true
	end
	IWin_Target["whitelistBoss"] = false
	IWin:Debug("Target is considered Boss: false", debugmsg)
	return false
end

function IWin:IsImmune(unit, school, debugmsg)
	local result = CleveRoids.CheckImmunity(unit, school)
	IWin:Debug(unit.." is immune to "..school..": "..tostring(result), debugmsg)
	return result
end

function IWin:IsCreatureType(creatureType, debugmsg)
	if IWin_Target["creatureType"] == nil then
		IWin_Target["creatureType"] = UnitCreatureType("target")
	end
	local result = IWin_Target["creatureType"] == creatureType
	IWin:Debug("Target is a "..creatureType..": "..tostring(result), debugmsg)
	return result
end

function IWin:IsExists(unit, debugmsg)
	local cached = IWin_Target["exists"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." exists: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitExists(unit) and true or false
	IWin_Target["exists"][unit] = result
	IWin:Debug(unit.." exists: "..tostring(result), debugmsg)
	return result
end

function IWin:GetName(unit, debugmsg)
	local cached = IWin_Target["name"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." name: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitName(unit)
	IWin_Target["name"][unit] = result
	IWin:Debug(unit.." name: "..tostring(result), debugmsg)
	return result
end

function IWin:IsAffectingCombat(unit, debugmsg)
	local cached = IWin_CombatVar["affectingCombat"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." is in combat: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitAffectingCombat(unit) and true or false
	IWin_CombatVar["affectingCombat"][unit] = result
	IWin:Debug(unit.." is in combat: "..tostring(result), debugmsg)
	return result
end

function IWin:IsPVP(unit, debugmsg)
	local cached = IWin_Target["pvp"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." is in pvp: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitIsPVP(unit) and true or false
	IWin_Target["pvp"][unit] = result
	IWin:Debug(unit.." is in pvp: "..tostring(result), debugmsg)
	return result
end

function IWin:IsDead(unit, debugmsg)
	local cached = IWin_CombatVar["dead"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." is dead: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitIsDead(unit) and true or false
	IWin_CombatVar["dead"][unit] = result
	IWin:Debug(unit.." is dead: "..tostring(result), debugmsg)
	return result
end

function IWin:IsFriend(unit, unit2, debugmsg)
	local result = UnitIsFriend(unit, unit2) and true or false
	IWin:Debug(unit.." is an ally to "..unit2..": "..tostring(result), debugmsg)
	return result
end

function IWin:GetLevel(unit, debugmsg)
	local cached = IWin_CombatVar["level"][unit]
	if cached ~= nil then
		IWin:Debug(unit.." is level: "..tostring(cached), debugmsg)
		return cached
	end
	local result = UnitLevel(unit)
	IWin_CombatVar["level"][unit] = result
	IWin:Debug(unit.." is level: "..tostring(result), debugmsg)
	return result
end

-- Item #######################################################################################################################################
--helper
function IWin:GetItemID(itemLink)
	for itemID in string.gfind(itemLink, "|c%x+|Hitem:(%d+):%d+:%d+:%d+|h%[(.-)%]|h|r$") do
		return itemID
	end
end

function IWin:IsShieldEquipped(debugmsg)
	local cached = IWin_Inventory["shieldEquipped"]
	if cached ~= nil then
		IWin:Debug("A shield is equipped: "..tostring(cached), debugmsg)
		return cached
	end
	local offHandLink = GetInventoryItemLink("player", 17)
	if offHandLink then
		local _, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(offHandLink)))
		local result = itemSubType == "Shields"
		IWin_Inventory["shieldEquipped"] = result
		IWin:Debug("A shield is equipped: "..tostring(result), debugmsg)
		return result
	end
	IWin_Inventory["shieldEquipped"] = false
	IWin:Debug("A shield is equipped: false", debugmsg)
	return false
end

function IWin:IsItemSubTypeEquipped(subType, debugmsg)
	if IWin_Inventory["itemSubTypeEquipped"] == nil then
		local rangedLink = GetInventoryItemLink("player", 18)
		if rangedLink then
			local _, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(rangedLink)))
			IWin_Inventory["itemSubTypeEquipped"] = itemSubType
		end
	end
	local result = IWin_Inventory["itemSubTypeEquipped"] == subType
	IWin:Debug(subType.." equipped: "..tostring(result), debugmsg)
	return result
end

function IWin:IsDaggerEquipped(debugmsg)
	local cached = IWin_Inventory["daggerEquipped"]
	if cached ~= nil then
		IWin:Debug("A dagger is equipped: "..tostring(cached), debugmsg)
		return cached
	end
	local mainHandLink = GetInventoryItemLink("player", 16)
	if mainHandLink then
		local _, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(mainHandLink)))
		local result = itemSubType == "Daggers"
		IWin_Inventory["daggerEquipped"] = result
		IWin:Debug("A dagger is equipped: "..tostring(result), debugmsg)
		return result
	end
	IWin_Inventory["daggerEquipped"] = false
	IWin:Debug("A dagger is equipped: false", debugmsg)
	return false
end

function IWin:Is2HanderEquipped(debugmsg)
	local cached = IWin_Inventory["2HanderEquipped"]
	if cached ~= nil then
		IWin:Debug("A 2-hander is equipped: "..tostring(cached), debugmsg)
		return cached
	end
	local offHandLink = GetInventoryItemLink("player", 17)
	local result = not offHandLink
	IWin_Inventory["2HanderEquipped"] = result
	IWin:Debug("A 2-hander is equipped: "..tostring(result), debugmsg)
	return result
end

function IWin:IsItemEquipped(slot, name, debugmsg)
	local itemLink = GetInventoryItemLink("player", slot)
	if itemLink then
		local itemName = GetItemInfo(tonumber(IWin:GetItemID(itemLink)))
		local result = itemName == name
		IWin:Debug("Item "..name.." is equipped: "..tostring(result), debugmsg)
		return result
	end
	IWin:Debug("Item "..name.." is equipped: false", debugmsg)
	return false
end

function IWin:IsItemInBag(item, debugmsg)
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemName = GetContainerItemLink(bag, slot)
			if itemName and strfind(itemName,item) then
				IWin:Debug("Item "..item.." is in inventory: true", debugmsg)
				return true
			end
		end
	end
	IWin:Debug("Item "..item.." is in inventory: false", debugmsg)
	return false
end

function IWin:GetItemCountInBag(item, debugmsg)
	local itemCount = 0
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemName = GetContainerItemLink(bag, slot)
			if itemName and strfind(itemName,item) then
				itemCount = itemCount + 1
			end
		end
	end
	IWin:Debug(item.." count in inventory: "..itemCount, debugmsg)
	return itemCount
end

function IWin:IsCDShortOffensiveTarget(melee)
	if melee and (not IWin:IsInRange() or IWin:IsBlacklistCooldownMelee()) then return false end
	if not melee and IWin:IsBlacklistCooldownRanged() then return false end
	local CDShortOffensiveSetting = IWin_Settings["CDShortOffensive"]
	if CDShortOffensiveSetting == "off" then return false end
	if CDShortOffensiveSetting == "boss" and not IWin:IsBoss() then return false end
	if CDShortOffensiveSetting == "elite" and not IWin:IsElite() then return false end
	return true
end

function IWin:IsCDLongOffensiveTarget(melee)
	if melee and (not IWin:IsInRange() or IWin:IsBlacklistCooldownMelee()) then return false end
	if not melee and IWin:IsBlacklistCooldownRanged() then return false end
	local CDLongOffensiveSetting = IWin_Settings["CDLongOffensive"]
	if CDLongOffensiveSetting == "off" then return false end
	if CDLongOffensiveSetting == "boss" and not IWin:IsBoss() then return false end
	if CDLongOffensiveSetting == "elite" and not IWin:IsElite() then return false end
	return true
end

function IWin:IsItemConsumableOffensiveTarget(melee)
	if melee and (not IWin:IsInRange() or IWin:IsBlacklistCooldownMelee()) then return false end
	if not melee and IWin:IsBlacklistCooldownRanged() then return false end
	local consumableOffensiveSetting = IWin_Settings["consumableOffensive"]
	if consumableOffensiveSetting == "off" then return false end
	if consumableOffensiveSetting == "boss" and not IWin:IsBoss() then return false end
	if consumableOffensiveSetting == "elite" and not IWin:IsElite() then return false end
	if IWin:IsTrainingDummy() then return false end
	return true
end

function IWin:IsItemTrinketOffensiveTarget(melee, skipRangeControl)
	if melee and ((not IWin:IsInRange() and not skipRangeControl) or IWin:IsBlacklistCooldownMelee()) then return false end
	if not melee and IWin:IsBlacklistCooldownRanged() then return false end
	local trinketOffensiveSetting = IWin_Settings["trinketOffensive"]
	if trinketOffensiveSetting == "off" then return false end
	if trinketOffensiveSetting == "boss" and not IWin:IsBoss() then return false end
	if trinketOffensiveSetting == "elite" and not IWin:IsElite() then return false end
	return true
end

--helper
function IWin:ParseWeaponSpeedFromText(text)
    if not text then return nil end
    -- Match patterns like "Speed 1.5", "Speed 1.59", "Speed 2"
    --local weaponSpeed = string.match(text, "Speed (%d+%.?%d*)")
    local _, _, weaponSpeed = string.find(text, "Speed (%d+%.?%d*)")
    if weaponSpeed then
        return tonumber(weaponSpeed)
    end
    return nil
end

function IWin:GetWeaponSpeed(debugmsg)
    local cached = IWin_Inventory["weaponSpeed"]
    if cached ~= nil then
        IWin:Debug("Weapon speed: " .. tostring(cached), debugmsg)
        return cached
    end

    local mainHandLink = GetInventoryItemLink("player", 16)
    if not mainHandLink then
        IWin_Inventory["weaponSpeed"] = 2
        IWin:Debug("No weapon. Unarmed speed: 2", debugmsg)
        return 2
    end

    IWin_T:ClearLines()
    IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")
    IWin_T:SetInventoryItem("player", 16)

    for i = 1, IWin_T:NumLines() do
        local left  = _G["IWin_TTextLeft" .. i]
        local right = _G["IWin_TTextRight" .. i]
        if right and right.GetText then
            local text = right:GetText()
            if text then
                local speed = IWin:ParseWeaponSpeedFromText(text)
                if speed then
                    IWin_Inventory["weaponSpeed"] = speed
                    IWin:Debug("Weapon speed: " .. speed, debugmsg)
                    return speed
                end
            end
        end
        if left and left.GetText then
            local text = left:GetText()
            if text then
                local speed = IWin:ParseWeaponSpeedFromText(text)
                if speed then
                    IWin_Inventory["weaponSpeed"] = speed
                    IWin:Debug("Weapon speed: " .. speed, debugmsg)
                    return speed
                end
            end
        end
    end

    IWin_Inventory["weaponSpeed"] = 2
    IWin:Debug("No weapon speed found. Default speed: 2", debugmsg)
    return 2
end

-- Movement #######################################################################################################################################
function IWin:IsMoving(debugmsg)
	local cached = IWin_CombatVar["moving"]
	if cached ~= nil then
		IWin:Debug("Player is moving: "..tostring(cached), debugmsg)
		return cached
	end
	if MonkeySpeed and MonkeySpeed.m_fSpeed and MonkeySpeed.m_fSpeed ~= 0 then
		IWin_CombatVar["moving"] = true
		IWin:Debug("Player is moving: true", debugmsg)
		return true
	end
	IWin_CombatVar["moving"] = false
	IWin:Debug("Player is moving: false", debugmsg)
	return false
end

-- Combo #######################################################################################################################################
function IWin:GetComboPoints(debugmsg)
	local cached = IWin_CombatVar["comboPoints"]
	if cached ~= nil then
		IWin:Debug("Player combo points: "..tostring(cached), debugmsg)
		return cached
	end
	local result = GetComboPoints()
	IWin_CombatVar["comboPoints"] = result
	IWin:Debug("Player combo points: "..tostring(result), debugmsg)
	return result
end

-- Group #######################################################################################################################################
function IWin:GetGroupSize(debugmsg)
	local cached = IWin_CombatVar["groupSize"]
	if cached ~= nil then
		IWin:Debug("Group size: "..tostring(cached), debugmsg)
		return cached
	end
	local result = math.max(1, GetNumPartyMembers() + 1, GetNumRaidMembers())
	IWin_CombatVar["groupSize"] = result
	IWin:Debug("Group size: "..tostring(result), debugmsg)
	return result
end

-- System #######################################################################################################################################
function IWin:GetTime(debugmsg)
	local cached = IWin_CombatVar["time"]
	if cached ~= nil then
		IWin:Debug("Current time: "..tostring(cached), debugmsg)
		return cached
	end
	local result = GetTime()
	IWin_CombatVar["time"] = result
	IWin:Debug("Current time: "..tostring(result), debugmsg)
	return result
end