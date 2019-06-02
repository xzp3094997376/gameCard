local m = {}

function m:Start()
    self.list_hong = {}
    self.list_cheng = {}
    self.list_zi = {}
    self.list_lan = {}
    TableReader:ForEachLuaTable("yuling", function(index, item)
        if item.star==6 then 
        	table.insert(self.list_hong,item)
        elseif item.star==5 then 
        	table.insert(self.list_cheng,item)
        elseif item.star==4 then 
        	table.insert(self.list_zi,item) 
        elseif item.star==3 then 
        	table.insert(self.list_lan,item) 
        end  
        return false
    end)
    local iconName = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").img
	self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
    local resNum = Tool.getCountByType("haogandu")
	self.num.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	self.Item1:CallUpdate({self.list_hong})
	self.Item2:CallUpdate({self.list_cheng})
	self.Item3:CallUpdate({self.list_zi})
	self.Item4:CallUpdate({self.list_lan})
end 

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m