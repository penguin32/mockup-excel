spreadsheetArea={}

local function containCursor()	-- Contain cursor in viewport.
	if cursor.x > spreadsheetArea.x+spreadsheetArea.cBoxField.width and cursor.x < spreadsheetArea.x + spreadsheetArea.width and cursor.y > spreadsheetArea.y + spreadsheetArea.cBoxField.height and cursor.y < spreadsheetArea.y + spreadsheetArea.height then
		return true
	else
		return false
	end
end

local function topBoxInteraction(v) -- Returns true if cursor interacts with a box.
	if (cursor.y > spreadsheetArea.cBoxField.y and cursor.y < spreadsheetArea.cBoxField.y + spreadsheetArea.cBoxField.height and cursor.x > v.deltaX and cursor.x < v.deltaX + v.width) and (cursor.x > spreadsheetArea.cBoxField.x + spreadsheetArea.cBoxField.width and cursor.x < spreadsheetArea.x + spreadsheetArea.width) then
		return true
	else
		return false
	end
end

local function leftBoxInteraction(v)
	if (cursor.x > spreadsheetArea.cBoxField.x and cursor.x < spreadsheetArea.cBoxField.x + spreadsheetArea.cBoxField.width and cursor.y > v.deltaY and cursor.y < v.deltaY + v.height) then
		return true
	else
		return false
	end
end

local function topBoxUpdate()
	for i,v in ipairs(spreadsheetArea.cRect) do
		if i ~= 1 then
			v.x=spreadsheetArea.cRect[i-1].x+spreadsheetArea.cRect[i-1].width
		end
	end
end

local function leftBoxUpdate()
	for i,v in ipairs(spreadsheetArea.rRect) do
		if i ~= 1 then
			v.y=spreadsheetArea.rRect[i-1].y+spreadsheetArea.rRect[i-1].height
		end
	end
end


local function updateSpreadsheet()
	local index = 0
	for a,b in ipairs(spreadsheetArea.rRect) do
		for c,d in ipairs(spreadsheetArea.cRect) do
			index = index + 1
			spreadsheetArea.rAndC[index].x = d.x
			spreadsheetArea.rAndC[index].y = b.y
			spreadsheetArea.rAndC[index].width = d.width
			spreadsheetArea.rAndC[index].height = b.height
			if index ~= spreadsheetArea.tablePos.persistentIndex then
	spreadsheetArea.rAndC[index].selected = false
			end -- For limiting selected boxes, for mousepressed() in this file.
		end
	end
end

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
			deltaY=spreadsheetArea.y,
			["color"]={["r"]=0,["g"]=0,["b"]=0},
		extendSide = function(self)
			if topBoxInteraction(self) then
				if (math.abs(cursor.x - (self.deltaX+self.width))<self.width/2) then
					if love.mouse.isDown(1) then
						self.width=math.abs(cursor.x-self.deltaX)+10
					end
				end
			end
		end
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
		  deltaY=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1),
		  ["color"]={["r"]=0,["g"]=0,["b"]=0},
		extendSide = function(self)
			if leftBoxInteraction(self) then
				if (math.abs(cursor.y - (self.deltaY+self.height))<self.height/2) then
					if love.mouse.isDown(1) then
						self.height=math.abs(cursor.y-self.deltaY)+10
					end
				end
			end
		end
		})
	end
	for i = 1,spreadsheetArea.amountOfRows,1 do
		for j = 65,90,1 do -- Alphabets
			table.insert(spreadsheetArea.rAndC,{
				value="",--i.."&"..j,
				width=65,
				height=20,
	              x=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(j-65),
		      y=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1),
		  deltaX=spreadsheetArea.cBoxField.x+spreadsheetArea.cBoxField.width+65*(i-65),
	          deltaY=spreadsheetArea.cBoxField.y+spreadsheetArea.cBoxField.height+20*(i-1),
		  ["color"]={["r"]=0,["g"]=0,["b"]=0},
		  selected = false
			})
		end
	end
	spreadsheetArea.tablePos = {x=0,y=0,index=0,persistentIndex=0
	} -- Used by highlight() and mousepressed().
end

function spreadsheetArea.draw()
	spreadsheetArea.highlight()
	for i,v in ipairs(spreadsheetArea.rAndC) do -- Print out value above drawn rectangles.
		love.graphics.setColor(1,1,1)
		love.graphics.print(v.value,v.deltaX,v.deltaY,0,1,1,-5,-v.height/8)
	end

	for i,v in ipairs(spreadsheetArea.cRect) do
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
		if topBoxInteraction(v) then -- For testing,	Resizing top boxes columns.
			love.graphics.setColor(0.4,0.4,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
			love.graphics.setColor(0.7,0.7,0)
		love.graphics.rectangle("fill",v.deltaX+v.width/1.2,v.deltaY,v.width,v.height)
			love.graphics.setColor(1,1,1)
		end
--		love.graphics.setColor(1,1,1)
		love.graphics.setColor(v.color.r,v.color.g,v.color.b)
		love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		love.graphics.print(v.value,v.deltaX+v.width/2,v.deltaY+v.height/6,0,1,1)
	end
	for i,v in ipairs(spreadsheetArea.rRect) do
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
		if leftBoxInteraction(v) then -- For testing,	Resizing left boxes rows.
			love.graphics.setColor(0.4,0.4,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
			love.graphics.setColor(0.7,0.7,0)
		love.graphics.rectangle("fill",v.deltaX,v.deltaY+v.height/2,v.width,v.height)
			love.graphics.setColor(1,1,1)
		end

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
	spreadsheetArea.scrollBarUpdate()
--	spreadsheetArea.mouseVisibility()
	for i,v in ipairs(spreadsheetArea.cRect) do
		v.extendSide(v)
	end
	for i,v in ipairs(spreadsheetArea.rRect) do
		v.extendSide(v)
	end
	topBoxUpdate()
	leftBoxUpdate()
	updateSpreadsheet()
	spreadsheetArea.getTotalLengthColumnRow()
end

function spreadsheetArea.getTotalLengthColumnRow() -- Will be use by scroll bars.
	spreadsheetArea.totalLengthColumn=spreadsheetArea.cRect[#spreadsheetArea.cRect].x+spreadsheetArea.cRect[#spreadsheetArea.cRect].width-spreadsheetArea.cRect[1].x
	spreadsheetArea.totalLengthRow=spreadsheetArea.rRect[#spreadsheetArea.rRect].y+spreadsheetArea.rRect[#spreadsheetArea.rRect].height-spreadsheetArea.rRect[1].y
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
	if containCursor() then
		love.mouse.setVisible(false)
	else
		love.mouse.setVisible(true)
	end
end

function spreadsheetArea.highlight()
	for a,topObj in ipairs(spreadsheetArea.cRect) do -- Top most.
		for b,leftObj in ipairs(spreadsheetArea.rRect) do -- Left most.
			if containCursor() and (cursor.x > topObj.deltaX and cursor.x < topObj.deltaX + topObj.width and cursor.y > leftObj.deltaY and cursor.y < leftObj.deltaY + leftObj.height) then
				spreadsheetArea.tablePos.x = topObj.deltaX
				spreadsheetArea.tablePos.y = leftObj.deltaY
			end
		end
	end
	for i,v in ipairs(spreadsheetArea.rAndC) do
			if v.selected == true then
				v.color.b=1
			else
				v.color.b=0.3
			end
		if v.deltaX == spreadsheetArea.tablePos.x and v.deltaY == spreadsheetArea.tablePos.y and containCursor() then
			v.color.g=0.7
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
			v.color.g=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
			spreadsheetArea.tablePos.index = i
		else
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		end
		if v.deltaX == spreadsheetArea.tablePos.x and v.deltaY < spreadsheetArea.tablePos.y and containCursor() then
			v.color.g=0.5
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		elseif v.deltaX == spreadsheetArea.tablePos.x and v.deltaY >= spreadsheetArea.tablePos.y and containCursor() then
			v.color.g=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		else
			v.color.g=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		end
		if v.deltaY == spreadsheetArea.tablePos.y and v.deltaX < spreadsheetArea.tablePos.x and containCursor() then
			v.color.g=0.7
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		elseif v.deltaY == spreadsheetArea.tablePos.y and v.deltaX >= spreadsheetArea.tablePos.x and containCursor() then
			v.color.g=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		end
		for i,v in ipairs(spreadsheetArea.cRect) do
			if v.deltaY == spreadsheetArea.tablePos.y then
				v.color={r=0,g=1,b=0} -- Continue here, fix color
			else				-- of top column bar.
				v.color={r=1,g=1,b=1}
			end
		end
	end
end

function spreadsheetArea.mousepressed(button)
	if spreadsheetArea.tablePos.index > 0 and button == 1 and containCursor() then
-- Function added below here will run only once every after a new mousepressed.
-- spreadsheetArea.tablePos.index, is a boxes' index where cursor hover at or last hover at.

		if spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].selected==false then
			spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].selected=true
		     spreadsheetArea.tablePos.persistentIndex = spreadsheetArea.tablePos.index
		else -- This is how I currently deselect a box.
			spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].selected=false
			spreadsheetArea.tablePos.persistentIndex = 0
		end -- Plan: If I click on a different box, It should reset v.selected value.
	end	    --  if v.selected == true, then if cursor.x < v.deltaX and so on...
end

function spreadsheetArea.keypressed(key)
	if key == "backspace" then -- Remove last characters on v.value that has selected==true
		for i,v in ipairs(spreadsheetArea.rAndC) do
			if v.selected == true then
				local byteoffset = utf8.offset(v.value,-1)
				if byteoffset then
					v.value = string.sub(v.value,1,byteoffset-1)
				end
			end
		end
	end
	if key == "return" then -- Remove last characters on v.value that has selected==true
		for i,v in ipairs(spreadsheetArea.rAndC) do
			if v.selected == true then
				local byteoffset = utf8.offset(v.value,-1)
				if byteoffset then
					v.value = v.value .. "\n"
				end
			end
		end
	end
end

function spreadsheetArea.textInput(t)
	for i,v in ipairs(spreadsheetArea.rAndC) do -- Append text input on v.value,
		if v.selected == true then	    -- that has selected == true.
			v.value = v.value .. t
		end
	end
end
