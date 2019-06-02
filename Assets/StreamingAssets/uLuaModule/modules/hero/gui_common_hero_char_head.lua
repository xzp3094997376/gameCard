
local m = {}

local desList = { money = TextMap.GetValue("Text_1_99")} 
--点击事件
function m:onClick(uiButton, eventName)
    --if (eventName == "btnCell") then
        self:onSelect(uiButton)
    --end
end

function m:onSelect(go)
    if self.char.isSelect == false or self.char.isSelect == nil then
		self.delegate:pushToTeam(self.char, self.char.isSelect)
		self.char.isSelect = true 
	else
        self.delegate:popToTeam(self.char, self.char.isSelect)
		self.char.isSelect = false 
	end
	self.delegate:setInfo()
    self:updateState()
end

function m:updateData()
    local char = self.char
    self.labName.text = char:getDisplayName() --名字
    if char:getType() == "renling" then 
        self.txt_lv.text = TextMap.GetValue("Text_1_1068") .. char.count
        self.txt_exp.text = toolFun.moneyNumberShowOne(char.Table.sell*tonumber(char.count))
    else 
	   self.txt_lv.text = TextMap.GetValue("Text_1_772") .. char.lv
       self.txt_exp.text = char.Table.sell
    end 
    local iconName = TableReader:TableRowByUnique("resourceDefine", "name",char.Table.sell_type).img
    self.img.Url=UrlManager.GetImagesPath("itemImage/"..iconName..".png")
	--end 
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    self:updateState()
end

function m:updateState()
    if self.char.isSelect == true then
        self.selected:SetActive(true)
    else
        self.selected:SetActive(false)
    end
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
    self.index = lua.index
    self.char = lua.char
    self.delegate = lua.delegate
    if lua.char.isSelect == true then
        self.char.isSelect=false
	else 
		self.char.isSelect=true
    end 
    self:onSelect(uiButton)
    self:updateData()
end


function m:Start()
end 

return m

