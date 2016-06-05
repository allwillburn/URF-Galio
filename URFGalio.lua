if GetObjectName(GetMyHero()) ~= "Galio" then return end

local GalioMenu = Menu("Galio", "Galio")

GalioMenu:SubMenu("Combo", "Combo")

GalioMenu.Combo:Boolean("Q", "Use Q in combo", true)
GalioMenu.Combo:Boolean("W", "Use W in combo", true)
GalioMenu.Combo:Boolean("E", "Use E in combo", true)
GalioMenu.Combo:Boolean("R", "Use R in combo", true)

GalioMenu:SubMenu("Misc", "Misc")
GalioMenu.Misc:Boolean("Level", "Auto level spells", true)
GalioMenu.Misc:Boolean("Ghost", "Auto Ghost", true)
GalioMenu.Misc:Boolean("W", "Auto W", true)
GalioMenu.Misc:Boolean("Q", "Auto Q", true)

OnTick(function (myHero)

	local target = GetCurrentTarget()

	--AUTO LEVEL UP
	if GalioMenu.Misc.Level:Value() then

			spellorder = {_Q, _W, _E, _Q, _W, _R, _Q, _W, _W, _Q, _R, _Q, _W, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end

	end

	--COMBO
	if IOW:Mode() == "Combo" then

		if GalioMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 940) then
			CastTargetSpell(target, _Q)
		end

		if GalioMenu.Combo.W:Value() and Ready(_W) then
			CastSpell(_W)
		end

		if GalioMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1180) then
			CastSkillShot(_E, target.pos)
		end

		if GalioMenu.Combo.R:Value() and Ready(_R) then
			CastSpell(_R)
		end

	end

        --AUTO QW
        if GalioMenu.Misc.W:Value() then
            
                if Ready(_W) then
		        CastSpell(_W)
	        end

        end

        if GalioMenu.Misc.Q:Value() then

                if Ready(_Q) and ValidTarget(target, 940) then
                        CastTargetSpell(target, _Q)
                end

        end

	--AUTO IGNITE
	if GalioMenu.Misc.Ghost:Value() then

		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end

	end

end)

