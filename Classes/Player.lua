local player = tt
tt.Classes.Player = class({}, "Player")
local Player = tt.Classes.Player

function Player:init(pointer)
    self.pointer = pointer
    self.ID = Unlock(UnitGUID, pointer)
    self.Name = ObjectName(self.pointer)
    self.x, self.y, self.z = ObjectPosition(self.pointer)
    self.Level = UnitLevel(self.pointer)
    self.Reaction = UnitReaction(self.pointer, "player")
    self.Distance = self:DistanceFromPlayer()
    self.Health = UnitHealth(self.pointer)
    self.MaxHealth = UnitHealthMax(self.pointer)
    self.HP = (self.Health / self.MaxHealth) * 100
    self.IsDead = UnitIsDeadOrGhost(self.pointer)
    self.Enemy = false
    self.Score = 0
end

function Player:Update()
    self.x, self.y, self.z = ObjectPosition(self.pointer)
    self.Level = UnitLevel(self.pointer)
    self.Reaction = UnitReaction(self.pointer, "player")
    self.Distance = self:DistanceFromPlayer()
    self.Health = UnitHealth(self.pointer)
    self.MaxHealth = UnitHealthMax(self.pointer)
    self.HP = (self.Health / self.MaxHealth) * 100
    self.Enemy = self.Reaction < 4
    self.IsDead = UnitIsDeadOrGhost(self.pointer)
    self.ID = Unlock(UnitGUID, self.pointer)
    self.Score = self:GetScore()
    --self:Debug()
end

function Player:CastOn(spell)
    return Unlock(CastSpellByName, spell, self.pointer)
end

function Player:GetScore()
    if self.IsDead then
        return 0
    end
    local score = 0
    score = score + (100-self.HP)
    score = score + (400 - self.Distance)
    return score
end

function Player:DistanceFromPlayer()
    local x1, y1, z1 = ObjectPosition(self.pointer)
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
    local debugtext = "ID : " .. tostring(self.ID) .. " pointer: " .. self.pointer
    if tt.Draw then
        local x1, y1, z1 = self.x, self.y, self.z
        local x2, y2, z2 = ObjectPosition("player")
        tt.Draw:SetColor(255, 8, 22,255)
        tt.Draw:Text(debugtext, "GameFontNormalLarge", x1, y1, z1+2)
    end
end