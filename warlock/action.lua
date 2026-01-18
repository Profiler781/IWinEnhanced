if UnitClass("player") ~= "Warlock" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
end

function IWin:DemonArmor()
	if IWin:IsSpellLearnt("Demon Armor")
		and not IWin:IsBuffActive("player", "Demon Armor") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Demon Armor")
	end
end

function IWin:DrainSoul()
	if IWin:IsSpellLearnt("Drain Soul")
		and IWin:GetItemCountInBag("Soul Shard") < 12
		and IWin:GetTimeToDie() < 8 then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Drain Soul")
	end
end

function IWin:Firestone()
	if IWin:IsSpellLearnt("Create Firestone")
		and not IWin:IsBuffActive("player", "Firestone") then
			if IWin:IsItemInBag("Firestone") then
				IWin_CombatVar["queueGCD"] = false
				UseItem("Firestone")
			elseif IWin:IsItemInBag("Soul Shard")
				and not UnitAffectingCombat("player")
				and not UnitAffectingCombat("target") then
					IWin_CombatVar["queueGCD"] = false
					CastSpellByName("Create Firestone")
			end
	end
end

function IWin:Immolate()
	if IWin:IsSpellLearnt("Immolate")
		and not IWin:IsBuffActive("target", "Immolate", "player") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Immolate")
	end
end

function IWin:ShadowBolt()
	if IWin:IsSpellLearnt("Shadow Bolt") then
		IWin_CombatVar["queueGCD"] = false
		CastSpellByName("Shadow Bolt")
	end
end

function IWin:SummonImp()
	if IWin:IsSpellLearnt("Summon Imp")
		and not HasPetUI()
		and not UnitAffectingCombat("player") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Summon Imp")
	end
end

function IWin:SummonVoidwalker()
	if IWin:IsSpellLearnt("Summon Voidwalker")
		and not HasPetUI()
		and IWin:IsItemInBag("Soul Shard")
		and not UnitAffectingCombat("player") then
			IWin_CombatVar["queueGCD"] = false
			CastSpellByName("Summon Voidwalker")
	end
end