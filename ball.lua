local Vector = require "vector"
local Ball = {}

function Ball.new()
  local self = {}

  self.position = Vector(0, 0)

  self.diameter = 128

  self.width = self.diameter
  self.height = self.diameter

  self.mass = 100

  self.radius = self.diameter / 2

  self.acceleration = Vector(0, 0)

  self.velocity = Vector(0, 0)

  function self.setPosition(x, y)
    self.position.x = x - self.width / 2
    self.position.y = y - self.height / 2
  end

  function self.getCenterPosition()
    local x = self.position.x + self.width / 2
    local y = self.position.y + self.height / 2
    return Vector(x, y)
  end

  function self.print()
    print(self.acceleration)
    print(self.velocity)
  end

  return self
end

return Ball
