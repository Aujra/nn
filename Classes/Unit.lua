local player = tt
tt.Classes.Unit = class({}, "Unit")
local Unit = tt.Classes.Unit

function Unit:init(pointer)
    self.pointer = pointer
    self.Name = ObjectName(self.pointer)
    self.x, self.y, self.z = ObjectPosition(self.pointer)
    self.Level = UnitLevel(self.pointer)
    self.Reaction = UnitReaction("player", self.pointer)
    self.Distance = self:DistanceFromPlayer()
    self.Health = UnitHealth(self.pointer)
    self.MaxHealth = UnitHealthMax(self.pointer)
    self.Enemy = self.Reaction < 4
    self.IsDead = UnitIsDeadOrGhost(self.pointer)
    self.HP = (self.Health / self.MaxHealth) * 100
end

function Unit:Update()
    self.x, self.y, self.z = ObjectPosition(self.pointer)
    self.Level = UnitLevel(self.pointer)
    self.Reaction = UnitReaction(self.pointer, "player")
    self.Distance = self:DistanceFromPlayer()
    self.Health = UnitHealth(self.pointer)
    self.MaxHealth = UnitHealthMax(self.pointer)
    self.Enemy = self.Reaction < 4
    self.IsDead = UnitIsDeadOrGhost(self.pointer)
    self.HP = (self.Health / self.MaxHealth) * 100
end

function Unit:DistanceFromPlayer()
    local x1, y1, z1 = self.x, self.y, self.z
    local x2, y2, z2 = ObjectPosition("player")
    local dist = math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function Unit:DistanceFrom(unit)
    local x1, y1, z1 = self.x, self.y, self.z
    local x2, y2, z2 = unit.x, unit.y, unit.z
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function Unit:UnitsInRange(range)
    local units = 0
    for k,v in pairs(tt.OM.Units) do
        if v.Distance <= range then
            units = units + 1
        end
    end
    return units
end

function Unit:EnemiesInRange(range)
    local units = 0
    for k,v in pairs(tt.OM.Units) do
        if v.Distance <= range and v.Reaction <= 4 and UnitAffectingCombat(v.pointer) then
            units = units + 1
        end
    end
    return units
end

function Unit:FriendlyInRange(range)
    local units = 0
    for k,v in pairs(tt.OM.Units) do
        if v.Distance <= range and v.Reaction >= 4 then
            units = units + 1
        end
    end
    return units
end

function Unit:HasAura(name, filter)
    local aname = AuraUtil.FindAuraByName(name, self.pointer, filter)
    return aname ~= nil
end

function Unit:ShouldInterruptCasting()
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(self.pointer)
    if not name then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(self.pointer)
    end
    if not name then
        return false
    end
    local elapsed = GetTime() - (startTimeMS / 1000)
    return name and not notInterruptible and elapsed > 0.2
end

function Unit:Debug()
    local debugtext = "Name: " .. self.Name .. " Level: " .. self.Level
    debugtext = debugtext .. "\n Reaction: " .. self.Reaction
    debugtext = debugtext .. "\n Distance: " .. tostring(self.Distance)
    debugtext = debugtext .. "\n UnitsInRange: " .. tostring(#self:UnitsInRange(30))
    if tt.Draw then
        local x1, y1, z1 = self.x, self.y, self.z
        local x2, y2, z2 = ObjectPosition("player")
        tt.Draw:SetColor(255, 8, 22,255)
        tt.Draw:Text(debugtext, "GameFontNormalLarge", x1, y1, z1+2)
    end
end