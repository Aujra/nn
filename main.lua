local nn = ...

tt = {}
tt.lastTime = 0
tt.lastmount = 0
tt.OM = {}
tt.nn = nn

tt.Classes = {}
tt.UI = {}
tt.LocalPlayer = nil

tt.Draw = nil

tt.running = true

nn:Require("/scripts/nn/class.lua", tt)
nn:Require("/scripts/nn/Engine/OM.lua", tt)
nn:Require("/scripts/nn/class.lua")
nn:Require("/scripts/nn/Classes/GameObject.lua", tt)
nn:Require("/scripts/nn/Classes/Unit.lua", tt)
nn:Require("/scripts/nn/Classes/Player.lua", tt)
nn:Require("/scripts/nn/Classes/LocalPlayer.lua", tt)
nn:Require("/scripts/nn/Classes/Spot.lua", tt)

nn:Require("/scripts/nn/Rotations/HunterRotation.lua", tt)
nn:Require("/scripts/nn/Rotations/MageRotation.lua", tt)
nn:Require("/scripts/nn/Rotations/PriestRotation.lua", tt)
nn:Require("/scripts/nn/Rotations/MonkRotation.lua", tt)
nn:Require("/scripts/nn/Rotations/WarriorRotation.lua", tt)

nn:Require("/scripts/nn/Libs/ScrollingTable.lua", tt)

nn:Require("/scripts/nn/UI/UnitViewer.lua", tt)
nn:Require("/scripts/nn/UI/StatusBar.lua", tt)

local statusFrame = CreateFrame("Frame")


tt.frame = CreateFrame("Frame", "tt", UIParent)
tt.frame:SetScript("OnUpdate", function(self, elapsed)

    if GetTime() - tt.lastTime < 0.1 then
        return
    end

    tt.lastTime = GetTime()
    if not tt.running then
        return
    end
    if not tt.Draw then
        tt.Draw = nn.Utils.Draw:New()
    end

    if tt.Draw then
        tt.Draw:ClearCanvas()
    end
    tt.Classes.LocalPlayer:Update(player)
    tt.OM:Update()
    tt.UI.UnitViewer:UpdateUnits()

    --tt:HandleBG()
    --tt:HandleDungeon()
    tt:DoRotation()
end)

function tt:HandleDungeon()
    local closestEnemy = nil
    local closestDistance = 9999
    for k,v in pairs(tt.OM.Units) do
        if v.Enemy and not v.IsDead then
            local distance = v:DistanceFromPlayer()
            if distance < closestDistance then
                closestEnemy = v
                closestDistance = distance
            end
        end
    end
    if closestEnemy then
        if closestEnemy:DistanceFromPlayer() > 30 then
            tt:NavTo(closestEnemy.x, closestEnemy.y, closestEnemy.z)
        else
            --Unlock(MoveForwardStop)
            Unlock(TargetUnit, closestEnemy.pointer)
            if not UnitAffectingCombat("player") and closestEnemy then
                tt:Cast("Fire Blast", "target")
            end
            local px, py, pz = ObjectPosition("player")
            local dx, dy, dz = px-closestEnemy.x, py-closestEnemy.y, pz-closestEnemy.z
            local radians = math.atan2(-dy, -dx)
            tt.nn.SetPlayerFacing(radians)
            self:DoRotation()
        end
    end
    if closestEnemy then
        tt.Draw:Line(tt.Classes.LocalPlayer.x, tt.Classes.LocalPlayer.y, tt.Classes.LocalPlayer.z, closestEnemy.x, closestEnemy.y, closestEnemy.z)
    end
end

function tt:HandleBG()
    if not UnitInBattleground("player") then
        if HonorFrameQueueButton == nil or not HonorFrameQueueButton:IsVisible() and GetBattlefieldStatus(1) ~= "queued" then
            TogglePVPUI()
        end
        if GetBattlefieldStatus(1) ~= "queued" and GetBattlefieldStatus(1) ~= "confirm"
        then
            Unlock(RunMacroText, "/click HonorFrameQueueButton")
        end
        if GetBattlefieldStatus(1) == "queued" then
            if PVPQueueFrame ~= nil and PVPQueueFrame:IsVisible() then
                TogglePVPUI()
            end
        end
        if GetBattlefieldStatus(1) == "confirm" then
            Unlock(AcceptBattlefieldPort, 1, true)
        end
    end
    if GetBattlefieldWinner() then
        LeaveBattlefield()
        return
    end
    if UnitIsDeadOrGhost("player") then
        Unlock(MoveForwardStop)
        RepopMe()
        return
    end
    if TimerTrackerTimer1 ~= nil and TimerTrackerTimer1.barShowing then
        Unlock(MoveForwardStop)
        return
    end

    local bestScoreUnit = nil
    local bestScore = 0
    for k,v in pairs(tt.OM.Players) do
        if v.Enemy and not UnitIsDead(v.pointer) then
            if v.Score > bestScore then
                bestScore = v.Score
                bestScoreUnit = v
            end
        end
    end

    local movespot = {}
    local spot = tt.Classes.Spot(628.09710693359, 230.25869750977, 328.99182128906, 727, 675.06805419922, 222.31399536133, 319.90646362305)
    local spots = tt.Classes.Spot(1816.8699951172, 160.08299255371, 1.8064399957657, 726, 1812.6453857422, 200.64604187012, -20.939380645752)
    local spot2 = tt.Classes.Spot(1061.9154052734, 1378.19140625, 328.5080871582, 726, 1090.0329589844, 1397.9826660156, 319.44784545898)
    tinsert(movespot, spot)
    tinsert(movespot, spots)
    tinsert(movespot, spot2)

    for k,v in pairs(movespot) do
        local x,y,z = ObjectPosition("player")
        local distance = math.sqrt((x - v.x)^2 + (y - v.y)^2 + (z - v.z)^2)
        if distance < 50 then
            print("Moving to spot since shit")
            local dx, dy, dz = v.x-v.facex, v.y-v.facey, v.z-v.facez
            local radians = math.atan2(-dy, -dx)
            tt.nn.SetPlayerFacing(radians)
            Unlock(MoveForwardStart)
            return
        end
    end

        if bestScoreUnit then
        if bestScoreUnit.Distance > 30 then
            tt:NavTo(bestScoreUnit.x, bestScoreUnit.y, bestScoreUnit.z)
        end
        if bestScoreUnit.Distance < 30 then
            Unlock(MoveForwardStop)
            Unlock(TargetUnit, bestScoreUnit.pointer)
            if not UnitAffectingCombat("player") and bestScoreUnit then
                tt:Cast("Fire Blast", "target")
            end
            local px, py, pz = ObjectPosition("player")
            local dx, dy, dz = px-bestScoreUnit.x, py-bestScoreUnit.y, pz-bestScoreUnit.z
            local radians = math.atan2(-dy, -dx)
            tt.nn.SetPlayerFacing(radians)
            self:DoRotation()
        end
    end
    tt.Draw:ClearCanvas()
    if bestScoreUnit then
        tt.Draw:Line(tt.Classes.LocalPlayer.x, tt.Classes.LocalPlayer.y, tt.Classes.LocalPlayer.z, bestScoreUnit.x, bestScoreUnit.y, bestScoreUnit.z)

    end
end

function tt:NavTo(x,y,z)
    tt.mountID = nil
    if tt.mountID == nil then
        for i = 1, C_MountJournal.GetNumMounts(), 1 do
            local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(i)
            if isUsable and isCollected then
                tt.mountID = i
                break
            end
        end
    end
    local _, _, _, _, _, _, _, mapId = GetInstanceInfo()
    local path = GenerateLocalPath(mapId,px,py,pz,x,y,z)
    if #path > 1 then
        local pathIndex = 2
        local function distance3D(x1, y1, z1, x2, y2, z2)
            local dx = x2 - x1
            local dy = y2 - y1
            local dz = z2 - z1
            return math.sqrt(dx*dx + dy*dy + dz*dz)
        end
        local px, py, pz = ObjectPosition("player")
        local tx = tonumber(path[pathIndex].x)
        local ty = tonumber(path[pathIndex].y)
        local tz = tonumber(path[pathIndex].z)
        local distance = distance3D(px, py, pz, tx, ty, tz)
        if distance < 5 then
            if pathIndex >= #path then
                Unlock(MoveForwardStop)
                return
            end
            pathIndex = pathIndex + 1
        end
        local dx, dy, dz = px-tx, py-ty, pz-tz
        local radians = math.atan2(-dy, -dx)
        tt.nn.SetPlayerFacing(radians)
        Unlock(MoveForwardStart)
    end
end

function tt:DoRotation()
    local player = tt.Classes.LocalPlayer
    local class = player.Class
    if class == "Warrior" then
        tt:WarriorRotation()
    end
    if class == "Mage" then
        tt:MageRotation()
    end
    if class == "Rogue" then
        tt:RogueRotation()
    end
    if class == "Priest" then
        tt:PriestRotation()
    end
    if class == "Hunter" then
        tt:HunterRotation()
    end
    if class == "Monk" then
        tt:MonkRotation()
    end
end

tt.frame:SetScript("OnKeyDown", function(self, key)
    if key == "`" then
        print("Hotkey toggling bot " .. (tt.running and "off" or "on"))
        tt.running = not tt.running
    end
    tt.frame:SetPropagateKeyboardInput(true)
end)

local oldprint = print
print = function(...)
    if lastmessage ~= ... then
        lastmessage = ...
        oldprint(...)
    end
end

--Combat Helpers
function tt:Cast(spell, target)
    target = target or "target"
    Unlock(CastSpellByName, spell, target)
    return false
end

function tt:LowestHealthPlayer()
    local party = tt.Party
    local lowestHealth = 100
    local lowestHealthPlayer = nil
    for k,v in pairs(party) do
        if v.HP < lowestHealth and v:DistanceFromPlayer() < 30 then
            lowestHealth = v.HP
            lowestHealthPlayer = v
        end
    end
    if lowestHealthPlayer and tt.Classes.LocalPlayer.HP < lowestHealthPlayer.HP then
        lowestHealthPlayer = tt.Classes.LocalPlayer
    end
    return lowestHealthPlayer
end

function tt:EnemyDoesNotHaveAura(aura)
    for k,v in pairs(tt.OM.Units) do
        if v.Enemy and not v:HasAura(aura, "HARMFUL") and v:DistanceFromPlayer() < 25 and Unlock(UnitAffectingCombat, v.pointer) then
            return v
        end
    end
    return nil
end

function tt:EnemyHasAura(aura)
    for k,v in pairs(tt.OM.Units) do
        if v.Enemy and v:HasAura(aura, "HARMFUL") and v:DistanceFromPlayer() < 25 then
            return v
        end
    end
    return nil
end

function tt:NumberFriendlyHasAura(aura)
    local count = 0
    for k,v in pairs(tt.Party) do
        if v:HasAura(aura, "HELPFUL") then
            count = count + 1
        end
    end
    return count
end

function tt:ClosestCastingEnemy(dist)
    dist = dist or 30
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.OM.Units) do
        if v.Enemy and UnitAffectingCombat(v.pointer) and
        v:ShouldInterruptCasting() and v:DistanceFromPlayer() < dist then
            local distance = v:DistanceFromPlayer()
            if distance < closestDistance then
                closest = v
                closestDistance = distance
            end
        end
    end
    return closest
end

function tt:NumberUnderHP(hp)
    local count = 0
    for k,v in pairs(tt.Party) do
        if v.HP < hp then
            count = count + 1
        end
    end
    return count
end