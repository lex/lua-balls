local physics = {}

local g = 9.81

function physics.calculatePhysics(objects, step, width, height)
  for i, object in ipairs(objects) do
    if object.position.y + object.position.h >= height and object.acceleration.y >= 0 then
      if object.acceleration.y > -1.0 and object.acceleration.y < 1.0 then
        -- the object is resting at the bottom of the window
        -- figure out the proper way to deal with this
      else
        object.acceleration.y = -(object.acceleration.y * 0.75)
        object.velocity.y = 0
      end
    else
      local scale = step / 100 --????? why not 1000? t: author
      object.acceleration.y = object.acceleration.y + scale * g
      object.velocity.y = scale * (object.velocity.y + object.acceleration.y)
      object.position.y = object.position.y + object.velocity.y
    end

    for j, otherObject in ipairs(objects) do
      if i == j then
        goto continue
      end
      -- check for balls touching balls here
    end

    ::continue::
  end
end

return physics
