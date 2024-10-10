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
    local unitaround = target:EnemiesInRange(25)

    if player:IsCasting() then
        return
    end

    local closestCaster = tt:ClosestCastingEnemy()
    local spec = GetSpecialization()
    local specName = spec and select(2, GetSpecializationInfo(spec))

    if specName == "Marksmanship" then
    end
    if UnitAffectingCombat("player") then
        if target.HP > 80 and not target:HasAura("Hunter's Mark", "HARMFUL") then
            tt:Cast("Hunter's Mark")
        end
        if (UnitHealth("player") / UnitHealthMax("player") * 100) < 30 then
            tt:Cast("Fortitude of the Bear")
        end
        if (UnitHealth("player") / UnitHealthMax("player") * 100) < 50 then
            tt:Cast("Exhilaration")
        end
        if (UnitHealth("player") / UnitHealthMax("player") * 100) < 60 and not player:HasAura("Survival of the Fittest", "HELPFUL") then
            tt:Cast("Survival of the Fittest")
        end
        if pet and not UnitIsDead("pet") and (UnitHealth("pet") / UnitHealthMax("pet") * 100) < 90 then
            tt:Cast("Mend Pet")
        end
        if closestCaster then
            tt:Cast("Counter Shot", closestCaster.pointer)
        end

        if IsPlayerSpell(193533) and not player:HasAura("Steady Focus", "HELPFUL") then
            print("Steady Focus")
            tt:Cast("Steady Shot")
        end
        tt:Cast("Kill Shot")
        tt:Cast("Rapid Fire")
        Unlock(RunMacroText, "/use 13")
        Unlock(RunMacroText, "/use 14")
        tt:Cast("Trueshot")
        tt:Cast("Wailing Arrow")
        tt:Cast("Aimed Shot")
        if player:HasAura("Precise Shots", "HELPFUL") and player.Focus > 55 then
            if unitaround > 2 then
                tt:Cast("Multi-Shot")
            else
                tt:Cast("Arcane Shot")
            end
        end
        tt:Cast("Explosive Shot")
        tt:Cast("Steady Shot")
    end
end

function GetClosestCaster()
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.Units) do
        if v.Reaction <= 4 and UnitAffectingCombat(v.pointer) and
        v:ShouldInterruptCasting() and v:DistanceFromPlayer() < 30 then
            local distance = v:DistanceFromPlayer()
            if distance < closestDistance then
                closest = v
                closestDistance = distance
            end
        end
    end
    return closest
end