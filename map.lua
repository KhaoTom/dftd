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
