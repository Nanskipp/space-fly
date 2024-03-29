local bullets = {}

bullets.create = function(dmg, pos)
    local bullet = Object()

    bullet.quad = Quad()
    bullet.quad.Color = Color(0, 255, 0)
    bullet.quad:SetParent(bullet)
    bullet.quad.Scale.Y = 5
    bullet.quad.Physics = PhysicsMode.Trigger
    bullet.quad.CollisionGroups = {1, 2, 3}

    bullet.destroy = function(self)
        self.Tick = nil
        self.quad:SetParent(nil)
        self.quad = nil
        self:SetParent(nil)
        self = nil
    end

    bullet.damage = dmg
    bullet.Position = pos - Number3(0.5, -10, 0)

    bullet.Tick = function(self)

        self.Position.Y = self.Position.Y + 3

        if self.Position.Y >= 200 then
            self:destroy()
        end

    end

    bullet.quad.OnCollisionBegin = function(self, other)
        local selfparent = self:GetParent()
        local otherparent = other:GetParent()
        if selfparent.damage ~= nil and otherparent.health ~= nil then
            if otherparent.isEnemy then
                otherparent.health = otherparent.health - selfparent.damage
                selfparent:destroy()
            end
        end
    end
    
    bullet:SetParent(World)
end

return bullets