function handleQuit()
  if love.keyboard.isDown("q") then
    love.event.push("quit", 0)
  end
end

function handlePlayerMove(scancode)
  outVector = {}
  outVector.x = 0
  outVector.y = 0
  if scancode == "d" then
    outVector.x = 1
    return outVector
  end
  if scancode == "a" then
    outVector.x =  -1
    return outVector
  end
  if scancode == "w" then
    outVector.y = -1
    return outVector
  end
  if scancode == "s" then
    outVector.y = 1
    return outVector
  end
  return nil
end
