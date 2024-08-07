verticalScrollBar={}

function verticalScrollBar.load()
	verticalScrollBar.width=20
	verticalScrollBar.y=nameBoxAndFormulaBar.y+nameBoxAndFormulaBar.height
end

function verticalScrollBar.draw()
end

function verticalScrollBar.update()
	verticalScrollBar.x=origin.x+dynamicAppWindow.width-verticalScrollBar.width
	verticalScrollBar.height=spreadsheetArea.height

	-- From spreadsheetArea.lua
	spreadsheetArea.width = dynamicAppWindow.width - verticalScrollBar.width
end
