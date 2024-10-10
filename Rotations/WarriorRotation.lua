local hr = tt
local hr = tt.hr
tt.hr = hr


function tt:WarriorRotation()
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
    local around = target and target:UnitsInRange(20)
    local closestCaster = tt:ClosestCastingEnemy(10)

    tt:SetStatusBarText("Warrior " .. specName)

    if UnitAffectingCombat("player") then
        if (UnitHealth("player") / UnitHealthMax("player") * 100) < 65 then
            tt:Cast("Last Stand")
        end
        if (UnitHealth("player") / UnitHealthMax("player") * 100) < 49 then
            tt:Cast("Shield Wall")
        end
        if closestCaster then
            tt:Cast("Pummel", closestCaster.Name)
            tt:Cast("Spell Reflection")
        end
        tt:Cast("Victory Rush")
        if IsSpellInRange("Shield Slam", "target") then
            tt:Cast("Shockwave")
            tt:Cast("Storm Bolt")
            tt:Cast("Demoralizing Shout")
            tt:Cast("Thunder Clap")
            if not player:HasAura("Shield Block", "HELPFUL") then
                tt:Cast("Shield Block")
            end
            if not player:HasAura("Ignore Pain", "HELPFUL") then
                tt:Cast("Ignore Pain")
            end
            tt:Cast("Shield Charge")
            tt:Cast("Shield Slam")
            tt:Cast("Revenge")
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