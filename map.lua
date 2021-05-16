local function makeIndex(x, y)
  return x .. ":" .. y
end


Map = {cells = {}}

function Map:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Map:getCell(x, y)
  return self.cells[makeIndex(x,y)]
end

function Map:cellBlocksVision(x, y)
  cell = self.cells[makeIndex(x,y)]
  return cell == "#" or cell == "+"
end

function Map:cellBlocksMovement(x, y)
  return self.cells[makeIndex(x,y)] == "#"
end

function Map:clearCell(x, y)
  self.cells[makeIndex(x,y)] = nil
end

currentMap = Map:new()


function loadMapFile(file)
  local cells = {}
  local x = 1
  local y = 1
  for line in love.filesystem.lines(file) do
    --table.insert(mapFile, line)
    for ch in line:gmatch(".") do
      if ch ~= " " then
        cells[makeIndex(x,y)] = ch
      end
      x = x + 1
    end
    y = y + 1
    x = 1
  end
  currentMap.cells = cells
end


function getMapSubsection(map, centerX, centerY, radius)
  local newMap = Map:new()
  local cx = 1
  local cy = 1
  
  for y = centerY - radius, centerY + radius do
    for x = centerX - radius, centerX + radius do
      newMap.cells[makeIndex(cx, cy)] = map:getCell(x,y)
      cx = cx + 1
    end
    cy = cy + 1
    cx = 1
  end
  return newMap
end


function setVisibility(map, centerX, centerY)
  map.cells[makeIndex(centerX, centerY)] = "x"
  -- check north
  if map:cellBlocksVision(centerX, centerY-1) then
    map:clearCell(centerX-1, centerY-2)
    map:clearCell(centerX,   centerY-2)
    map:clearCell(centerX+1, centerY-2)
    map:clearCell(centerX-2, centerY-3)
    map:clearCell(centerX-1, centerY-3)
    map:clearCell(centerX,   centerY-3)
    map:clearCell(centerX+1, centerY-3)
    map:clearCell(centerX+2, centerY-3)
  end
  -- check west
  if map:cellBlocksVision(centerX-1, centerY) then
    map:clearCell(centerX-2, centerY-1)
    map:clearCell(centerX-2, centerY)
    map:clearCell(centerX-2, centerY+1)
    map:clearCell(centerX-3, centerY-2)
    map:clearCell(centerX-3, centerY-1)
    map:clearCell(centerX-3, centerY)
    map:clearCell(centerX-3, centerY+1)
    map:clearCell(centerX-3, centerY+2)
  end
  -- check south
  if map:cellBlocksVision(centerX, centerY+1) then
    map:clearCell(centerX-1, centerY+2)
    map:clearCell(centerX,   centerY+2)
    map:clearCell(centerX+1, centerY+2)
    map:clearCell(centerX-2, centerY+3)
    map:clearCell(centerX-1, centerY+3)
    map:clearCell(centerX,   centerY+3)
    map:clearCell(centerX+1, centerY+3)
    map:clearCell(centerX+2, centerY+3)
  end
  -- check east
  if map:cellBlocksVision(centerX+1, centerY) then
    map:clearCell(centerX+2, centerY-1)
    map:clearCell(centerX+2, centerY)
    map:clearCell(centerX+2, centerY+1)
    map:clearCell(centerX+3, centerY-2)
    map:clearCell(centerX+3, centerY-1)
    map:clearCell(centerX+3, centerY)
    map:clearCell(centerX+3, centerY+1)
    map:clearCell(centerX+3, centerY+2)
  end
  -- check northwest
  if map:cellBlocksVision(centerX-2, centerY-1) or map:cellBlocksVision(centerX-1, centerY-2) then
    map:clearCell(centerX-3, centerY-3)
    map:clearCell(centerX-2, centerY-3)
    map:clearCell(centerX-3, centerY-2)
    map:clearCell(centerX-2, centerY-2)
  end
  if map:cellBlocksVision(centerX-1, centerY-1) then
    map:clearCell(centerX-3, centerY-3)
  end
  -- check southwest
  if map:cellBlocksVision(centerX-2, centerY+1) or map:cellBlocksVision(centerX-1, centerY+2) then
    map:clearCell(centerX-3, centerY+3)
    map:clearCell(centerX-2, centerY+3)
    map:clearCell(centerX-3, centerY+2)
    map:clearCell(centerX-2, centerY+2)
  end
  if map:cellBlocksVision(centerX-1, centerY+1) then
    map:clearCell(centerX-3, centerY+3)
  end
  -- check northeast
  if map:cellBlocksVision(centerX+2, centerY-1) or map:cellBlocksVision(centerX+1, centerY-2) then
    map:clearCell(centerX+3, centerY-3)
    map:clearCell(centerX+2, centerY-3)
    map:clearCell(centerX+3, centerY-2)
    map:clearCell(centerX+2, centerY-2)
  end
  if map:cellBlocksVision(centerX+1, centerY-1) then
    map:clearCell(centerX+3, centerY-3)
  end
  -- check southeast
  if map:cellBlocksVision(centerX+2, centerY+1) or map:cellBlocksVision(centerX+1, centerY+2) then
    map:clearCell(centerX+3, centerY+3)
    map:clearCell(centerX+2, centerY+3)
    map:clearCell(centerX+3, centerY+2)
    map:clearCell(centerX+2, centerY+2)
  end
  if map:cellBlocksVision(centerX+1, centerY+1) then
    map:clearCell(centerX+3, centerY+3)
  end
end
