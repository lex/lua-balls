local SDL = require "SDL"
local image = require "SDL.image"

local graphics = {}
local width = 640
local height = 480

local ret, err = SDL.init {
  SDL.flags.Video,
  SDL.flags.Audio
}

if not ret then
  error(err)
end

local formats, ret, err = image.init { image.flags.PNG }
if not formats[image.flags.PNG] then
  error(err)
end

local img, ret = image.load("../res/ball.png")

if not img then
  error(err)
end

local window, err = SDL.createWindow {
  title = "lua-balls",
  width = width,
  height = height,
}

if not window then
  error(err)
end

local renderer, err = SDL.createRenderer(window, 0, 0)
if not renderer then
  error(err)
end

local ball, err = renderer:createTextureFromSurface(img)
if not ball then
  error(err)
end

graphics.window = window
graphics.renderer = renderer
graphics.ball = ball
graphics.windowWidth = width
graphics.windowHeight = height
graphics.SDL = SDL

function graphics.render(objects)
  renderer:clear()

  for i, o in ipairs(objects) do
    renderer:copy(ball, nil, graphics.objectPositionForSdl(o))
  end

  renderer:present()
end

function graphics.objectPositionForSdl(o)
  return {
    x=o.position.x,
    y=o.position.y,
    w=o.width,
    h=o.height
  }
end

return graphics
