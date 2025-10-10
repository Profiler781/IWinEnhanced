--[[
#########################################
# IWinEnhanced Discord Agamemnoth#5566  #
################ Enhance ################
#  IWin by Atreyyo @ VanillaGaming.org  #
#########################################
]]--

---- For Warriors ----
if UnitClass("player") ~= "Warrior" then return end

---- Loading ----
IWin = CreateFrame("frame",nil,UIParent)
IWin.t = CreateFrame("GameTooltip", "IWin_T", UIParent, "GameTooltipTemplate")
IWin_CombatVar = {
	["gcd"] = 0,
	["dodge"] = 0,
	["reservedRage"] = 0,
	["reservedRageStance"] = nil,
	["reservedRageStanceLast"] = 0,
	["charge"] = 0,
	["queueGCD"] = true,
	["slamQueued"] = false,
	["swingAttackQueued"] = false,
}
local Cast = CastSpellByName
IWin_PartySize = {
	["raid"] = 40,
	["group"] = 5,
	["solo"] = 1,
	["off"] = 0,
}
local GCD = 1.5

---- Event Register ----
IWin:RegisterEvent("ACTIONBAR_UPDATE_STATE")
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
IWin:RegisterEvent("ADDON_LOADED")
IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced system loaded.|r")
		if IWin_Settings == nil then IWin_Settings = {} end
		if IWin_Settings["rageTimeToReserveBuffer"] == nil then IWin_Settings["rageTimeToReserveBuffer"] = 1.5 end
		if IWin_Settings["ragePerSecondPrediction"] == nil then IWin_Settings["ragePerSecondPrediction"] = 10 end
		if IWin_Settings["outOfRaidCombatLength"] == nil then IWin_Settings["outOfRaidCombatLength"] = 25 end
		if IWin_Settings["playerToNPCHealthRatio"] == nil then IWin_Settings["playerToNPCHealthRatio"] = 0.75 end
		if IWin_Settings["charge"] == nil then IWin_Settings["charge"] = "solo" end
		if IWin_Settings["sunder"] == nil then IWin_Settings["sunder"] = "high" end
		if IWin_Settings["demo"] == nil then IWin_Settings["demo"] = "off" end
		if IWin_Settings["dtBattle"] == nil then IWin_Settings["dtBattle"] = true end
		if IWin_Settings["dtDefensive"] == nil then IWin_Settings["dtDefensive"] = true end
		if IWin_Settings["dtBerserker"] == nil then IWin_Settings["dtBerserker"] = false end
		if IWin_Settings["jousting"] == nil then IWin_Settings["jousting"] = "off" end
		IWin.hasSuperwow = SetAutoloot and true or false
		IWin:UnregisterEvent("ADDON_LOADED")
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1,"dodge") then
			IWin_CombatVar["dodge"] = GetTime()
		end
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string.find(arg1,"dodged") then
			IWin_CombatVar["dodge"] = GetTime()
		end
	elseif event == "ACTIONBAR_UPDATE_STATE" and arg1 == nil then
		IWin_CombatVar["gcd"] = GetTime()
	end
end)

---- Spell data ----
IWin_ExecuteCostReduction = {
	[0] = 0,
	[1] = 2,
	[2] = 5,
}

IWin_BloodrageCostReduction = {
	[0] = 0,
	[1] = 2,
	[2] = 5,
}

IWin_ThunderClapCostReduction = {
	[0] = 0,
	[1] = 1,
	[2] = 2,
	[3] = 4,
}

function IWin:GetTalentRank(tabIndex, talentIndex)
	local _, _, _, _, currentRank = GetTalentInfo(tabIndex, talentIndex)
	return currentRank
end

function IWin:GetExecuteCostReduction()
	local executeRank = IWin:GetTalentRank(2, 13)
	return IWin_ExecuteCostReduction[executeRank]
end

function IWin:GetBloodrageCostReduction()
	local bloodrageRank = IWin:GetTalentRank(3, 1)
	return IWin_BloodrageCostReduction[bloodrageRank]
end

function IWin:GetThunderClapCostReduction()
	local thunderClapRank = IWin:GetTalentRank(1, 6)
	return IWin_ThunderClapCostReduction[thunderClapRank]
end

IWin_RageCost = {
	["Battle Shout"] = 10,
	["Berserker Rage"] = 0 - IWin:GetTalentRank(2, 14) * 5,
	["Bloodrage"] = - 10 - IWin:GetBloodrageCostReduction(),
	["Bloodthirst"] = 30,
	["Charge"] = - 12 - IWin:GetTalentRank(1, 4) * 5,
	["Cleave"] = 20,
	["Concussion Blow"] = - 10,
	["Demoralizing Shout"] = 10,
	["Disarm"] = 20,
	["Execute"] = 15 - IWin:GetExecuteCostReduction(),
	["Hamstring"] = 10,
	["Heroic Strike"] = 15 - IWin:GetTalentRank(1, 1),
	["Intercept"] = 10,
	["Master Strike"] = 20,
	["Mocking Blow"] = 10,
	["Mortal Strike"] = 30,
	["Overpower"] = 5,
	["Piercing Howl"] = 10,
	["Pummel"] = 10,
	["Rend"] = 10,
	["Revenge"] = 5,
	["Shield Bash"] = 10,
	["Shield Block"] = 10,
	["Shield Slam"] = 20,
	["Slam"] = 15,
	["Sunder Armor"] = 15,
	["Sweeping Strikes"] = 30,
	["Thunder Clap"] = 20 - IWin:GetThunderClapCostReduction(),
	["Whirlwind"] = 25,
}

IWin_Taunt = {
	"Taunt",
	"Mocking Blow",
	"Challenging Shout",
	"Growl",
	"Challenging Roar",
	"Hand of Reckoning",
}

---- Functions ----
function IWin:GetBuffIndex(unit, spell)
	if unit == "player" then
		if not IWin.hasSuperwow then
	    	DEFAULT_CHAT_FRAME:AddMessage("|cFF00FFFFbalakethelock's SuperWoW|r required:")
	        DEFAULT_CHAT_FRAME:AddMessage("https://github.com/balakethelock/SuperWoW")
	    	return 0
		end
	    local index = 0
	    while true do
	        spellID = GetPlayerBuffID(index)
	        if not spellID then break end
	        if spell == SpellInfo(spellID) then
	        	return index
	        end
	        index = index + 1
	    end
	else
		local index = 1
		while UnitBuff(unit, index) do
			IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")
			IWin_T:ClearLines()
			IWin_T:SetUnitBuff(unit, index)
			local buffName = IWin_TTextLeft1:GetText()
			if buffName == spell then
				return index
			end
			index = index + 1
		end
	end
	return nil
end

function IWin:GetDebuffIndex(unit, spell)
	index = 1
	while UnitDebuff(unit, index) do
		IWin_T:SetOwner(WorldFrame, "ANCHOR_NONE")
		IWin_T:ClearLines()
		IWin_T:SetUnitDebuff(unit, index)
		local buffName = IWin_TTextLeft1:GetText()
		if buffName == spell then 
			return index
		end
		index = index + 1
	end	
	return nil
end

function IWin:GetBuffStack(unit, spell)
	local index = IWin:GetBuffIndex(unit, spell)
	if index then
		local _, stack = UnitBuff(unit, index)
		return stack
	end
	local index = IWin:GetDebuffIndex(unit, spell)
	if index then
		local _, stack = UnitDebuff(unit, index)
		return stack
	end
	return 0
end

function IWin:IsBuffStack(unit, spell, stack)
	return IWin:GetBuffStack(unit, spell) == stack
end

function IWin:IsBuffActive(unit, spell)
	return IWin:GetBuffRemaining(unit, spell) ~= 0
end

function IWin:GetBuffRemaining(unit, spell)
	if unit == "player" then
		local index = IWin:GetBuffIndex(unit, spell)
		if index then
			return GetPlayerBuffTimeLeft(index)
		end
		local index = IWin:GetDebuffIndex(unit, spell)
		if index then
			return GetPlayerBuffTimeLeft(index)
		end
	elseif unit == "target" then
		local libdebuff = pfUI and pfUI.api and pfUI.api.libdebuff or ShaguTweaks and ShaguTweaks.libdebuff
		if not libdebuff then
	    	DEFAULT_CHAT_FRAME:AddMessage("Either pfUI or ShaguTweaks required")
	    	return 0
		end
		local index = IWin:GetDebuffIndex(unit, spell)
		if index then
			local _, _, _, _, _, _, timeleft = libdebuff:UnitDebuff("target", index)
			return timeleft
		end
	end
	return 0
end

function IWin:GetCooldownRemaining(spell)
	local spellID = 1
	local bookspell = GetSpellName(spellID, "BOOKTYPE_SPELL")
	while bookspell do	
		if spell == bookspell then
			local start, duration = GetSpellCooldown(spellID, "BOOKTYPE_SPELL")
			if start ~= 0 and duration ~= GCD then
				return duration - (GetTime() - start)
			else
				return 0
			end
		end
		spellID = spellID + 1
		bookspell = GetSpellName(spellID, "BOOKTYPE_SPELL")
	end
	return false
end

function IWin:IsOnCooldown(spell)
	return IWin:GetCooldownRemaining(spell) ~= 0
end

function IWin:IsSpellLearnt(spell)
	local spellID = 1
	local bookspell = GetSpellName(spellID, "BOOKTYPE_SPELL")
	while bookspell do
		if bookspell == spell then
			return true
		end
		spellID = spellID + 1
		bookspell = GetSpellName(spellID, "BOOKTYPE_SPELL")
	end
	return false
end

function IWin:IsGCDActive()
	return GetTime() - IWin_CombatVar["gcd"] < 1.5
end

function IWin:IsOverpowerAvailable()
	local overpowerTimeActive = GetTime() - IWin_CombatVar["dodge"]
	local gcdRemaining = math.min(0, GCD - (GetTime() - IWin_CombatVar["gcd"]))
 	return overpowerTimeActive < 5 - gcdRemaining
 end

function IWin:IsCharging()
	local chargeTimeActive = GetTime() - IWin_CombatVar["charge"]
	return chargeTimeActive < 1
end

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

function IWin:GetTimeToDie()
	local ttd = 0
	if UnitInRaid("player") or UnitIsPVP("target") then
		ttd = 999
	elseif GetNumPartyMembers() ~= 0 then
		ttd = UnitHealth("target") / UnitHealthMax("player") * IWin_Settings["playerToNPCHealthRatio"] * IWin_Settings["outOfRaidCombatLength"] / GetNumPartyMembers() * 2
	else
		ttd = UnitHealth("target") / UnitHealthMax("player") * IWin_Settings["playerToNPCHealthRatio"] * IWin_Settings["outOfRaidCombatLength"]
	end
	return ttd
end

function IWin:GetHealthPercent(unit)
	return UnitHealth(unit) / UnitHealthMax(unit) * 100
end

function IWin:IsExecutePhase()
	return IWin:GetHealthPercent("target") <= 20
end

function IWin:IsRageAvailable(spell)
	local rageRequired = IWin_RageCost[spell] + IWin_CombatVar["reservedRage"]
	return UnitMana("player") >= rageRequired
end

function IWin:IsRageCostAvailable(spell)
	return UnitMana("player") >= IWin_RageCost[spell]
end

function IWin:IsInRange(spell, distance)
	if not IsSpellInRange
		or not spell
		or not IWin:IsSpellLearnt(spell) then
			if distance == "ranged" then
				return not (CheckInteractDistance("target", 3) ~= nil)
			else
        		return CheckInteractDistance("target", 3) ~= nil
        	end
	else
		return IsSpellInRange(spell, "target") == 1
	end
end

function IWin:GetStanceSwapRageRetain()
	return math.min(IWin:GetTalentRank(1, 2) * 5, UnitMana("player"))
end

function IWin:IsStanceSwapMaxRageLoss(rage)
	return rage >= math.max(0, UnitMana("player") - IWin:GetStanceSwapRageRetain() + IWin_CombatVar["reservedRage"])
end

function IWin:GetRageToReserve(spell, trigger, unit)
	local spellTriggerTime = 0
	if trigger == "nocooldown" then
		return IWin_RageCost[spell]
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
		return math.max(0, IWin_RageCost[spell] - IWin_Settings["ragePerSecondPrediction"] * timeToReserveRage)
	end
	return 0
end

function IWin:IsTimeToReserveRage(spell, trigger, unit)
	return IWin:GetRageToReserve(spell, trigger, unit) ~= 0
end

function IWin:SetReservedRage(spell, trigger, unit)
	IWin_CombatVar["reservedRage"] = IWin_CombatVar["reservedRage"] + IWin:GetRageToReserve(spell, trigger, unit)
end

function IWin:IsTanking()
	return UnitIsUnit("targettarget", "player")
end

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

function IWin:Is2HanderEquipped()
	local offHandLink = GetInventoryItemLink("player", 17)
	return not offHandLink
end

IWin_UnitClassification = {
	["worldboss"] = true,
	["rareelite"] = true,
	["elite"] = true,
	["rare"] = false,
	["normal"] = false,
	["trivial"] = false,
}

function IWin:IsElite()
	local classification = UnitClassification("target")
	return IWin_UnitClassification[classification]
end

function IWin:IsReservedRageStance(stance)
	if IWin_CombatVar["reservedRageStance"] then
		return IWin_CombatVar["reservedRageStance"] == stance
	end
	return true
end

function IWin:SetReservedRageStance(stance)
	if IWin_CombatVar["reservedRageStanceLast"] + GCD < GetTime() then
		IWin_CombatVar["reservedRageStance"] = stance
	end
end

function IWin:SetReservedRageStanceCast()
	IWin_CombatVar["reservedRageStanceLast"] = GetTime()
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

function IWin:IsDefensiveTacticsActive(stance)
	local dtStance = stance or IWin:GetStance()
	if IWin:GetTalentRank(3, 18) ~= 0
		and IWin:IsShieldEquipped()
		and (
				(
					IWin_Settings["dtBattle"]
					and dtStance == "Battle Stance"
				) or (
					IWin_Settings["dtDefensive"]
					and dtStance == "Defensive Stance"
					and IWin:IsSpellLearnt("Defensive Stance")
				) or (
					IWin_Settings["dtBerserker"]
					and dtStance == "Berserker Stance"
					and IWin:IsSpellLearnt("Berserker Stance")
				)
			) then
			return true
	else
		return false
	end
end

function IWin:IsHighAP()
	local APbase, APpos, APneg = UnitAttackPower("player")
	return (APbase + APpos - APneg) * 0.35 + 200 > 600 + 20 * 15
end

IWin_BlacklistFear = {
	"Magmadar",
	"Onyxia",
	"Nefarian",
}

function IWin:IsBlacklistFear()
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

IWin_BlacklistDemoralizingShout = {
	"Vek'lor",
	"Vek'nilash",
}

function IWin:IsBlacklistDemoralizingShout()
	if not UnitExists("target") then
		return true
	end
	local name = UnitName("target")
	for unit in IWin_BlacklistDemoralizingShout do
		if IWin_BlacklistDemoralizingShout[unit] == name then
			return true
		end
	end
	return false
end

---- General Actions ----
function IWin:TargetEnemy()
	if not UnitExists("target") or UnitIsDead("target") or UnitIsFriend("target", "player") then
		TargetNearestEnemy()
	end
end

function IWin:StartAttack()
	if IWin_CombatVar["swingAttackQueued"] then return end
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

function IWin:MarkSkull()
	if GetRaidTargetIndex("target") ~= 8
		and not UnitIsFriend("player", "target")
		and not UnitInRaid("player")
		and GetNumPartyMembers() ~= 0 then
			SetRaidTarget("target", 8)
	end
end

function IWin:InitializeRotation()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["queueGCD"] = true
	IWin_CombatVar["slamQueued"] = false
	IWin_CombatVar["swingAttackQueued"] = false
	if IWin_CombatVar["reservedRageStanceLast"] + GCD < GetTime() then
		IWin_CombatVar["reservedRageStance"] = nil
	end
end

function IWin:Perception()
	if IWin:IsSpellLearnt("Perception")
		and not IWin:IsOnCooldown("Perception")
		and IWin_CombatVar["queueGCD"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Perception")
	end
end

---- Class Actions ----
function IWin:BattleShout()
	if IWin:IsSpellLearnt("Battle Shout")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsBuffActive("player","Battle Shout")
		and IWin:IsRageAvailable("Battle Shout")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Battle Shout")
	end
end

function IWin:BattleShoutRefresh()
	if IWin:IsSpellLearnt("Battle Shout")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetBuffRemaining("player","Battle Shout") < 9
		and IWin:IsRageAvailable("Battle Shout")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Battle Shout")
	end
end

function IWin:BattleShoutRefreshOOC()
	if IWin:IsSpellLearnt("Battle Shout")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetBuffRemaining("player","Battle Shout") < 30
		and IWin:IsRageAvailable("Battle Shout")
		and UnitMana("player") > 60
		and not UnitAffectingCombat("player")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Battle Shout")
	end
end

function IWin:BerserkerRage()
	if IWin:IsSpellLearnt("Berserker Rage")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsStanceActive("Berserker Stance")
		and not IWin:IsBlacklistFear()
		and not IWin:IsOnCooldown("Berserker Rage")
		and UnitAffectingCombat("player")
		and (
				IWin:IsTanking()
				or IWin:GetTalentRank(2, 14) ~= 0
			)
		and not IWin_CombatVar["slamQueued"] then
				IWin_CombatVar["queueGCD"] = false
				Cast("Berserker Rage")
	end
end

function IWin:BerserkerRageImmune()
	if IWin:IsSpellLearnt("Berserker Rage")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Berserker Rage")
		and not IWin_CombatVar["slamQueued"] then
			if not IWin:IsStanceActive("Berserker Stance") then
				Cast("Berserker Stance")
			else
				IWin_CombatVar["queueGCD"] = false
				Cast("Berserker Rage")
			end
	end
end

function IWin:Bloodrage()
	if IWin:IsSpellLearnt("Bloodrage")
		and UnitMana("player") < 70
		and IWin:GetHealthPercent("player") > 25
		and not IWin:IsBuffActive("player","Enrage")
		and not IWin:IsOnCooldown("Bloodrage")
		and (
				IWin:IsStanceActive("Defensive Stance")
				or (
					UnitAffectingCombat("player")
					and (
							IWin:IsSpellLearnt("Mortal Strike")
							or IWin:IsSpellLearnt("Bloodthirst")
							or IWin:IsSpellLearnt("Shield Slam")
							or IWin:GetTalentRank(2, 9) ~= 0
						)
					)
			) then
		Cast("Bloodrage")
	end
end

function IWin:Bloodthirst(queueTime)
	if IWin:IsSpellLearnt("Bloodthirst")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetCooldownRemaining("Bloodthirst") < queueTime
		and IWin:IsRageAvailable("Bloodthirst")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Bloodthirst")
	end
end

function IWin:SetReservedRageBloodthirst()
	if not IWin:IsHighAP() then 
		IWin:SetReservedRage("Bloodthirst", "cooldown")
	end
end

function IWin:BloodthirstHighAP(queueTime)
	if IWin:IsSpellLearnt("Bloodthirst")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetCooldownRemaining("Bloodthirst") < queueTime
		and IWin:IsRageAvailable("Bloodthirst")
		and UnitMana("player") < 60
		and IWin:IsHighAP()
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Bloodthirst")
	end
end

function IWin:SetReservedRageBloodthirstHighAP()
	if IWin:IsHighAP() then 
		IWin:SetReservedRage("Bloodthirst", "cooldown")
	end
end

function IWin:Charge()
	if IWin:IsSpellLearnt("Charge")
		and not IWin:IsOnCooldown("Charge")
		and IWin:IsInRange("Charge","ranged")
		and not UnitAffectingCombat("player") then
			if not IWin:IsStanceActive("Battle Stance")
				and (
						IWin:IsStanceSwapMaxRageLoss(25)
						or UnitIsPVP("target")
					) then
					Cast("Battle Stance")
			end
			if IWin:IsStanceActive("Battle Stance") then
				IWin_CombatVar["queueGCD"] = false
				Cast("Charge")
				IWin_CombatVar["charge"] = GetTime()
			end
	end
end

function IWin:ChargePartySize()
	local partySize = IWin_Settings["charge"]
	if (
			UnitInRaid("player")
			and IWin_PartySize[partySize] == 40
		) or (
			GetNumPartyMembers() ~= 0
			and IWin_PartySize[partySize] >= 5
		) or (
			GetNumPartyMembers() == 0
			and IWin_PartySize[partySize] >= 1
		) then
			IWin:Charge()
	end
end

function IWin:Cleave()
	if IWin:IsSpellLearnt("Cleave") then
		if IWin:IsRageAvailable("Cleave") then
			IWin_CombatVar["swingAttackQueued"] = true
			Cast("Cleave")
		else
			--SpellStopCasting()
		end
	end
end

function IWin:CleaveStance()
	if IWin:IsStanceActive("Defensive Stance") then
		if not IWin:IsSpellLearnt("Sweeping Strikes")
			and IWin:IsSpellLearnt("Berserker Stance") then
				Cast("Berserker Stance")
		elseif IWin:IsSpellLearnt("Battle Stance") then
			Cast("Battle Stance")
		end
	end
end

function IWin:ConcussionBlow()
	if IWin:IsSpellLearnt("Concussion Blow")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Concussion Blow")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Concussion Blow")
	end
end

function IWin:DemoralizingShout()
	if IWin:IsSpellLearnt("Demoralizing Shout")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Demoralizing Shout")
		and not IWin:IsBlacklistDemoralizingShout()
		and IWin_Settings["demo"] == "on"
		and IWin:IsInRange("Intimidating Shout")
		and not IWin:IsBuffActive("target", "Demoralizing Shout")
		and IWin:GetTimeToDie() > 10
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Demoralizing Shout")
	end
end

function IWin:SetReservedRageDemoralizingShout()
	if not IWin:IsBlacklistDemoralizingShout()
		and IWin_Settings["demo"] == "on"
		and not IWin:IsBuffActive("target", "Demoralizing Shout")
		and IWin:GetTimeToDie() > 10 then
			IWin:SetReservedRage("Demoralizing Shout", "debuff", "target")
	end
end

function IWin:DPSStance()
	if IWin:IsStanceActive("Defensive Stance") then
		if IWin:IsSpellLearnt("Berserker Stance") then
			Cast("Berserker Stance")
		else
			Cast("Battle Stance")
		end
	end
end

function IWin:DPSStanceDefault()
	if IWin:IsSpellLearnt("Berserker Stance")
		and IWin:IsReservedRageStance("Berserker Stance")
		and UnitAffectingCombat("player") then
			IWin:SetReservedRageStance("Berserker Stance")
			if not IWin:IsStanceActive("Berserker Stance") then
				IWin:SetReservedRageStanceCast()
				Cast("Berserker Stance")
			end
	elseif IWin:IsSpellLearnt("Battle Stance")
		and IWin:IsInRange("Rend")
		and IWin:IsReservedRageStance("Battle Stance") then
			IWin:SetReservedRageStance("Battle Stance")
			if not IWin:IsStanceActive("Battle Stance") then
				IWin:SetReservedRageStanceCast()
				Cast("Battle Stance")
			end
	end
end

function IWin:Execute()
	if IWin:IsSpellLearnt("Execute")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsExecutePhase()
		and IWin:IsRageAvailable("Execute")
		and (
				UnitIsPVP("target")
				or IWin:IsElite()
				or IWin:GetHealthPercent("player") < 40
				or UnitInRaid("player")
				or UnitMana("player") < 40
			)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Defensive Stance") then
				Cast("Battle Stance")
			else
				IWin_CombatVar["queueGCD"] = false
				Cast("Execute")
			end
	end
end

function IWin:SetReservedRageExecute()
	local lowHealthTarget = (UnitHealthMax("player") * 0.3 > UnitHealth("target"))
	if (
			lowHealthTarget
			or IWin:IsExecutePhase()
		)
		and (
				UnitIsPVP("target")
				or IWin:IsElite()
				or IWin:GetHealthPercent("player") < 40
				or UnitInRaid("player")
				or UnitMana("player") < 40
			) then 
			IWin:SetReservedRage("Execute", "cooldown")
	end
end

function IWin:ExecuteAOE()
	if IWin:IsSpellLearnt("Execute")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsExecutePhase()
		and IWin:IsRageAvailable("Execute")
		and (
				UnitIsPVP("target")
				or IWin:GetHealthPercent("player") < 40
				or UnitMana("player") < 30
			)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Defensive Stance") then
				Cast("Battle Stance")
			else
				IWin_CombatVar["queueGCD"] = false
				Cast("Execute")
			end
	end
end

function IWin:SetReservedRageExecuteAOE()
	local lowHealthTarget = (UnitHealthMax("player") * 0.3 > UnitHealth("target"))
	if (
			lowHealthTarget
			or IWin:IsExecutePhase()
		)
		and (
				UnitIsPVP("target")
				or IWin:GetHealthPercent("player") < 40
				or UnitMana("player") < 30
			) then 
			IWin:SetReservedRage("Execute", "cooldown")
	end
end

function IWin:ExecuteDefensiveTactics()
	if IWin:IsSpellLearnt("Execute")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsExecutePhase()
		and IWin:IsRageAvailable("Execute")
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Defensive Stance")
				and IWin:IsDefensiveTacticsActive("Battle Stance")
				and not IWin:IsDefensiveTacticsActive() then
					Cast("Battle Stance")
			elseif IWin:IsStanceActive("Defensive Stance")
				and IWin:IsDefensiveTacticsActive("Berserker Stance")
				and not IWin:IsDefensiveTacticsActive() then
					Cast("Berserker Stance")
			end
			if IWin:IsStanceActive("Battle Stance")
				or IWin:IsStanceActive("Berserker Stance") then
					IWin_CombatVar["queueGCD"] = false
					Cast("Execute")
			end
	end
end

function IWin:SetReservedRageExecuteDefensiveTactics()
	local lowHealthTarget = (UnitHealthMax("player") * 0.3 > UnitHealth("target"))
	if (
			lowHealthTarget
			or IWin:IsExecutePhase()
		)
		and (
				IWin:IsDefensiveTacticsActive("Battle Stance")
				or IWin:IsDefensiveTacticsActive("Berserker Stance")
			) then 
			IWin:SetReservedRage("Execute", "cooldown")
	end
end

function IWin:Hamstring()
	if IWin:IsSpellLearnt("Hamstring")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Hamstring")
		and IWin:IsInRange("Hamstring")
		and IWin:IsRageCostAvailable("Hamstring")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Hamstring")
	end
end

function IWin:HamstringJousting()
	if IWin:IsSpellLearnt("Hamstring")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Hamstring")
		and IWin:IsInRange("Hamstring")
		and IWin:IsRageCostAvailable("Hamstring")
		and GetNumPartyMembers() == 0
		and IWin_Settings["jousting"] == "on"
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Hamstring")
	end
end

function IWin:HeroicStrike()
	if IWin:IsSpellLearnt("Heroic Strike") then
		if IWin:IsRageAvailable("Heroic Strike") then
			IWin_CombatVar["swingAttackQueued"] = true
			Cast("Heroic Strike")
		else
			--SpellStopCasting()
		end
	end
end

function IWin:Intercept()
	if IWin:IsSpellLearnt("Intercept")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Intercept")
		and IWin:IsInRange("Intercept","ranged")
		and not IWin:IsCharging()
		and (
				(
					not UnitAffectingCombat("player")
					and IWin:IsOnCooldown("Charge")
				)
				or UnitAffectingCombat("player")
				or (
						IWin:IsStanceActive("Berserker Stance")
						and not IWin:IsStanceSwapMaxRageLoss(25)
						and not UnitIsPVP("target")
					)
			)
		and (
				(
					IWin:IsRageCostAvailable("Intercept")
					and (
							IWin:IsStanceActive("Berserker Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost["Intercept"]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and not IWin_CombatVar["slamQueued"] then
			if not IWin:IsStanceActive("Berserker Stance") then
				Cast("Berserker Stance")
			end
			if not IWin:IsRageCostAvailable("Intercept") then
				Cast("Bloodrage")
			end
			if IWin:IsStanceActive("Berserker Stance") then
				IWin_CombatVar["queueGCD"] = false
				Cast("Intercept")
			end
	end
end

function IWin:InterceptPartySize()
	local partySize = IWin_Settings["charge"]
	if (
			UnitInRaid("player")
			and IWin_PartySize[partySize] == 40
		) or (
			GetNumPartyMembers() ~= 0
			and IWin_PartySize[partySize] >= 5
		) or (
			GetNumPartyMembers() == 0
			and IWin_PartySize[partySize] >= 1
		) then
			IWin:Intercept()
	end
end

function IWin:MasterStrike()
	if IWin:IsSpellLearnt("Master Strike")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Master Strike")
		and IWin:IsRageAvailable("Master Strike")
		and (
				IWin:IsTanking()
				or UnitIsPVP("target")
			)
		and not IWin_CombatVar["slamQueued"] then
				IWin_CombatVar["queueGCD"] = false
				Cast("Master Strike")
	end
end

function IWin:SetReservedRageMasterStrike()
	if IWin:IsTanking()
		or UnitIsPVP("target") then
			IWin:SetReservedRage("Master Strike", "cooldown")
	end
end

function IWin:MockingBlow()
	if IWin:IsSpellLearnt("Mocking Blow")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsTanking()
		and IWin:IsOnCooldown("Taunt")
		and not IWin:IsOnCooldown("Mocking Blow")
		and not IWin:IsTaunted() then
			if not IWin:IsStanceActive("Battle Stance") then
				Cast("Battle Stance")
			else
				IWin_CombatVar["queueGCD"] = false
				Cast("Mocking Blow")
			end
	end
end

function IWin:MortalStrike(queueTime)
	if IWin:IsSpellLearnt("Mortal Strike")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetCooldownRemaining("Mortal Strike") < queueTime
		and IWin:IsRageAvailable("Mortal Strike")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Mortal Strike")
	end
end

function IWin:Overpower()
	if IWin:IsSpellLearnt("Overpower")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsOverpowerAvailable()
		and not IWin:IsOnCooldown("Overpower")
		and (
				IWin:IsRageAvailable("Overpower")
				or IWin:IsStanceActive("Battle Stance")
			)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsReservedRageStance("Battle Stance")
				and (
						(
							IWin:IsStanceSwapMaxRageLoss(25)
							and IWin:GetStanceSwapRageRetain() >= IWin_RageCost["Overpower"]
						)
						or UnitIsPVP("target")
						or IWin:IsStanceActive("Battle Stance")
					) then
						IWin:SetReservedRageStance("Battle Stance")
						if not IWin:IsStanceActive("Battle Stance") then
							IWin:SetReservedRageStanceCast()
							Cast("Battle Stance")
						end
			end
			if IWin:IsStanceActive("Battle Stance") then
				IWin_CombatVar["queueGCD"] = false
				Cast("Overpower")
			end
	end
end

function IWin:OverpowerDefensiveTactics()
	if IWin:IsSpellLearnt("Overpower")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsOverpowerAvailable()
		and not IWin:IsOnCooldown("Overpower")
		and (
				IWin:IsRageAvailable("Overpower")
				or IWin:IsStanceActive("Battle Stance")
			)
		and IWin:IsReservedRageStance("Battle Stance")
		and not IWin_CombatVar["slamQueued"] then
			IWin:SetReservedRageStance("Battle Stance")
			if not IWin:IsStanceActive("Battle Stance")
				and IWin:IsDefensiveTacticsActive("Battle Stance")
				and not IWin:IsDefensiveTacticsActive()
				and (
						IWin:IsStanceSwapMaxRageLoss(25)
						or UnitIsPVP("target")
					) then
						IWin:SetReservedRageStanceCast()
						Cast("Battle Stance")
			end
			if IWin:IsStanceActive("Battle Stance") then
				IWin_CombatVar["queueGCD"] = false
				Cast("Overpower")
			end
	end
end

function IWin:PiercingHowl()
	if IWin:IsSpellLearnt("Piercing Howl")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsInRange("Intimidating Shout")
		and IWin:IsRageCostAvailable("Piercing Howl") then
			IWin_CombatVar["queueGCD"] = false
			Cast("Piercing Howl")
	end
end

function IWin:Pummel()
	if IWin:IsSpellLearnt("Pummel")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Pummel")
		and (
				(
					IWin:IsRageCostAvailable("Pummel")
					and (
							IWin:IsStanceActive("Berserker Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost["Pummel"]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and (
				not IWin:IsShieldEquipped()
				or not IWin:IsStanceActive("Defensive Stance")
			) then
				if IWin:IsStanceActive("Defensive Stance") then
					Cast("Battle Stance")
				else
					if not IWin:IsRageCostAvailable("Pummel") then
						Cast("Bloodrage")
					end
					IWin_CombatVar["queueGCD"] = false
					Cast("Pummel")
				end
	end
end

function IWin:Rend()
	if IWin:IsSpellLearnt("Rend")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Rend")
		and IWin:GetTimeToDie() > 9
		and not UnitInRaid("player")
		and not IWin:IsBuffActive("target","Rend")
		and not (
					UnitCreatureType("target") == "Undead"
					or UnitCreatureType("target") == "Mechanical"
					or UnitCreatureType("target") == "Elemental"
				)
		and not IWin:IsStanceActive("Berserker Stance")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Rend")
	end
end

function IWin:Revenge()
	if IWin:IsSpellLearnt("Revenge")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Revenge")
		and IWin:IsRageCostAvailable("Revenge")
		and not IWin_CombatVar["slamQueued"] then
			if not IWin:IsStanceActive("Defensive Stance")
				and (
						(
							IWin:IsDefensiveTacticsActive("Defensive Stance")
							and not IWin:IsDefensiveTacticsActive("Battle Stance")
						)
						or IWin:GetTalentRank(3, 18) == 0
					) then
				Cast("Defensive Stance")
			end
			if IWin:IsStanceActive("Defensive Stance") then
				Cast("Revenge")
			end
	end
end

function IWin:SetReservedRageRevenge()
	if IWin:IsTanking() then
		IWin:SetReservedRage("Revenge", "cooldown")
	end
end

function IWin:ShieldBash()
	if IWin:IsSpellLearnt("Shield Bash")
		and IWin_CombatVar["queueGCD"]
		and not IWin:IsOnCooldown("Shield Bash")
		and IWin:IsShieldEquipped() 
		and (
				(
					IWin:IsRageCostAvailable("Shield Bash")
					and (
							not IWin:IsStanceActive("Berserker Stance")
							or IWin:GetStanceSwapRageRetain() >= IWin_RageCost["Shield Bash"]
						)
				)
				or not IWin:IsOnCooldown("Bloodrage")
			)
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Berserker Stance") then
				Cast("Defensive Stance")
			else
				if not IWin:IsRageCostAvailable("Shield Bash") then
					Cast("Bloodrage")
				end
				IWin_CombatVar["queueGCD"] = false
				Cast("Shield Bash")
			end
	end
end

function IWin:ShieldSlam(queueTime)
	if IWin:IsSpellLearnt("Shield Slam")
		and IWin_CombatVar["queueGCD"]
		and IWin:GetCooldownRemaining("Shield Slam") < queueTime
		and IWin:IsRageAvailable("Shield Slam")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Shield Slam")
	end
end

function IWin:Shoot()
	local rangedLink = GetInventoryItemLink("player", 18)
	local itemSubType = nil
	if rangedLink then
		_, _, _, _, _, itemSubType = GetItemInfo(tonumber(IWin:GetItemID(rangedLink)))
	end
	if itemSubType == "Bows" then
		Cast("Shoot Bow")
	elseif itemSubType == "Guns" then
		Cast("Shoot Gun")
	elseif itemSubType == "Crossbows" then
		Cast("Shoot Crossbow")
	elseif itemSubType == "Thrown" then
		Cast("Throw")
	end
end

function IWin:Slam()
	if IWin:IsSpellLearnt("Slam")
		and IWin_CombatVar["queueGCD"]
		and IWin_CombatVar["reservedRageStanceLast"] + 0.2 < GetTime()
		and IWin:IsRageAvailable("Slam")
		and IWin:Is2HanderEquipped()
		and (
				not st_timer
				or st_timer > UnitAttackSpeed("player") * 0.9
				or st_timer > IWin:GetSlamCastSpeed()
			) then
			IWin_CombatVar["queueGCD"] = false
			Cast("Slam")
	end
end

function IWin:GetSlamCastSpeed()
	local slamCastSpeed = (2.5 - IWin:GetTalentRank(1, 16) * 0.25) / (1 + IWin:GetTalentRank(2, 15) * 0.06)
	return slamCastSpeed
end

function IWin:SetSlamQueued()
	if not st_timer then return end
	local nextSwing = st_timer + UnitAttackSpeed("player")
	local nextSlam = GCD + IWin:GetSlamCastSpeed()
	if IWin:IsSpellLearnt("Slam")
		and IWin:Is2HanderEquipped()
		and nextSlam > nextSwing then
			IWin_CombatVar["slamQueued"] = true
	end
end

function IWin:SetReservedRageSlam()
	if IWin:Is2HanderEquipped() then
		IWin:SetReservedRage("Slam", "nocooldown")
	end
end

function IWin:SunderArmor()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Sunder Armor")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorFirstStack()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageCostAvailable("Sunder Armor")
		and not IWin:IsBuffActive("target", "Sunder Armor")
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorDPS()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Sunder Armor")
		and not (IWin_Settings["sunder"] == "off")
		and IWin:GetTimeToDie() > 10
		and (
				not IWin:IsBuffStack("target", "Sunder Armor", 5)
				or (
						IWin:IsBuffActive("target", "Sunder Armor")
						and IWin:GetBuffRemaining("target", "Sunder Armor") < 9
					)
			)
		and not IWin:IsGCDActive()
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Sunder Armor")
	end
end

function IWin:SetReservedRageSunderArmorDPS()
	if IWin:IsSpellLearnt("Sunder Armor")
		and not (IWin_Settings["sunder"] == "off")
		and IWin:GetTimeToDie() > 10
		and not IWin:IsBuffStack("target", "Sunder Armor", 5)
		and not IWin:Is2HanderEquipped() then
			IWin:SetReservedRage("Sunder Armor", "nocooldown")
	end
end

function IWin:SunderArmorRaid()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Sunder Armor")
		and IWin_Settings["sunder"] == "high"
		and UnitInRaid("player")
		and IWin:IsElite()
		and not IWin:IsBuffStack("target", "Sunder Armor", 5)
		and not IWin:IsGCDActive()
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorDPSRefresh()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Sunder Armor")
		and not (IWin_Settings["sunder"] == "off")
		and IWin:GetTimeToDie() > 10
		and IWin:IsBuffActive("target", "Sunder Armor")
		and IWin:GetBuffRemaining("target", "Sunder Armor") < 6
		and not IWin:IsGCDActive()
		and not IWin_CombatVar["slamQueued"] then
			IWin_CombatVar["queueGCD"] = false
			Cast("Sunder Armor")
	end
end

function IWin:SweepingStrikes()
	if IWin:IsSpellLearnt("Sweeping Strikes")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsReservedRageStance("Battle Stance")
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsTimeToReserveRage("Sweeping Strikes", "cooldown") then
			IWin:SetReservedRageStance("Battle Stance")
			if not IWin:IsStanceActive("Battle Stance") then
				IWin:SetReservedRageStanceCast()
				Cast("Battle Stance")
			end
			if not IWin:IsOnCooldown("Sweeping Strikes")
				and IWin:IsRageAvailable("Sweeping Strikes")
				and IWin:IsStanceActive("Battle Stance") then
					IWin_CombatVar["queueGCD"] = false
					Cast("Sweeping Strikes")
			end
	end
end

function IWin:TankStance()
	if IWin:IsSpellLearnt("Defensive Stance")
		and (
				IWin:IsDefensiveTacticsActive("Defensive Stance")
				or not IWin:IsDefensiveTacticsActive()
			)
		and UnitAffectingCombat("player")
		and not IWin:IsStanceActive("Defensive Stance") then
			Cast("Defensive Stance")
	elseif IWin:IsSpellLearnt("Battle Stance")
		and (
				IWin:IsDefensiveTacticsActive("Battle Stance")
				--or not IWin:IsDefensiveTacticsActive()
			)
		and not IWin:IsDefensiveTacticsActive()
		and not IWin:IsStanceActive("Battle Stance") then
			Cast("Battle Stance")
	elseif IWin:IsSpellLearnt("Berserker Stance")
		and (
				IWin:IsDefensiveTacticsActive("Berserker Stance")
				--or not IWin:IsDefensiveTacticsActive()
			)
		and not IWin:IsDefensiveTacticsActive()
		and not IWin:IsStanceActive("Berserker Stance") then
			Cast("Berserker Stance")
	end
end

function IWin:Taunt()
	if IWin:IsSpellLearnt("Taunt")
		and not IWin:IsTanking()
		and not IWin:IsOnCooldown("Taunt")
		and not IWin:IsTaunted() then
			if not IWin:IsStanceActive("Defensive Stance") then
				Cast("Defensive Stance")
			else
				Cast("Taunt")
			end
	end
end

function IWin:ThunderClap(queueTime)
	if IWin:IsSpellLearnt("Thunder Clap")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsRageAvailable("Thunder Clap")
		and IWin:IsInRange()
		and IWin:GetCooldownRemaining("Thunder Clap") < queueTime
		and not IWin_CombatVar["slamQueued"] then
			if IWin:IsStanceActive("Berserker Stance") then
				Cast("Battle Stance")
			else
				IWin_CombatVar["queueGCD"] = false
				Cast("Thunder Clap")
			end
	end
end

function IWin:Whirlwind(queueTime)
	if IWin:IsSpellLearnt("Whirlwind")
		and IWin_CombatVar["queueGCD"]
		and IWin:IsReservedRageStance("Berserker Stance")
		and not IWin_CombatVar["slamQueued"]
		and IWin:IsTimeToReserveRage("Whirlwind", "cooldown")
		and UnitAffectingCombat("player") then
			IWin:SetReservedRageStance("Berserker Stance")
			if not IWin:IsStanceActive("Berserker Stance") then
				IWin:SetReservedRageStanceCast()
				Cast("Berserker Stance")
			end
			if (
					IWin:GetCooldownRemaining("Whirlwind") < queueTime
					or not IWin:IsOnCooldown("Whirlwind")
				)
				and IWin:IsRageAvailable("Whirlwind")
				and IWin:IsInRange("Rend")
				and IWin:IsStanceActive("Berserker Stance") then
					IWin_CombatVar["queueGCD"] = false
					Cast("Whirlwind")
			end
	end
end

---- idebug button ----
SLASH_IDEBUG1 = '/idebug'
function SlashCmdList.IDEBUG()
	DEFAULT_CHAT_FRAME:AddMessage(IWin_Settings["test"])
end

---- commands ----
SLASH_IWIN1 = "/iwin"
function SlashCmdList.IWIN(command)
	if not command then return end
	local arguments = {}
	for token in string.gfind(command, "%S+") do
		table.insert(arguments, token)
	end

	if arguments[1] == "charge"then
		if arguments[2] ~= "raid"
			and arguments[2] ~= "group"
			and arguments[2] ~= "solo"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: raid, group, solo, off.|r")
				return
		end
	elseif arguments[1] == "sunder" then
		if arguments[2] ~= "high"
			and arguments[2] ~= "low"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: high, low, off.|r")
				return
		end
	elseif arguments[1] == "demo" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	elseif arguments[1] == "dt" then
		if arguments[2] ~= "battle"
			and arguments[2] ~= "defensive"
			and arguments[2] ~= "berserker"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: battle, defensive, berserker.|r")
				return
		end
	elseif arguments[1] == "ragebuffer" then
		if tonumber(arguments[2]) < 0
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more. 1.5 is the default parameter.|r")
				return
		end
	elseif arguments[1] == "ragegain" then
		if tonumber(arguments[2]) < 0
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: 0 or more. 10 is the default parameter.|r")
				return
		end
	elseif arguments[1] == "jousting" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Unkown parameter. Possible values: on, off.|r")
				return
		end
	end

    if arguments[1] == "charge" then
        IWin_Settings["charge"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Charge: |r" .. IWin_Settings["charge"])
	elseif arguments[1] == "sunder" then
	    IWin_Settings["sunder"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Sunder Armor: |r" .. IWin_Settings["sunder"])
	elseif arguments[1] == "demo" then
	    IWin_Settings["demo"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Demoralizing Shout: |r" .. IWin_Settings["demo"])
	elseif arguments[1] == "dt" and arguments[2] == "battle" then
	    IWin_Settings["dtBattle"] = not IWin_Settings["dtBattle"]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Battle Stance: |r" .. tostring(IWin_Settings["dtBattle"]))
	elseif arguments[1] == "dt" and arguments[2] == "defensive" then
	    IWin_Settings["dtDefensive"] = not IWin_Settings["dtDefensive"]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Defensive Stance: |r" .. tostring(IWin_Settings["dtDefensive"]))
	elseif arguments[1] == "dt" and arguments[2] == "berserker" then
	    IWin_Settings["dtBerserker"] = not IWin_Settings["dtBerserker"]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Defensive Tactics Berserker Stance: |r" .. tostring(IWin_Settings["dtBerserker"]))
	elseif arguments[1] == "ragebuffer" then
	    IWin_Settings["rageTimeToReserveBuffer"] = tonumber(arguments[2])
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Buffer: |r" .. tostring(IWin_Settings["rageTimeToReserveBuffer"]))
	elseif arguments[1] == "ragegain" then
	    IWin_Settings["ragePerSecondPrediction"] = tonumber(arguments[2])
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Rage Gain per second: |r" .. tostring(IWin_Settings["ragePerSecondPrediction"]))
	elseif arguments[1] == "jousting" then
	    IWin_Settings["jousting"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Jousting: |r" .. IWin_Settings["jousting"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff Usage:")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin : Current setup")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin charge [" .. IWin_Settings["charge"] .. "] : |r Setup for Charge and Intercept")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin sunder [" .. IWin_Settings["sunder"] .. "] : |r Setup for Sunder Armor priority as DPS")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin demo [" .. IWin_Settings["demo"] .. "] : |r Setup for Demoralizing Shout")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin dt battle : |r (" .. tostring(IWin_Settings["dtBattle"]) .. ") Setup for Battle Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin dt defensive : |r (" .. tostring(IWin_Settings["dtDefensive"]) .. ") Setup for Defensive Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin dt berserker : |r (" .. tostring(IWin_Settings["dtBerserker"]) .. ") Setup for Berserker Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin ragebuffer [" .. tostring(IWin_Settings["rageTimeToReserveBuffer"]) .. "] : |r Setup to save 100% required rage for spells X seconds before the spells are used. 1.5 is the default parameter.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin ragegain [" .. tostring(IWin_Settings["ragePerSecondPrediction"]) .. "] : |r Setup to anticipate rage gain per second. Required rage will be saved gradually before the spells are used. 10 is the default parameter. Increase the value if rage is wasted.")
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff   /iwin jousting [" .. IWin_Settings["jousting"] .. "] : |r Setup for Jousting solo DPS")
    end
end

---- idps button ----
SLASH_IDPS1 = '/idps'
function SlashCmdList.IDPS()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:DPSStance()
	IWin:Bloodrage()
	IWin:BattleShout()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:SunderArmorDPSRefresh()
	IWin:BloodthirstHighAP(GCD)
	IWin:SetReservedRageBloodthirstHighAP()
	IWin:SunderArmorRaid()
	IWin:Execute()
	IWin:SetReservedRageExecute()
	IWin:HamstringJousting()
	IWin:Slam()
	IWin:SetReservedRageSlam()
	IWin:SetSlamQueued()
	IWin:Overpower()
	IWin:DPSStanceDefault()
	IWin:ShieldSlam(GCD)
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike(GCD)
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst(GCD)
	IWin:SetReservedRageBloodthirst()
	IWin:Whirlwind(0)
	IWin:SetReservedRage("Whirlwind", "cooldown")
	IWin:MasterStrike()
	IWin:SetReservedRageMasterStrike()
	IWin:ConcussionBlow()
	IWin:BattleShoutRefresh()
	IWin:DemoralizingShout()
	IWin:SetReservedRageDemoralizingShout()
	IWin:Rend()
	IWin:SunderArmorDPS()
	IWin:SetReservedRageSunderArmorDPS()
	IWin:BerserkerRage()
	IWin:HeroicStrike()
	IWin:Perception()
	IWin:StartAttack()
end

---- icleave button ----
SLASH_ICLEAVE1 = '/icleave'
function SlashCmdList.ICLEAVE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:CleaveStance()
	IWin:Bloodrage()
	IWin:BattleShout()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:SweepingStrikes()
	IWin:SetReservedRage("Sweeping Strikes", "cooldown")
	IWin:Whirlwind(GCD)
	IWin:SetReservedRage("Whirlwind", "cooldown")
	IWin:BloodthirstHighAP(GCD)
	IWin:SetReservedRageBloodthirstHighAP()
	IWin:ExecuteAOE()
	IWin:SetReservedRageExecuteAOE()
	IWin:Slam()
	IWin:SetReservedRageSlam()
	IWin:SetSlamQueued()
	IWin:Overpower()
	IWin:DPSStanceDefault()
	IWin:ShieldSlam(GCD)
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike(GCD)
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst(GCD)
	IWin:SetReservedRageBloodthirst()
	IWin:MasterStrike()
	IWin:SetReservedRageMasterStrike()
	IWin:ConcussionBlow()
	IWin:BattleShoutRefresh()
	IWin:DemoralizingShout()
	IWin:SetReservedRageDemoralizingShout()
	IWin:BerserkerRage()
	IWin:Cleave()
	IWin:Perception()
	IWin:StartAttack()
end

---- itank button ----
SLASH_ITANK1 = '/itank'
function SlashCmdList.ITANK()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:TankStance()
	IWin:Bloodrage()
	IWin:Slam()
	IWin:SetReservedRageSlam()
	IWin:SetSlamQueued()
	IWin:ExecuteDefensiveTactics()
	IWin:SetReservedRageExecuteDefensiveTactics()
	IWin:OverpowerDefensiveTactics()
	IWin:ShieldSlam(GCD)
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike(GCD)
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst(GCD)
	IWin:SetReservedRage("Bloodthirst", "cooldown")
	IWin:Revenge()
	IWin:SetReservedRageRevenge()
	IWin:ConcussionBlow()
	IWin:SunderArmorFirstStack()
	IWin:BattleShoutRefresh()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:DemoralizingShout()
	IWin:SetReservedRageDemoralizingShout()
	IWin:SunderArmor()
	IWin:SetReservedRage("Sunder Armor", "nocooldown")
	IWin:BerserkerRage()
	IWin:HeroicStrike()
	IWin:Perception()
	IWin:StartAttack()
end

---- ihodor button ----
SLASH_IHODOR1 = '/ihodor'
function SlashCmdList.IHODOR()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:TankStance()
	IWin:Bloodrage()
	IWin:ThunderClap(GCD)
	IWin:SetReservedRage("Thunder Clap", "cooldown")
	IWin:DemoralizingShout()
	IWin:SetReservedRageDemoralizingShout()
	IWin:Slam()
	IWin:SetReservedRageSlam()
	IWin:SetSlamQueued()
	IWin:ExecuteDefensiveTactics()
	IWin:SetReservedRageExecuteDefensiveTactics()
	IWin:ShieldSlam(GCD)
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike(GCD)
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst(GCD)
	IWin:SetReservedRage("Bloodthirst", "cooldown")
	IWin:Revenge()
	IWin:SetReservedRageRevenge()
	IWin:ConcussionBlow()
	IWin:SunderArmorFirstStack()
	IWin:BattleShoutRefresh()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:SunderArmor()
	IWin:SetReservedRage("Sunder Armor", "nocooldown")
	IWin:BerserkerRage()
	IWin:Cleave()
	IWin:Perception()
	IWin:StartAttack()
end

---- ichase button ----
SLASH_ICHASE1 = '/ichase'
function SlashCmdList.ICHASE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:Charge()
	IWin:Intercept()
	IWin:Hamstring()
	IWin:PiercingHowl()
	IWin:StartAttack()
end

---- ikick button ----
SLASH_IKICK1 = '/ikick'
function SlashCmdList.IKICK()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:ShieldBash()
	IWin:Pummel()
	IWin:StartAttack()
end

---- ifeardance button ----
SLASH_IFEARDANCE1 = '/ifeardance'
function SlashCmdList.IFEARDANCE()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:BerserkerRageImmune()
	IWin:StartAttack()
end

---- itaunt button ----
SLASH_ITAUNT1 = '/itaunt'
function SlashCmdList.ITAUNT()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:Taunt()
	IWin:MockingBlow()
	IWin:StartAttack()
end

---- ishoot button ----
SLASH_ISHOOT1 = '/ishoot'
function SlashCmdList.ISHOOT()
	IWin:InitializeRotation()
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:Shoot()
end