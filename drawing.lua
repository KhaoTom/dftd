canvasWidth = 640
canvasHeight = 350
canvasVerticalScale = 2.74
textCanvasWidth = 640*2
textCanvasHeight = 350*2.74

-- ega color partials
c00=0
c55=0.333
cAA=0.666
cFF=1

cellWidth = 30
wallWidth = 5
doorWidth = 3
diameter = 7

function drawGameText(cgfx, gameText)
  love.graphics.setCanvas(cgfx)
  love.graphics.setColor(0.06, 0.05, 0.07)
  love.graphics.rectangle("fill", cellWidth * diameter, 0, canvasWidth - cellWidth * diameter, canvasHeight)
  love.graphics.rectangle("fill", 0, cellWidth * diameter, cellWidth * diameter, canvasHeight - cellWidth * diameter)
  
  love.graphics.setColor(cAA, cAA, cAA)
  love.graphics.print("Your turn.", 20, 10 + cellWidth * diameter)
  
  for i=0,3 do
    love.graphics.print(gameText[1 + i*3], 20 + cellWidth * diameter, 10 + i*32)
    love.graphics.print(gameText[2 + i*3], 20 + cellWidth * diameter, 24 + i*32)
    love.graphics.print(gameText[3 + i*3], 120 + cellWidth * diameter, 24 + i*32)
  end
  
  love.graphics.setCanvas()
end

function drawMap(cgfx, map)
  love.graphics.setCanvas(cgfx)
  love.graphics.setColor(0.06, 0.05, 0.07)
  love.graphics.rectangle("fill",0,0, diameter * cellWidth + wallWidth/2, diameter * cellWidth + wallWidth/2)
  
  love.graphics.setColor(c55, cAA, cFF)
  love.graphics.print("x", (diameter+1) / 2 * cellWidth - 3, (diameter+1) / 2 * cellWidth - 4)
  
  love.graphics.setLineStyle( "rough" )
  
  for y=1,diameter do
    for x=1,diameter do
      cell = map:getCell(x,y)
--      love.graphics.print(cell or " ", x * 14 + 5, y * 14 + 150)
--      if x == 4 and y == 4 then
--        love.graphics.print("x", x * 14 + 5, y * 14 + 150)
--      end
      if cell == "#" then
        
        love.graphics.setLineWidth( wallWidth )
        love.graphics.setColor(cAA, cAA, cAA)
        
        drawWallCenter(x, y)
        -- check neighbors and draw as appropriate
        neighbors = {{x+1,y}, {x-1,y}, {x,y+1}, {x,y-1}}
        for i=1,4 do
          local nx = neighbors[i][1]
          local ny = neighbors[i][2]
          local ncell = map:getCell(nx,ny)
          if ncell == "#" then
            drawWallToWallSegment(x, y, nx, ny)
          elseif ncell == "+" then
            drawWallToDoorSegment(x, y, nx, ny)
          end
        end
      elseif cell == "+" then
        love.graphics.setLineWidth( doorWidth )
        love.graphics.setColor(cFF, cAA, c55)
        
        drawDoor(x,y, map:getCell(x,y+1) == "#")
      end
    end
  end
  
  love.graphics.setCanvas()
end

function drawWallCenter(x, y)
  love.graphics.rectangle("fill", x * cellWidth - wallWidth/2, y * cellWidth - wallWidth/2, wallWidth, wallWidth)
end

function drawWallToWallSegment(x1, y1, x2, y2)
  love.graphics.line(x1 * cellWidth, y1 * cellWidth, x2 * cellWidth , y2 * cellWidth)
end

function drawWallToDoorSegment(x1, y1, x2, y2)
  if x1 < x2 then
    love.graphics.line(x1 * cellWidth, y1 * cellWidth, x2 * cellWidth - cellWidth/2, y2 * cellWidth)
  elseif x1 > x2 then
    love.graphics.line(x1 * cellWidth, y1 * cellWidth, x2 * cellWidth + cellWidth/2, y2 * cellWidth)
  elseif y1 < y2 then
    love.graphics.line(x1 * cellWidth, y1 * cellWidth, x2 * cellWidth, y2 * cellWidth - cellWidth/2)
  elseif y1 > y2 then
    love.graphics.line(x1 * cellWidth, y1 * cellWidth, x2 * cellWidth, y2 * cellWidth + cellWidth/2)
  end
end

function drawDoor(x, y, isVertical)
  if isVertical then
    love.graphics.line(x * cellWidth, y * cellWidth - cellWidth/2, x * cellWidth, y * cellWidth + cellWidth/2)
  else
    love.graphics.line(x * cellWidth - cellWidth/2, y * cellWidth, x * cellWidth + cellWidth/2, y * cellWidth)
  end
end

