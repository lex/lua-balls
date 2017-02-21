local Ball = {}

function Ball.new()
  local self = {}

  self.position = {}
  self.position.x = 0
  self.position.y = 0

  self.diameter = 128
  self.mass = 100

  self.position.w = self.diameter
  self.position.h = self.diameter

  self.radius = self.diameter / 2

  self.acceleration = {}
  self.acceleration.x = 0
  self.acceleration.y = 0

  self.velocity = {}
  self.velocity.x = 0
  self.velocity.y = 0

  function self.setPosition(x, y)
    self.position.x = x - self.position.w / 2
    self.position.y = y - self.position.h / 2
  end

  return self
end

return Ball
