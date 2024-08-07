titleBar={}

function titleBar.load()
	titleBar.x=origin.x
	titleBar.y=origin.y
	titleBar.fileName = "New file is not save"
	titleBar.width=dynamicAppWindow.width
	titleBar.height=30
end

function titleBar.draw()
	love.graphics.print(titleBar.fileName.." - Excel",titleBar.x+dynamicAppWindow.middleWidth,titleBar.y+titleBar.height/4,0,1,1,string.len(titleBar.fileName)*4.5)
end

function titleBar.update()
	titleBar.width = dynamicAppWindow.width
end
