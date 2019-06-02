local script = {}
local MaterialHasSelected = TextMap.GetValue("Text78")

function script:update(lua)
    local item = lua.item
    local delegate = lua.delegate
    self.index = lua.index
    self.pIndex = lua.pIndex
    self.data = lua
    self.item = item
    self.delegate = delegate
    self.img_frame.enabled = false
    self.delegate = delegate
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", item, self.img_frame.width, self.img_frame.height })

    self.txt_count.text = item.count
    self.selectCount = item.selectCount or 0
    if self.selectCount > 0 then
        self.txt_count.text = self.selectCount .. "/" .. self.item.count
        self.binding:Show("btn_sub")
    else
        self.binding:Hide("btn_sub")
    end
end

--刷新材料选择状态
function script:updateSubState(ret)
    if self.selectCount == 0 then
        self.binding:Hide("btn_sub")
    else
        self.binding:Show("btn_sub")
    end
    self.delegate:selectMaterial(self.item, ret, self.selectCount, self.index, self.pIndex)
end

--添加材料
function script:AddItem(go)
    if self.delegate:isExpFull() then
        MessageMrg.show(TextMap.TXT_NEED_EXP_FULL)
        return
    end
    if self.selectCount == self.item.count then
        MessageMrg.show(TextMap.MaterialHasSelected)
        return
    end
    self.selectCount = self.selectCount + 1
    self.txt_count.text = self.selectCount .. "/" .. self.item.count
    self:updateSubState(true)
end

--减少材料
function script:SubItem(go)
    self.selectCount = self.selectCount - 1
    self.txt_count.text = self.selectCount .. "/" .. self.item.count
    self:updateSubState(false)
end

--事件
function script:onClick(go, name)
    if name == "btn_add" then
        self:AddItem(go)
    elseif name == "btn_sub" then
        self:SubItem(go)
    end
end

function script:create()
    return self
end

return script