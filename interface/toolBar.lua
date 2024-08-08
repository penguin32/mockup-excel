toolBar={}

function toolBar.load()
	toolBar.x=origin.x
	toolBar.y=menuBar.y+menuBar.height
	toolBar.height=90
end

function toolBar.draw()
end

function toolBar.update()
	toolBar.width=dynamicAppWindow.width
end
