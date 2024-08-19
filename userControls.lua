cursor={x=0,y=0}

function love.mousepressed(x,y,button)
	verticalScrollBar.interact(button)
	leafBarAndHorizontalScrollBar.interact(button)
	spreadsheetArea.mousepressed(button)
end

function love.mousereleased(x,y,button)
	leafBarAndHorizontalScrollBar.scrollBar.isPressed = false
	verticalScrollBar.scrollBar.isPressed = false
	spreadsheetArea.mousereleased(button)
end

function cursor.update()
	cursor.x,cursor.y = love.mouse.getPosition()
end

function cursor.draw()
	love.graphics.circle("line",cursor.x,cursor.y,20)
end

function love.keypressed(key)
	spreadsheetArea.keypressed(key)
end

function love.textinput(t)
	spreadsheetArea.textInput(t)
end
