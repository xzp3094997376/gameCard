local newPackItem = {}
local binding
local superLinkData = {}
function newPackItem:update(vo, delegate)
    self.select:SetActive(false)
	self.gameObject:SetActive(true)
    self.img_kuangzi.gameObject:SetActive(false)
    --self.bg.gameObject:SetActive(false)
    self.go.gameObject:SetActive(false)
    self.binding:Hide("ghost_power")
    if vo == nil or vo.itemID == "nothing" then
		self.gameObject:SetActive(false)
        self.isNothing = "nothing"
        --self.bg.gameObject:SetActive(true)
        self.img_kuangzi.gameObject:SetActive(true)
    else
        self.index = vo.index
        self.isNothing = vo.char.itemID
        self.go.gameObject:SetActive(true)
        self._item = vo.char
        self.delegate = vo.delegate
        self.select:SetActive(false)
        --delegate:showSelect(self.select, vo.itemKey)
        if binding == nil then
            binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
        end
        self.itemInfo = self._item
        self.itemInfo.rwCount = nil
        self.itemInfo.itemCount = nil
        self.itemInfo.tempCount = nil
        binding:CallUpdate({ "itemvo", self.itemInfo, self.img_kuangzi.width, self.img_kuangzi.height, true })
		-- binding:CallManyFrame(function()
		-- 	binding.target.shuliang.gameObject:SetActive(false)
		-- end, 1)
		local count = self._item.itemShowCount--string.gsub(self._item.itemShowCount, "^%s*(.-)%s*$", "%1")
        if count == "" or count == " " then 
			count = "1"
		end 
        self.txtDes_equip.text = ""
        self.txtDes_equip2.text = ""
        self.txtDes.text = ""
        self.txtName.text = self._item.itemColorName
		self.txtNum.text =  TextMap.GetValue("Text_1_942")..count
		self.txtDes.text = self._item.itemPro
        self.btn_chushou.gameObject:SetActive(false)

        --
            if self._item.itemTable.type == "equip" then
                self.btn_chushou.gameObject:SetActive(true)
                self.btn_xiangqing.gameObject:SetActive(false)
                local gji = ""
                local sming = ""
                local wfang = ""
                local ffang = ""           
                for i = 0, 3 do
                    local title = string.gsub(self._item.itemTable.magic[i]._magic_effect.format, "：{0}","")
                    local value = "[ffff96]"..title.."：[-]"..self._item.itemTable.magic[i].magic_arg1--)--string.gsub(self._item.itemTable.magic[i]._magic_effect.format, "{0}"
                    if title == TextMap.GetValue("Text_1_894") then
                        gji = value
                    elseif title == TextMap.GetValue("Text_1_893") then
                        sming = value
                    elseif title == TextMap.GetValue("Text_1_892") then 
                        wfang = value
                    elseif title == TextMap.GetValue("Text_1_891") then 
                        ffang = value
                    end
                end
                self.txtDes_equip.text = sming.."\n"..wfang
                self.txtDes_equip2.text = gji.."\n"..ffang
                self.txtDes.text = ""
            end

        --

	
        if self._item.itemType == "ghost" then
            self.binding:Show("ghost_power")
            local num = self._item.ghost_power or 0
            self.ghost_power.text = num > 0 and "+" .. num or ""
        end
		    if self._item.itemTable.can_use == 1 then
                self.btn_xiangqing.gameObject:SetActive(true)
				self.btntxt_nor.text = TextMap.GetValue("Text_1_6")
			else
                self.btn_xiangqing.gameObject:SetActive(false)
				--if self._item.itemType == "ghost" then 
				--	self.btntxt_nor.text = "培养"
				--else 
				--	self.btntxt_nor.text = "详情"
				--end
			end
			--if self._item.itemType == "item" and superLinkData[self._item.itemTable.id] ~= nil then
			--	self.btntxt_nor.text = TextMap.GetValue("Text_1_943")
			--end
			--self.btntxt_nor_left.text = TextMap.GetValue("Text_1_349")
    end
end


function newPackItem:isAvalible(id)
    local num = 0
    local msg = nil
    local name = ""
    return msg
end

local function getAttrList(arg)
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

function newPackItem:onClick(go, name)
    if name == "newpackitem" and self.isNothing ~= "nothing" then
        if self.delegate ~= nil then
            self.delegate:itemClick(self._item)
        end
        --self.delegate:showSelect(self.select, self._item.itemKey)
    elseif name == "btn_xiangqing" then 
		if self._item.itemType == "ghost" then
            --uSuperLink.openModule(546)
			local data = {}
			data[1] = 1
			data[2] = self._item.itemKey
			uSuperLink.open("ghost", data)
            return
        end
        if self.btntxt_nor.text == TextMap.GetValue("Text_1_6") then
            local temp = {}
            temp.obj = self._item
            temp.type = "use"
            temp.go = self.binding.gameObject
            local msg = self:isAvalible(self._item.itemTable.id)
            if msg ~= nil then --判断是否有相对于的钥匙和宝箱             
            MessageMrg.show(msg)
            return
            else
                local use_type = 0
                use_type = TableReader:TableRowByID("item",self._item.itemID).use_type
                if use_type ==2 then
                    UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newPackUse", temp)
                else
                    UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newPackSell", temp)
                end
            end
            temp = nil
        elseif self.btntxt_nor.text == TextMap.GetValue("Text_1_943") then
            uSuperLink.openModule(superLinkData[self._item.itemTable.id])
        else
            local temp = {}
            temp.obj = self._item
            UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newpackInfo", temp)
            temp = nil
        end
	elseif name == "btn_chushou" then
		if self._item.itemType == "ghost" and self._item.ghostItem ~= nil then
            UIMrg:pushWindow("Prefabs/moduleFabs/guidao/guidao_desc", self._item.ghostItem)
            return
        end
        if self._item.itemTable.can_sell ~= 1 then
            MessageMrg.show(TextMap.GetValue("Text_1_944"))
        else
            local temp = {}
            temp.obj = self._item
            temp.type = "sell"
            temp.go = self.binding.gameObject
            temp.sellType = "juexing"
            UIMrg:pushWindow("Prefabs/moduleFabs/packModule/newPackSell", temp)
            temp = nil
        end
	end
end

--初始化
function newPackItem:create(binding)
    self.binding = binding
    return self
end

return newPackItem