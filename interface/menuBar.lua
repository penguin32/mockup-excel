menuBar={}

function menuBar.load()
	menuBar.x=origin.x
	menuBar.y=titleBar.y+titleBar.height
	menuBar.height=30
end

function menuBar.draw()
end

function menuBar.update()
	menuBar.width=dynamicAppWindow.width
end
