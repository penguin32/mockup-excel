cursor={x=0,y=0}

function cursor.update()
	cursor.x,cursor.y = love.mouse.getPosition()
	if love.mouse.isDown(1) then
		leafBarAndHorizontalScrollBar.scrollBar.deltaX = cursor.x - leafBarAndHorizontalScrollBar.scrollBar.btnWidth/2
	end

end

function cursor.draw()
	love.graphics.circle("line",cursor.x,cursor.y,20)
end
