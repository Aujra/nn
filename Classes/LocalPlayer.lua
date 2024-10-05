local player = tt
tt.Classes.LocalPlayer = class({}, "LocalPlayer")
local LocalPlayer = tt.Classes.LocalPlayer

function LocalPlayer:init(pointer)
    self.Name = UnitName(pointer)
    self.Level = UnitLevel(pointer)
    self.Class = UnitClass(pointer)
    self.x, self.y, self.z = ObjectPosition(pointer)
    self.Health = UnitHealth(pointer)
    self.MaxHealth = UnitHealthMax(pointer)
    self.HP = (self.Health / self.MaxHealth) * 100
end

function LocalPlayer:Update(pointer)
    self.Name = UnitName("player")
    self.Class = UnitClass("player")
    self.Level = UnitLevel("player")
    self.x, self.y, self.z = ObjectPosition("player")
    self.Health = UnitHealth("player")
    self.MaxHealth = UnitHealthMax("player")
    self.HP = (self.Health / self.MaxHealth) * 100
    self.IsMoving = GetUnitSpeed("player") > 0
end

function LocalPlayer:DistanceFromPlayer()
    return 0
end

function LocalPlayer:DistanceFrom(unit)
    local x1, y1, z1 = self.x, self.y, self.z
    local x2, y2, z2 = unit.x, unit.y, unit.z
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function LocalPlayer:UnitsInRange(range)
    local units = {}
    for k,v in pairs(tt.OM.Units) do
        if v.Distance <= range then
            table.insert(units, v)
        end
    end
    return units
end

function LocalPlayer:HasAura(name, filter)
    local aname = AuraUtil.FindAuraByName(name, "player", filter)
    return aname ~= nil
end

function LocalPlayer:IsCasting()
    local name, _, _, _, _, _, _, _, _ = UnitCastingInfo("player")
    local channel = UnitChannelInfo("player")
    if name or channel then
        return true
    end
    return false
end

function LocalPlayer:Debug()
    local debugtext = "Name: " .. self.Name .. " Level: " .. self.Level
    debugtext = debugtext .. "\n Distance: " .. tostring(self.Distance)
    debugtext = debugtext .. "\n UnitsInRange: " .. tostring(#self:UnitsInRange(30))
    if tt.Draw then
        local x1, y1, z1 = self.x, self.y, self.z
        tt.Draw:SetColor(255, 8, 22,255)
        tt.Draw:Text(debugtext, "GameFontNormalLarge", x1, y1, z1+2)
    end
end