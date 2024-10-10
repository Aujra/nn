local hr = tt
local hr = tt.hr
tt.hr = hr


function tt:PriestRotation()
    local player = tt.Classes.LocalPlayer
    local target = UnitTarget("player")

    if player:IsCasting() then
        return
    end

    target = tt.Units[target]

    local lowestHealthPlayer = tt:LowestHealthPlayer()

    local spec = GetSpecialization()
    local specName = spec and select(2, GetSpecializationInfo(spec))

    local under70 = tt:NumberUnderHP(85)
    local notPurged = tt:EnemyDoesNotHaveAura("Purge the Wicked")

    tt:SetStatusBarText("Priest " .. specName)

    if specName == "Discipline" then
        if UnitAffectingCombat("player") then
            if lowestHealthPlayer and lowestHealthPlayer.HP < 40 then
                lowestHealthPlayer:CastOn("Flash Heal")
            end
            if lowestHealthPlayer and lowestHealthPlayer.HP < 70 and not lowestHealthPlayer:HasAura("Renew", "HELPFUL") then
                lowestHealthPlayer:CastOn("Renew")
            end
            if lowestHealthPlayer and lowestHealthPlayer.HP < 80 then
                lowestHealthPlayer:CastOn("Power Word: Shield")
            end
            if lowestHealthPlayer and under70 >= 3 then
                lowestHealthPlayer:CastOn("Power Word: Radiance")
            end
            if target then
                if not target:HasAura("Purge the Wicked", "HARMFUL") then
                    tt:Cast("Purge the Wicked", "target")
                end
                tt:Cast("Mindbender", "target")
                tt:Cast("Shadow Word: Death", "target")
                tt:Cast("Mind Blast", "target")
                tt:Cast("Penance", "target")
                tt:Cast("Smite", "target")
            end
        end
    end

    if specName == "Holy" then
        if UnitAffectingCombat("player") then
            if lowestHealthPlayer and lowestHealthPlayer.HP < 60 then
                lowestHealthPlayer:CastOn("Flash Heal")
            end
            if lowestHealthPlayer and lowestHealthPlayer.HP < 90 and not lowestHealthPlayer:HasAura("Renew", "HELPFUL") then
                lowestHealthPlayer:CastOn("Renew")
            end
            if lowestHealthPlayer and lowestHealthPlayer.HP < 85 and not lowestHealthPlayer:HasAura("Prayer of Mending", "HELPFUL") then
                lowestHealthPlayer:CastOn("Prayer of Mending")
            end
            if target then
                if not target:HasAura("Shadow Word: Pain", "HARMFUL") then
                    tt:Cast("Shadow Word: Pain", "target")
                end
                tt:Cast("Holy Fire", "target")
                tt:Cast("Smite", "target")
            end
        end
    end

    if specName == "Shadow" then
        if UnitAffectingCombat("player") and target then
            if not player:HasAura("Shadowform", "HELPFUL") then
                tt:Cast("Shadowform")
            end
            tt:Cast("Power Word: Shield", "player")
            if not target:HasAura("Shadow Word: Pain", "HARMFUL") then
                tt:Cast("Shadow Word: Pain", "target")
            end
            if not target:HasAura("Devouring Plague", "HARMFUL") then
                tt:Cast("Devouring Plague", "target")
            end
            tt:Cast("Mind Blast", "target")
            if not target:HasAura("Vampiric Touch", "HARMFUL") then
                tt:Cast("Vampiric Touch", "target")
            end
            tt:Cast("Mind Flay", "target")
        end
    end
    tt:Debug()
end

function tt:Debug()
    local debugtext = "Priest Rotation"
    local under70 = tt:NumberUnderHP(85)
    local closestCaster = tt:ClosestCastingEnemy()
    local notPurged = tt:EnemyDoesNotHaveAura("Purge the Wicked")

    debugtext = debugtext .. " Under 70: " .. under70 .. " /// Closest Caster: "
    if closestCaster then
        debugtext = debugtext .. closestCaster.Name
    else
        debugtext = debugtext .. "None"
    end
    debugtext = debugtext .. " /// Not Purged: "
    if notPurged then
        debugtext = debugtext .. notPurged.Name
    else
        debugtext = debugtext .. "None"
    end
    tt:SetStatusBarText(debugtext)
end