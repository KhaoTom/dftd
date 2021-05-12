local function makeIndex(x, y)
  return x .. ":" .. y
end


Map = {cells = {}}

function Map:getCell(x, y)
  return self.cells[makeIndex(x,y)]
end


currentMap = Map


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