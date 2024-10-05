tt.Classes.GameObject = class({}, "GameObject")
local GameObject = tt.Classes.GameObject

function GameObject:init(pointer)
    self.pointer = pointer
    self.Name = ObjectName(self.pointer)
    self.x, self.y, self.z = ObjectPosition(self.pointer)
end

function GameObject:Update()
    self.Name = ObjectName(self.pointer)
    self.x, self.y, self.z = ObjectPosition(self.pointer)
end