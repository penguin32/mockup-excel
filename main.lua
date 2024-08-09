testing_properties={ -- Used by testing properties, in drawing or updating:
	r=20		-->Radius, for testing, showing points in the viewport.
}

function testing_properties.drawCoordinates()
	-- Four corners of a dynamically resizing window.
	love.graphics.circle("line",origin.x,origin.y,testing_properties.r)
	love.graphics.circle("line",origin.x+dynamicAppWindow.width,origin.y,testing_properties.r)
	love.graphics.circle("line",origin.x,origin.y+dynamicAppWindow.height,testing_properties.r)
	love.graphics.circle("line",origin.x+dynamicAppWindow.width,origin.y+dynamicAppWindow.height,testing_properties.r)

	-- Middle part of the window's width at the TitleBar that resizes dynamically.
	love.graphics.circle("line",titleBar.x+dynamicAppWindow.middleWidth,titleBar.y+titleBar.height/2,testing_properties.r)
end

function testing_properties.drawInterface()	
	-- Title Bar
	love.graphics.rectangle("line",titleBar.x,titleBar.y,titleBar.width,titleBar.height)
	-- Menu Bar
	love.graphics.rectangle("line",menuBar.x,menuBar.y,menuBar.width,menuBar.height)
	-- Tool Bar
	love.graphics.rectangle("line",toolBar.x,toolBar.y,toolBar.width,toolBar.height)
	-- Name Box and Formula Bar
	love.graphics.rectangle("line",nameBoxAndFormulaBar.x,nameBoxAndFormulaBar.y,nameBoxAndFormulaBar.width,nameBoxAndFormulaBar.height)	
	-- Spreadsheet Area
	love.graphics.rectangle("line",spreadsheetArea.x,spreadsheetArea.y,spreadsheetArea.width,spreadsheetArea.height)
	-- Leaf Bar and Horizontal ScrollBar
	love.graphics.rectangle("line",leafBarAndHorizontalScrollBar.x,leafBarAndHorizontalScrollBar.y,leafBarAndHorizontalScrollBar.width,leafBarAndHorizontalScrollBar.height)
	-- Status Bar, View Buttons and Zoom Controls
	love.graphics.rectangle("line",statusViewAndZoom.x,statusViewAndZoom.y,statusViewAndZoom.width,statusViewAndZoom.height)
	-- Vertical Scroll Bar
	love.graphics.rectangle("fill",verticalScrollBar.x,verticalScrollBar.y,verticalScrollBar.width,verticalScrollBar.height)
end

function love.load()
	love.window.setTitle("Mock-up of Excel - by penguin32")
	love.window.maximize()

	origin = {x=0,y=0}
	dynamicAppWindow={		-- Changes dynamically.
		width=0,
		height=0,
		middleWidth=0
	}
-- Require'd lua files, uses some of the global above, so when requiring files, it needs to
-- be below the global variables its uses.
	require "interface.titleBar"
	require "interface.menuBar"
	require "interface.toolBar"
	require "interface.nameBoxAndFormulaBar"
	require "interface.spreadsheetArea"
	require "interface.leafBarAndHorizontalScrollBar"
	require "interface.statusViewAndZoom"
	require "interface.verticalScrollBar"
	require "userControls"

	titleBar.load()
	menuBar.load()
	toolBar.load()
	nameBoxAndFormulaBar.load()
	spreadsheetArea.load()
	leafBarAndHorizontalScrollBar.load()
	statusViewAndZoom.load()
	verticalScrollBar.load()
end

function love.draw()
--	testing_properties.drawCoordinates()
	testing_properties.drawInterface()

	titleBar.draw()
	menuBar.draw()
	toolBar.draw()
	nameBoxAndFormulaBar.draw()
	spreadsheetArea.draw()
	leafBarAndHorizontalScrollBar.draw()
	statusViewAndZoom.draw()
	verticalScrollBar.draw()
	cursor.draw()
end

function love.update()
	dynamicAppWindow.width=love.graphics.getWidth()
	dynamicAppWindow.height=love.graphics.getHeight()
	dynamicAppWindow.middleWidth=dynamicAppWindow.width/2

	titleBar.update()
	menuBar.update()
	toolBar.update()
	nameBoxAndFormulaBar.update()
	spreadsheetArea.update()
	leafBarAndHorizontalScrollBar.update()
	statusViewAndZoom.update()
	verticalScrollBar.update()
	cursor.update()
end
