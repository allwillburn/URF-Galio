	local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Galio" then return end

require("OpenPredict")
require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Galio/master/Galio.lua', SCRIPT_PATH .. 'Galio.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Galio/master/Galio.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local GalioQ = {delay = .5, range = 850, width = 250, speed = 1200}
local GalioR = {delay = 2, range = 4000, width = 600, speed = 1500}

local GalioMenu = Menu("Galio", "Galio")

GalioMenu:SubMenu("Combo", "Combo")

GalioMenu.Combo:Boolean("Q", "Use Q in combo", true)
GalioMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
GalioMenu.Combo:Boolean("W", "Use W in combo", true)
GalioMenu.Combo:Boolean("E", "Use E in combo", true)
GalioMenu.Combo:Boolean("R", "Use R in combo", false)
GalioMenu.Combo:Slider("Rpred", "R Hit Chance", 3,0,10,1)
GalioMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
GalioMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
GalioMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
GalioMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
GalioMenu.Combo:Boolean("RHydra", "Use RHydra", true)
GalioMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
GalioMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
GalioMenu.Combo:Boolean("Randuins", "Use Randuins", true)

GalioMenu:SubMenu("AutoMode", "AutoMode")
GalioMenu.AutoMode:Boolean("Level", "Auto level spells", false)
GalioMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
GalioMenu.AutoMode:Boolean("Q", "Auto Q", false)
GalioMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
GalioMenu.AutoMode:Boolean("W", "Auto W", false)
GalioMenu.AutoMode:Boolean("E", "Auto E", false)
GalioMenu.AutoMode:Boolean("R", "Auto R", false)

GalioMenu:SubMenu("LaneClear", "LaneClear")
GalioMenu.LaneClear:Boolean("Q", "Use Q", true)
GalioMenu.LaneClear:Boolean("W", "Use W", true)
GalioMenu.LaneClear:Boolean("E", "Use E", true)
GalioMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
GalioMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

GalioMenu:SubMenu("Harass", "Harass")
GalioMenu.Harass:Boolean("Q", "Use Q", true)
GalioMenu.Harass:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
GalioMenu.Harass:Boolean("W", "Use W", true)

GalioMenu:SubMenu("KillSteal", "KillSteal")
GalioMenu.KillSteal:Boolean("Q", "KS w Q", true)
GalioMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
GalioMenu.KillSteal:Boolean("E", "KS w E", true)

GalioMenu:SubMenu("AutoIgnite", "AutoIgnite")
GalioMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

GalioMenu:SubMenu("Drawings", "Drawings")
GalioMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

GalioMenu:SubMenu("SkinChanger", "SkinChanger")
GalioMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
GalioMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 6, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

GalioMenu:SubMenu("", "")

GalioMenu:SubMenu("", "")

GalioMenu:SubMenu("Warning Using R in Combo May Get You Banned ", "Warning Using R in Combo May Get You Banned ")

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local ally = ClosestAlly

	--AUTO LEVEL UP
	if GalioMenu.AutoMode.Level:Value() then

			spellorder = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if GalioMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 850) then
                local QPred = GetPrediction(target,GalioQ)
                       if QPred.hitChance > (GalioMenu.Harass.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
            end
            if GalioMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 500) then
				CastSpell(_W)
            end     
          end

	--COMBO
		
	  
	  if Mix:Mode() == "Combo" then
            if GalioMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if GalioMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if GalioMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if GalioMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if GalioMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 500) then
			 CastSkillShot(_E, target)
	    end

           
            if GalioMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 850) then
                local QPred = GetPrediction(target,GalioQ)
                       if QPred.hitChance > (GalioMenu.Combo.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
            end
            if GalioMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if GalioMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if GalioMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if GalioMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 500) then
			CastSpell(_W)
	    end
	    
	    local ally = ClosestAlly
            if GalioMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 4000) and (EnemiesAround(myHeroPos(), 4000) >= GalioMenu.Combo.RX:Value()) then
			local RPred = GetPrediction(target,GalioR)
                       if QPred.hitChance > (GalioMenu.Combo.Rpred:Value() * 0.1) then
                                 CastTargetSpell(_R,RPred.castPos)
                       end
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 825) and GalioMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         local QPred = GetPrediction(target,GalioQ)
                       if QPred.hitChance > (GalioMenu.KillSteal.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
            end

                if IsReady(_E) and ValidTarget(enemy, 500) and GalioMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if GalioMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 825) then
	        	CastSkillShot(_Q, closeminion)
                end

                if GalioMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 200) then
	        	CastSpell(_W)
	        end

                if GalioMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 500) then
	        	CastSkillShot(_E, target)
	        end

                if GalioMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if GalioMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if GalioMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, ) then
		      local QPred = GetPrediction(target,GalioQ)
                       if QPred.hitChance > (GalioMenu.AutoMode.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end
            end
        if GalioMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 500) then
	  	      CastSpell(_W)
          end
        end
        if GalioMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 500) then
		      CastSkillShot(_E, target)
	  end
        end
        if GalioMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 4000) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if GalioMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if GalioMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 850, 0, 200, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
               

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if GalioMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Galio</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





