local hr = tt
local hr = tt.hr
tt.hr = hr


function tt:HunterRotation()
    local player = tt.Classes.LocalPlayer
    local target = UnitTarget("player")
    target = tt.Units[target]
    if not target then
        return
    end
    local pet = UnitName("pet")
    local unitaround = target:EnemiesInRange(35)

    if player:IsCasting() then
        return
    end

    local closestCaster = GetClosestCaster()

    if closestCaster then
        print("Interrupting " .. closestCaster.Name)
        tt:Cast("Counter Shot", closestCaster.pointer)
    end

    if UnitAffectingCombat("player") then
        if target.HP > 80 and not target:HasAura("Hunter's Mark", "HARMFUL") then
            tt:Cast("Hunter's Mark")
        end
        if (UnitHealth("player") / UnitHealthMax("player") * 100) < 50 then
            tt:Cast("Exhilaration")
        end
        if pet and not UnitIsDead("pet") and (UnitHealth("pet") / UnitHealthMax("pet") * 100) < 90 then
            tt:Cast("Mend Pet")
        end
        if target:ShouldInterruptCasting() then
            tt:Cast("Counter Shot")
        end
        tt:Cast("Trueshot")
        tt:Cast("Kill Shot")
        if player:HasAura("Precise Shots", "HELPFUL") then
            if unitaround > 2 then
                tt:Cast("Multi-Shot")
            else
                tt:Cast("Arcane Shot")
            end
        end
        tt:Cast("Wailing Arrow")
        tt:Cast("Rapid Fire")
        tt:Cast("Aimed Shot")
        tt:Cast("Explosive Shot")
        tt:Cast("Trueshot")
        tt:Cast("Kill Shot")
        tt:Cast("Wailing Arrow")
        tt:Cast("Rapid Fire")
        tt:Cast("Aimed Shot")
        tt:Cast("Explosive Shot")

        if unitaround > 2 then
            tt:Cast("Multi-Shot")
        else
            tt:Cast("Arcane Shot")
        end
        tt:Cast("Steady Shot")
    end
end

function GetClosestCaster()
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.Units) do
        if v.Reaction <= 4 and UnitAffectingCombat(v.pointer) and
        v:ShouldInterruptCasting() then
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