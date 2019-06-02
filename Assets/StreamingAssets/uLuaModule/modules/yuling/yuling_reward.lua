local m = {}

function m:update(data)
    self.delegate = data.delegate
    self.tp=1
    self.btn_total:SetActive(false)
    m:updateInfo()
end

function m:updateInfo()
    local list={}
    if self.tp==1 then 
        local drawNum1 = Player.yuling.xihaoDrawTimes -- 每日普通召唤次数
        local drawNum2 = Player.yuling.yulingDrawTimes -- 每日高级召唤次数
        self.desc1.text=TextMap.GetValue("Text_1_3016") .. drawNum1
        self.desc2.text=TextMap.GetValue("Text_1_3017") .. drawNum2
        for k,v in pairs(self.list_mrjl) do
            v.state=2
            v.tp=self.tp
            local isBuy =false -- 是否已购买
            if Player.yuling.dayRewards[v.row.id]~=nil then 
                isBuy=true
            end 
            if isBuy== true then 
                v.state=3
            end  
            if v.row.type=="times_draw_yl" then 
                if tonumber(v.row.need)<= drawNum2 and isBuy==false then 
                    v.state=1
                end 
            else 
                if tonumber(v.row.need)<= drawNum1 and isBuy==false then 
                    v.state=1
                end 
            end 
        end
        table.sort(self.list_mrjl, function (a,b)
            if a.state~=b.state then return a.state<b.state end 
            return tonumber(a.row.id) < tonumber(b.row.id) 
        end )
        list=self.list_mrjl
    else 
        local drawNum1 = Player.Times.totalXihaoDraw -- 普通召唤总次数
        local drawNum2 = Player.Times.totalYulingDraw -- 高级召唤总次数
        self.desc1.text=TextMap.GetValue("Text_1_3014") .. drawNum1
        self.desc2.text=TextMap.GetValue("Text_1_3015") .. drawNum2
        for k,v in pairs(self.list_zsjl) do
            v.state=2
            v.tp=self.tp
            local isBuy =false -- 是否已购买
            if Player.yuling.lifetimeRewards[v.row.id]~=nil then 
                isBuy=true
            end 
            if isBuy== true then 
                v.state=3
            end  
            if v.row.type=="times_draw_yl" then 
                if tonumber(v.row.need)<= drawNum2 and isBuy==false then 
                    v.state=1
                end 
            else 
                if tonumber(v.row.need)<= drawNum1 and isBuy==false then 
                    v.state=1
                end 
            end 
        end
        table.sort(self.list_zsjl, function (a,b)
            if a.state~=b.state then return a.state<b.state end 
            return tonumber(a.row.id) < tonumber(b.row.id) 
        end )
        list=self.list_zsjl
    end 
    self.content:refresh(list, self, true, 0)
end


function m:Start()
    self.list_mrjl = {}
    TableReader:ForEachLuaTable("yuling_mrjl", function(index, item)
        local it = {}
        it.row = item
        local li = RewardMrg.getProbdropByTable(item.drop)
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        table.insert(self.list_mrjl,it)
        return false
    end)
    self.list_zsjl = {}
    TableReader:ForEachLuaTable("yuling_zsjl", function(index, item)
        local it = {}
        it.row = item
        local li = RewardMrg.getProbdropByTable(item.drop)
        local _item = li[1]
        it.item = _item
        it.name = _item.name
        table.insert(self.list_zsjl,it)
        return false
    end)
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btn_total_gray" then 
        if self.tp~=2 then 
            self.tp=2
            self.btn_total:SetActive(true)
            self.btn_day:SetActive(false)
            self:updateInfo()
        end
    elseif name == "btn_day_gray" then 
        if self.tp~=1 then 
            self.tp=1
            self.btn_total:SetActive(false)
            self.btn_day:SetActive(true)
            self:updateInfo()
        end  
    end
end

return m