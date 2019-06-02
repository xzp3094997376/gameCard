local giftCell = {}
local state = 0
local localid = 0
local infobindArr = {}
local isHaveInit = false
function giftCell:typeId(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function giftCell:GetAwardState(index)
    local state = 0 --已经领取
    if index < Player.qianCengTa.lastTower and Player.qianCengTa.specialBox[index] == 0 then
        return state
    end
    state = 1 --未完成
    if Player.qianCengTa.specialBox[index] ~= 0 then
        state = 2 --可领取
    end
    return state
end

local infobindArr = {}
function giftCell:update(luaDatas)
    if luaDatas == nil then
        self.gameObject:SetActive(false)
        return
    end
    self.Sprite_hasGet.gameObject:SetActive(false)
    self.gameObject:SetActive(true)
    self.state = giftCell:GetAwardState(luaDatas.index)
    if self.state == 2 then
        self.btntxt_nor.text = TextMap.GetValue("Text_1_22")--TextMap.GetValue("Text483")
		self.btntxt_gray.text = TextMap.GetValue("Text_1_22")--TextMap.GetValue("Text483")
        self.btn_fight.isEnabled = true
		self.btntxt_nor.gameObject:SetActive(true)
		self.btntxt_gray.gameObject:SetActive(false)
        self.btn_fight.gameObject:SetActive(true)
    elseif self.state == 0 then
        self.Sprite_hasGet.gameObject:SetActive(true)
        self.btntxt_nor.text = TextMap.GetValue("Text_1_138")--TextMap.GetValue("Text397")
		self.btntxt_gray.text = TextMap.GetValue("Text_1_138")--TextMap.GetValue("Text397")
        self.btn_fight.isEnabled = false
		self.btntxt_nor.gameObject:SetActive(false)
		self.btntxt_gray.gameObject:SetActive(false)
        self.btn_fight.gameObject:SetActive(false)
    else
        self.btntxt_nor.text = TextMap.GetValue("Text1350")
		self.btntxt_gray.text = TextMap.GetValue("Text1350")
        self.btn_fight.isEnabled = false
		self.btntxt_nor.gameObject:SetActive(false)
		self.btntxt_gray.gameObject:SetActive(true)
        self.btn_fight.gameObject:SetActive(true)
    end
    if localid == luaDatas.index then
        return
    end
    localid = luaDatas.index
    self.ceng.text =string.gsub(TextMap.GetValue("LocalKey_744"),"{0}",localid)
    local result = TableReader:TableRowByID("towerChapter_config", localid)
    local data = TableReader:TableRowByID("tower_box", result.box_id)
    self.dropTypeList = {} 
    local itemCount = data.probdrop.Count - 1
    for i = 0, 6 do
        if i <= itemCount then
            local vo
            local num = 1
            if data.drop[i].arg2 ~= nil and data.drop[i].arg2 ~= "" and data.drop[i].arg2 > 0 then
                num = data.drop[i].arg2
            end
            table.insert(self.dropTypeList, data.probdrop[i]["type"])
            if giftCell:typeId(data.probdrop[i]["type"]) then
                if data.probdrop[i]["type"] == "char" then
                    local itemobj = TableReader:TableRowByUnique("char", "name", data.probdrop[i]["arg"])
                    vo = Char:new(itemobj.id, num)
                    itemobj = nil
                    vo.lv = 0
                    vo.type_item = "char"
                else
                    local itemprobdrop = TableReader:TableRowByID(data.probdrop[i]["type"], data.probdrop[i]["arg"])
                    vo = itemvo:new(data.probdrop[i]["type"], num, itemprobdrop.id, 1, "1")
                    itemprobdrop = nil
                    vo.type_item = "itemvo"
                end
            else
                vo = itemvo:new(data.probdrop[i]["type"], num, data.probdrop[i]["arg"], 1, "1")
                vo.type_item = "itemvo"
            end
            if infobindArr[i] == nil then
                infobindArr[i] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/qiancengta/boxGetitem", self.rewardTable.gameObject)
            end
            infobindArr[i].gameObject:SetActive(true)
            infobindArr[i]:CallUpdate(vo)
            vo = nil
        else
            if infobindArr[i] ~= nil then
                infobindArr[i].gameObject:SetActive(false)
            end
        end
    end
    -- self.binding:CallAfterTime(0.01,
    --     function()
            self.rewardTable.repositionNow = true
        -- end)
end

function giftCell:onClick(go, name)
    if name == "btn_fight" then
        if Tool:judgeBagCount(self.dropTypeList) == false then return end
        self.btn_fight.isEnabled = false
        Api:QCTGetAward(localid,
            function(result)
    --             self.btntxt_nor.text = TextMap.GetValue("Text_1_138")--TextMap.GetValue("Text397")
				-- self.btntxt_gray.text = TextMap.GetValue("Text_1_138")--TextMap.GetValue("Text397")
				-- self.btntxt_nor.gameObject:SetActive(false)
				-- self.btntxt_gray.gameObject:SetActive(false)
                self.btn_fight.gameObject:SetActive(false)
                self.Sprite_hasGet.gameObject:SetActive(true)
                self.btn_fight.isEnabled = false
                packTool:showMsg(result, self.go, 0)
            end, function()
                self.btn_fight.isEnabled = true
            end)
    end
end

function giftCell:isHaveGetAward()
    if localid < Player.qianCengTa.lastTower and Player.qianCengTa.specialBox[localid] == 0 then
        state = 0 --已经领取
        return
    end
    state = 1 --未完成
    if Player.qianCengTa.specialBox[localid] ~= 0 then
        state = 2 --可领取
    end
end

function giftCell:create(binding)
    self.binding = binding
    return self
end

return giftCell