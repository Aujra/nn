local hr = tt
local hr = tt.hr
tt.hr = hr


function tt:MageRotation()
    local player = tt.Classes.LocalPlayer
    local target = UnitTarget("player")

    if not target then
        return
    end

    if player:IsCasting() then
        return
    end

    if UnitAffectingCombat("player") then
        tt:Cast("Blazing Barrier", "player")
        if player:HasAura("Hot Streak!", "HELPFUL") or player:HasAura("Hyperthermia", "HELPFUL") then
            tt:Cast("Pyroblast", "target")
        end
        if player:HasAura("Heating Up", "HELPFUL") then
            tt:Cast("Fire Blast", "target")
        end
        tt:Cast("Phoenix Flames", "target")
        if GetUnitSpeed("player") > 0 then
            tt:Cast("Scorch", "target")
        end
        tt:Cast("Fireball", "target")
    end
end

function GetClosestCaster()
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.Units) do
        if v.Reaction <= 4 and UnitAffectingCombat(v.pointer) and
        v:ShouldInterruptCasting() and v:DistanceFromPlayer() < 30 then
            print("Found caster " .. v.Name)
            local distance = v:DistanceFromPlayer()
            if distance < closestDistance then
                closest = v
                closestDistance = distance
            end
        end
    end
    return closest
end