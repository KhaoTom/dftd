require "input"
require "drawing"
require "map"

egacanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
egacanvas:setFilter('linear','nearest')

function love.load()
  -- setup
  normalFont = love.graphics.newFont("/gfx/Mx437_IBM_EGA_9x14.ttf", 38.36)
  love.graphics.setFont(normalFont)
  loadMapFile("e1m1.txt")
  drawMap(egacanvas, currentMap)
end


function love.update(dt)
  handleInput()
end


function love.draw()
  love.graphics.draw(egacanvas, 0, 0, 0, 2, 2.74)
  
  love.graphics.setColor(cAA, cAA, c55, 1)
  love.graphics.print("Don't Feed the Dragon!", 50, 50)

end
