local tt = tt
tt.Classes.Spot = class({}, "Spot")
local Spot = tt.Classes.Spot

function Spot:init(x,y,z,mapID, facex, facey, facez)
    self.x = x
    self.y = y
    self.z = z
    self.mapID = mapID
    self.facex = facex
    self.facey = facey
    self.facez = facez
end

function Spot:DistanceFromPlayer()
    local x1, y1, z1 = self.x, self.y, self.z
    local x2, y2, z2 = ObjectPosition("player")
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end