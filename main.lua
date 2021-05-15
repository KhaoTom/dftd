require "input"
require "drawing"
require "map"

egacanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
egacanvas:setFilter('linear','nearest')

playerPos = {}
playerPos.x = 4
playerPos.y = 4
  
function love.load()
  -- setup
  normalFont = love.graphics.newFont("/gfx/Mx437_IBM_EGA_9x14.ttf", 14, "mono", 16)
  love.graphics.setFont(normalFont)
  loadMapFile("e1m1.txt")
  drawPlayerView()
end


function love.update(dt)

end


function love.draw()
  love.graphics.draw(egacanvas, 0, 0, 0, 2, canvasVerticalScale)
  
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.push("quit", 0)
    return
  end
   
  if handlePlayerMove(scancode, playerPos) then
    drawPlayerView()
    return
  end
end


function drawPlayerView()
  view = getMapSubsection(currentMap, playerPos.x, playerPos.y, 3)
  setVisibility(view, playerPos.x, playerPos.y)
  drawMap(egacanvas, view, 7)
end