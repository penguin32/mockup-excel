spreadsheetArea={}

function spreadsheetArea.load()
	spreadsheetArea.x=origin.x
	spreadsheetArea.y=nameBoxAndFormulaBar.y+nameBoxAndFormulaBar.height
	--spreadsheetArea.height=0 -- Adjusted at statusViewAndZoom.load()
	--spreadsheetArea.width=0  -- Adjusted at verticalScrollBar.load() or update()

	spreadsheetArea.cBoxField={
		width=20,
		height=20,
		x=spreadsheetArea.x,
		y=spreadsheetArea.y
	}-- cornerBoxField, top left corner.

	-- 	These two table below will become a label for objects created between cRect and
	-- rRect which would represents Objects' positions.
	-- Object(row,column) instead of that, Because I don't want to deal with switch cases
	-- because of alphabets, It'll be Object(x,y)
	spreadsheetArea.cRect={} -- columnsRectangles, an Object that has value and positions.
	spreadsheetArea.rRect={} -- rowRectangles, an Object that has value and positions.
	spreadsheetArea.amountOfRows = 30	-- Could be change by user.
	for i = 65,90,1 do
		table.insert(spreadsheetArea.cRect,{
			value=string.char(i),
			width=65,
			height=spreadsheetArea.cBoxField.height,
		       x=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(i-65),
			y=spreadsheetArea.y
		})
	end
	for i = 1,spreadsheetArea.amountOfRows,1 do
		table.insert(spreadsheetArea.rRect,{
			value=i,
			width=spreadsheetArea.cBoxField.width,
			height=20,
			x=spreadsheetArea.cBoxField.x,
			y=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1)
		})
	end
end

function spreadsheetArea.draw()
	love.graphics.rectangle("line",spreadsheetArea.cBoxField.x,spreadsheetArea.cBoxField.y,spreadsheetArea.cBoxField.width,spreadsheetArea.cBoxField.height)
	for i,v in ipairs(spreadsheetArea.cRect) do
		love.graphics.rectangle("line",v.x,v.y,v.width,v.height)
		love.graphics.print(v.value,v.x+v.width/2,v.y+v.height/6,0,1,1)
	end
	for i,v in ipairs(spreadsheetArea.rRect) do
		love.graphics.rectangle("line",v.x,v.y,v.width,v.height)
		love.graphics.print(v.value,v.x+v.width/9.5,v.y+v.height/6,0,1,1)
	end
end

function spreadsheetArea.update()
end
