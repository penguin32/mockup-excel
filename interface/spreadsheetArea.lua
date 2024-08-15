spreadsheetArea={}

function spreadsheetArea.load()
	spreadsheetArea.x=origin.x
	spreadsheetArea.y=nameBoxAndFormulaBar.y+nameBoxAndFormulaBar.height
	spreadsheetArea.height=0 -- Adjusted at statusViewAndZoom.load()
	spreadsheetArea.width=0  -- Adjusted at verticalScrollBar.load() or update()

	spreadsheetArea.totalLengthColumn=0 -- Use for horizontal scroll bar percentage.
	spreadsheetArea.portionTotalLengthColumn=0
	spreadsheetArea.totalLengthRow=0
	spreadsheetArea.portionTotalLengthRow=0
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
	spreadsheetArea.rAndC={} -- The table, rows and columns of spreadsheet.
	spreadsheetArea.amountOfRows = 30	-- Could be change by user.
	for i = 65,90,1 do -- Alphabets , Columns.
		table.insert(spreadsheetArea.cRect,{
			value=string.char(i),
			width=65,
			height=spreadsheetArea.cBoxField.height,
		       x=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(i-65),
			y=spreadsheetArea.y,
		  deltaX=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(i-65),
			deltaY=spreadsheetArea.y
		})
	end
	for i = 1,spreadsheetArea.amountOfRows,1 do -- Numbers, Rows
		table.insert(spreadsheetArea.rRect,{
			value=i,
			width=spreadsheetArea.cBoxField.width,
			height=20,
			x=spreadsheetArea.cBoxField.x,
		       y=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1),
			deltaX=spreadsheetArea.cBoxField.x,
		   deltaY=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1)
		})
	end
	for i = 1,spreadsheetArea.amountOfRows,1 do
		for j = 65,90,1 do -- Alphabets
			table.insert(spreadsheetArea.rAndC,{
				value=i.."&"..j,
				width=65,
				height=20,
	              x=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(j-65),
		      y=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1),
		  deltaX=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(i-65),
	          deltaY=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1),
		  ["color"]={["r"]=0,["g"]=0.1,["b"]=0},
		  onlyInsideViewport = function()
			if (cursor.x > spreadsheetArea.x and cursor.x < spreadsheetArea.x + spreadsheetArea.width and cursor.y > spreadsheetArea.y and cursor.y < spreadsheetArea.y + spreadsheetArea.height) then
				return true
			else
				return false
		  	end

		  end,
		  highlight = function(self, bool)
			  bool = bool or true
			if self.keepHighlighted == true or self.selecting == true or (cursor.x > self.deltaX and cursor.y > self.deltaY and cursor.x < self.deltaX + self.width and cursor.y < self.deltaY + self.height) then
				self["color"]["g"]=0.1
	      love.graphics.setColor(self["color"]["r"],self["color"]["g"],self["color"]["b"])
		love.graphics.rectangle("fill",self.deltaX,self.deltaY,self.width,self.height)
	      love.graphics.setColor(1,1,1)
				self["color"]["g"]=1
	      love.graphics.setColor(self["color"]["r"],self["color"]["g"],self["color"]["b"])
		love.graphics.rectangle("line",self.deltaX,self.deltaY,self.width,self.height)
	      love.graphics.setColor(1,1,1)
	      if bool == self.onlyInsideViewport() then
	      return true
	      end
			else
				self["color"]["g"]=0.1
	      love.graphics.setColor(self["color"]["r"],self["color"]["g"],self["color"]["b"])
		love.graphics.rectangle("line",self.deltaX,self.deltaY,self.width,self.height)
	      love.graphics.setColor(1,1,1)
	      return false
			end
		   end,
		   selecting = false,
		   selected = false,	-- Need to be manually turned false by the user.
		   rectangularSelection = function(self) -- Used on mousepressed() userControls
			   spreadsheetArea.rectangularSelection.table = {}
spreadsheetArea.rectangularSelection.x = self.deltaX
spreadsheetArea.rectangularSelection.y = self.deltaY
			   self.keepHighlighted = false
			   if self.highlight(self,false) and self.selected == false then
				   self.selecting = true
				   self.selected = true
			   else
				   self.selected = false
				   self.selecting = false
			   end
		   end,
--		   onMousereleased = function(self) -- Used on userControls.lua
--			   self.selecting = false
--		   end,
		   keepHighlighted = false
		})
		end
	end
	spreadsheetArea.rectangularSelection={-- Will be use for grabing boxes.
		x=0,			-- Instead of looping through all boxes,
		y=0,			-- I will refer to the first selected box here.
					-- Then put all those selected boxes in a table here.
		table={},		-- I should refer its object's value as an identifier.
		onMouseDown = function()-- On update() here.
	   for i,v in ipairs(spreadsheetArea.rAndC) do
   		if love.mouse.isDown(1) and v.onlyInsideViewport() then
		   if v.deltaX >= spreadsheetArea.rectangularSelection.x and v.deltaX <= cursor.x and v.deltaY >= spreadsheetArea.rectangularSelection.y and v.deltaY <= cursor.y  then
			   table.insert(spreadsheetArea.rectangularSelection.table,v.value)
	--		   v.keepHighlighted = true
		   end
		end
	   end
		 end,
		 keepHighlighted = function()
			 for i,v in ipairs(spreadsheetArea.rectangularSelection.table) do
				for i,object in ipairs(spreadsheetArea.rAndC) do
					if object.value == v then
						object.keepHighlighted = true
					end
				end
			 end
		 end
	}
	spreadsheetArea.getTotalLengthColumnRow() -- Used for scrollBar navigation.
						  -- scrollBarUpdate()
end

function spreadsheetArea.draw()
	for i, v in ipairs(spreadsheetArea.rAndC) do -- for testing
		if v.selected == true then
			love.graphics.setColor(1,1,1)
			love.graphics.circle("fill",spreadsheetArea.rectangularSelection.x,spreadsheetArea.rectangularSelection.y,20)
		end
	end
	for i = #spreadsheetArea.rAndC, 1, -1 do -- Iterating from the end of the sequence.
		spreadsheetArea.rAndC[i].highlight(spreadsheetArea.rAndC[i])
		love.graphics.print(spreadsheetArea.rAndC[i].value,spreadsheetArea.rAndC[i].deltaX+spreadsheetArea.rAndC[i].width/2,spreadsheetArea.rAndC[i].deltaY+spreadsheetArea.rAndC[i].height/6,0,1,1,string.len(spreadsheetArea.rAndC[i].value)*3)
	end

	for i,v in ipairs(spreadsheetArea.cRect) do
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		love.graphics.print(v.value,v.deltaX+v.width/2,v.deltaY+v.height/6,0,1,1)
	end
	for i,v in ipairs(spreadsheetArea.rRect) do
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
		love.graphics.setColor(1,1,1)
		love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		love.graphics.print(v.value,v.deltaX+v.width/9.5,v.deltaY+v.height/6,0,1,1)
	end
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",spreadsheetArea.cBoxField.x,spreadsheetArea.cBoxField.y,spreadsheetArea.cBoxField.width,spreadsheetArea.cBoxField.height)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",spreadsheetArea.cBoxField.x,spreadsheetArea.cBoxField.y,spreadsheetArea.cBoxField.width,spreadsheetArea.cBoxField.height)
end

function spreadsheetArea.update()
	spreadsheetArea.rectangularSelection.onMouseDown()
	spreadsheetArea.rectangularSelection.keepHighlighted()
	spreadsheetArea.scrollBarUpdate()
	spreadsheetArea.mouseVisibility()
	for i, v in ipairs(spreadsheetArea.rAndC) do -- for testing
		if v.selected == true then
			spreadsheetArea.rectangularSelection.x=v.deltaX
			spreadsheetArea.rectangularSelection.y=v.deltaY
		end
	end
end

function spreadsheetArea.getTotalLengthColumnRow() -- Will be use by horizontal scroll bar.
	for i,v in ipairs(spreadsheetArea.cRect) do
		spreadsheetArea.totalLengthColumn=spreadsheetArea.totalLengthColumn+v.width
	end
	for i,v in ipairs(spreadsheetArea.rRect) do -- and vertical scroll bar.
		spreadsheetArea.totalLengthRow=spreadsheetArea.totalLengthRow+v.height
	end
end

function spreadsheetArea.scrollBarUpdate()
	spreadsheetArea.portionTotalLengthColumn = spreadsheetArea.totalLengthColumn*leafBarAndHorizontalScrollBar.scrollBar.percentage
	for i,v in ipairs(spreadsheetArea.cRect) do
		v.deltaX=v.x-spreadsheetArea.portionTotalLengthColumn
	end
	spreadsheetArea.portionTotalLengthRow = spreadsheetArea.totalLengthRow*verticalScrollBar.scrollBar.percentage
	for i,v in ipairs(spreadsheetArea.rRect) do
		v.deltaY=v.y-spreadsheetArea.portionTotalLengthRow
	end
	for i,v in ipairs(spreadsheetArea.rAndC) do
		v.deltaX=v.x-spreadsheetArea.portionTotalLengthColumn
		v.deltaY=v.y-spreadsheetArea.portionTotalLengthRow
	end
end

function spreadsheetArea.mouseVisibility()
	if cursor.x > spreadsheetArea.x and cursor.x < spreadsheetArea.x + spreadsheetArea.width and cursor.y > spreadsheetArea.y and cursor.y < spreadsheetArea.y + spreadsheetArea.height then
		love.mouse.setVisible(false)
	else
		love.mouse.setVisible(true)
	end
end
