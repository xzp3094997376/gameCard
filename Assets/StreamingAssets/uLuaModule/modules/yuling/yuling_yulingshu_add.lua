local m = {} 

function m:Start()
	local lv = Player.yuling.yulingshu.curLevel
	local item1=TableReader:TableRowByID("yulingshu_lvup",lv)
	local _index = 0
	TableReader:ForEachTable("yulingshu_magic_effect",
        function(index, item)
            if item ~= nil and tonumber(item.level)==lv then
            	local id = item.magic_effect
            	local num=0
                for i=1,lv do
                    local arg = Player.yuling.yulingshu[i][id] or 0
                    num=num+arg
                end
            	if num>0 then 
            		_index=_index+1
            		local arg1 = num/item._magic_effect.denominator
            		self["des".. _index].text=string.gsub("[ffff96]" .. item._magic_effect.format .. "[-]", "{0}", "[-][24FC24]" .. arg1)
            	end 	
            end
            return false
        end)
	for i=0,item1.magic.Count-1 do
		local row = item1.magic[i]
		local arg1 = row.magic_arg1/row._magic_effect.denominator
		self["des_".. (i+1)].text=string.gsub("[ffff96]" .. row._magic_effect.format .. "[-]", "{0}", "[-][24FC24]" .. arg1)
	end
end

function m:onClick(go, name)
    if name == "closeBtn" then 
    	UIMrg:popWindow()
    end
end

return m