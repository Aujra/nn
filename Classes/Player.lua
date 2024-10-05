local player = tt
tt.Classes.Player = class({}, "Player")
local Player = tt.Classes.Player

function Player:init(pointer)
    self.pointer = pointer
    self.Name = ObjectName(self.pointer)
    self.x, self.y, self.z = ObjectPosition(self.pointer)
    self.Level = UnitLevel(self.pointer)
    self.Reaction = UnitReaction(self.pointer, "player")
    self.Distance = self:DistanceFromPlayer()
end

function Player:Update()
    self.x, self.y, self.z = ObjectPosition(self.pointer)
    self.Level = UnitLevel(self.pointer)
    self.Reaction = UnitReaction(self.pointer, "player")
    self.Distance = self:DistanceFromPlayer()
end

function Player:DistanceFromPlayer()
    local x1, y1, z1 = self.x, self.y, self.z
    local x2, y2, z2 = ObjectPosition("player")
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function Player:DistanceFrom(Player)
    local x1, y1, z1 = self.x, self.y, self.z
    local x2, y2, z2 = Player.x, Player.y, Player.z
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function Player:HasAura(name, filter)
    local aname = AuraUtil.FindAuraByName(name, self.pointer, filter)
    return aname ~= nil
end

function Player:PlayersInRange(range)
    local Players = {}
    for k,v in pairs(tt.OM.Players) do
        if v.Distance <= range then
            table.insert(Players, v)
        end
    end
    return Players
end

function Player:Debug()
    local debugtext = "Name: " .. self.Name .. " Level: " .. self.Level
    debugtext = debugtext .. "\n Reaction: " .. self.Reaction
    debugtext = debugtext .. "\n Distance: " .. tostring(self.Distance)
    debugtext = debugtext .. "\n PlayersInRange: " .. tostring(#self:PlayersInRange(30))
    if tt.Draw then
        local x1, y1, z1 = self.x, self.y, self.z
        local x2, y2, z2 = ObjectPosition("player")
        tt.Draw:SetColor(255, 8, 22,255)
        tt.Draw:Text(debugtext, "GameFontNormalLarge", x1, y1, z1+2)
    end
end