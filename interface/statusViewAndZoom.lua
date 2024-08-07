statusViewAndZoom={}

function statusViewAndZoom.load()
	statusViewAndZoom.height=30
	statusViewAndZoom.x=origin.x
end

function statusViewAndZoom.draw()
end

function statusViewAndZoom.update()
        statusViewAndZoom.width=dynamicAppWindow.width

	-- A nutcase of spreadsheetArea.height, to be simply adjusted at this load()
	-- 	along with leafBarAnd.. ..height.
spreadsheetArea.height=dynamicAppWindow.height-titleBar.height-menuBar.height-toolBar.height-nameBoxAndFormulaBar.height-leafBarAndHorizontalScrollBar.height-statusViewAndZoom.height

	leafBarAndHorizontalScrollBar.y=spreadsheetArea.y+spreadsheetArea.height

	statusViewAndZoom.y=leafBarAndHorizontalScrollBar.y+leafBarAndHorizontalScrollBar.height
end
