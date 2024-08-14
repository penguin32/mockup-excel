testing_properties={ -- Used by testing properties, in drawing or updating:
	r=20		-->Radius, for testing, showing points in the viewport.
}

function testing_properties.drawHorizontalScrollBarAttb() -- Column attributes.
	-- Below is for Testing columnXrow lengths.
	love.graphics.print("Total columns length: "..spreadsheetArea.totalLengthColumn,spreadsheetArea.x+100,spreadsheetArea.y+150,0,2,2)
	love.graphics.print("Portion columns length: "..spreadsheetArea.portionTotalLengthColumn,spreadsheetArea.x+100,spreadsheetArea.y+200,0,2,2)
-- Just for testing horizontal scroll bar.
	love.graphics.print((leafBarAndHorizontalScrollBar.scrollBar.percentage*100+25) .."%",leafBarAndHorizontalScrollBar.scrollBar.x-leafBarAndHorizontalScrollBar.scrollBar.maxWidth/2,leafBarAndHorizontalScrollBar.y+4,0,1.5,1.5)
end

function testing_properties.drawVerticalScrollBarAttb()
	love.graphics.print("Total rows length: "..spreadsheetArea.totalLengthRow,spreadsheetArea.x+100,spreadsheetArea.y+50,0,2,2)
	love.graphics.print("Portion rows length: "..spreadsheetArea.portionTotalLengthRow,spreadsheetArea.x+100,spreadsheetArea.y+100,0,2,2)
-- Just for testing vertical scroll bar.
	love.graphics.print((verticalScrollBar.scrollBar.percentage*100+21-0.0740740) .."%",verticalScrollBar.x-100,verticalScrollBar.y+verticalScrollBar.height/2,0,1.5,1.5)
end

function testing_properties.drawCoordinates() -- For Testing.
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
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",titleBar.x,titleBar.y,titleBar.width,titleBar.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",titleBar.x,titleBar.y,titleBar.width,titleBar.height)
	-- Menu Bar
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",menuBar.x,menuBar.y,menuBar.width,menuBar.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",menuBar.x,menuBar.y,menuBar.width,menuBar.height)
	-- Tool Bar
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",toolBar.x,toolBar.y,toolBar.width,toolBar.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",toolBar.x,toolBar.y,toolBar.width,toolBar.height)
	-- Name Box and Formula Bar
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",nameBoxAndFormulaBar.x,nameBoxAndFormulaBar.y,nameBoxAndFormulaBar.width,nameBoxAndFormulaBar.height)	
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",nameBoxAndFormulaBar.x,nameBoxAndFormulaBar.y,nameBoxAndFormulaBar.width,nameBoxAndFormulaBar.height)	
	-- Spreadsheet Area
	love.graphics.rectangle("line",spreadsheetArea.x,spreadsheetArea.y,spreadsheetArea.width,spreadsheetArea.height)
	-- Leaf Bar and Horizontal ScrollBar
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",leafBarAndHorizontalScrollBar.x,leafBarAndHorizontalScrollBar.y,leafBarAndHorizontalScrollBar.width,leafBarAndHorizontalScrollBar.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",leafBarAndHorizontalScrollBar.x,leafBarAndHorizontalScrollBar.y,leafBarAndHorizontalScrollBar.width,leafBarAndHorizontalScrollBar.height)
	-- Status Bar, View Buttons and Zoom Controls
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",statusViewAndZoom.x,statusViewAndZoom.y,statusViewAndZoom.width,statusViewAndZoom.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",statusViewAndZoom.x,statusViewAndZoom.y,statusViewAndZoom.width,statusViewAndZoom.height)
	-- Vertical Scroll Bar
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",verticalScrollBar.x,verticalScrollBar.y,verticalScrollBar.width,verticalScrollBar.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",verticalScrollBar.x,verticalScrollBar.y,verticalScrollBar.width,verticalScrollBar.height)
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
--	testing_properties.drawCoordinates() -- Those circles you'd see in the screen.
--	testing_properties.drawHorizontalScrollBarAttb() -- For seeing column attributes
							 -- scroll bar.
--	testing_properties.drawVerticalScrollBarAttb() -- For seeing row attributes scroll bar.
	spreadsheetArea.draw()				-- Hidden behind other interfaces.
	testing_properties.drawInterface() 		 -- Temporary boxes for interface.
	titleBar.draw()
	menuBar.draw()
	toolBar.draw()
	nameBoxAndFormulaBar.draw()
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
