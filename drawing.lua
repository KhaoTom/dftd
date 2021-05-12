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

cellWidth = 15
wallWidth = 5
doorWidth = 3

function initTitleScreen(cgfx)
  love.graphics.setCanvas(cgfx)
  love.graphics.clear(c55,0,0,1)
  
  love.graphics.setLineStyle( "rough" )
  love.graphics.setLineWidth( 3 )
  
  love.graphics.setColor(c55, c55, cAA)
  love.graphics.line(10, 10, 630, 340)
  
  love.graphics.setColor(c00, c55, cAA)
  love.graphics.line(10, 350, 630, 10)
  
  love.graphics.setCanvas()
end

function drawMap(cgfx, map)
  love.graphics.setCanvas(cgfx)
  love.graphics.clear(c55,0,0,1)
  
  love.graphics.setLineStyle( "rough" )
  
  for y=1,9 do
    for x=1,9 do
      cell = map:getCell(x,y)
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
  
  love.graphics.print("Hello, World!", 5)
  
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

