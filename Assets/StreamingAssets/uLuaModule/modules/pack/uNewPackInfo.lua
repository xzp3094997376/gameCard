local newPackInfo = {}
local tempNumHC = 0
local tempNumLY = 0
--设置每个物品的详细信息，temp可以是itemVo类型数据，也可以是char类型数据

--temp基础数据
--_type
function newPackInfo:update(temp, _type)
    local itemData = temp.obj
    local tempObj = TableReader:TableRowByID(itemData.itemType, itemData.itemID)
    self.txt_mingcheng.text = itemData.itemColorName
	
	local count = string.gsub(itemData.itemShowCount, "^%s*(.-)%s*$", "%1")
	if count == "" then 
		count = "1"
	end
    self.txt_shuliang.text = TextMap.GetValue("Text1343") .. (itemData.itemCount or count)
    tempNumLY = tempObj.droptype.Count
    self.img_kuangzi.gameObject:SetActive(false)
    infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.newpackitem)
    infobinding:CallUpdate({ "itemvo", itemData, self.img_kuangzi.width, self.img_kuangzi.height })
    if tempNumLY == 0 then
        MessageMrg.show(TextMap.GetValue("Text1344"))
        UIMrg:popWindow()
        return
    end
    if tempNumLY > 0 then
        local index = 0
        for i = 0, tempNumLY - 1 do
            local tempData = {}
            if tempObj.droptype[i] ~= nil then
                tempData.obj = Tool.readSuperLinkById(tempObj.droptype[i])
				--tempData.id = tempObj.droptype[i]
				--print("xx: " .. tempObj.droptype[i])
                if i == 0 then
                    tempData.type = "equip"
                else
                    tempData.type = "tujing"
                end
                local binding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/packModule/newPackInfoitem", self.tables.gameObject)
                binding:CallUpdate(tempData)
                binding.name = index
                binding = nil
                tempData = nil
                index = index + 1
            end
        end
    end
    self.tables.repositionNow = true
    self.view:ResetPosition()
end

function newPackInfo:refreashData()
    self.tables.repositionNow = true
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("refreashPackInfo")
    if tempNumLY == 0 then
        self.binding:CallAfterTime(0.1, funcs.handler(self,
            function()
                self.tujingTxt:SetActive(false)
            end))
    end
end


--按钮点击事件
function newPackInfo:onClick(go, name)
    UIMrg:popWindow()
end

--初始化
function newPackInfo:create(binding)
    self.binding = binding
    return self
end

return newPackInfo