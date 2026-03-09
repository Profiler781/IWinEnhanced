if UnitClass("player") ~= "Shaman" then return end

function IWin:InitializeRotation()
	IWin:InitializeRotationCore()
end

function IWin:ChainLightning()
	local spell = "Chain Lightning"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:Earthquake()
	local spell = "Earthquake"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:LightningBolt()
	local spell = "Lightning Bolt"
	if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	IWin:Cast(spell)
end

function IWin:MoltenBlast()
	local spell = "Molten Blast"
	--if IWin:IsSpellSkip(spell, nil, true, queueTime, true) then return end
	if IWin:GetBuffRemaining("target", "Flame Shock", "player") > 4
		and IWin:GetBuffRemaining("target", "Flame Shock", "player") < 6 then
			IWin:Cast(spell)
	end
end