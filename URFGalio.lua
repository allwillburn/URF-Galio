if GetObjectName(GetMyHero()) ~= "Garen" then return end

local GarenMenu = Menu("Garen", "Garen")

GarenMenu:SubMenu("Combo", "Combo")

GarenMenu.Combo:Boolean("Q", "Use Q in combo", true)
GarenMenu.Combo:Boolean("W", "Use W in combo", true)
GarenMenu.Combo:Boolean("E", "Use E in combo", true)
GarenMenu.Combo:Boolean("R", "Use R in combo", true)

GarenMenu:SubMenu("Misc", "Misc")
GarenMenu.Misc:Boolean("Level", "Auto level spells", true)
GarenMenu.Misc:Boolean("Ghost", "Auto Ghost", true)
GarenMenu.Misc:Boolean("QWE", "Auto QWE", true)

OnTick(function (myHero)

	local target = GetCurrentTarget()

	--AUTO LEVEL UP
	if GarenMenu.Misc.Level:Value() then

			spellorder = {_Q, _W, _E, _Q, _W, _R, _Q, _W, _W, _Q, _R, _Q, _W, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end

	end

	--COMBO
	if IOW:Mode() == "Combo" then

		if GarenMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
			CastSpell(_Q)
		end

		if GarenMenu.Combo.W:Value() and Ready(_W) then
			CastSpell(_W)
		end

		if GarenMenu.Combo.E:Value() and Ready(_E) then
			CastSpell(_E)
		end

		if GarenMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 400) then
			CastTargetSpell(target, _R)

		end

	end

        --AUTO QWE
        if GarenMenu.Misc.QWE:Value() then        

                if Ready(_E) and ValidTarget(target, 1000) then
		        CastSpell(_E)
                end

                if Ready(_Q) then
	  	        CastSpell(_Q)
                end

	        if Ready(_W) then
		        CastSpell(_W)
	        end

        end

	--AUTO IGNITE
	if GarenMenu.Misc.Ghost:Value() then

		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end

	end

end)
