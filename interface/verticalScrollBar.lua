verticalScrollBar={}

function verticalScrollBar.load()
	verticalScrollBar.width=20
	verticalScrollBar.height=0	-- update() here.
	verticalScrollBar.x=0		-- update() here.
	verticalScrollBar.y=nameBoxAndFormulaBar.y+nameBoxAndFormulaBar.height

	verticalScrollBar.scrollBar={
		x=0, -- Getting updated at update() here.
		y=0,
		width=verticalScrollBar.width,
		maxHeight=0,
		btnX=0,
		deltaY=0,
		btnWidth=verticalScrollBar.width/1.4,
		btnHeight=0, -- Button width, height.
		percentage=0,
						-- Will be updated on update() here.
		minPercentToPixel=0, 	-- Pretends to be (constantX,0) pixels.
		maxPercentToPixel=0,	-- Pretends to be (constantX,max)pixels.
					-- Edit, must treat now as actual percent!
		isPressed = false
	}
end

function verticalScrollBar.draw()
	-- btnScrollBar.
	love.graphics.rectangle("fill",verticalScrollBar.scrollBar.btnX,verticalScrollBar.scrollBar.deltaY,verticalScrollBar.scrollBar.btnWidth,verticalScrollBar.scrollBar.btnHeight)
end

local function setBtnPercentage() -- Will set percentage.
	if verticalScrollBar.scrollBar.isPressed == true then
		verticalScrollBar.scrollBar.maxPercentToPixel=(verticalScrollBar.scrollBar.maxHeight-verticalScrollBar.scrollBar.btnHeight)/verticalScrollBar.scrollBar.maxHeight
				  -- Pretend maxPercent, It's not actually 100,
				  -- because maxHeight is subtracted by btnWidth.
		verticalScrollBar.scrollBar.percentage=(verticalScrollBar.scrollBar.deltaY-verticalScrollBar.scrollBar.y)/verticalScrollBar.scrollBar.maxHeight
		if verticalScrollBar.scrollBar.percentage < verticalScrollBar.scrollBar.minPercentToPixel then
			verticalScrollBar.scrollBar.percentage = verticalScrollBar.scrollBar.minPercentToPixel
		elseif verticalScrollBar.scrollBar.percentage > verticalScrollBar.scrollBar.maxPercentToPixel then
			verticalScrollBar.scrollBar.percentage = verticalScrollBar.scrollBar.maxPercentToPixel
			-- Pretend max percentage, because not really actually a 100%,
			-- because of btnHeight.
		end
	end
end

local function setScrollBarBtn()
	if verticalScrollBar.scrollBar.deltaY >= verticalScrollBar.scrollBar.y then
		verticalScrollBar.scrollBar.deltaY=verticalScrollBar.scrollBar.y+verticalScrollBar.scrollBar.maxHeight*verticalScrollBar.scrollBar.percentage
	elseif verticalScrollBar.scrollBar.deltaY < verticalScrollBar.scrollBar.y then
		verticalScrollBar.scrollBar.deltaY=verticalScrollBar.scrollBar.y
	elseif verticalScrollBar.scrollBar.deltaY+verticalScrollBar.scrollBar.btnHeight <= verticalScrollBar.scrollBar.y+verticalScrollBar.scrollBar.maxHeight then
		verticalScrollBar.scrollBar.deltaY=verticalScrollBar.scrollBar.y+verticalScrollBar.scrollBar.maxHeight*verticalScrollBar.scrollBar.percentage
	elseif verticalScrollBar.scrollBar.deltaY+verticalScrollBar.scrollBar.btnHeight > verticalScrollBar.scrollBar.y+verticalScrollBar.scrollBar.maxHeight then
		verticalScrollBar.scrollBar.deltaY=verticalScrollBar.scrollBar.y+verticalScrollBar.scrollBar.maxHeight-verticalScrollBar.scrollBar.btnHeight
	end
end

function verticalScrollBar.update()
	verticalScrollBar.x=origin.x+dynamicAppWindow.width-verticalScrollBar.width
	verticalScrollBar.height=spreadsheetArea.height

	-- For scroll bar.
	verticalScrollBar.scrollBar.x=verticalScrollBar.x
	verticalScrollBar.scrollBar.y=verticalScrollBar.y+spreadsheetArea.cBoxField.height
	verticalScrollBar.scrollBar.btnX=verticalScrollBar.scrollBar.x+3
	verticalScrollBar.scrollBar.btnHeight=verticalScrollBar.height/5
	verticalScrollBar.scrollBar.maxHeight=verticalScrollBar.height-spreadsheetArea.cBoxField.height
	setBtnPercentage()
	setScrollBarBtn()

	if verticalScrollBar.scrollBar.isPressed == true then
		verticalScrollBar.scrollBar.deltaY=cursor.y-verticalScrollBar.scrollBar.btnHeight/2
	end

	-- From spreadsheetArea.lua
	spreadsheetArea.width = dynamicAppWindow.width - verticalScrollBar.width
end

function verticalScrollBar.interact(button)
	if button == 1 then
		if cursor.x > verticalScrollBar.scrollBar.x and cursor.x < verticalScrollBar.scrollBar.x + verticalScrollBar.scrollBar.width and cursor.y > verticalScrollBar.scrollBar.y and cursor.y < verticalScrollBar.scrollBar.y + verticalScrollBar.scrollBar.maxHeight then
			verticalScrollBar.scrollBar.isPressed = true
		end
	end
end
