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
local IWin_Settings = {
	["rageTimeToReserveBuffer"] = 1.5,
	["ragePerSecondPrediction"] = 10, -- change it to match your gear and buffs
	["outOfRaidCombatLength"] = 20,
	["playerToNPCHealthRatio"] = 0.75,
}
local IWin_CombatVar = {
	["dodge"] = 0,
	["reservedRage"] = 0,
	["reservedRageStance"] = nil,
	["charge"] = 0,
}
local Cast = CastSpellByName

---- Event Register ----
IWin:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
IWin:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
IWin:RegisterEvent("ADDON_LOADED")
IWin:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "IWinEnhanced" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff0066ff IWinEnhanced system loaded.|r")
		IWin:UnregisterEvent("ADDON_LOADED")
	elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" then
		if string.find(arg1,"dodge") then
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
	["Berserker Rage"] = 0 - IWin:GetTalentRank(2, 16) * 5,
	["Bloodrage"] = - 10 - IWin:GetBloodrageCostReduction(),
	["Bloodthirst"] = 30,
	["Charge"] = - 12 - IWin:GetTalentRank(1, 4) * 3,
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
	return IWin:GetBuffStack(unit, spell) ~= 0
end

function IWin:GetBuffRemaining(unit, spell)
	if unit == "player" then
		local index = IWin:GetBuffIndex(unit, spell)
		if index then
			return GetPlayerBuffTimeLeft(index - 1)
		end
		local index = IWin:GetDebuffIndex(unit, spell)
		if index then
			return GetPlayerBuffTimeLeft(index - 1)
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

function IWin:GetTimeToDiePrediction()
	local ttd = 0
	if UnitInRaid("player") then
		ttd = 999
	elseif UnitInParty("player") then
		ttd = UnitHealth("target") / UnitHealthMax("player") * IWin_Settings["playerToNPCHealthRatio"] * IWin_Settings["outOfRaidCombatLength"] / GetNumPartyMembers()
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

function IWin:IsInMeleeRange()
	return CheckInteractDistance("target", 3) ~= nil
end

function IWin:GetStanceSwapRageRetain()
	return math.min(IWin:GetTalentRank(1, 2) * 5, UnitMana("player"))
end

function IWin:IsStanceSwapMaxRageLoss(rage)
	return rage >= math.max(0, UnitMana("player") - IWin:GetStanceSwapRageRetain())
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

function IWin:IsDefensiveTacticsActive()
	return IWin:GetTalentRank(3, 18) and IWin:IsShieldEquipped()
end

function IWin:IsHighAP()
	local APbase, APpos, APneg = UnitAttackPower("player")
	return (APbase + APpos + APneg) * 0.35 + 200 > 825
end

---- Actions ----
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
	if not attackActionFound and not PlayerFrame.inCombat then
		AttackTarget()
	end
end

function IWin:MarkSkull()
	if GetRaidTargetIndex("target") ~= 8
		and not UnitIsFriend("player", "target")
		and not UnitInRaid("player") then
			SetRaidTarget("target", 8)
	end
end

function IWin:BattleShout()
	if IWin:IsSpellLearnt("Battle Shout")
		and not IWin:IsBuffActive("player","Battle Shout")
		and not IWin:IsBuffActive("player","Blessing of Power")
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
		and not IWin:IsOnCooldown("Berserker Rage")
		and UnitAffectingCombat("player")
		and IWin:IsTanking() then
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

function IWin:BerserkerStanceInstance()
	if IWin:IsSpellLearnt("Berserker Stance")
		and IsInInstance()
		and not IWin:IsStanceActive("Berserker Stance")
		and IWin:IsStanceSwapMaxRageLoss(25) then
			Cast("Berserker Stance")
	end
end

function IWin:Bloodrage()
	if IWin:IsSpellLearnt("Bloodrage")
		and UnitMana("player") < 70
		and IWin:GetHealthPercent("player") > 25
		and (
				IWin:IsStanceActive("Defensive Stance")
				or (
					UnitAffectingCombat("player")
					and (
							IWin:IsSpellLearnt("Mortal Strike")
							or IWin:IsSpellLearnt("Bloodthirst")
							or IWin:IsSpellLearnt("Shield Slam")
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
		and not IWin:IsInMeleeRange()
		and not UnitAffectingCombat("player") then
			if not IWin:IsStanceActive("Battle Stance") then
				Cast("Battle Stance")
			else
				Cast("Charge")
				IWin_CombatVar["charge"] = GetTime()
			end
	end
end

function IWin:ChargeOpenWorld()
	if IWin:IsSpellLearnt("Charge")
		and not IWin:IsOnCooldown("Charge")
		and not IWin:IsInMeleeRange()
		and not UnitAffectingCombat("player")
		and not IsInInstance() then
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
		and not IWin:IsBuffActive("target", "Demoralizing Shout")
		and IWin:GetTimeToDiePrediction() > 10 then
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
		and IWin:IsRageAvailable("Execute")
		and IWin:IsDefensiveTacticsActive() then
			if IWin:IsStanceActive("Defensive Stance") then
				Cast("Battle Stance")
			else
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
		and IWin:IsDefensiveTacticsActive() then 
			IWin:SetReservedRage("Execute", "cooldown")
	end
end

function IWin:Hamstring()
	if IWin:IsSpellLearnt("Hamstring")
		and IWin:IsInMeleeRange()
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
		and not IWin:IsInMeleeRange()
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
		and IWin:IsRageReservedStance("Battle Stance")
		and IWin:IsDefensiveTacticsActive() then
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
		and IWin:GetTimeToDiePrediction() > 9
		and not UnitInRaid("player")
		and not IWin:IsRageReservedStance("Berserker Stance")
		and not IWin:IsBuffActive("target","Rend")
		and not (
					UnitCreatureType("target") == "undead"
					or UnitCreatureType("target") == "mechanical"
				) then
			IWin_CombatVar["reservedRageStance"] = "Battle Stance"
			if IWin:IsStanceActive("Berserker Stance")
				and IWin:IsStanceSwapMaxRageLoss(0) then
					Cast("Battle Stance")
			end
			if not IWin:IsStanceActive("Berserker Stance") then
				Cast("Rend")
			end
	end
end

function IWin:Revenge()
	if IWin:IsSpellLearnt("Revenge")
		and not IWin:IsOnCooldown("Revenge")
		and IWin:IsRageCostAvailable("Revenge") then
			if not IWin:IsStanceActive("Defensive Stance") then
				Cast("Defensive Stance")
			else
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
		and IWin:GetTimeToDiePrediction() > 10
		and not IWin:IsBuffStack("target", "Sunder Armor", 5) then
			Cast("Sunder Armor")
	end
end

function IWin:SetReservedRageSunderArmorDPS()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:GetTimeToDiePrediction() > 10
		and not IWin:IsBuffStack("target", "Sunder Armor", 5) then
			IWin:SetReservedRage("Sunder Armor", "nocooldown")
	end
end

function IWin:SunderArmorRaid()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageAvailable("Sunder Armor")
		and UnitInRaid("player")
		and IWin:IsElite()
		and not IWin:IsBuffStack("target", "Sunder Armor", 5) then
			Cast("Sunder Armor")
	end
end

function IWin:SunderArmorDPSRefresh()
	if IWin:IsSpellLearnt("Sunder Armor")
		and IWin:IsRageAvailable("Sunder Armor")
		and IWin:GetTimeToDiePrediction() > 10
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
		and not IWin:IsDefensiveTacticsActive() then
			if UnitAffectingCombat("player")
				and not IWin:IsStanceActive("Defensive Stance") then
					Cast("Defensive Stance")
			end
	else
		Cast("Battle Stance")
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
				and IWin:IsInMeleeRange()
				and IWin:IsStanceActive("Berserker Stance") then 
					Cast("Whirlwind")
			end
	end
end

---- idebug button ----
SLASH_IDEBUG1 = '/idebug'
function SlashCmdList.IDEBUG()
	DEFAULT_CHAT_FRAME:AddMessage(IWin:GetCooldownRemaining("Whirlwind"))
end

---- idps button ----
SLASH_IDPS1 = '/idps'
function SlashCmdList.IDPS()
	IWin_CombatVar["reservedRage"] = 0
	IWin_CombatVar["reservedRageStance"] = nil
	IWin:TargetEnemy()
	IWin:BattleShoutRefreshOOC()
	IWin:ChargeOpenWorld()
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
	--IWin:MasterStrike()
	--IWin:SetReservedRage("Master Strike", "cooldown")
	IWin:Overpower()
	IWin:ConcussionBlow()
	IWin:BattleShoutRefresh()
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
	IWin:ChargeOpenWorld()
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
	--IWin:MasterStrike()
	--IWin:SetReservedRage("Master Strike", "cooldown")
	IWin:Overpower()
	IWin:ConcussionBlow()
	IWin:BattleShoutRefresh()
	IWin:DemoralizingShout()
	IWin:SetReservedRage("Demoralizing Shout", "debuff", "target")
	IWin:BerserkerRage()
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
	IWin:TargetEnemy()
	IWin:Charge()
	IWin:Intercept()
	IWin:Hamstring()
	IWin:StartAttack()
end

---- ikick button ----
SLASH_IKICK1 = '/ikick'
function SlashCmdList.IKICK()
	IWin:TargetEnemy()
	IWin:ShieldBash()
	IWin:Pummel()
	IWin:StartAttack()
end

---- ifeardance button ----
SLASH_IFEARDANCE1 = '/ifeardance'
function SlashCmdList.IFEARDANCE()
	IWin:TargetEnemy()
	IWin:BerserkerRageImmune()
	IWin:StartAttack()
end

---- itaunt button ----
SLASH_ITAUNT1 = '/itaunt'
function SlashCmdList.ITAUNT()
	IWin:TargetEnemy()
	IWin:Taunt()
	IWin:MockingBlow()
	IWin:StartAttack()
end

---- ishoot button ----
SLASH_ISHOOT1 = '/ishoot'
function SlashCmdList.ISHOOT()
	IWin:TargetEnemy()
	IWin:MarkSkull()
	IWin:Shoot()
end