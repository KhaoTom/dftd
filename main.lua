require "input"
require "drawing"
require "map"
require "character"

-- initialized once
local fullScreen = false
local drawXscale = canvasHorizontalScale
local drawYscale = canvasVerticalScale

-- initialized in love.load
local egacanvas
local playerPos
local characters
local shader
local normalFont
local playerState
local movePrompt
local currentShop
local currentShopper
local currentPlusValue


function love.load()
  -- setup
  egacanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
  egacanvas:setFilter('linear','nearest')
  
  normalFont = love.graphics.newFont("/gfx/Mx437_IBM_EGA_9x14.ttf", 14, "none", 16)
  love.graphics.setFont(normalFont)
  
  local str = love.filesystem.read('scanline.frag')
  shader = love.graphics.newShader(str)
  shader:send('count', canvasHeight*4)
  
  movePrompt = string.format("Move?\n (%s,%s,%s,%s)", 
    love.keyboard.getKeyFromScancode("up"),
    love.keyboard.getKeyFromScancode("down"),
    love.keyboard.getKeyFromScancode("left"),
    love.keyboard.getKeyFromScancode("right"))
  
  playerState = "move"
  
  playerPos = {
    x = 8,
    y = 4
  }
  
  characters = {
    Character:new("c1"),
    Character:new("c2"),
    Character:new("c3"),
    Character:new("c4")
  }
  
  loadMapFile("e1m1.txt")
  drawPlayerView()
  updateGameText()
  updateStatsText()
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
  --print(love.keyboard.getKeyFromScancode( scancode ))
  if scancode == "escape" then
    love.event.push("quit", 0)
    return
  end
  
  
  if scancode == "f11" then
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
    return
  end
  
  if playerState == "move" then
    local moveVector = handlePlayerMove(scancode)
    if moveVector then
      doPlayerMove(playerPos, moveVector)
      drawPlayerView()
      return
    end
    
  elseif playerState == "shopperSelect" then
    if handleMoveOrCancelKeypress(scancode) then return end
    local charSelect = handleCharacterSelect(scancode)
    if charSelect then
      currentShopper = charSelect
      playerState = "purchaseSelect"
      updateGameText()
      return
    end
    
  elseif playerState == "purchaseSelect" then
    if handleCancelKeypress(scancode) then return end
    local incdec = handleIncrementDecrement(scancode)
    if incdec then
      currentPlusValue = currentPlusValue + incdec
      if currentPlusValue < 0 then currentPlusValue = 0 end
      updateGameText()
      return
    end
  end
  
end


function handleCancelKeypress(scancode)
  if scancode == "q" or scancode == "kp." then
    playerState = "move"
    updateGameText()
    return true
  else
    return false
  end
end

function handleMoveOrCancelKeypress(scancode)
  local moveVector = handlePlayerMove(scancode)
  if moveVector or scancode == "q" or scancode == "kp." then
    playerState = "move"
    updateGameText()
    return true
  else
    return false
  end
end


function drawPlayerView()
  view = getMapSubsection(currentMap, playerPos.x, playerPos.y, 3)
  setVisibility(view, 4, 4)
  drawMap(egacanvas, view)
end

function updateGameText()
  drawGameText(egacanvas, getGameText())
end

function updateStatsText()
  drawStatsText(egacanvas, getStatsText())
end

function doPlayerMove(fromPos, dirVector)
  if currentMap:cellBlocksMovement(fromPos.x + dirVector.x, fromPos.y + dirVector.y) then
    return
  end
  
  -- move
  playerPos.x = playerPos.x + dirVector.x*2
  playerPos.y = playerPos.y + dirVector.y*2
  
  local cell = currentMap:getCell(playerPos.x, playerPos.y)
  
  if isShop(cell) then
    enterShop(getShopType(cell))
    updateGameText()
  end
end


function getShopType(cell)
  if cell == "w" then
    return "weapon"
  elseif cell == "a" then
    return "armor"
  elseif cell == "g" then 
    return "gem"
  elseif cell == "m" then 
    return "magic"
  elseif cell == "n" then 
    return "necromancy"
  elseif cell == "t" then 
    return "training"
  end
  return nil
end

function enterShop(shopType)
  currentPlusValue = 0
  playerState = "shopperSelect"
  currentShop = shopType
end


function makeShopperSelectPrompt()
  local shopPrompt = string.format("Welcome to the %s shop! Who is shopping?\n (%s, %s, %s, %s, cancel: %s)",
      currentShop,
      love.keyboard.getKeyFromScancode("1"),
      love.keyboard.getKeyFromScancode("2"),
      love.keyboard.getKeyFromScancode("3"),
      love.keyboard.getKeyFromScancode("4"),
      love.keyboard.getKeyFromScancode("q"))
  return shopPrompt
end


function makePurchaseSelectPrompt()
  local ownedEquip
  if currentShop == "weapon" then 
    ownedEquip = "Currently wielding: Sword +" .. characters[currentShopper].weapon
  else
    ownedEquip = "unhandled shop"
  end
  local shopPrompt = string.format("%s.\nHow many pluses to add?\n (inc: %s, dec: %s, buy: %s, cancel: %s)\n +%d",
    ownedEquip,
    love.keyboard.getKeyFromScancode("w"),
    love.keyboard.getKeyFromScancode("s"),
    love.keyboard.getKeyFromScancode("e"),
    love.keyboard.getKeyFromScancode("q"),
    currentPlusValue)
  return shopPrompt
end


function getStatsText()
  local statsText = {
    characters[1].name .. " :", " HP " .. characters[1].hp, "MP " .. characters[1].mp,
    characters[2].name .. " :", " HP " .. characters[2].hp, "MP " .. characters[2].mp,
    characters[3].name .. " :", " HP " .. characters[3].hp, "MP " .. characters[3].mp,
    characters[4].name .. " :", " HP " .. characters[4].hp, "MP " .. characters[4].mp,
  }
  return statsText
end

function getGameText()
  local gameText = {}
  if playerState == "move" then
    table.insert(gameText, movePrompt)
  elseif playerState == "shopperSelect" then
    table.insert(gameText, makeShopperSelectPrompt())
  elseif playerState == "purchaseSelect" then
    table.insert(gameText, makePurchaseSelectPrompt())
  end
  return gameText
end
