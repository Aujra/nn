local hr = tt
local hr = tt.hr
tt.hr = hr


function tt:MonkRotation()
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

    tt:SetStatusBarText("Priest " .. specName)

    if UnitAffectingCombat("player") then
        if player:HasAura("Moderate Stagger", "HARMFUL") then
            tt:Cast("Purifying Brew", "player")
        end
        tt:Cast("Touch of Death", "target")
        tt:Cast("Expel Harm", "target")
        tt:Cast("Blackout Kick", "target")
        tt:Cast("Keg Smash", "target")
        tt:Cast("Breath of Fire", "target")
        tt:Cast("Weapon of Order", "target")
        tt:Cast("Rising Sun Kick", "target")
        tt:Cast("Chi Burst", "target")
        tt:Cast("Rushing Jade Wind", "target")
        tt:Cast("Tiger Palm", "target")
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