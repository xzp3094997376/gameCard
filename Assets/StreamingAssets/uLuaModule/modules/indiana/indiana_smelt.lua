--宝物熔炼主界面
local m = {}

function m:Start(...)
    self.CanSelect=true
    self.type="smelt"
	self.selectIndex = 1
    self.id_list = {}
    --读取配表
    self.piece_list = {}
    TableReader:ForEachLuaTable("melting", function(index, item) --遍历宝物碎片表
        local piece = TreasurePiece:new(item.name,0)
        local temp = {}
        temp.type = "smelt"
        temp.treasure = piece
        table.insert(self.piece_list,temp)
        return false
    end)


    for  i=1,#self.piece_list do
        if i == 1 then
            self.piece_list[i].select = true
        else
            self.piece_list[i].select = false
        end
        self.piece_list[i].real_index = i
    end
    self.cur_select = 1
    self.txt_cost.text = TableReader:TableRowByID("trsRobConfig", "meltUp_need_gold").value

end

function m:update(lua)
    --刷新宝物碎片列表
    self:refreshList()
    self:refreshAddBtn()
end

function m:refreshAddBtn()
    local list =m:getCanUseTreasure()
    if list ~=nil and #list >0 then 
        self.addAil.enabled=true 
    else 
        self.addAil.enabled=false
    end 
end

function m:getCanUseTreasure()
    local list ={}
    local noUse = Tool.getUnUseTreasure()
    table.foreach(noUse, function(i, v)
        local gh = Treasure:new(v.value.id, v.key)
        if gh.star == 5 and gh.lv == 1 and gh.power == 0 and gh.kind ~= "jing" then --未培养过的紫色宝物
            table.insert(list, gh)
        end
    end)
    return list
end

function m:getData(data)
    local list = {}
    for i = 1, table.getn(data), 1 do
        local d = data[i]
        d.realIndex = i
		d.delegate = self
		table.insert(list, d)
    end

    return list
end

--刷新宝物碎片列表
function m:refreshList()
	local list = m:getData(self.piece_list)
	self.scrollview:refresh(list, self, false, 0)
	
    self:showMaterial(self.piece_list[1])
    self:setMaterial(nil)
end


function m:updateItem(index, item)

	--currentId = id
	self.selectIndex = index
	self:showMaterial(self.piece_list[self.selectIndex])
	--self:onUpdate(false, false)
	--if self.tab then
    --    self.tab:CallUpdate({ delegate = self, char = self.char })
    --end
end

--显示宝物碎片需要熔炼的材料
function m:showMaterial(treasure)
    if treasure == nil  then return end
    self.piece_list[self.cur_select].select = false
    self.piece_list[treasure.real_index].select = true
    self.cur_select = treasure.real_index
    local temp = {}
    temp.type = "other"
    temp.treasure = treasure.treasure
    temp.real_index = treasure.real_index
    self.cur_piece = treasure.treasure
    self.piece:CallUpdateWithArgs(temp,nil,self,false)
    self.piece2:CallUpdateWithArgs(temp,nil,self,false)
	self.txtName.text = TextMap.GetValue("Text_1_929")..temp.treasure:getDisplayColorName()
	local tb = TableReader:TableRowByID("treasure", temp.treasure.Table.treasureId)
	self.txtDes.text = self:getMagics(tb.magic)
end

function m:getMagics(magics)
    local txt = ""
    local len = magics.Count - 1
	local list = {}
	local nList = {}
    for i = 0, len do
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1
        -- local magic_arg2 = row.magic_arg2
        local desc = ""
		local arg1 = magic_arg1 / magic_effect.denominator
        desc = string.gsub("[ffff96]"..magic_effect.format.."[-]", "{0}", "[ffffff]"..arg1)
        if i < len then desc = desc .. "\n" end
        -- if math.floor(magic_arg1 / magic_effect.denominator) == 0 then desc =  "" end
        txt = txt .. desc
		list[i+1] = desc
		nList[i+1] = arg1
    end
    return  txt, list, nList
end

--熔炼材料
function m:setMaterial(treasure)
    if treasure == nil then  --取消材料
        self.cur_material = nil
        self.treasure.gameObject:SetActive(false)
        self.btn_add.gameObject:SetActive(true)
		--self.img_add.gameObject:SetActive(true)
        self.btn_smelt.isEnabled = false
    else                              --选中材料
        self.cur_material = treasure
        self.treasure.gameObject:SetActive(true)
        local temp = {}
        temp.type = "smelt"
        temp.treasure = treasure
        self.treasure:CallUpdateWithArgs(temp,nil,self,false)
        self.btn_add.gameObject:SetActive(false)
		--self.img_add.gameObject:SetActive(false)
        self.btn_smelt.isEnabled = true
    end
end

--添加材料
function m:onAdd()
    UIMrg:pushWindow("Prefabs/moduleFabs/TreasureModule/treasure_select_charpiece", {type = "smelt",delegate = self})
end

--熔炼
function m:onSmelt()
    if self.cur_material == nil or self.cur_piece == nil then return end
    Api:treasureSmelt(self.cur_material.key, self.cur_piece.id, function(reuslt)
        self:setMaterial(nil)
        self:PlayEffect()
        self:refreshAddBtn()
        print("成功")
    end)
end

--播放特效
function m:PlayEffect()
    self.zhuzhao:SetActive(false)
    self.CanSelect=false
    self.zhuzhao:GetComponent("TweenPosition"):ResetToBeginning()
    self.zhuzhao:SetActive(true)
    self:AllMode("mode_1")
    self.binding:CallAfterTime(0.8,function()
        self:AllMode("mode_2")
        self.zhuzhao:GetComponent("TweenPosition"):Play(true)
        self.binding:CallAfterTime(1.8,function()
            self.binding:CallAfterTime(0.2,function()
                self.zhuzhao:GetComponent("TweenAlpha"):ResetToBeginning()
                self.zhuzhao:GetComponent("TweenAlpha"):Play(true)
                self.zhuzhao:SetActive(false)
                end)
            end)

        self.binding:CallAfterTime(0.5,function()
            self:AllMode("mode_3")
            self.binding:CallAfterTime(0.4,function()
            self:AllMode("mode_none")
            self.CanSelect=true
            Events.Brocast("refreshData")
            end)
        end)
    end,2)
end

function m:AllMode(mode)
    self.lizixishou:SetActive(mode == "mode_1")
    self.lizituowei:SetActive(mode == "mode_2")
    self.bao:SetActive(mode == "mode_3")
end

function m:onClick(go, name)
    if name == "btn_smelt" then --熔炼
        self:onSmelt()
    elseif name == "btn_close" then
        Events.Brocast("refreshData")
        UIMrg:popWindow()
    elseif name == "btn_add" then
        self:onAdd()
    elseif name == "btn_cancel" then
        self:setMaterial(nil)
    elseif name == "btn_onekey" then 
        local list = m:getCanUseTreasure()
        if #list >0 then 
            self:setMaterial(list[1])
        else 
            MessageMrg.show(TextMap.GetValue("Text1747"))
        end
    end
end

return m