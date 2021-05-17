
function handlePlayerMove(scancode)
  local outVector = {}
  outVector.x = 0
  outVector.y = 0
  if scancode == "right" or scancode == "d" or scancode == "l" or scancode == "kp6" then
    outVector.x = 1
    return outVector
  end
  if scancode == "left" or scancode == "a" or scancode == "h" or scancode == "kp4" then
    outVector.x =  -1
    return outVector
  end
  if scancode == "up" or scancode == "w" or scancode == "k" or scancode == "kp8" then
    outVector.y = -1
    return outVector
  end
  if scancode == "down" or scancode == "s" or scancode == "j" or scancode == "kp2" then
    outVector.y = 1
    return outVector
  end
  return nil
end
