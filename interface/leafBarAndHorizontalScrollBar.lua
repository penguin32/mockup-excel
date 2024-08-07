leafBarAndHorizontalScrollBar={}

function leafBarAndHorizontalScrollBar.load()
	leafBarAndHorizontalScrollBar.x=origin.x
	leafBarAndHorizontalScrollBar.width=dynamicAppWindow.width
	leafBarAndHorizontalScrollBar.height=30
	--	Simple adjustments due to ordering of load(), added on statusViewAndZoom.load()
	--leafBarAndHorizontalScrollBar.y=0
end

function leafBarAndHorizontalScrollBar.draw()
end

function leafBarAndHorizontalScrollBar.update()
	leafBarAndHorizontalScrollBar.width=dynamicAppWindow.width
end
