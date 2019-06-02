local m = {} 

function m:update(data,index,delegate)
    self.index = index
    self.char = data
    self.delegate = delegate
    self.img_frame.enabled = false
    if self.char~=nil then 
    	if self.__itemAll == nil then
    		self.__itemAll = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/itemAll_pre", self.img_frame.gameObject)
    	end
    	self.name.text = self.char:getDisplayColorName()
        if Player.CharsShows[self.char.dictid] ==1 then 
            self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height, true, nil,isGray=false})
        else 
            self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height, true, nil,isGray=true})
        end 
    else 
    	self.gameObject:SetActive(false)
    end
end

function m:onClick(go, name)
    print (name)
    if name == "btn_click" then
        local temp = {}
        temp.obj=self.char
        temp._type = "char"
        temp.type = 1
        MessageMrg.showTips(temp)
    end
end

return m