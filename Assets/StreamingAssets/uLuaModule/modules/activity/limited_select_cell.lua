local m = {} 

function m:update(lua)
    self.index = lua.index
    self.char = lua.char.char
    self.num = lua.char.num --角色身上的等级
    self.delegate = lua.delegate
    if lua.char.char.isChoose == nil then
        lua.char.char.isChoose = false
    end
    self:updateState(lua.char.char.isChoose)
    self.isChoose=lua.char.char.isChoose
    local _type = self.char:getType()
    self._type = _type
    self:updateChar()
end

function m:updateState(state)
	self.isChoose=state
    self.btn_select:SetActive(state)
end
function m:updateChar()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height,true})
    self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  char.lv
    self.labName.text = char:getDisplayName()
end

--点击事件
function m:onClick(uiButton, eventName)
    if eventName == "btnCell" then --点击选择，针对角色
        if self.char.isCanChoose==false then
            if self.char:getType()=="char" and self.char.Table.can_return~=1 then 
                MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_790"),"{0}",self.char.name))
            elseif self.char:getType()=="treasure" and self.char.kind=="jing" then 
                MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_791"),"{0}",self.char.name))
            else 
                MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_792"),"{0}",self.char.name))
            end 
            return
        end
        if self.isChoose==false then 
	        if self.delegate.select_num < tonumber(self.delegate.date.num) then 
		        self:updateState(true)
		        self.delegate:updateTeams(self.char,true)
		    else 
		    	MessageMrg.show(TextMap.GetValue("Text_1_59"))
	        end
	    else 
	    	self:updateState(false)
		    self.delegate:updateTeams(self.char,false)
		end 
    end
end

return m