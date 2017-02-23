local Ball = require "ball"
local graphics = require "graphics"
local physics = require "physics"

local debug = false

local balls = {}

local maxFps = 90
local frameTime = 1 / maxFps * 1000

local running = true

while running do
  for e in graphics.SDL.pollEvent() do
    if e.type == graphics.SDL.event.Quit then
      running = false

    elseif e.type == graphics.SDL.event.KeyDown then
      if debug then
        physics.calculatePhysics(balls, frameTime, graphics.windowWidth, graphics.windowHeight)
      end

    elseif e.type == graphics.SDL.event.MouseButtonDown then
      local newBall = Ball.new()

      newBall.setPosition(e.x, e.y)

      table.insert(balls, newBall)

    end
  end

  if not debug then
    physics.calculatePhysics(balls, frameTime, graphics.windowWidth, graphics.windowHeight)
  end

  graphics.render(balls)

  graphics.SDL.delay(frameTime)
end

graphics.SDL.quit()
