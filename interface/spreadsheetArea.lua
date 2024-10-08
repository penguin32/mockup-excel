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

local function separateLetterFromNumbers(phrase)
	local charTable = {}
	for i=1,#phrase,1 do
		table.insert(charTable,string.sub(phrase,i,i))
	end
	-- Checking if the first character is a letter. 65 to 90
	-- Then check chars if its a number 0 to 9,     48 to 57
	local alphabetColumn = ""
	local aNumberRow = ""
	for i,v in ipairs(charTable) do
		if string.byte(v) >= 65 and string.byte(v) <= 90 then
			alphabetColumn = alphabetColumn .. v
		elseif string.byte(v) >= 48 and string.byte(v) <= 57 then
			aNumberRow = aNumberRow .. v
		end
	end
	return tonumber(aNumberRow), alphabetColumn
end

local function runMethods(commands)-- =SUM(D6:D11) letters first then numbers, column then row.
	local firstParenthesis = string.find(commands,"%(")-- This are index where theyre found
	local separator = string.find(commands,":")
	local secondParenthesis = string.find(commands,"%)")

-- Getting first phrase.
	local	phrase1Row = nil
	local	phrase1Column = nil
	if firstParenthesis ~= nil then
		local phrase1 = string.sub(commands,firstParenthesis+1,separator-1)
		phrase1Row, phrase1Column = separateLetterFromNumbers(phrase1)
	end
-- Getting second phrase after that colon.
	local	phrase2Row = nil
	local	phrase2Column = nil
	if secondParenthesis ~= nil then
		local phrase2 = string.sub(commands,separator+1,secondParenthesis-1)
		phrase2Row, phrase2Column = separateLetterFromNumbers(phrase2)
	end

local iDidRun = false
local outputOfFunctions = 0

	if separator ~= nil and phrase1Row ~= nil and phrase1Column ~= nil and phrase2Row ~= nil and phrase2Column ~= nil then

		if string.sub(commands,1,4) == "=SUM" then

			iDidRun = true
			local byRowFirst = false
			local holdMyBeer = phrase1Row
		repeat -- Doing things in order, I know it's unnecessary.
			-- Just incase I needed this in future.
	for i,v in ipairs(spreadsheetArea.rAndC) do
		if v.selectedRect == true then
       if (phrase1Row == v.row and phrase1Column == v.column) and tonumber(v.value) ~= nil then
		outputOfFunctions = outputOfFunctions + tonumber(v.value)
		v.selectedRect = false
	elseif (phrase1Row == v.row and phrase1Column == v.column) and tonumber(v.value) == nil then
		v.selectedRect = false
	end
		end
	end -- In a tic tac toe, with "and" operator, with a selected
	--	Square tiles 3x3, it will only add diagonally,
	--	but with "or" operator, it will add everything by layer order
	--	starting from top left of the tic tac toe.
	--	Conclusion: or-operator works best for square tiles 3x3
	--			if I want that in order? I don't think I'd need that.
	--		and-operator works only for 1 dimension/n dimensions.
	--		I have more work for that,
	--	But if i want to do it in-order, it depends wether i want to do
	--	task by column then row, or by row and then column, it will depends.
	--	on what I may need in the future coding this.
	--	For now it should be "or" operator.
	--
	--	Nevermind, I'm using "and" operator, to make it possible to
	--	specify which boxes from the selected box I should add.
		if phrase1Row <= phrase2Row then
			phrase1Row = phrase1Row + 1
		else
			byRowFirst = true
		end
	if byRowFirst == true then
		if string.byte(phrase1Column) <= string.byte(phrase2Column) then
			phrase1Column = string.char(string.byte(phrase1Column)+1)
		end
		if phrase1Row > phrase2Row then
			phrase1Row = holdMyBeer
			byRowFirst = false
		end
	end
		until(phrase1Row > phrase2Row and string.byte(phrase1Column) > string.byte(phrase2Column))

--	for i,v in ipairs(spreadsheetArea.rAndC) do
--		if v.selectedRect == true then
--			outputOfFunctions = outputOfFunctions + v.value
--			v.selectedRect = false -- To stop re using same object.
--		end
--	end
		end -- end of if commands == "=SUM"
	end -- end of checking variables == nil
	return iDidRun, outputOfFunctions
-- How am I going to be sure that it wouldn't skip over some objects because index?
-- 	ans: Inside for-loops it does skip objects so addition with
-- 		"columns by rows" in order is troublesome since it has to be kept
-- 		running under update() function until all object.selectedRect all turned to
-- 		false,
--		then only it will set a certain boolean to turn it of,
--		when it is turned on first by a "return" key.
--		For now phrase1 and phrase2 column row, is not needed for sum function
--			when adding numbers in orders.
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
	spreadsheetArea.rAndC[index].selected = false -- Comment line for multiple select box.
			end -- For limiting selected boxes, for mousepressed() in this file.
		end
	end

	if spreadsheetArea.selectedRectMode == true then
		if spreadsheetArea.tablePos.persistentIndex > 0 then
		for i,v in ipairs(spreadsheetArea.rAndC) do
			if v.deltaX >= spreadsheetArea.rAndC[spreadsheetArea.tablePos.persistentIndex].deltaX and v.deltaY >= spreadsheetArea.rAndC[spreadsheetArea.tablePos.persistentIndex].deltaY and v.deltaX + v.width <= cursor.x and v.deltaY + v.height <= cursor.y then-- and spreadsheetArea.selectedRectMode == true then
				v.selectedRect = true
			else
				v.selectedRect = false
			end
		end
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
			["color"]={["r"]=0.5,["g"]=0.5,["b"]=0.5}
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
		["color"]={["r"]=0.5,["g"]=0.5,["b"]=0.5}
		})
	end

-- August 22, 2024 : Temporary solution for saving file because I want to use this app :)
	if love.filesystem.getInfo("savedata.txt")then
		file = love.filesystem.read("savedata.txt")
		data = lume.deserialize(file)
		spreadsheetArea.rAndC = data.rAndC
		spreadsheetArea.cRect = data.cRect
		spreadsheetArea.rRect = data.rRect
	else
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
		  ["color"]={["r"]=0,["g"]=0.5,["b"]=0.5},
		  selected = false,
		  selectedRect = false, -- I'll use this for rectangular selection CONTINUE
		  row=i,
		  column=string.char(j) -- For Adding function() command.
			})
		end
	end
	end -- August 22, 2024, Temporary solution for saving data & loading it.
	spreadsheetArea.tablePos = {x=0,y=0,index=0,persistentIndex=0
	} -- Used by highlight() and mousepressed().
	spreadsheetArea.selectedRectMode = false 	-- Set true, to select multiple boxes.
end

function spreadsheetArea.draw()
	spreadsheetArea.highlight()
	for i,v in ipairs(spreadsheetArea.rAndC) do -- Print out value above drawn rectangles.
		love.graphics.setColor(1,1,1)
		love.graphics.print(v.value,v.deltaX,v.deltaY,0,1,1,-5,-v.height/8)
		if v.selectedRect == true then
			love.graphics.setColor(0.8,0.8,0,0.5) -- For testing.
			love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
		end
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

--		love.graphics.setColor(1,1,1)
		love.graphics.setColor(v.color.r,v.color.g,v.color.b)
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
		spreadsheetArea.cRectExtendSide(v)
	end
	for i,v in ipairs(spreadsheetArea.rRect) do
		spreadsheetArea.rRectExtendSide(v)
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
		if containCursor() then
			if (cursor.x > topObj.deltaX and cursor.x < topObj.deltaX + topObj.width and cursor.y > leftObj.deltaY and cursor.y < leftObj.deltaY + leftObj.height) then
				spreadsheetArea.tablePos.x = topObj.deltaX
				spreadsheetArea.tablePos.y = leftObj.deltaY
				topObj.color={r=0,g=1,b=0}
				leftObj.color={r=0,g=1,b=0}
			end
		else
				topObj.color={r=0.5,g=0.5,b=0.5}
				leftObj.color={r=0.5,g=0.5,b=0.5}
		end
		end
	end
	for i,v in ipairs(spreadsheetArea.rAndC) do
			if v.selected == true then
				v.color.g=0.6
			else
				v.color.g=0.3
			end
		if v.deltaX == spreadsheetArea.tablePos.x and v.deltaY == spreadsheetArea.tablePos.y and containCursor() then
			v.color.b=0.5
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("fill",v.deltaX,v.deltaY,v.width,v.height)
			v.color.b=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
			spreadsheetArea.tablePos.index = i
		else
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		end
		if v.deltaX == spreadsheetArea.tablePos.x and v.deltaY < spreadsheetArea.tablePos.y and containCursor() then
			v.color.b=0.5
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		elseif v.deltaX == spreadsheetArea.tablePos.x and v.deltaY >= spreadsheetArea.tablePos.y and containCursor() then
			v.color.b=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		else
			v.color.b=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		end
		if v.deltaY == spreadsheetArea.tablePos.y and v.deltaX < spreadsheetArea.tablePos.x and containCursor() then
			v.color.b=0.7
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		elseif v.deltaY == spreadsheetArea.tablePos.y and v.deltaX >= spreadsheetArea.tablePos.x and containCursor() then
			v.color.b=0
			love.graphics.setColor(v["color"]["r"],v["color"]["g"],v["color"]["b"])
			love.graphics.rectangle("line",v.deltaX,v.deltaY,v.width,v.height)
		end
	end
	for i,v in ipairs(spreadsheetArea.cRect) do
		if spreadsheetArea.tablePos.index > 0 then
	       if spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].deltaX ~= v.deltaX and containCursor() then
			v.color={r=0.5,g=0.5,b=0.5}
		end
		end
	end
	for i,v in ipairs(spreadsheetArea.rRect) do
		if spreadsheetArea.tablePos.index > 0 then
		if spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].deltaY ~= v.deltaY and containCursor() then
			v.color={r=0.5,g=0.5,b=0.5}
		end
		end
	end
end

function spreadsheetArea.mousepressed(button)
if containCursor() then
	if button == 1 then
		if spreadsheetArea.tablePos.index > 0 then
-- Function added below here will run only once every after a new mousepressed.
-- spreadsheetArea.tablePos.index, is a boxes' index where cursor hover at or last hover at.

		if spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].selected==false then
			spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].selected=true
		     spreadsheetArea.tablePos.persistentIndex = spreadsheetArea.tablePos.index
		else -- This is how I currently deselect a box.
			spreadsheetArea.rAndC[spreadsheetArea.tablePos.index].selected=false
			spreadsheetArea.tablePos.persistentIndex = 0
		end -- Plan: If I click on a different box, It should reset v.selected value.
		end --  if v.selected == true, then if cursor.x < v.deltaX and so on...
	end

	-- Mouse button 2, right-click to test out function, selectedRectMode<- this is a bool.
	if button == 2 then
		if spreadsheetArea.selectedRectMode == false then
			spreadsheetArea.selectedRectMode = true
		     spreadsheetArea.tablePos.persistentIndex = spreadsheetArea.tablePos.index
		end
	end
end
end

function spreadsheetArea.mousereleased(button)
	if button == 2 then
		if spreadsheetArea.selectedRectMode == true then
			spreadsheetArea.selectedRectMode = false
		     spreadsheetArea.tablePos.persistentIndex = 0
		end
	end
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
				local bool, output = runMethods(v.value)
				if bool == true then
					v.value = output
				elseif byteoffset then
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

function spreadsheetArea.rRectExtendSide(object)
	if leftBoxInteraction(object) then
		if (math.abs(cursor.y - (object.deltaY+object.height))<object.height/2) then
			if love.mouse.isDown(1) then
				object.height=math.abs(cursor.y-object.deltaY)+10
			end
		end
	end
end

function spreadsheetArea.cRectExtendSide(object)
	if topBoxInteraction(object) then
		if (math.abs(cursor.x - (object.deltaX+object.width))<object.width/2) then
			if love.mouse.isDown(1) then
				object.width=math.abs(cursor.x-object.deltaX)+10
			end
		end
	end
end
