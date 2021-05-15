function handleQuit()
  if love.keyboard.isDown("q") then
    love.event.push("quit", 0)
  end
end

function handlePlayerMove(scancode, playerPos)
  if scancode == "d" then
    playerPos.x = playerPos.x + 2
    return true
  end
  if scancode == "a" then
    playerPos.x = playerPos.x - 2
    return true
  end
  if scancode == "w" then
    playerPos.y = playerPos.y - 2
    return true
  end
  if scancode == "s" then
    playerPos.y = playerPos.y + 2
    return true
  end
  return false
end
