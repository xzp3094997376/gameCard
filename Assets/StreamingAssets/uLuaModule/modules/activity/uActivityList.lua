local actList = {}

function actList:create(...)
    return self
end

-- function actList:OnDestroy( ... )
--     actFont = nil
-- end


function actList:Start(...)
    LuaMain:ShowTopMenu(6,nil,{[1]={ type="crystal"},[2]={ type="c_gold"},[3]={ type="money"},[4]={ type="gold"}})
    self._title=Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_117"),function ()
        LuaMain:ShowTopMenu(1)
        Api:checkUpdate(function()end)
        Tool.updateActivityOpen()
        UIMrg:pop()
    end)
    self:init()
    self.binding:CallManyFrame(function()
        self:getActivityData()
    end, 1)

end

function actList:onEnter()
     LuaMain:ShowTopMenu(6,nil,{[1]={ type="crystal"},[2]={ type="c_gold"},[3]={ type="money"},[4]={ type="gold"}})
end

function actList:update(data)
    if data then
        self.__curActId = data[1]
        self._type = data[2]
    else
        self.__curActId = nil
        self._type = nil
    end
    if self._type=="fuli" and self._title~=nil then 
        self._title:CallTargetFunctionWithLuaTable("setTitle",TextMap.GetValue("Text_1_118"))
    elseif self._type=="like" and self._title~=nil then 
        self._title:CallTargetFunctionWithLuaTable("setTitle",TextMap.GetValue("Text_1_2961"))
    end
    --LuaMain:ShowTopMenu()
end

function actList:init()
    self.bind = {}
    self.currentSelect=nil
end


function actList:getActivityData(...)
    self.list = {}
    Api:getActivity("",self._type, function(result)
        self:ApiReqActivityandFuli(result)
        activityinfo_resp=result
        end, function(...) 
        LuaMain:ShowTopMenu(1)
        UIMrg:pop()
        return false
        end)
end

function actList:ApiReqActivityandFuli(result)
    actList:refreshData(result,true)
    self.binding:CallManyFrame(function()
        self.canSelect=true
        Events.Brocast('SelectActCallBack', self._findIndex)
    end, 5)
    if result.ids.Count>0 then 
        self:showActivity(nil, result.ids[self._findIndex].act_id)
    end 
end

function actList:refreshData(result,_bool)
    if result.ids == nil then 
        return
    end
    local count = result.ids.Count
    if count == 0 then 
        MessageMrg.show(TextMap.GetValue("Text1647")) 
        LuaMain:ShowTopMenu(1)
        UIMrg:pop() 
        return 
    end
    
    local rp ={}
    if result.rp ~=nil then 
        rp=json.decode(result.rp:toString())
    end 
    self.rp = {}
    self.redPoint = 0
    table.foreachi(rp, function(k, v)
        self.rp[v] = true
    end)
    if _bool ==true then 
        local _list = {}
        local _find = false
        self._findIndex = 0
        for i = 0, count - 1 do
            local info = {}
            local it = result.ids[i]
            info.icon = it.icon
            info.is_new = it.is_new
            info.is_selected = false
            info.id = it.act_id
            info.title = it.t
            info.delegate = self
            self.list[info.id] = info
            table.insert(_list, info)
            if self.__curActId ~= nil and _find == false and info.id == self.__curActId then
                _find = true
                self._findIndex = i
            end
            info = nil
        end
        self.left:refresh(_list, self, true, 0)
        self.binding:CallAfterTime(0.1,function()
            self.left:goToIndex(self._findIndex)
        end) 
    else 
        if self.currentSelect~=nil and self.currentSelect.gameObject~=nil then 
            self.currentSelect:showEffect()
        end
    end 
    if result.act_type ~= nil then
        self._type = result.act_type
    end 
    _list = nil
    if result.infos~=nil then
        local infos_drop = json.decode(result.infos:toString())
        table.foreach(infos_drop, function(i, v)
            self:getContentData(i,v)
        end)
    end 
end

function actList:OnEnable()
    self.canSelect=true
    self:refreshEveryPay()
end

function actList:OnDestroy()
    Events.RemoveListener('activity_refresh')
    LuaTimer.Delete(time_id)
    LuaTimer.Delete(timer_id)
end

Events.AddListener("activity_refresh",
    function(params)
        actList:refreshEveryPay()
    end
    )

function actList:refreshEveryPay( ... )
     Api:getActivity("",self._type, function(result)
            local id = self.currentID
            actList:refreshData(result,false)
            self:refreshContent(id,true)
            self:onEnter()
        end)
end

function actList:onExit()
    self.__exit = true
end

function actList:showActivity(selected, id, go)
    --先设置好currentID
    if not self.currentID then self.currentID = id end

    if self.currentSelect ~= nil then
        self.list[self.currentID].is_selected = false
        self.currentSelect.data.is_selected=false
        self.currentSelect:showSelect(false)
    end
    if selected ~= nil then
        self.currentSelect = selected
        self.currentID = self.currentSelect.id
        self.currentEvent = self.currentSelect.event
        self.list[self.currentID].is_selected = true
        self.currentSelect.data.is_selected=true
        self.currentSelect:showSelect(true)
    end
    if self.list[id].info.event == "sendActBylevel" or self.list[id].info.event == "turnTable" then
        Api:getActivity(id,self._type, function(result)
            if result.ret == 0 then
                self:getContentData(id,json.decode(result.info:toString()))
                self:refreshContent(id,false)
            end
        end, function(...)
            return false
        end)
    elseif self.list[id].info == nil then
        Api:getActivity(id,self._type, function(result)
            if result.ret == 0 then
                self:getContentData(id,json.decode(result.info:toString()))
                self:refreshContent(id,false)
            end
        end, function(...)
            return false
        end)
    else
        self:refreshContent(id,false)
    end
end

function actList:getContentData(id, info, ret)
    local temp = {}
    local tableInfo = info

    temp.id = tableInfo.id
    temp.title = tableInfo.title
    temp.desc = tableInfo.desc
    temp.cdkey = tableInfo.cdkey
    temp.show_rank = tableInfo.show_rank
    temp.cost = tableInfo.cost
    temp.total = tableInfo.total
    temp.gift_cnt = tableInfo.gift_cnt
    temp.draw_cnt = tableInfo.draw_cnt
    temp.event = tableInfo.event
    temp.bg_icon = tableInfo.bg_icon
    temp.d_package = tableInfo.d_package
    ------------------大转盘新增数据---------
    temp.dangwei = tableInfo.dangwei

    temp.pointRank = tableInfo.pointRank
    temp.end_time = tableInfo.end_time
    temp.point = tableInfo.point
    temp.free_text = tableInfo.free_text
    temp.status = tableInfo.status
    temp.free_item = tableInfo.free_item_name
    ----------------------------------------------------
    -------------------许愿池新数据---------------
    temp.wishShow = tableInfo.wishShow
    temp.silverItem = tableInfo.silverItem
    temp.goldItem = tableInfo.goldItem
    temp.silverToGoldNum = tableInfo.silverToGoldNum
    temp.name = tableInfo.name
    ----------------------------------------------
    temp.rankType = tableInfo.rankType
    temp.rank_multiple = tableInfo.rank_multiple
    temp.menKan = tableInfo.menKan
    temp.finalReward = tableInfo.finalReward
    temp.rank_lowest = tableInfo.rank_lowest
    temp.selectPackage = tableInfo.selectPackage
    temp.selectName = tableInfo.selectName
    temp.selectIcon = tableInfo.selectIcon

    temp.add_qq = tableInfo.add_qq
    temp.add_wechat = tableInfo.add_wechat
    local status = tableInfo.status or 0
    local drop = tableInfo.drop

    local extra_drop = tableInfo.extra_drop or {}
    local package = tableInfo.package
    --为了适配status传入的额外信息而设置的，放置在package中
    local pkg_extra_info = {}

    if type(status) ~= "number" then
        local temp_status = {}
        local temp_extra_status = {}
        table.foreachi(status, function(i, v)
            temp_status[v.id] = v.status
            --适配（挑战获胜）额外信息
            pkg_extra_info[v.id] = { total = v.total or 0, complete = v.complete or 0, link_id = v.link_id or 0 }
            temp_extra_status[v.id] = v.extra
        end)
        temp.status = temp_status

        temp.extra_status = temp_extra_status
    else
        temp.status = status
    end

    if drop ~= "-1" then
        if type(package) ~= "string" then
            local temp_package = {}
            local temp_drop = {}
            local temp_key = {}
            local temp_extra_drop = {}
            table.foreachi(package, function(i, v)
                --适配（挑战获胜）额外信息
                v.extra_info = pkg_extra_info[v.id]
                local id = v.id
                -- local name = v.name
                local dropItem = drop[id]
                temp_extra_drop[i] = extra_drop[id]
                -- temp_key[i] = id
                temp_package[i] = v
                temp_drop[i] = dropItem
            end)
            temp.package = temp_package
            temp.drop = temp_drop
            temp.extra_drop = temp_extra_drop
            -- temp.keys = temp_key
        else
            temp.package = package
            temp.drop = drop
        end
    end


    temp.rank = tableInfo.rank

    temp._source_data = tableInfo
    self.list[id].info = temp
end
local time_id=0
local timer_id=0

function actList:updateTurnTableState( ... )
    Api:getActivity("",self._type, function(result)
            local id = self.currentID
            actList:refreshData(result,false)
            self:onEnter()
            actList:refreshContent(id,true)
        end)
end

function actList:refreshHeroModelAndTitle(data)
    local bg_icon = data.bg_icon
    if self.title~=nil then
        if bg_icon~=nil and bg_icon~= "" then
            self.bg:SetActive(true)
            self.title_obj:SetActive(true)
            self.title.Url=UrlManager.GetImagesPath("sl_activity/" .. bg_icon .. ".png")
        else 
            self.bg:SetActive(false)
            self.title_obj:SetActive(false)
        end  
        
    end
    local path = UrlManager.GetImagesPath("sl_activity/activity_tip/" .. data.title .. ".png")
    if self.tip ~= nil and data.event~="normalPay" and data.event~="wishingWell" and data.event~="turnTable" and data.event~="fortune" and data.event~="login30" and data.event~="getBP" then 
        self.tip.gameObject:SetActive(true)
        self.tip.Url=path
    else 
        self.tip.gameObject:SetActive(false)
    end 
    if self.hero~=nil and data.event~="normalPay" and data.event~="wishingWell" and data.event~="turnTable" and data.event~="fortune" and data.event~="login30" and data.event~="getBP" then 
        local id = 0
        if data.title~=nil then 
            id =tonumber(data.title)
        end
        local row
        if id~=nil and id>0 and id <1000 then 
            row = TableReader:TableRowByID("char", id)
        end
        if row~=nil then 
            self.hero.gameObject:SetActive(true)
            self.hero:LoadByModelId(id, "idle", function() end, false, 0, 1)
        else 
            self.hero.gameObject:SetActive(false)
        end 
    else 
        self.hero.gameObject:SetActive(false)
    end
    if self.time ~=nil and (data._source_data==nil or data._source_data.time_not_show==nil or data._source_data.time_not_show~=true) and data.event~="rankActivity" then    
        local timeTxt = ""
        local act_time = data
        if act_time.start_time ==nil and act_time.end_time ==nil then 
            act_time=data._source_data.time
        end 
        if act_time.start_time~=nil and act_time.start_time~="" then 
            local start_time = Tool.getFormatTime(tonumber(act_time.start_time) / 1000)
            timeTxt=TextMap.GetValue("Text_1_119") .. start_time .. "[-]"
            if act_time.end_time~=nil and act_time.end_time~="" then 
                local end_time = Tool.getFormatTime(tonumber(act_time.end_time) / 1000)
                timeTxt =timeTxt .. TextMap.GetValue("Text_1_120") .. end_time .. "[-]"
            end
        else 
            if act_time.end_time~=nil and act_time.end_time~="" then 
                local end_time = Tool.getFormatTime(tonumber(act_time.end_time) / 1000)
                timeTxt =TextMap.GetValue("Text_1_121") .. end_time .. "[-]"
            end
        end
        self.time.gameObject:SetActive(true)
        self.time.text=timeTxt
        if act_time.end_time~=nil and act_time.end_time~="" and tonumber(act_time.end_time) / 1000 >=os.time() then 
            LuaTimer.Delete(time_id)
            local time  =Tool.FormatTime4(tonumber(act_time.end_time) / 1000 -os.time()) 
            self.time1.text=TextMap.GetValue("Text_1_122") .. time 
            time_id = LuaTimer.Add(0, 1000, function(id)
                local time  =Tool.FormatTime4(tonumber(act_time.end_time) / 1000 -os.time()) 
                self.time1.text=TextMap.GetValue("Text_1_122") .. time 
                if tonumber(act_time.end_time) / 1000 <= os.time() then 
                    self.time1.text=""
                    LuaTimer.Delete(time_id)
                end  
                end) 
            if data.event =="turnTable" then
                LuaTimer.Delete(time_id)
                timer_id=LuaTimer.Add(0,tonumber(act_time.end_time) -os.time()*1000, function(id)
                    LuaTimer.Delete(time_id)
                    actList:updateTurnTableState()
                    end)
            end  
        else 
            LuaTimer.Delete(time_id)
            self.time1.text=""   
        end 
    else 
        self.time.text=""
        LuaTimer.Delete(time_id)
        self.time1.text=""
    end
    if data.event=="wishingWell" then 
        self.time1.transform.localPosition=Vector3(0,-150,0)
    else 
        self.time1.transform.localPosition=Vector3(0,0,0)
    end 
    if self.Content~=nil and data.event~="normalPay" and data.event~="wishingWell" and data.event~="turnTable" and data.event~="cdkeyChange" and data.event~="fortune" and data.event~="findBug" and data.event~="notice" and data.event~="login30" and data.event~="getBP" and data.event ~= "addQQ" then 
        self.Content.gameObject:SetActive(true)
        self.Content.text = data.desc
        if data.desc=="" or data.desc==" " then 
            self.Content.gameObject:SetActive(false)
        end 
        if data.event=="rankActivity" then 
            self.Content.alignment = NGUIText.Alignment.Left
        else 
            self.Content.alignment=NGUIText.Alignment.Center
        end 
    else 
        self.Content.gameObject:SetActive(false)
    end 
end

function actList:OnDestroy()
    LuaTimer.Delete(time_id)
end

function actList:getTableLen()
    local index = 0
    for k,v in pairs(self.bind) do
        index=index+1
    end 
    return index
end

function actList:refreshContent(id, ret)
    local event = self.list[id].info.event
    if event=="turnTable" or event=="sendActBylevel" then 
        Api:checkUpdate(function()
            actList:refreshContentData(id, ret)
            end)
    else 
        actList:refreshContentData(id, ret)
    end 
end 
local num = 0
function actList:refreshContentData(id, ret)
    if not ret then 
        self:refreshHeroModelAndTitle(self.list[id].info)
    end 
    local event = self.list[id].info.event
    if event == nil then Debug.Log("nil-------") return end
    local name_pre = self:getPrefabsName(event)
    if not ret then 
        num=num+1
        if self.cur_name_pre~=nil and self.bind[self.cur_name_pre]~=nil then
            self.bind[self.cur_name_pre].gameObject:SetActive(false) 
        end 
        if self.bind[name_pre] ==nil then
            local path ="Prefabs/moduleFabs/activityModule/" .. name_pre
            self.bind[name_pre] = ClientTool.loadAndGetLuaBinding(path, self.right)
        else 
            self.bind[name_pre].gameObject:SetActive(true)
        end
        self.cur_name_pre=name_pre
    end 
    if self.cur_name_pre~=name_pre then return end 
    self.bind[name_pre]:CallTargetFunctionWithLuaTable("updateContent", { delegate = self, data = self.list[id].info, ret = ret })
end

function actList:getPrefabsName(event)
    local name_pre = ""
    if event == "notice" or event == "returnGold" or event == "findBug" or
        event == "extraGold" or event == "shopSale"
    then
        name_pre="act_notice"
    elseif event == "totalPay" or event == "totalCost" then
        name_pre="act_totalPay"
    elseif event == "addQQ" then
        name_pre="act_addqq"
    elseif event == "rankJJC" then
        name_pre="act_rankPower"
    elseif event =="fortune" then
        name_pre="act_zhaocaimao"
    elseif event =="firstPayGift" or event =="dailyGift" or event =="dailyFirstPay" or event=="openGift" then
        name_pre="act_dailyFirstPay"
    elseif event=="lvlup" or event== "loginGift" then 
        name_pre="act_lvlup"
    elseif event=="sendActBylevel" then 
        name_pre="act_jubaopen"
    else
        name_pre="act_" .. event
    end
    return name_pre
end
function actList:checkRedPoint()
    return true
end

function actList:getDropPackage(delegate, aid, gid, cb)
    local info = self.list[aid].info
    if info.status == 0 then MessageMrg.show(TextMap.GetValue("Text447")) return end
    if info.status == 1 or info.status == 4 or info.status == 5 or info .event=="sendActBylevel" then --领取|开宴
    Api:getActGift(aid, gid, function(result)
        if result.drop ~= nil then
            self:showMsg(result, info.event)
            self:onEnter()
            self.rp[aid] = false
            if self.currentSelect ~= nil then self.currentSelect:hideEffect() end
            delegate:getCallBack()
        end
        if cb then cb() end
    end, function()
        return false
    end)
    elseif info.status == 3 then
        DialogMrg.chognzhi()
    end
end

function actList:fortune(delegate, aid,  cb)
    local info = self.list[aid].info
    Api:fortune(aid, function(result)
        if result.drop ~= nil then
            self:showMsg(result, info.event)
            self:onEnter()
            self.rp[aid] = false
            if self.currentSelect ~= nil then self.currentSelect:hideEffect() end
            delegate:getCallBack()
        end
        if cb then cb() end
    end, function()
        return false
    end)
end

function actList:buyVipGift(delegate, aid, gid,num,cb)
    local info = self.list[aid].info
    Api:buyVipGift(aid, gid,num, function(result)
        if result.drop ~= nil then
            self:showMsg(result, info.event)
            self:onEnter()
            local times = self.list[aid].info._source_data.times[gid]
            self.list[aid].info._source_data.times[gid]=times-1
        end
        if cb then cb() end
    end, function()
        return false
    end)
end

function actList:getMutliPackage(delegate, aid, gid,cb)
    local info = self.list[aid].info
    if info.status[gid] == 0 then MessageMrg.show(TextMap.GetValue("Text447")) return end
    Api:getActGift(aid, gid, function(result)
        if result.drop ~= nil then
            if result.times~=nil and result.times>0 then
                info.status[gid] = 1
            else 
                info.status[gid] = 2
            end 
            self:showMsg(result, info.event)
            self:onEnter()
            local rp = false
            if info.package ~=nil then 
                for k, v in pairs(info.package) do
                    local st = info.status[info.package[k].id]
                    if st == 1 then
                        rp = true
                    end 
                end
            end 
            self.rp[aid] = rp
            if self.currentSelect ~= nil then self.currentSelect:showEffect() end
            delegate:getCallBack()
        end
        if cb then cb(result) end
    end, function()
        return false
    end)
end

function actList:hideEffect()
    if self.currentSelect ~= nil then self.currentSelect:hideEffect() end
end

function actList:showMsg(drop, event)
    local tp = 1
    if event == "doubleMoney" or event == "getBP" then
        tp = 0
    end
    packTool:showMsg(drop, nil, tp)
end

function actList:getDrop(_drop)
    local drop = _drop
    local _list = {}
    for i = 0, drop.Count - 1 do
        local v = drop[i]
        if self:isUsedType(v.type) then
            local m = {}
            m.type = v.type
            m.arg = v.arg
            m.arg2 = v.arg2
            table.insert(_list, m)
        end
    end
    return _list
end

function actList:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

--小红点计数
function actList:countRedPoint(add)
    if add then self.redPoint = self.redPoint + 1
    else self.redPoint = self.redPoint - 1
    end
end

--按钮事件
function actList:onClick(go, name)
   if name == "btnBack" then 
    print("LLLLLLLLLLL")
        LuaMain:ShowTopMenu(1)
        UIMrg:pop()
    end
end

return actList