local m = {} 
local REFRESH_TIMER = 0 
function m:update(all_lua)
    self:RegistEventFunction(all_lua.data.rankType)
    if timerApi ~= nil then
        LuaTimer.Delete(timerApi)
    end
    self.tp=nil
    self.click_rank:SetActive(true)
    self.click_yulan:SetActive(false)
    self.click_rankRewaed:SetActive(false)

	self.data = all_lua.data
	self.delegate = all_lua.delegate
	--self.Content.text = self.data.desc
    local data = self.data
    if data.event=="rankActivity" then 
        local timeTxt = ""
        local act_time = data
        if act_time.start_time~=nil then 
            local start_time = os.date("*t",tonumber(act_time.start_time) / 1000)
            local times = string.gsub(TextMap.GetValue("LocalKey_786"),"{0}",start_time.month)
            times=string.gsub(times,"{1}",start_time.day)
            times=string.gsub(times,"{2}",start_time.hour)
            times=string.gsub(times,"{3}",start_time.min)
            timeTxt=TextMap.GetValue("Text_1_140") .. times .. "[-]"
            if act_time.end_time~=nil then 
                local end_time = os.date("*t",tonumber(act_time.end_time) / 1000)
                local times = string.gsub(TextMap.GetValue("LocalKey_786"),"{0}",end_time.month)
                times=string.gsub(times,"{1}",end_time.day)
                times=string.gsub(times,"{2}",end_time.hour)
                times=string.gsub(times,"{3}",end_time.min)
                timeTxt =timeTxt .. TextMap.GetValue("Text_1_141") .. times .."[-]"
            end
        else 
            if act_time.end_time~=nil then 
                local end_time = os.date("*t",tonumber(act_time.end_time) / 1000)
                local times = string.gsub(TextMap.GetValue("LocalKey_786"),"{0}",end_time.month)
                times=string.gsub(times,"{1}",end_time.day)
                times=string.gsub(times,"{2}",end_time.hour)
                times=string.gsub(times,"{3}",end_time.min)
                timeTxt =TextMap.GetValue("Text_1_141") .. times .."[-]"
            end
        end
        self.time.gameObject:SetActive(true)
        self.time.text=timeTxt
    else 
        self.time.text=""
    end
    
    local rank = self.data.rank
    local list = {}
    local rankList = {}
    local index = 0
    local index_2 = 0

    if rank ~= nil then
        for k, v in pairs(rank) do
            local cell = {}
            v.rank =v.rank or (index+1)
            cell.data=v
            cell.muti = self.data.rank_multiple or 1
            cell.type = self.data.rankType
            table.insert(list, cell)
            index = index + 1
        end
    end
    if #list>0 then 
        self.table.gameObject:SetActive(true)
        self.table:refresh(list, self, true, 0)
		self.isNoHave = false
    else
        self.table.gameObject:SetActive(true)
        self.table:refresh({}, self, true, 0)
        self.table.gameObject:SetActive(false)
		self.isNoHave = true
    end 

    local source = self.data._source_data

    local me = source["self"] or {}
    
    local _list = self:getRankTextReward(self.data.drop, me.rank)
    self:CreatHeroInfo(_list)
    self.rankScrollview.gameObject:SetActive(true)
    self.rankScrollview:refresh(_list,self,true,0)
    self.rankScrollview.gameObject:SetActive(false)  
    if rank ~= nil then
        for k, v in pairs(rank) do
            table.insert(rankList, 
                { name = v.name, 
                num = v.act_value or 0, 
                vip = v.vip, 
                max = self.delegate:SetmaxRank(),
                rank = index_2 + 1, 
                _type = self.data.rankType,
                muti = self.data.rank_multiple or 1
                })
            index_2 = index_2 + 1
        end
    end

    local  mdangweilist = self:SortDangwei(self.data.d_package,self.data.dangwei)
    local _mDangweilist = self:getTextReward(mdangweilist,self.data.d_package)
    self.dangweiScrollview.gameObject:SetActive(true)
    self.dangweiList=_mDangweilist
    self.dangweiScrollview:refresh(self.dangweiList,self,true,0)
    local find = -1
    for i=1,#self.dangweiList do
        if find<0 then 
            if self.dangweiList[i].dw_status==1 then
                find=i-1 
            end 
        end 
    end
    if find<0 then 
        find=0
    end 
    self.dangweiScrollview.gameObject:SetActive(false)
    self.dangweiFind=find
    local reward_me_rank = tonumber(me.rank) or 9999
    local reward_me_value = me.act_value or 0
    if self.data.rankType == "rankPay"  then
        reward_me_value = self.data.rank_multiple * reward_me_value
    end
    if reward_me_rank > 9998 or reward_me_value < tonumber(self.data.rank_lowest) then
        self.my_rank_txt.text = TextMap.GetValue("Text1661")
        reward_me_rank = 9999
    else
        self.my_rank_txt.text = TextMap.GetValue("Text_1_142").."[00ff00]"..reward_me_rank.."[-]"
    end

    self.my_power_txt.text = self:GetCorrcentDes(self.data.rankType)..reward_me_value
    

    local dangwei_reward = false
    for i,v in pairs(self.data.d_package) do
        if v.status == 1 then
            dangwei_reward = true
            break
        end
    end

    if dangwei_reward or self.data.status == 1 then 
        self.delegate.delegate:countRedPoint(true)
    else
        self.delegate.delegate:countRedPoint(false)
    end
    if self.tp==nil or self.tp==1 then 
        self.tp=1
        self.click_rank:SetActive(false)
        self.click_yulan:SetActive(false)
        self.click_rankRewaed:SetActive(true)
        self.table.gameObject:SetActive(false)
        if self.data.end_time / 1000 <=os.time() then 
            self.feiche_bg:SetActive(true)
        else 
            self.rankScrollview.gameObject:SetActive(true)
            self.binding:CallAfterTime(0.1,function()
                self.rankScrollview:goToIndex(0)
            end)
        end 
        self.dangweiScrollview.gameObject:SetActive(false)
        self.nohave:SetActive(false)
    elseif self.tp==3 then 
        self.tp=3
        self.click_rank:SetActive(true)
        self.click_yulan:SetActive(false)
        self.click_rankRewaed:SetActive(false)
        self.table.gameObject:SetActive(true)
        self.binding:CallAfterTime(0.1,function()
            self.table:goToIndex(0)
        end)
        self.feiche_bg:SetActive(false)
        self.rankScrollview.gameObject:SetActive(false)
        self.dangweiScrollview.gameObject:SetActive(false)
        self.nohave:SetActive(self.isNoHave or false)
    elseif self.tp==2 then 
        self.click_rank:SetActive(false)
        self.click_yulan:SetActive(true)
        self.click_rankRewaed:SetActive(false)
        self.table.gameObject:SetActive(false)
        self.feiche_bg:SetActive(false)
        self.rankScrollview.gameObject:SetActive(false)
        self.dangweiScrollview.gameObject:SetActive(true)
        self.binding:CallAfterTime(0.1,function()
            self.dangweiScrollview:goToIndex(self.dangweiFind)   
        end)
        self.nohave:SetActive(false)
    end 


    local end_time = source["end_time"]--1446800000000
    --倒计时
    local time = ClientTool.GetNowTime(end_time or 0)
    --[[LuaTimer.Delete(REFRESH_TIMER)
    if time > 0 then
        REFRESH_TIMER = LuaTimer.Add(0, 1000, function(id)
            local time = ClientTool.GetNowTime(end_time or 0)
            if time > 0 then
                local txt_day = 0
                if time >= 86400 then
                    txt_day = math.floor(time/86400)
                    self.txt_day.text = txt_day
                else
                    self.txt_day.text = 0
                    txt_day = 0
                end 
                time = Tool.FormatTime(time-86400*txt_day)
                self.txt_time.text = time
            else
                self.txt_day.text = 0
                self.txt_time.text = "00:00:00"
            end
        end)
    else
        self.txt_day.text = 0
        self.txt_time.text = "00:00:00"
    end]]

    --[[ClientTool.AddClick(self.btn_rule,function()
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", 
            {
                10000,title = TextMap.GetValue("Text1687"),rule = self.data.desc
            })
    end)

    if self.data.rankType ~= "rankPay" and self.data.rankType ~= "rankJJC" and time >0 then
    timerApi = LuaTimer.Add(3000, 10000, function()
                        Api:getTopRank(self.data.id,3,function(rank_data)
                            self:onUpdateRankActivity(rank_data)                          
                        end,function()
                            print("error.....")
                        end)
                    end)
    end
    ]]
end
function m:DwCallBack(id,state)
    local find = -1
    for i=1,#self.dangweiList do
        if tonumber(self.dangweiList[i].dw_id)==tonumber(id) then 
            self.dangweiList[i].dw_status=state
            find=i-1 
        end 
    end
    if find<0 then 
        find=0
    end 
    self.dangweiScrollview:refresh(self.dangweiList,self,true,0)
    self.binding:CallAfterTime(0.1,function()
        self.dangweiScrollview:goToIndex(find)
    end)
end

function m:getScrollView()  
    if self.tp ==2 then     
        return self.view_dangwei
    elseif self.tp ==3 then     
        return self.view
    else 
        return self.view_rank
    end      
end

function m:onClick(go, name)
    if name == "btn_rank" then
        if self.tp~=3 then 
            self.tp=3
            self.click_rank:SetActive(true)
            self.click_yulan:SetActive(false)
            self.click_rankRewaed:SetActive(false)
            self.table.gameObject:SetActive(true)
            self.binding:CallAfterTime(0.1,function()
                self.table:goToIndex(0)
            end)
            self.feiche_bg:SetActive(false)
            self.rankScrollview.gameObject:SetActive(false)
            self.dangweiScrollview.gameObject:SetActive(false)
			self.nohave:SetActive(self.isNoHave or false)
        end 
    elseif name == "btn_yulan" then
		self.nohave:SetActive(false)
        if self.tp~=2 then 
            self.tp=2
            self.click_rank:SetActive(false)
            self.click_yulan:SetActive(true)
            self.click_rankRewaed:SetActive(false)
            self.table.gameObject:SetActive(false)
            self.feiche_bg:SetActive(false)
            self.rankScrollview.gameObject:SetActive(false)
            self.dangweiScrollview.gameObject:SetActive(true)
            self.binding:CallAfterTime(0.1,function()
                self.dangweiScrollview:goToIndex(self.dangweiFind)   
            end)
        end 
    elseif name == "btn_rankRewaed" then
		self.nohave:SetActive(false)
        if self.tp~=1 then 
            self.tp=1
            self.click_rank:SetActive(false)
            self.click_yulan:SetActive(false)
            self.click_rankRewaed:SetActive(true)
            self.table.gameObject:SetActive(false)
            if self.data.end_time / 1000 <=os.time() then 
                self.feiche_bg:SetActive(true)
            else 
                self.rankScrollview.gameObject:SetActive(true)
                self.binding:CallAfterTime(0.1,function()
                    self.rankScrollview:goToIndex(0)
                end)
            end 
            self.dangweiScrollview.gameObject:SetActive(false)
        end 
    elseif name=="btn_get" then 
        self.delegate.delegate:getDropPackage(self.delegate, self.data.id, "", function()
            self.btn_name.text = TextMap.GetValue("Text397")
            self.btn_get.isEnabled = false
            end)
    end
end

function m:getRankTextReward(reward, index)
    local list = {}
    if index == nil then index = 10000 end
    if reward then
        local rank = tonumber(index) or 9999
        local maxRank = 0
        local ii = 1
        for k, v in pairs(reward) do
            local cell = {}
            cell.type="rank"
            local rankId = self.data.package[k].id
            local numRank = tonumber(rankId)
            cell.rankId=self.data.package[k].id
            if numRank == nil then
                local tb = split(rankId, "-")
                local one = tonumber(tb[1]) or 0
                local two = tonumber(tb[2]) or 0
                if maxRank < two then maxRank = two end
                if (rank >= one and rank <= two) then
                    cell.isMeRank = true
                else 
                    cell.isMeRank = false
                end
            else
                if maxRank < numRank then maxRank = numRank end
                if rank == numRank then
                    cell.isMeRank = true
                else 
                    cell.isMeRank = false
                end
            end
            cell.li = {}
            table.foreach(v, function(i, item)
                local _type = item.type
                if _type == "char" then
                    local vo = Char:new(nil,item.arg)
                    vo.__tp = "char"
                    table.insert(cell.li, vo)
                    vo = nil
                else
                    local vo = itemvo:new(item.type, item.arg2, item.arg)
                    vo.__tp = "vo"
                    table.insert(cell.li, vo)
                    vo = nil
                end
            end)
            table.insert(list,cell)
        end
    end
    return list
end


function m:getTextReward(reward,package)
    local list = {}
    if reward then
        local function getItemName(name, count)
            return "[ffffff]" .. name .. "[-][ffd200] x" .. count .. " "
        end
        local ii = 1
        for k, v in pairs(reward) do
            local li = {}
            table.foreach(v, function(i, item)
                local _type = item.type
                if _type == "char" then
                    local vo = Char:new(item.arg)
                    if vo.info.level > 0 then
                        vo = CharPiece:new(vo.id)
                        vo.rwCount = vo.needCharNumber
                    end
                    vo.__tp = "char"
                    table.insert(li, vo)
                    vo = nil
                else
                    local vo = itemvo:new(item.type, item.arg2, item.arg)
                    vo.__tp = "vo"
                    table.insert(li, vo)
                    vo = nil
                end
            end)
            table.insert(list, 
                { rank = package[k].name, 
                  li = li,
                  subtype=1,
                  dw_status = package[k].status,
                  dw_id = package[k].id,
                  act_id = self.data.id,
                  delegate=self
                 })
        end
    end
    return list
end

function m:SortDangwei(package,dangwei)
    local temp_Dangwei = {}
    if package == nil then
        return temp_Dangwei
    end
    table.foreachi(package, function(i, v)
        local id = v.id
        local dangweiItem = dangwei[id]
        temp_Dangwei[i] = dangweiItem
    end)
    return temp_Dangwei
end

function m:GetCorrcentValue(_type)
     local _ms
    if _type == "rankLvl" then
        _ms = "level"
    elseif _type == "rankPower" then
        _ms = "power"
    elseif _type == "rankPay" then
        _ms = "money"
    elseif _type == "rankJJC" then
        _ms = "power"
    end

    return _ms
end

function m:GetCorrcentDes(_type)
    local _mdes = ""
    if _type == "rankLvl" then
        _mdes = TextMap.GetValue("Text_1_143").."[00ff00]"
    elseif _type == "rankPower" then
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1663").."[00ff00]"
    elseif _type == "rankPay" then
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1664").."[00ff00]"
    elseif _type == "rankJJC" then
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1665").."[00ff00]"  
    elseif _type == "rankChapterStar" then
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1666").."[00ff00]"
    elseif _type == "rankQCT" then
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1667").."[00ff00]"
    elseif _type == "rankTotalPower" then
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1668").."[00ff00]"
    else
        _mdes = "[F0E77B]" .. TextMap.GetValue("Text1669").."[00ff00]"
    end

    return _mdes
end

function m:RegistEventFunction(_type)
    if _type == "rankPay" then
        ActivityPay = true
        Events.RemoveListener("onUpdatePayRank")
        Events.AddListener("onUpdatePayRank", funcs.handler(self, self.onUpdateRankActivity))
    elseif _type == "rankJJC" then
        ActivityJJC = true
        Events.RemoveListener("onUpdateJJC")
        Events.AddListener("onUpdateJJC", funcs.handler(self, self.onUpdateRankActivity))
    end
end

function m:onUpdateRankActivity(up_data)
    local new_data = json.decode(up_data:toString())
    local rank_new = new_data.ranklist or new_data.rank
    local me_new = new_data.self
    local list = {}
    local index = 0
    if rank_new ~= nil then
        for k, v in pairs(rank_new) do
            if index < 3 then
                table.insert(list, v)
            end
            index = index + 1
        end
    end


    for i = 1, 3 do
        self["rankItem" .. i]:CallUpdate({
            data = list[i],
            muti = self.data.rank_multiple or 1,
            type = self.data.rankType
            })
    end

    if me_new ~= nil then
        local reward_me_rank = tonumber(me_new.rank) or 9999
        local reward_me_value = me_new.act_value or "0"
        if self.data.rankType == "rankPay"  then
            reward_me_value = self.data.rank_multiple * reward_me_value
        end
        if reward_me_rank > 9998 or reward_me_value < tonumber(self.data.rank_lowest) then
            self.my_rank_txt.text = TextMap.GetValue("Text1661")
            reward_me_rank = 9999
        else
            self.my_rank_txt.text = TextMap.GetValue("Text1670").."[00ff00]"..reward_me_rank.."[-]"
        end

        self.my_power_txt.text = self:GetCorrcentDes(self.data.rankType)..reward_me_value
    end

end


function m:OnDestroy()
    if timerApi ~= nil then
        LuaTimer.Delete(timerApi)
    end
    if ActivityPay then
        ActivityPay = false
        Events.RemoveListener("onUpdatePayRank")
    elseif ActivityJJC then
        ActivityJJC = false
        Events.RemoveListener("onUpdateJJC")
    end
end

function m:CreatHeroInfo(_list)
    self.feiche_bg:SetActive(true)
    local isEz = false
    if _list then  
        for i = 1, #_list do
            if _list[i].isMeRank==true then 
                isEz=true
                local items = _list[i].li
                self.titleRank.text=string.gsub(TextMap.GetValue("LocalKey_803"),"{0}",_list[i].rankId)
                ClientTool.UpdateMyTable("Prefabs/moduleFabs/activityModule/itemActivity",self.Table,items)
                self.msg:SetActive(false)
                if self.data.status==1 then 
                    self.btn_name.text = TextMap.GetValue("Text376")
                    self.btn_get.isEnabled = true
                elseif self.data.status==2 then  
                    self.btn_name.text = TextMap.GetValue("Text397")
                    self.btn_get.isEnabled = false
                end 
            end
        end
    end
    if not isEz then
        self.msg:SetActive(true)
        self.scrollview.gameObject:SetActive(false)
        self.titleRank.gameObject:SetActive(false)
        self.btn_get.gameObject:SetActive(false)
    end
    self.feiche_bg:SetActive(false)
end



return m