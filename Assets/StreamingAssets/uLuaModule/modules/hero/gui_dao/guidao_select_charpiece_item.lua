--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/22
-- Time: 14:40
-- To change this template use File | Settings | File Templates.
--
local m = {}
function m:update(lua)
    self.index = lua.index
    self.char = lua.char
    self.delegate = lua.delegate
    local char = self.char
    self.labName.text = char:getDisplayName() --名字

    if self.List_start ~= nil then
        self.List_start.gameObject:SetActive(false)
    end

    m:SetStarInfo()

    --local stars = {}
    if self.delegate._tp ~= "ghost" and self.delegate._tp ~= "treasure" then
        --for i = 1, char.star do
        --    stars[i] = i
        --end
        self.txt_lv.text = ""
        self.txt_desc.text = ""
    else
        self.txt_desc.text = char:getMainAttr()
        self.txt_lv.text = "Lv" .. char.lv
        self.binding:Hide("num")
        self.binding:Hide("img_frame")
        --self.binding:Hide("star")
        self.binding:Show("gd_frame")
        --self.gd_frame.spriteName = self.char:getFrameNormal()
		if self.__itemAll == nil then
			self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.gd_frame.gameObject)
			--self.binding:CallAfterTime(0.2, function()
            -- ClientTool.AdjustDepth(self.__itemAll.gameObject, self.gd_frame.depth)
            -- end)
		end
		self.__itemAll:CallUpdate({ "char", self.char, self.gd_frame.width, self.gd_frame.height })

	
        local name = self.char:getHeadSpriteName()
        local atlasName = packTool:getIconByName(name)
        --self.icon:setImage(name, atlasName)
        return
    end
    --ClientTool.UpdateGrid("", self.star, stars)
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    m:updateState()
end

function m:SetStarInfo()
    if self.char ~= nil and self.char.key ~= nil and self.List_start ~= nil then
        self.List_start.gameObject:SetActive(false)
        local starNum = tonumber(Player.Ghost[self.char.key].star)
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
    self.List_start_Grid.repositionNow = true
end

function m:updateState()
    if self.delegate._tp == "ghost" or self.delegate._tp == "treasure" then self.binding:Hide("num") return end
    self.count = self.delegate:getCount(self.char.id) or 0
    self.num.text = self.count
end

function m:onClick(uiButton, eventName)
    if self.delegate._tp == "ghost" then
        Events.Brocast('selectedGhost', self.char)
		if self.delegate.callback ~= nil then 
			self.delegate.callback()
		end 
        return
    end

    if self.delegate._tp == "treasure" then
        Api:treasureOn(self.char.charid, self.char.pos,self.char.key, function()
            print("宝物装备成功")
            UIMrg:popWindow()
            Events.Brocast('selectedTreasure', self.char)
            if self.delegate.callback ~= nil then self.delegate.callback() end 
        end,function ( ... )
            print("宝物装备失败")
        end)
        return
    end

    if self.delegate:isFull(self.char) then return end
    self.count = self.count + 1
    self.num.text = self.count
    self.delegate:pushList(self.char)
end

return m

