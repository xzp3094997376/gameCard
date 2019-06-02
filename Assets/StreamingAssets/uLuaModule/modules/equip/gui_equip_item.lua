-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    if eventName == "button" or eventName == "btn_go" then
        if self.ghost.tab == 1 then --装备强化
			uSuperLink.open("ghost",  {1, self.ghost})
        elseif self.ghost.tab == 2 then --装备碎片合成
        	if Tool:judgeBagCount(self.dropTypeList) == false then return end
			m:consumeEquip()
        elseif self.ghost.tab == 3 or self.ghost.tab == 4 then --前往
        	local piece = GhostPiece:new(self.ghost.id)
        	DialogMrg.showPieceDrop(piece)
        end
    elseif eventName == "btn_hero" then
    	if self.ghost.Table.type == "ghostPiece" then 
			local temp = {}
			temp.obj = self.ghost
			UIMrg:pushWindow("Prefabs/moduleFabs/hero/equip_info_dialog", temp)
			return
		end
        self:showInfoPanel()
    end
    -- self:check()
end

function m:consumeEquip()
    if self.ghost == nil then return end
	if self.isconsuming then return end 
	self.isconsuming = true 
    local id = self.ghost.id
	local that = self
    Api:ghostCombineByPiece(tonumber(id), function(result)
        Tool.resetUnUseGhost()
       -- m:playAnimation(result)
	   that.isconsuming = false 
	   --that.delegate:onUpdate()
	   that.ghost:updateInfo()
	   that:updateEquip()
	   that.delegate:updateRedPoint()
	   if result.ret == 0 then 
		 packTool:showMsg(result, that.delegate.msg, 0)
	   end 
    end, function(ret)
        return false
    end)
end 

function m:showMsg(drop, event)
    local list = RewardMrg.getList(drop)
    local ms = {}
    table.foreach(list, function(i, v)
        local g = {}
        g.type = v:getType()
        g.icon = "resource_fantuan"
        g.text = v.rwCount
        g.goodsname = v.name
        table.insert(ms, g)
        g = nil
    end)
    OperateAlert.getInstance:showGetGoods(ms, self.gameObject)
end


function m:getAttrList(arg)
    local list = {}
    local len = arg.Count
    for i = 0, 3 do
        if i > len - 1 then
            list[i + 1] = 0
        else
            list[i + 1] = arg[i]
        end
    end
    return list
end

function m:updateEquip()
	if self.List_start ~= nil then
        self.List_start.gameObject:SetActive(false)
    end
    local ghost = self.ghost
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.ghost, self.img_frame.width, self.img_frame.height, nil,nil,nil,false})
    if self.ghost.tab == 1 then --icon
		self.txt_lv.gameObject:SetActive(true)
		self.txt_des.gameObject:SetActive(true)
		self.txt_count.gameObject:SetActive(false)
		self.btn_go.gameObject:SetActive(false)
		self.button.gameObject:SetActive(true)
		if self.ghost.hasWear == 1 then
			self.txt_equip.text = TextMap.GetValue("Text_1_323")
			self.txt_equip_name.text = self.ghost.charName
		elseif self.ghost.key == nil then
			--self.txt_equip.text = self.ghost:getMainAttr()
			self.txt_equip_name.text = self.ghost:getMainAttr()
		elseif self.ghost.hasWear == nil then 
			self.txt_equip.text = ""
			self.txt_equip_name.text = ""
		else
			self.txt_equip.text = ""
			self.txt_equip_name.text = ""
		end
		
		local descLeft = ""
		local list = self.ghost:getDesc(m:getAttrList(self.ghost.info.xilian))
		table.foreachi(list, function(i, v)
			descLeft = descLeft .. v -- .. "\n"
		end)
		local attr = string.sub(descLeft, 1, -2)
		self.txt_des.text = attr
		
		--属性信息
		self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  ghost.lv
		self.txt_name.text = ghost:getDisplayColorName()
		self.redPoint:SetActive(self:check())

		
		--图标
	else --装备碎片    
		self.dropTypeList = {"ghost"}
		self.txt_lv.gameObject:SetActive(false)
		self.txt_des.gameObject:SetActive(false)
		self.txt_count.gameObject:SetActive(true)
		self.redPoint:SetActive(false)
		self.txt_equip.text = ""
		self.txt_equip_name.text = ""

		self.button.gameObject:SetActive(true)
		self.txt_name.text = ghost:getDisplayColorName()
		local row = TableReader:TableRowByID("ghostPiece", ghost.id)
		local consume = row.consume
		--local costList = RewardMrg.getConsumeTable(consume)
		local needNum = 0
		for i = 0, consume.Count - 1 do 
			if consume[i].consume_type == "ghostPiece" then 
				needNum = consume[i].consume_arg2
				break
			end 
		end 
		if ghost.count >= needNum then --碎片可以进行合成
		 	self.font.text = TextMap.GetValue("Text_1_324")
		     --self.btn_sprite.spriteName = "YX-red"
		     self.btn_go.gameObject:SetActive(false)
		 	self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-][00ff00]" .. ghost.count .. "/" .. needNum.."[-]"
		 	self.redPoint:SetActive(true)
		else
		    --if ghost.tab == 4 then
		    --    self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-]" .. ghost.count
		    --    --self.font.spriteName = "YX-qianwang"
			--	self.btn_go.gameObject:SetActive(true)
			--	self.button.gameObject:SetActive(false)
		    --else
		        self.txt_count.text = "[ffff96]" .. TextMap.GetValue("Text1145") .. "[-]" .. ghost.count .. "/" .. needNum
		        --self.font.spriteName = "YX-qianwang"
				self.btn_go.gameObject:SetActive(true)
				self.button.gameObject:SetActive(false)
				ghost.tab = 3
		    --end
		    --self.btn_sprite.spriteName = "YX-yellow"
		end
    end
	m:SetStarInfo()
end

function m:SetStarInfo()
    if self.ghost ~= nil and self.ghost.key ~= nil and self.List_start ~= nil then
        self.List_start.gameObject:SetActive(false)
        local starNum = tonumber(Player.Ghost[self.ghost.key].star)
        if starNum ~= nil and starNum >= 0 then
            self.List_start.gameObject:SetActive(true)
            m:ShowStar(starNum)
        end
    end
end

function m:ShowStar(count)
    local list = {}
    for i = 1, 5 do
        list[i] = self["Star"..i]
        list[i].gameObject:SetActive(false)
    end

    if count > 0 and #list > 0 then
        for i = 1, count do
            list[i].gameObject:SetActive(true)
        end
    end
    self.List_start_grid.repositionNow = true
end

function m:onUpdate()
	m:updateEquip()
end 

function m:check()
    if self.ghost == nil then return false end
    local ghost = self.ghost
    return ghost:redPointJingLian() or ghost:redPointQianHua() or false
end

--显示英雄详细信息面板
function m:showInfoPanel()
    if self.ghost == nil then return end
    Tool.push("equip_info", "Prefabs/moduleFabs/equipModule/equip_info", {type = 1, ghost = self.ghost})
end

--更新角色列表
--@ghost 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
    --self.index = lua.index
    self.ghost = lua.char
    self.delegate = lua.delegate
    -- self.type = self.delegate:getTab()
    self:updateEquip()
end

return m

