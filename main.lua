require "input"
require "drawing"
require "map"

egacanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
egacanvas:setFilter('linear','nearest')

playerPos = {}
playerPos.x = 8
playerPos.y = 4
  
function love.load()
  -- setup
  normalFont = love.graphics.newFont("/gfx/Mx437_IBM_EGA_9x14.ttf", 14, "none", 16)
  love.graphics.setFont(normalFont)
  
  local str = love.filesystem.read('scanline.frag')
  shader = love.graphics.newShader(str)
  --shader:send('inputSize', {love.graphics.getWidth(), love.graphics.getHeight()})
  --shader:send('textureSize', {love.graphics.getWidth(), love.graphics.getHeight()})
  shader:send('count', canvasHeight*4)
  
  loadMapFile("e1m1.txt")
  drawPlayerView()
  drawGameText(egacanvas)
end


function love.update(dt)
  shader:send('time', love.timer.getTime())
end


function love.draw()
  love.graphics.setShader(shader)
  
  love.graphics.draw(egacanvas, 0, 0, 0, 2, canvasVerticalScale)
  
  love.graphics.setShader()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.push("quit", 0)
    return
  end
  
  moveVector = handlePlayerMove(scancode)
  if moveVector then
    tryMove(playerPos, moveVector)
    drawPlayerView()
    return
  end
end


function drawPlayerView()
  view = getMapSubsection(currentMap, playerPos.x, playerPos.y, 3)
  setVisibility(view, 4, 4)
  drawMap(egacanvas, view)
end


function tryMove(fromPos, dirVector)
  if not currentMap:cellBlocksMovement(fromPos.x + dirVector.x, fromPos.y + dirVector.y) then
    playerPos.x = playerPos.x + dirVector.x*2
    playerPos.y = playerPos.y + dirVector.y*2
  end
end
