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
	["dodge"] = 0,
	["reservedRage"] = 0,
	["reservedRageStance"] = nil,
	["charge"] = 0,
}
local Cast = CastSpellByName
IWin_PartySize = {
	["raid"] = 40,
	["group"] = 5,
	["solo"] = 1,
	["off"] = 0,
}

---- Event Register ----
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
			if start ~= 0 and duration ~= 1.5 then
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

function IWin:IsOverpowerAvailable()
	local overpowerTimeActive = GetTime() - IWin_CombatVar["dodge"]
 	return overpowerTimeActive < 5
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

function IWin:IsInRange(spell)
	if not IsSpellInRange
		or not spell
		or not IWin:IsSpellLearnt(spell) then
        return CheckInteractDistance("target", 3) ~= nil
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

function IWin:IsRageReservedStance(stance)
	if IWin_CombatVar["reservedRageStance"] then
		return IWin_CombatVar["reservedRageStance"] == stance
	end
	return true
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

---- Class Actions ----
function IWin:BattleShout()
	if IWin:IsSpellLearnt("Battle Shout")
		and not IWin:IsBuffActive("player","Battle Shout")
		and IWin:IsRageAvailable("Battle Shout") then
			Cast("Battle Shout")
	end
end

function IWin:BattleShoutRefresh()
	if IWin:IsSpellLearnt("Battle Shout")
		and IWin:GetBuffRemaining("player","Battle Shout") < 9
		and IWin:IsRageAvailable("Battle Shout") then
			Cast("Battle Shout")
	end
end

function IWin:BattleShoutRefreshOOC()
	if IWin:IsSpellLearnt("Battle Shout")
		and IWin:GetBuffRemaining("player","Battle Shout") < 30
		and IWin:IsRageAvailable("Battle Shout")
		and UnitMana("player") > 60
		and not UnitAffectingCombat("player") then
			Cast("Battle Shout")
	end
end

function IWin:BerserkerRage()
	if IWin:IsSpellLearnt("Berserker Rage")
		and IWin:IsStanceActive("Berserker Stance")
		and not IWin:IsBlacklistFear()
		and not IWin:IsOnCooldown("Berserker Rage")
		and UnitAffectingCombat("player")
		and (
				IWin:IsTanking()
				or IWin:GetTalentRank(2, 14) ~= 0
			) then
			Cast("Berserker Rage")
	end
end

function IWin:BerserkerRageImmune()
	if IWin:IsSpellLearnt("Berserker Rage")
		and not IWin:IsOnCooldown("Berserker Rage") then
			if not IWin:IsStanceActive("Berserker Stance") then
				Cast("Berserker Stance")
			else
				Cast("Berserker Rage")
			end
	end
end

function IWin:Bloodrage()
	if IWin:IsSpellLearnt("Bloodrage")
		and UnitMana("player") < 70
		and IWin:GetHealthPercent("player") > 25
		and not IWin:IsBuffActive("player","Enrage")
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

function IWin:Bloodthirst()
	if IWin:IsSpellLearnt("Bloodthirst")
		and not IWin:IsOnCooldown("Bloodthirst")
		and IWin:IsRageAvailable("Bloodthirst") then
			Cast("Bloodthirst")
	end
end

function IWin:SetReservedRageBloodthirst()
	if not IWin:IsHighAP() then 
		IWin:SetReservedRage("Bloodthirst", "cooldown")
	end
end

function IWin:BloodthirstHighAP()
	if IWin:IsSpellLearnt("Bloodthirst")
		and not IWin:IsOnCooldown("Bloodthirst")
		and IWin:IsRageAvailable("Bloodthirst")
		and UnitMana("player") < 60
		and IWin:IsHighAP() then
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
		and IWin:IsInRange("Charge")
		and not UnitAffectingCombat("player") then
			if not IWin:IsStanceActive("Battle Stance")
				and (
						IWin:IsStanceSwapMaxRageLoss(25)
						or UnitIsPVP("target")
					) then
					Cast("Battle Stance")
			end
			if IWin:IsStanceActive("Battle Stance") then
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
		and not IWin:IsOnCooldown("Concussion Blow") then
			Cast("Concussion Blow")
	end
end

function IWin:DemoralizingShout()
	if IWin:IsSpellLearnt("Demoralizing Shout")
		and IWin:IsRageAvailable("Demoralizing Shout")
		and not IWin:IsBlacklistDemoralizingShout()
		and IWin_Settings["demo"] == "on"
		and IWin:IsInRange("Intimidating Shout")
		and not IWin:IsBuffActive("target", "Demoralizing Shout")
		and IWin:GetTimeToDie() > 10 then
			Cast("Demoralizing Shout")
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
		and IWin:IsRageReservedStance("Berserker Stance") then
			Cast("Berserker Stance")
	else
		Cast("Battle Stance")
	end
end

function IWin:Execute()
	if IWin:IsSpellLearnt("Execute")
		and IWin:IsExecutePhase()
		and IWin:IsRageAvailable("Execute") then
			if IWin:IsStanceActive("Defensive Stance") then
				Cast("Battle Stance")
			else
				Cast("Execute")
			end
	end
end

function IWin:SetReservedRageExecute()
	local lowHealthTarget = (UnitHealthMax("player") * 0.3 > UnitHealth("target"))
	if lowHealthTarget
		or IWin:IsExecutePhase() then 
			IWin:SetReservedRage("Execute", "cooldown")
	end
end

function IWin:ExecuteDefensiveTactics()
	if IWin:IsSpellLearnt("Execute")
		and IWin:IsExecutePhase()
		and IWin:IsRageAvailable("Execute") then
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
		and not IWin:IsOnCooldown("Hamstring")
		and IWin:IsInRange("Hamstring")
		and IWin:IsRageCostAvailable("Hamstring") then
			Cast("Hamstring")
	end
end

function IWin:HeroicStrike()
	if IWin:IsSpellLearnt("Heroic Strike") then
		if IWin:IsRageAvailable("Heroic Strike") then
			Cast("Heroic Strike")
		else
			--SpellStopCasting()
		end
	end
end

function IWin:Intercept()
	if IWin:IsSpellLearnt("Intercept")
		and not IWin:IsOnCooldown("Intercept")
		and IWin:IsInRange("Intercept")
		and not IWin:IsCharging()
		and (
				(
					not UnitAffectingCombat("player")
					and IWin:IsOnCooldown("Charge")
				)
				or UnitAffectingCombat("player")
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
			) then
			if not IWin:IsStanceActive("Berserker Stance") then
				Cast("Berserker Stance")
			end
			if not IWin:IsRageCostAvailable("Intercept") then
				Cast("Bloodrage")
			end
			if IWin:IsStanceActive("Berserker Stance") then
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
		and not IWin:IsOnCooldown("Master Strike")
		and IWin:IsRageAvailable("Master Strike") then
			Cast("Master Strike")
	end
end

function IWin:MockingBlow()
	if IWin:IsSpellLearnt("Mocking Blow")
		and not IWin:IsTanking()
		and IWin:IsOnCooldown("Taunt")
		and not IWin:IsOnCooldown("Mocking Blow")
		and not IWin:IsTaunted() then
			if not IWin:IsStanceActive("Battle Stance") then
				Cast("Battle Stance")
			else
				Cast("Mocking Blow")
			end
	end
end

function IWin:MortalStrike()
	if IWin:IsSpellLearnt("Mortal Strike")
		and not IWin:IsOnCooldown("Mortal Strike")
		and IWin:IsRageAvailable("Mortal Strike") then
			Cast("Mortal Strike")
	end
end

function IWin:Overpower()
	if IWin:IsSpellLearnt("Overpower")
		and IWin:IsOverpowerAvailable()
		and not IWin:IsOnCooldown("Overpower")
		and IWin:IsRageAvailable("Overpower")
		and IWin:IsRageReservedStance("Battle Stance") then
			IWin_CombatVar["reservedRageStance"] = "Battle Stance"
			if not IWin:IsStanceActive("Battle Stance")
				and (
						IWin:IsStanceSwapMaxRageLoss(25)
						or UnitIsPVP("target")
					) then
					Cast("Battle Stance")
			end
			if IWin:IsStanceActive("Battle Stance") then
				Cast("Overpower")
			end
	end
end

function IWin:OverpowerDefensiveTactics()
	if IWin:IsSpellLearnt("Overpower")
		and IWin:IsOverpowerAvailable()
		and not IWin:IsOnCooldown("Overpower")
		and IWin:IsRageAvailable("Overpower")
		and IWin:IsRageReservedStance("Battle Stance") then
			IWin_CombatVar["reservedRageStance"] = "Battle Stance"
			if not IWin:IsStanceActive("Battle Stance")
				and IWin:IsDefensiveTacticsActive("Battle Stance")
				and not IWin:IsDefensiveTacticsActive()
				and (
						IWin:IsStanceSwapMaxRageLoss(25)
						or UnitIsPVP("target")
					) then
					Cast("Battle Stance")
			end
			if IWin:IsStanceActive("Battle Stance") then
				Cast("Overpower")
			end
	end
end

function IWin:PiercingHowl()
	if IWin:IsSpellLearnt("Piercing Howl")
		and IWin:IsInRange("Intimidating Shout")
		and IWin:IsRageCostAvailable("Piercing Howl") then
			Cast("Piercing Howl")
	end
end

function IWin:Pummel()
	if IWin:IsSpellLearnt("Pummel")
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
			Cast("Pummel")
		end
	end
end

function IWin:Rend()
	if IWin:IsSpellLearnt("Rend")
		and IWin:IsRageAvailable("Rend")
		and IWin:GetTimeToDie() > 9
		and not UnitInRaid("player")
		and not IWin:IsBuffActive("target","Rend")
		and not (
					UnitCreatureType("target") == "Undead"
					or UnitCreatureType("target") == "Mechanical"
					or UnitCreatureType("target") == "Elemental"
				)
		and not IWin:IsStanceActive("Berserker Stance") then
			Cast("Rend")
	end
end

function IWin:Revenge()
	if IWin:IsSpellLearnt("Revenge")
		and not IWin:IsOnCooldown("Revenge")
		and IWin:IsRageCostAvailable("Revenge") then
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
			) then
		if IWin:IsStanceActive("Berserker Stance") then
			Cast("Defensive Stance")
		else
			if not IWin:IsRageCostAvailable("Shield Bash") then
				Cast("Bloodrage")
			end
			Cast("Shield Bash")
		end
	end
end

function IWin:ShieldSlam()
	if IWin:IsSpellLearnt("Shield Slam")
		and not IWin:IsOnCooldown("Shield Slam")
		and IWin:IsRageAvailable("Shield Slam") then
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
	local slamCastSpeed = (2.5 - IWin:GetTalentRank(1, 15) * 0.25) / (1 + IWin:GetTalentRank(2, 15) * 0.06)
	if IWin:IsSpellLearnt("Slam")
		and IWin:IsRageAvailable("Slam")
		and IWin:Is2HanderEquipped()
		and (
				not st_timer
				or st_timer > UnitAttackSpeed("player") * 0.9
				or st_timer > slamCastSpeed
			) then
			Cast("Slam")
	end
end

function IWin:SetReservedRageSlam()
	if IWin:Is2HanderEquipped() then
		IWin:SetReservedRage("Slam", "nocooldown")
	end
end

function IWin:SunderArmor()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageAvailable("Sunder Armor") then
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorFirstStack()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageCostAvailable("Sunder Armor")
		and not IWin:IsBuffActive("target", "Sunder Armor") then
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorDPS()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageAvailable("Sunder Armor")
		and not IWin_Settings["sunder"] == "off"
		and IWin:GetTimeToDie() > 10
		and not IWin:IsBuffStack("target", "Sunder Armor", 5) then
			Cast("Sunder Armor")
	end
end

function IWin:SetReservedRageSunderArmorDPS()
	if IWin:IsSpellLearnt("Sunder Armor")
		and not IWin_Settings["sunder"] == "off"
		and IWin:GetTimeToDie() > 10
		and not IWin:IsBuffStack("target", "Sunder Armor", 5) then
			IWin:SetReservedRage("Sunder Armor", "nocooldown")
	end
end

function IWin:SunderArmorRaid()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageAvailable("Sunder Armor")
		and IWin_Settings["sunder"] == "high"
		and UnitInRaid("player")
		and IWin:IsElite()
		and not IWin:IsBuffStack("target", "Sunder Armor", 5) then
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorDPSRefresh()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageAvailable("Sunder Armor")
		and not IWin_Settings["sunder"] == "off"
		and IWin:GetTimeToDie() > 10
		and IWin:IsBuffActive("target", "Sunder Armor")
		and IWin:GetBuffRemaining("target", "Sunder Armor") < 9 then
			Cast("Sunder Armor")
	end
end

function IWin:SweepingStrikes()
	if IWin:IsSpellLearnt("Sweeping Strikes")
		and IWin:IsRageReservedStance("Battle Stance") then
			if IWin:IsTimeToReserveRage("Sweeping Strikes", "cooldown")
				and UnitAffectingCombat("player") then
					IWin_CombatVar["reservedRageStance"] = "Battle Stance"
					if not IWin:IsStanceActive("Battle Stance") then
						Cast("Battle Stance")
					end
			end
			if not IWin:IsOnCooldown("Sweeping Strikes")
				and IWin:IsRageAvailable("Sweeping Strikes")
				and IWin:IsStanceActive("Battle Stance") then 
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

function IWin:ThunderClap()
	if IWin:IsSpellLearnt("Thunder Clap")
		and IWin:IsRageAvailable("Thunder Clap")
		and IWin:IsInRange("Rend")
		and not IWin:IsOnCooldown("Thunder Clap") then
			if IWin:IsStanceActive("Berserker Stance") then
				Cast("Battle Stance")
			else
				Cast("Thunder Clap")
			end
	end
end

function IWin:Whirlwind()
	if IWin:IsSpellLearnt("Whirlwind")
		and IWin:IsRageReservedStance("Berserker Stance") then
			if IWin:IsTimeToReserveRage("Whirlwind", "cooldown")
				and UnitAffectingCombat("player") then
					IWin_CombatVar["reservedRageStance"] = "Berserker Stance"
					if not IWin:IsStanceActive("Berserker Stance") then
						Cast("Berserker Stance")
					end
			end
			if not IWin:IsOnCooldown("Whirlwind")
				and IWin:IsRageAvailable("Whirlwind")
				and IWin:IsInRange("Rend")
				and IWin:IsStanceActive("Berserker Stance") then 
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
				DEFAULT_CHAT_FRAME:AddMessage("Unkown parameter. Possible values: raid, group, solo, off.")
				return
		end
	elseif arguments[1] == "sunder" then
		if arguments[2] ~= "high"
			and arguments[2] ~= "low"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("Unkown parameter. Possible values: high, low, off.")
				return
		end
	elseif arguments[1] == "demo" then
		if arguments[2] ~= "on"
			and arguments[2] ~= "off"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("Unkown parameter. Possible values: on, off.")
				return
		end
	elseif arguments[1] == "dt" then
		if arguments[2] ~= "battle"
			and arguments[2] ~= "defensive"
			and arguments[2] ~= "berserker"
			and arguments[2] ~= nil then
				DEFAULT_CHAT_FRAME:AddMessage("Unkown parameter. Possible values: battle, defensive, berserker.")
				return
		end
	end
    if arguments[1] == "charge" then
        IWin_Settings["charge"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("Charge: " .. IWin_Settings["charge"])
	elseif arguments[1] == "sunder" then
	    IWin_Settings["sunder"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("Sunder Armor: " .. IWin_Settings["sunder"])
	elseif arguments[1] == "demo" then
	    IWin_Settings["demo"] = arguments[2]
	    DEFAULT_CHAT_FRAME:AddMessage("Demoralizing Shout: " .. IWin_Settings["demo"])
	elseif arguments[1] == "dt" and arguments[2] == "battle" then
	    IWin_Settings["dtBattle"] = not IWin_Settings["dtBattle"]
	    DEFAULT_CHAT_FRAME:AddMessage("Defensive Tactics Battle Stance: " .. tostring(IWin_Settings["dtBattle"]))
	elseif arguments[1] == "dt" and arguments[2] == "defensive" then
	    IWin_Settings["dtDefensive"] = not IWin_Settings["dtDefensive"]
	    DEFAULT_CHAT_FRAME:AddMessage("Defensive Tactics Defensive Stance: " .. tostring(IWin_Settings["dtDefensive"]))
	elseif arguments[1] == "dt" and arguments[2] == "berserker" then
	    IWin_Settings["dtBerserker"] = not IWin_Settings["dtBerserker"]
	    DEFAULT_CHAT_FRAME:AddMessage("Defensive Tactics Berserker Stance: " .. tostring(IWin_Settings["dtBerserker"]))
	else
		DEFAULT_CHAT_FRAME:AddMessage("Usage:")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin : Current setup")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin charge [" .. IWin_Settings["charge"] .. "] : Setup for Charge and Intercept")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin sunder [" .. IWin_Settings["sunder"] .. "] : Setup for Sunder Armor priority as DPS")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin demo [" .. IWin_Settings["demo"] .. "] : Setup for Demoralizing Shout")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin dt battle : (" .. tostring(IWin_Settings["dtBattle"]) .. ") Setup for Battle Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin dt defensive : (" .. tostring(IWin_Settings["dtDefensive"]) .. ") Setup for Defensive Stance with Defensive Tactics")
		DEFAULT_CHAT_FRAME:AddMessage(" /iwin dt berserker : (" .. tostring(IWin_Settings["dtBerserker"]) .. ") Setup for Berserker Stance with Defensive Tactics")
    end
end

---- idps button ----
SLASH_IDPS1 = '/idps'
function SlashCmdList.IDPS()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:DPSStance()
	IWin:Bloodrage()
	IWin:BattleShout()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:BloodthirstHighAP()
	IWin:SetReservedRageBloodthirstHighAP()
	IWin:SunderArmorDPSRefresh()
	IWin:SunderArmorRaid()
	IWin:Execute()
	IWin:SetReservedRageExecute()
	IWin:ShieldSlam()
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike()
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst()
	IWin:SetReservedRageBloodthirst()
	IWin:Whirlwind()
	IWin:SetReservedRage("Whirlwind", "cooldown")
	IWin:MasterStrike()
	IWin:SetReservedRage("Master Strike", "cooldown")
	IWin:Overpower()
	IWin:DPSStanceDefault()
	IWin:ConcussionBlow()
	IWin:BattleShoutRefresh()
	IWin:Slam()
	IWin:SetReservedRageSlam()
	IWin:DemoralizingShout()
	IWin:SetReservedRage("Demoralizing Shout", "debuff", "target")
	IWin:Rend()
	IWin:SunderArmorDPS()
	IWin:SetReservedRageSunderArmorDPS()
	IWin:BerserkerRage()
	IWin:HeroicStrike()
	IWin:StartAttack()
end

---- icleave button ----
SLASH_ICLEAVE1 = '/icleave'
function SlashCmdList.ICLEAVE()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
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
	IWin:Whirlwind()
	IWin:SetReservedRage("Whirlwind", "cooldown")
	IWin:BloodthirstHighAP()
	IWin:SetReservedRageBloodthirstHighAP()
	IWin:Execute()
	IWin:SetReservedRageExecute()
	IWin:ShieldSlam()
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike()
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst()
	IWin:SetReservedRageBloodthirst()
	IWin:MasterStrike()
	IWin:SetReservedRage("Master Strike", "cooldown")
	IWin:Overpower()
	IWin:DPSStanceDefault()
	IWin:ConcussionBlow()
	IWin:BattleShoutRefresh()
	IWin:Slam()
	IWin:SetReservedRageSlam()
	IWin:DemoralizingShout()
	IWin:SetReservedRage("Demoralizing Shout", "debuff", "target")
	IWin:BerserkerRage()
	IWin:DPSStanceDefault()
	IWin:Cleave()
	IWin:StartAttack()
end

---- itank button ----
SLASH_ITANK1 = '/itank'
function SlashCmdList.ITANK()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:TankStance()
	IWin:Bloodrage()
	IWin:ShieldSlam()
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike()
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst()
	IWin:SetReservedRage("Bloodthirst", "cooldown")
	IWin:Revenge()
	IWin:SetReservedRageRevenge()
	IWin:ExecuteDefensiveTactics()
	IWin:SetReservedRageExecuteDefensiveTactics()
	IWin:OverpowerDefensiveTactics()
	IWin:ConcussionBlow()
	IWin:SunderArmorFirstStack()
	IWin:BattleShoutRefresh()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:DemoralizingShout()
	IWin:SetReservedRage("Demoralizing Shout", "debuff", "target")
	IWin:SunderArmor()
	IWin:SetReservedRage("Sunder Armor", "nocooldown")
	IWin:BerserkerRage()
	IWin:HeroicStrike()
	IWin:StartAttack()
end

---- ihodor button ----
SLASH_IHODOR1 = '/ihodor'
function SlashCmdList.IHODOR()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargePartySize()
	IWin:InterceptPartySize()
	IWin:TankStance()
	IWin:Bloodrage()
	IWin:ThunderClap()
	IWin:SetReservedRage("Thunder Clap", "cooldown")
	IWin:DemoralizingShout()
	IWin:SetReservedRage("Demoralizing Shout", "debuff", "target")
	IWin:ShieldSlam()
	IWin:SetReservedRage("Shield Slam", "cooldown")
	IWin:MortalStrike()
	IWin:SetReservedRage("Mortal Strike", "cooldown")
	IWin:Bloodthirst()
	IWin:SetReservedRage("Bloodthirst", "cooldown")
	IWin:Revenge()
	IWin:SetReservedRageRevenge()
	IWin:ExecuteDefensiveTactics()
	IWin:SetReservedRageExecuteDefensiveTactics()
	IWin:ConcussionBlow()
	IWin:SunderArmorFirstStack()
	IWin:BattleShoutRefresh()
	IWin:SetReservedRage("Battle Shout", "buff", "player")
	IWin:SunderArmor()
	IWin:SetReservedRage("Sunder Armor", "nocooldown")
	IWin:BerserkerRage()
	IWin:Cleave()
	IWin:StartAttack()
end

---- ichase button ----
SLASH_ICHASE1 = '/ichase'
function SlashCmdList.ICHASE()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
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
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:ShieldBash()
	IWin:Pummel()
	IWin:StartAttack()
end

---- ifeardance button ----
SLASH_IFEARDANCE1 = '/ifeardance'
function SlashCmdList.IFEARDANCE()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:BerserkerRageImmune()
	IWin:StartAttack()
end

---- itaunt button ----
SLASH_ITAUNT1 = '/itaunt'
function SlashCmdList.ITAUNT()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:Taunt()
	IWin:MockingBlow()
	IWin:StartAttack()
end

---- ishoot button ----
SLASH_ISHOOT1 = '/ishoot'
function SlashCmdList.ISHOOT()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:Shoot()
end