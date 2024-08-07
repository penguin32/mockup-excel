spreadsheetArea={}

function spreadsheetArea.load()
	spreadsheetArea.x=origin.x
	spreadsheetArea.y=nameBoxAndFormulaBar.y+nameBoxAndFormulaBar.height
	--spreadsheetArea.height=0 -- Adjusted at statusViewAndZoom.load()
	--spreadsheetArea.width=0  -- Adjusted at verticalScrollBar.load() or update()
end

function spreadsheetArea.draw()
end

function spreadsheetArea.update()
end
