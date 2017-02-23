local Vector = require "vector"
local physics = {}

local g = 9.81
local pi = 3.14159265359

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function physics.calculatePhysics(objects, step, width, height)
  for i, object in ipairs(objects) do
    -- check horizontal bounds
    if object.position.x + object.width >= width or object.position.x <= 0 then
      -- bounce from the sides
      object.velocity.x = -object.velocity.x
    end

    -- check vertical bounds
    if object.position.y + object.height >= height and object.acceleration.y >= 0 then
      -- bounce from the bottom
      object.acceleration.y = -(object.acceleration.y * 0.75)
      object.velocity.y = -object.velocity.y
    end

    -- usual stuff
    local scale = step / 100 --????? why not 1000? t: author
    object.acceleration.y = object.acceleration.y + scale * g
    object.velocity.y = scale * (object.velocity.y + object.acceleration.y)
    object.position.y = object.position.y + object.velocity.y
    object.position.x = object.position.x + object.velocity.x

    -- keep the objects from going out of screen bounds
    object.position.x = math.clamp(0, object.position.x, width - object.width)
    object.position.y = math.clamp(0, object.position.y, height - object.height)

    for j, otherObject in ipairs(objects) do
      if i == j then
        goto continue
      end

      -- check for balls touching balls here
      if physics.colliding(object, otherObject) then
        physics.resolveCollision(object, otherObject)
      end
    end

    ::continue::
  end
end

function physics.colliding(object, otherObject)
  local xd = object.position.x - otherObject.position.x
  local yd = object.position.y - otherObject.position.y

  local radiuses = object.radius + otherObject.radius
  local radiusesSquared = radiuses * radiuses
  local distance = (xd * xd) + (yd * yd)

  return distance <= radiusesSquared
end

function physics.resolveCollision(object, otherObject)
  -- from here: http://stackoverflow.com/questions/345838/ball-to-ball-collision-detection-and-handling
  local collision = object.getCenterPosition() - otherObject.getCenterPosition()
  local distance = collision:len()

  local mtdX = collision.x * (((object.radius + otherObject.radius)-distance)/distance)
  local mtdY = collision.y * (((object.radius + otherObject.radius)-distance)/distance)

  -- move the objects away from each other
  object.position.x = object.position.x + mtdX
  object.position.y = object.position.y + mtdY

  otherObject.position.x = otherObject.position.x - mtdX
  otherObject.position.y = otherObject.position.y - mtdY

  if distance == 0.0 then
    return
  end

  if distance < 128 then
    -- resolve objects being inside each other?
    distance = 135
  end

  collision.x = collision.x / distance
  collision.y = collision.y / distance

  local aci = object.velocity:dot(collision)
  local bci = otherObject.velocity:dot(collision)

  local acf = bci
  local bcf = aci

  local firstCollision = collision + Vector.zero
  local secondCollision = collision + Vector.zero

  firstCollision.x = firstCollision.x * (acf - aci)
  firstCollision.y = firstCollision.y * (acf - aci)

  secondCollision.x = secondCollision.x * (bcf - bci)
  secondCollision.y = secondCollision.y * (bcf - bci)

  object.velocity = object.velocity + firstCollision
  otherObject.velocity = otherObject.velocity + secondCollision
end

return physics
