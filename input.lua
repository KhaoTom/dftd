function handleInput()
  if love.keyboard.isDown("q") then
    love.event.push("quit", 0)
  end
end