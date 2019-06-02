local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = data.delegate
    local item = Yuling:new(data.id)
    self.name.text = item:getDisplayColorName()
    local iconName = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").img
	self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	self.lv.text=string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",item.lv)
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.cell.gameObject)
    end
    self.__itemAll:CallUpdate({ "char" ,item, self.cell.width, self.cell.height,true })--"char"
    local info = Player.yuling[data.id]
    if info.quality>0 then 
    	self.__itemAll:CallTargetFunction("isShowGray",false)
    	if info.huyou>0 then
    		self.shangzheng:SetActive(true)
    	end 
    else 
    	self.__itemAll:CallTargetFunction("isShowGray",true)
    end 
end


function m:Start()

end

return m