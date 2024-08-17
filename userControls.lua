cursor={x=0,y=0}

function love.mousepressed(x,y,button)
	verticalScrollBar.interact()
	leafBarAndHorizontalScrollBar.interact()
	spreadsheetArea.mousepressed(button)
end

function love.mousereleased()
	leafBarAndHorizontalScrollBar.scrollBar.isPressed = false
	verticalScrollBar.scrollBar.isPressed = false
end

function cursor.update()
	cursor.x,cursor.y = love.mouse.getPosition()
end

function cursor.draw()
	love.graphics.circle("line",cursor.x,cursor.y,20)
end
