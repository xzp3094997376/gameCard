local m = {} 

function m:update(item, index, myTable, delegate)
	for i=1,#item do
		self["cell" .. (i-1)].text= item[i].color .. item[i].name .. "[-]"
	end
	for i=#item+1,3 do
		self["cell" .. (i-1)].text=""
	end
end 

return m