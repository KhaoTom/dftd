
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


function handleCharacterSelect(scancode)
  if scancode == "1" then
    return 1
  elseif scancode == "2" then
    return 2
  elseif scancode == "3" then
    return 3
  elseif scancode == "4" then
    return 4
  else
    return nil
  end  
end


function handleIncrementDecrement(scancode)
  if scancode == "up" or scancode == "w" or scancode == "k" or scancode == "kp8" then
    return 1
  end
  if scancode == "down" or scancode == "s" or scancode == "j" or scancode == "kp2" then
    return -1
  end
  return nil
end
