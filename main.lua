local nn = ...

tt = {}
tt.lastTime = 0
tt.OM = {}
tt.nn = nn

tt.Classes = {}
tt.UI = {}
tt.LocalPlayer = nil

tt.Draw = nil

tt.running = false

nn:Require("/scripts/nn/class.lua", tt)
nn:Require("/scripts/nn/Engine/OM.lua", tt)
nn:Require("/scripts/nn/class.lua")
nn:Require("/scripts/nn/Classes/GameObject.lua", tt)
nn:Require("/scripts/nn/Classes/Unit.lua", tt)
nn:Require("/scripts/nn/Classes/Player.lua", tt)
nn:Require("/scripts/nn/Classes/LocalPlayer.lua", tt)

nn:Require("/scripts/nn/Rotations/HunterRotation.lua", tt)

nn:Require("/scripts/nn/Libs/ScrollingTable.lua", tt)
nn:Require("/scripts/nn/Libs/SearchTable.lua", tt)
nn:Require("/scripts/nn/UI/UnitViewer.lua", tt)

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
    --tt.UI.UnitViewer:UpdateUnits()
    tt:DoRotation()
end)

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
    Unlock("CastSpellByName", spell, target)
    return false
end