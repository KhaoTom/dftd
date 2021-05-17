require "input"
require "drawing"
require "map"
require "character"

egacanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
egacanvas:setFilter('linear','nearest')

local fullScreen = false
local drawXscale = canvasHorizontalScale
local drawYscale = canvasVerticalScale

playerPos = {}
playerPos.x = 8
playerPos.y = 4

characters = {
  Character:new("c1"),
  Character:new("c2"),
  Character:new("c3"),
  Character:new("c4")
}


function love.load()
  -- setup
  normalFont = love.graphics.newFont("/gfx/Mx437_IBM_EGA_9x14.ttf", 14, "none", 16)
  love.graphics.setFont(normalFont)
  
  local str = love.filesystem.read('scanline.frag')
  shader = love.graphics.newShader(str)
  shader:send('count', canvasHeight*4)
  
  loadMapFile("e1m1.txt")
  drawPlayerView()
  drawGameText(egacanvas, getGameText())
end


function love.update(dt)
  shader:send('time', love.timer.getTime())
end


function love.draw()
  love.graphics.setShader(shader)
  
  love.graphics.draw(egacanvas, 0, 0, 0, drawXscale, drawYscale)

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
  
  if key == "f11" then
    if not fullScreen then
      fullScreen = love.window.setFullscreen(true, 'desktop')
      drawXscale = love.graphics.getWidth() / canvasWidth
      drawYscale = love.graphics.getHeight() / canvasHeight
    else
      love.window.setFullscreen(false)
      fullScreen = false
      drawXscale = canvasHorizontalScale
      drawYscale = canvasVerticalScale
    end
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


function getGameText()
  gameText = {
    characters[1].name .. " :", " HP " .. characters[1].hp, "MP " .. characters[1].mp,
    characters[2].name .. " :", " HP " .. characters[2].hp, "MP " .. characters[2].mp,
    characters[3].name .. " :", " HP " .. characters[3].hp, "MP " .. characters[3].mp,
    characters[4].name .. " :", " HP " .. characters[4].hp, "MP " .. characters[4].mp,

  }
  return gameText
end
