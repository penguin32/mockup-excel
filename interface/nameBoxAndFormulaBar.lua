nameBoxAndFormulaBar={}

function nameBoxAndFormulaBar.load()
	nameBoxAndFormulaBar.x = origin.x
	nameBoxAndFormulaBar.y = toolBar.y+toolBar.height
	nameBoxAndFormulaBar.height= 30
end

function nameBoxAndFormulaBar.draw()
end

function nameBoxAndFormulaBar.update()
	nameBoxAndFormulaBar.width = dynamicAppWindow.width
end
