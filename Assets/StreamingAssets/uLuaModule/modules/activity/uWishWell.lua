local WishRewardShow = require("uLuaModule/modules/activity/uWishShowReward.lua")

local m = {}
local infobindinglist = {}

function m:update(all_data)
	local itemlist = {}
    self.all_data = all_data
    for k, v in pairs(all_data.wishShow) do
        local _item = {}
        _item.key = tonumber(k)
        _item.type = v[1].type
        _item.arg = v[1].arg
        _item.arg2 = v[1].arg2
        table.insert(itemlist,_item)
    end
    table.sort(itemlist,function (a,b)
        return a.key < b.key  
    end)


	self:SetInfo(itemlist)
	self.act_id = all_data.id
    self.silvernum.text =string.gsub(TextMap.GetValue("LocalKey_682"),"{0}",Player.ItemBagIndex[all_data.silverItem.consume_arg].count)
    self.goldnum.text = string.gsub(TextMap.GetValue("LocalKey_682"),"{0}",Player.ItemBagIndex[all_data.goldItem.consume_arg].count)


    local vo_silver = itemvo:new(all_data.silverItem.consume_type, all_data.silverItem.consume_arg2, all_data.silverItem.consume_arg)
    local assets_silver = packTool:getIconByName(vo_silver.itemImage)

    local vo_gold = itemvo:new(all_data.goldItem.consume_type, all_data.goldItem.consume_arg2, all_data.goldItem.consume_arg)
    local assets_gold = packTool:getIconByName(vo_gold.itemImage)

    self.img_silver:setImage(vo_silver.itemImage, assets_silver)
    self.img_gold:setImage(vo_gold.itemImage, assets_gold)
end

function m:updateRes( ... )
    self.silvernum.text =string.gsub(TextMap.GetValue("LocalKey_682"),"{0}",Player.ItemBagIndex[self.all_data.silverItem.consume_arg].count)
    self.goldnum.text =string.gsub(TextMap.GetValue("LocalKey_682"),"{0}",Player.ItemBagIndex[self.all_data.goldItem.consume_arg].count)
end

function m:SetInfo(itemlist)
	    
    for i=1,#itemlist do
        self:updateshowitem(itemlist[i],i)
    end

    if my_timer ~= nil then
        LuaTimer.Delete(my_timer)
    end

    
    local sortlist = {}
    for i=1,#infobindinglist do
        local item_sort = {}
        item_sort._obj = infobindinglist[i]
        item_sort._index = i
        table.insert(sortlist,item_sort)
    end

    table.sort(sortlist,function (a,b)
        return a._obj.gameObject.transform.localPosition.x < b._obj.gameObject.transform.localPosition.x  
    end)

    local last_index = sortlist[#sortlist]._index

    my_timer = LuaTimer.Add(0, 1, function(id)
        if self.obj.gameObject == nil then
            return false
        end
        for i=1,#infobindinglist do
            local item = infobindinglist[i]
            local x_pos = item.gameObject.transform.localPosition.x - 1.2
            item.gameObject.transform.localPosition = Vector3(x_pos,0,0)
        end

        for i=1,#infobindinglist do
            local item = infobindinglist[i]
            local x_pos = item.gameObject.transform.localPosition.x
            if x_pos < 50 then
                local item_last = infobindinglist[last_index]
                local x_pos = item_last.gameObject.transform.localPosition.x + 105
                item.gameObject.transform.localPosition = Vector3(x_pos,0,0)
                last_index = i
            end
        end
        return true
    end)
end

function m:updateshowitem( _data ,_i)
    local _type = _data.type

    local infobinding = nil
    if _i > #infobindinglist then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Grid.gameObject)
        table.insert(infobindinglist,infobinding)
    else
        infobinding = infobindinglist[_i]
    end
    if infobinding == nil then return end

    self.frame.gameObject:SetActive(false)
    local char = RewardMrg.getDropItem(_data)
    infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height, true, nil, true })
end

function m:onClick(go, name)
    local _type = ""
    m.bgBox:SetActive(true)
    if name == "s_one_bt" then
        _type = "silver"
        self:WishingEvent(_type,1)
    elseif name == "s_ten_bt" then
        _type = "silver"
        self:WishingEvent(_type,10)
    elseif name == "g_one_bt" then
        _type = "gold"
        self:WishingEvent(_type,1)
    elseif name == "g_ten_bt" then
        _type = "gold"
        self:WishingEvent(_type,10)
    elseif name == "componse_bt" then
        m.bgBox:SetActive(false)
        self:WishCoinCompoundEvent()
    elseif name == "btn_rule" then
        m.bgBox:SetActive(false)
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {10000,title = TextMap.GetValue("Text450"),rule = self.all_data.desc})
    end
end



function m:WishingEvent(_type,_num)
	Api:WishingReq(self.act_id, _type, _num, function(result)
        if result.ret == 0 then
            m.Effect.gameObject:SetActive(true)
            LuaTimer.Add(2 * 1000, function() -- 播放特效
            m.Effect.gameObject:SetActive(false)
            self:showReward(result)
            end)
        else
            m.Effect.gameObject:SetActive(false)
        end

    end,function ()
        m.bgBox:SetActive(false)
        return false
    end)
end


function m:WishCoinCompoundEvent()
    local _tatio = self.all_data.silverToGoldNum
    local _maxCount = Player.ItemBagIndex[self.all_data.silverItem.consume_arg].count/_tatio
    _maxCount = math.floor(_maxCount)
     if _maxCount < 1 then
        MessageMrg.show(TextMap.GetValue("Text451"))
        return
    end

    if _maxCount > 99 then
        _maxCount = 99
    end

   

    local _cost_item = {}
    _cost_item.type = self.all_data.silverItem.consume_type
    _cost_item.arg = self.all_data.silverItem.consume_arg
    _cost_item.arg2 = 1
 
    local _componse_item = {}
    _componse_item.type = self.all_data.goldItem.consume_type
    _componse_item.arg = self.all_data.goldItem.consume_arg
    _componse_item.arg2 = 1

	UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/componse_view", {
           -- prize = self._prize,
           -- maxCount = lastTimes,
           -- item = self.item,
           -- delegate = self.delegate
           cost_item = self.all_data.silverItem.consume_arg,
           componse_item = self.all_data.goldItem.consume_arg,
           tatio = _tatio,
           maxCount = _maxCount,
           cost_item = _cost_item,--银币
           item = _componse_item, -- 合成的金币
           act_id = self.act_id,
           delegate=self
        })
end

function m:showReward(_result)
    LuaTimer.Add(10, function()
        --可以点击了
        m.bgBox:SetActive(false)

        --播放特效
        --local reward = _data.drop or {}
        --print(".....reward......"..reward[1].charPieceSplit)
        local reward = RewardMrg.getList(_result)

        WishRewardShow:show({ delegate = self, data = reward })
    end)
end


return m