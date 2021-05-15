require "input"
require "drawing"
require "map"

egacanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
egacanvas:setFilter('linear','nearest')

function love.load()
  -- setup
  normalFont = love.graphics.newFont("/gfx/Mx437_IBM_EGA_9x14.ttf", 14, "none", 16)
  love.graphics.setFont(normalFont)
  loadMapFile("e1m1.txt")
  view = getMapSubsection(currentMap, 2, 2, 3)
  drawMap(egacanvas, view, 7)
end


function love.update(dt)
  handleInput()
end


function love.draw()
  love.graphics.draw(egacanvas, 0, 0, 0, 2, canvasVerticalScale)
  
end
