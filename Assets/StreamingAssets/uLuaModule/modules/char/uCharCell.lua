local charCell = {}

--显示窗口
function charCell:showWindow(button)
    if self.char:getType() == "char" then
        --角色
        self.delegate:showInfo(self.char, self.index)

    elseif self.__pieceEnought then
        --可召唤
        self.delegate:showSummon(self.char)
    else
        --碎片
        DialogMrg.showPieceDrop(self.char)
    end
end

--点击事件
function charCell:onClick(uiButton, eventName)
    if (eventName == "btnCell") then
        self:showWindow(uiButton)
    end
end

function charCell:updateChar()
    local char = self.char
    --    self.charCell.spriteName = "juese_liebiaodb2"

    --    self.binding:Show("equpList")
    self.binding:Hide("slider_count")
    --    self.img_jiahao:SetActive(false)
    self.txt_power.text = char.power
    self.labName.text = char:getDisplayName() --名字
    --    local that = self
    --    local equips = that.char:getEquips()
    --    ClientTool.UpdateMyTable("Prefabs/moduleFabs/charModule/MiniEquip", that.equpList, equips)
    if char.teamIndex ~= 7 then
        self.binding:Show("has_enter")
    else
        self.binding:Hide("has_enter")
    end
    self.binding:CallAfterTime(0.2, function()
        self.red_point:SetActive(self.char:checkRedPoint())
    end)
end

function charCell:updateHead()
    local char = self.char
    local _type = self.char:getType()
    self.pic:setImage(char:getHeadSpriteName(), "headImage")
    self.img_frame.spriteName = char:getFrame()
    if _type == "char" then
        self.lv_bg.spriteName = char:getLvFrame()
        self.txt_lv.text = char.lv
        local stars = {}
        for i = 1, char.star do
            stars[i] = i
        end
        ClientTool.UpdateGrid("", self.star, stars)
        self.binding:Show("img_shengjie")
        self.binding:Show("img_ly")
        self.binding:Show("lv_bg")
        self.binding:Show("txt_power")
    elseif _type == "charPiece" then
        local stars = {}
        for i = 1, char.star do
            stars[i] = i
        end
        ClientTool.UpdateGrid("", self.star, stars)
        self.binding:Show("img_shengjie")
        self.binding:Hide("img_ly")
        self.binding:Hide("lv_bg")
        self.binding:Hide("txt_power")
    else
        self.binding:Hide("img_shengjie")
        --        self.pic:isShowGray(true)
    end
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function charCell:update(lua)
    self.index = lua.index
    --    self.table = table
    self.char = lua.char
    self.delegate = lua.delegate
    local _type = self.char:getType()

    if _type == "char" then
        self:updateChar()
    elseif _type == "charPiece" then
        self:updatePiece()
    end
    self:updateHead()
    --    if self.__itemAll == nil then
    --        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.char_node)
    --    end
    --    self.__itemAll:CallUpdate({ "char", self.char, self.char_head.width, self.char_head.height })
end

function charCell:updatePiece()
    local piece = self.char
    --    self.binding:Hide("equpList")
    self.binding:Hide("has_enter")

    self.binding:Show("slider_count")
    local info = piece:pieceInfo(nil)
    self.txt_count.text = info.desc
    self.slider_count.value = info.value

    if info.value >= 1 then
        --碎片足够
        self.__pieceEnought = true
        --        self.charCell.spriteName = "juese_liebiaodb2"
        self.red_point:SetActive(true)
        --        self.img_jiahao:SetActive(true)
        self.labName.text = self.char.Table.name

    else
        --碎片
        self.__pieceEnought = false
        --        self.charCell.spriteName = "juese_liebiaodb1"
        self.red_point:SetActive(false)
        --        self.img_jiahao:SetActive(false)
        self.labName.text = self.char.name
    end
end

--初始化
function charCell:create(binding)
    self.binding = binding

    return self
end

return charCell