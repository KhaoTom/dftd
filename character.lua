Character = {
  str = 3,
  int = 3,
  wis = 3,
  dex = 3,
  con = 3,
  cha = 3,
  hp = 10,
  mp = 5,
  name = "newbie",
  class = "fighter",
  weapon = 0,
  armor = 0,
  gem = 0
}


function Character:new (name)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  if name then o.name = name end
  return o
end
