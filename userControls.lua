cursor={x=0,y=0}

function love.keypressed(key,scancode)
	if key == "escape" then
		for i,v in ipairs(spreadsheetArea.rAndC) do
			if v.selected == true then
				v.selected = false
			end
		end
	end
end

function love.mousepressed(x,y,button)
	verticalScrollBar.interact()
	leafBarAndHorizontalScrollBar.interact()
	for i,v in ipairs(spreadsheetArea.rAndC) do
		v.rectangularSelection(v)
	end
end

function love.mousereleased()
	leafBarAndHorizontalScrollBar.scrollBar.isPressed = false
	verticalScrollBar.scrollBar.isPressed = false
	for i,v in ipairs(spreadsheetArea.rAndC) do
		v.onMousereleased(v)
	end
end

function cursor.update()
	cursor.x,cursor.y = love.mouse.getPosition()
end

function cursor.draw()
	love.graphics.circle("line",cursor.x,cursor.y,20)
end
