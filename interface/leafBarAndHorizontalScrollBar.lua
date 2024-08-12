leafBarAndHorizontalScrollBar={}

function leafBarAndHorizontalScrollBar.load()
	leafBarAndHorizontalScrollBar.x=origin.x
	leafBarAndHorizontalScrollBar.width=dynamicAppWindow.width
	leafBarAndHorizontalScrollBar.height=30
	--	Simple adjustments due to ordering of load(), added on statusViewAndZoom.load()
	leafBarAndHorizontalScrollBar.y=0

	leafBarAndHorizontalScrollBar.scrollBar={
		x=0, -- Getting updated at update() here.
		y=0,
		maxWidth=0,
		height=leafBarAndHorizontalScrollBar.height/1.4,
		deltaX=0,
		btnY=0,
		btnWidth=0, -- Button width, height.
		btnHeight=leafBarAndHorizontalScrollBar.height/1.9,
		offsetX=0,
		percentage=0,
						-- Will be updated on update() here.
		minPercentToPixel=0, 	-- Pretends to be (0,constantY) pixels.
		maxPercentToPixel=0,	-- Pretends to be (max,constantY)pixels.
					-- Edit, must treat now as actual percent!
		isPressed = false
	}
end

function leafBarAndHorizontalScrollBar.draw()
	-- Scroll bar.
	love.graphics.rectangle("line",leafBarAndHorizontalScrollBar.scrollBar.x,leafBarAndHorizontalScrollBar.scrollBar.y,leafBarAndHorizontalScrollBar.scrollBar.maxWidth,leafBarAndHorizontalScrollBar.scrollBar.height)
	-- btnScrollBar.
	love.graphics.rectangle("fill",leafBarAndHorizontalScrollBar.scrollBar.deltaX,leafBarAndHorizontalScrollBar.scrollBar.btnY,leafBarAndHorizontalScrollBar.scrollBar.btnWidth,leafBarAndHorizontalScrollBar.scrollBar.btnHeight)
end

local function setBtnPercentage() -- Will set percentage.
	if leafBarAndHorizontalScrollBar.scrollBar.isPressed == true then
		leafBarAndHorizontalScrollBar.scrollBar.maxPercentToPixel=(leafBarAndHorizontalScrollBar.scrollBar.maxWidth-leafBarAndHorizontalScrollBar.scrollBar.btnWidth)/leafBarAndHorizontalScrollBar.scrollBar.maxWidth	-- Pretend maxPercent, It's not actually 100,
				  -- because maxWidth is subtracted by btnWidth.
		leafBarAndHorizontalScrollBar.scrollBar.percentage=(leafBarAndHorizontalScrollBar.scrollBar.deltaX-leafBarAndHorizontalScrollBar.scrollBar.x)/leafBarAndHorizontalScrollBar.scrollBar.maxWidth
		if leafBarAndHorizontalScrollBar.scrollBar.percentage < leafBarAndHorizontalScrollBar.scrollBar.minPercentToPixel then
			leafBarAndHorizontalScrollBar.scrollBar.percentage = leafBarAndHorizontalScrollBar.scrollBar.minPercentToPixel
		elseif leafBarAndHorizontalScrollBar.scrollBar.percentage > leafBarAndHorizontalScrollBar.scrollBar.maxPercentToPixel then
			leafBarAndHorizontalScrollBar.scrollBar.percentage = leafBarAndHorizontalScrollBar.scrollBar.maxPercentToPixel
			-- Pretend max percentage, because not really actually a 100%,
			-- because of btnWidth.
		end
	end
end

local function setScrollBarBtn()-- Will set scroll bar btn base of percentage, and check bounds
	if leafBarAndHorizontalScrollBar.scrollBar.deltaX >= leafBarAndHorizontalScrollBar.scrollBar.x then
		leafBarAndHorizontalScrollBar.scrollBar.deltaX=leafBarAndHorizontalScrollBar.scrollBar.x+leafBarAndHorizontalScrollBar.scrollBar.maxWidth*leafBarAndHorizontalScrollBar.scrollBar.percentage
	elseif leafBarAndHorizontalScrollBar.scrollBar.deltaX < leafBarAndHorizontalScrollBar.scrollBar.x then
		leafBarAndHorizontalScrollBar.scrollBar.deltaX=leafBarAndHorizontalScrollBar.scrollBar.x
	elseif leafBarAndHorizontalScrollBar.scrollBar.deltaX+leafBarAndHorizontalScrollBar.scrollBar.btnWidth <= leafBarAndHorizontalScrollBar.scrollBar.x+leafBarAndHorizontalScrollBar.scrollBar.maxWidth then
		leafBarAndHorizontalScrollBar.scrollBar.deltaX=leafBarAndHorizontalScrollBar.scrollBar.x+leafBarAndHorizontalScrollBar.scrollBar.maxWidth*leafBarAndHorizontalScrollBar.scrollBar.percentage
	elseif leafBarAndHorizontalScrollBar.scrollBar.deltaX+leafBarAndHorizontalScrollBar.scrollBar.btnWidth > leafBarAndHorizontalScrollBar.scrollBar.x+leafBarAndHorizontalScrollBar.scrollBar.maxWidth then
		leafBarAndHorizontalScrollBar.scrollBar.deltaX=leafBarAndHorizontalScrollBar.scrollBar.x+leafBarAndHorizontalScrollBar.scrollBar.maxWidth-leafBarAndHorizontalScrollBar.scrollBar.btnWidth
	end
end

function leafBarAndHorizontalScrollBar.update()
	leafBarAndHorizontalScrollBar.width=dynamicAppWindow.width

	-- scrollBar
	leafBarAndHorizontalScrollBar.scrollBar.maxWidth=leafBarAndHorizontalScrollBar.width/3
	leafBarAndHorizontalScrollBar.offsetX=leafBarAndHorizontalScrollBar.scrollBar.maxWidth+5
	leafBarAndHorizontalScrollBar.scrollBar.x=leafBarAndHorizontalScrollBar.x+leafBarAndHorizontalScrollBar.width-leafBarAndHorizontalScrollBar.offsetX
	leafBarAndHorizontalScrollBar.scrollBar.y=leafBarAndHorizontalScrollBar.y+5
	leafBarAndHorizontalScrollBar.scrollBar.btnY=leafBarAndHorizontalScrollBar.scrollBar.y+2.9
	leafBarAndHorizontalScrollBar.scrollBar.btnWidth=leafBarAndHorizontalScrollBar.scrollBar.maxWidth/4


	setBtnPercentage()
	setScrollBarBtn()

	if leafBarAndHorizontalScrollBar.scrollBar.isPressed == true then
		leafBarAndHorizontalScrollBar.scrollBar.deltaX = cursor.x - leafBarAndHorizontalScrollBar.scrollBar.btnWidth/2
	end
end

function leafBarAndHorizontalScrollBar.interact() -- Used in userControls.lua
	if cursor.y > leafBarAndHorizontalScrollBar.scrollBar.y and cursor.y < leafBarAndHorizontalScrollBar.scrollBar.y + leafBarAndHorizontalScrollBar.scrollBar.height and cursor.x > leafBarAndHorizontalScrollBar.scrollBar.x and cursor.x < leafBarAndHorizontalScrollBar.scrollBar.x + leafBarAndHorizontalScrollBar.scrollBar.maxWidth then
		leafBarAndHorizontalScrollBar.scrollBar.isPressed = true
	end
end
