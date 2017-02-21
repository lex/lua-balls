local physics = {}

local g = 9.81
function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function physics.calculatePhysics(objects, step, width, height)
  for i, object in ipairs(objects) do
    -- check horizontal bounds
    if object.position.x + object.position.w >= width or object.position.x <= 0 then
      -- bounce from the sides
      object.velocity.x = -object.velocity.x
    end

    -- check vertical bounds
    if object.position.y + object.position.h >= height and object.acceleration.y >= 0 then
      -- bounce from the bottom
      object.acceleration.y = -(object.acceleration.y * 0.75)
      object.velocity.y = 0
    end

    -- usual stuff
    local scale = step / 100 --????? why not 1000? t: author
    object.acceleration.y = object.acceleration.y + scale * g
    object.velocity.y = scale * (object.velocity.y + object.acceleration.y)
    object.position.y = object.position.y + object.velocity.y
    object.position.x = object.position.x + object.velocity.x

    -- keep the objects from going out of screen bounds
    object.position.x = math.clamp(0, object.position.x, width + object.position.w)
    object.position.y = math.clamp(0, object.position.y, height - object.position.h)

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
  object.velocity.x = object.velocity.x - 0.5
  otherObject.velocity.x = otherObject.velocity.x + 0.5
end

return physics
