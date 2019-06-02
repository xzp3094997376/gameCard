
local m = {}
local bt_status = false
--点击事件
function m:onClick(go, name)
    if name == "button" then
		m:GotoTreasureView("strength")
        --bt_status = not bt_status
        --self.sub_txtGroup.gameObject:SetActive(not bt_status)
        --if bt_status then
        --    self.button.transform.localScale = Vector3(-1,1,1)
        --else
        --    self.button.transform.localScale = Vector3(1,1,1)
        --end
    end
end

function m:GotoTreasureView(typemode)
    local infotemp = {}
    infotemp.treasure = self._treasure
    infotemp.typemode = typemode
    Tool.push("treasure_info","Prefabs/moduleFabs/TreasureModule/treasureInfo",infotemp)
end

function m:onUpdate()
	self._treasure:updateInfo()
	m:updateTreasures()
end

function m:RestAll()
    bt_status = false
    self.sub_txtGroup.gameObject:SetActive(true)
    self.button.transform.localScale = Vector3(1,1,1)
end

function m:updateTreasures()
    local _treasure = self._treasure
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "treasure", _treasure, self.img_frame.width, self.img_frame.height, true, nil, })
    self.txt_name.text = _treasure:getDisplayColorName()
	self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  _treasure.lv
    self.txt_baseP.text = _treasure:GetTreasureBaseProperty(0)
    self.txt_jinglian.text = ""--"[ffff96]" .. TextMap.GetValue("Text1751").."：[-]".._treasure.power

    local data = _treasure:GetCharIDandPos()
    if data ~= nil then
        if data.charid ~= nil then
			local ename = ""
			local char = Char:new(data.charid)	
			if tostring(data.charid) == tostring(Player.Info.playercharid) then 
				ename = Char:getItemColorName(char.star, Player.Info.nickname)--  .. TextMap.GetValue("Text_1_2816")
			else
				ename = Char:getItemColorName(char.star, char.name)--  .. TextMap.GetValue("Text_1_2816")		
			end 
			self.txt_equip.text = TextMap.GetValue("Text_1_323")
            self.txt_equip_name.text = ename
        else 
            self.txt_equip.text = ""
            self.txt_equip_name.text = ""
        end
    end
   self.iswearsp:SetActive(_treasure.onPosition)
   local config = TableReader:TableRowByID("treasureArgs","treasure_casting_open").arg
end


function m:update(lua)
    self:RestAll()
    self.index = lua.index
    self._treasure = lua._treasure
    self.delegate = lua.delegate
    -- self.type = self.delegate:getTab()
    self:updateTreasures()
    self.button.gameObject:SetActive(self._treasure.kind ~= "jing")
end

function m:Start()
end


return m

