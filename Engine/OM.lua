local om = tt
local OM = tt.OM
tt.OM = OM

tt.GameObjects = {}
tt.Units = {}
tt.Players = {}
tt.LocalPlayer = {}

OM.GameObjects = tt.GameObjects
OM.Units = tt.Units
OM.Players = tt.Players
OM.LocalPlayer = tt.LocalPlayer

function OM:Update()
    local objects = Objects()
    local gameobjects = tt.nn.ObjectManager("GameObject" or 8)
    local units = tt.nn.ObjectManager(5)
    local players = tt.nn.ObjectManager(6)

    --OM:CleanOM()

    for v,k in pairs(gameobjects) do
        if not self.GameObjects[k] then
            self.GameObjects[k] = tt.Classes.GameObject:new(k)
        else
            self.GameObjects[k]:Update()
        end
    end
    for v,k in pairs(units) do
        if not self.Units[k] then
            self.Units[k] = tt.Classes.Unit:new(k)
        else
            self.Units[k]:Update()
        end
    end
    for v,k in pairs(players) do
        if not self.Players[k] then
            self.Players[k] = tt.Classes.Player:new(k)
        else
            self.Players[k]:Update()
        end
    end
end

function OM:CleanOM()
    for v,k in pairs(self.GameObjects) do
        if not tt.nn:ObjectExists(k) then
            self.GameObjects[k] = nil
        end
    end
    for v,k in pairs(self.Units) do
        if not tt.nn:ObjectExists(k) then
            self.Units[k] = nil
        end
    end
    for v,k in pairs(self.Players) do
        if not tt.nn:ObjectExists(k) then
            self.Players[k] = nil
        end
    end
end