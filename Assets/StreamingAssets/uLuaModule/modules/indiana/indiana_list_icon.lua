 --宝物掠夺列表对手icon
local m = {}

function m:Start(...)
end

function m:update(data,index,delegate)
    self.data = data
    self.index = index
    self.delegate = delegate
    self:setPlayerInfo(self.data)
    self.pid = data.pid
    self.pieceId = self.delegate.treasure_id
end

--设置对手信息
function m:setPlayerInfo(data)
    if data == nil then return end
    --设置阵容信息
    local team = data.defenceTeam
    local list = {}
    if team ~= nil then
        for i, v in pairs(team) do
            local char = nil
            if v.dictid ~=nil then 
                char = Char:new(nil,v.dictid)
                char.star=v.quality
            else 
                char = Char:new(v.id)
            end
            char.lv = v.level
            char.star_level = v.star
            char.stage = v.stage
            table.insert(list,char)
        end
    end
    self.txt_name.text =Tool.getNameColor(data.quality) .. data.nickname .. "[-]"
    self.txt_team.text =string.gsub(TextMap.GetValue("LocalKey_812"),"{0}",data.level)
    self.txt_gailv.text = self:configChance(data.pct)
    self.txt_power.text= toolFun.moneyNumber(math.floor(tonumber(data.power)))
    self.isNPC = data.isNPC
    if data.isNPC == true then
        self.btn_rob_five.gameObject:SetActive(true)
    else
        self.btn_rob_five.gameObject:SetActive(false)
    end
    self.scrollview:refresh(list,self,false,0)
    if #list<7 then 
        self.scrollview.gameObject:GetComponent("BoxCollider").enabled = false
        for i=0,self.grid.transform.childCount-1 do
            self.grid.transform:GetChild(i):GetComponent("BoxCollider").enabled = false
        end 
    end
    self.grid.repositionNow = true
    if self.index==0 then 
        Messenger.Broadcast('IndianaDrag')--新手引导的监听
    end 
end

function m:configChance(count)
    if count == nil then return "" end
    if count > 7000 then           --高概率
        return Tool.getNameColor(4) .. TextMap.GetValue("Text1726") .. "[-]"
    elseif count >= 3000 then --中概率
        return Tool.getNameColor(3) .. TextMap.GetValue("Text1727") .. "[-]"
    else                                   --低概率
        return Tool.getNameColor(2) .. TextMap.GetValue("Text1728") .. "[-]"
    end
end

--掠夺一次
function m:onRobOne()
    if not GuideMrg:isPlaying() then
        Api:treasureRob(self.pid,self.pieceId,function (result)
            if result.ret==0 and result.battle3.win==true then 
                self.isClose = true
                UIMrg:pop()
                Events.Brocast("refreshData")
            end 
            self.delegate:refreshVp()
            LuaMain:refreshTopMenu()
            local fightData = {}
            fightData["battle"] = result
            fightData["drop"] = result.drop
            fightData["mdouleName"] = "indiana"
            fightData["pieceId"] = self.pieceId
            UIMrg:pushObject(GameObject())
            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        end)
    else
        --触发引导时的挑战，guideid为表monsterteam的id,表示实际和这个怪物组战斗
        local guideid = TableReader:TableRowByID("trsRobConfig","newbie_teamid").value
        guideid=tonumber(guideid)
        Api:treasureRob_guide(self.pid,self.pieceId,guideid,function (result)
            if result.ret==0 and result.battle3.win==true then 
                self.isClose = true
                UIMrg:pop()
                Events.Brocast("refreshData")
            end 
            self.delegate:refreshVp()
            LuaMain:refreshTopMenu()
            local fightData = {}
            fightData["battle"] = result
            fightData["drop"] = result.drop
            fightData["mdouleName"] = "indiana"
            fightData["pieceId"] = self.pieceId
            UIMrg:pushObject(GameObject())
            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        end)
    end 
end

--掠夺五次
function m:onRobFive()
    if self.pid == nil or self.pieceId == nil then return end
    Api:robNtime(self.pid,self.pieceId,5,function (result)
        self.delegate:refreshVp()
        LuaMain:refreshTopMenu()
        local data = json.decode(result:toString()).robRet
        self.isClose = false
        for i=1,#data do
            if data[i].win==true then 
                self.isClose = true
            end 
        end
        local piecelist={}
        table.insert(piecelist,self.pieceId)
        UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_result",{result=result,piecelist=piecelist,delegate=self})
        self.btn_rob_five.isEnabled = true
    end)
end

function m:onClick(go, name)
    local needvp=TableReader:TableRowByID("trsRobConfig", "rob_vp").value
    if name == "btn_rob_one" then  --掠夺一次
        if Player.Resource.vp<needvp then 
            local cb= function ()
                self.delegate:refreshVp()
            end
            DialogMrg:BuyBpAOrSoul("vp", "", cb ,cb )
            return 
        end 
        if self.isNPC ~= true then  --不是npc
            local end_time = Player.Treasure.outOfRobTime
            if end_time ~= nil then
                local time = ClientTool.GetNowTime(end_time or 0)
                if time > 0 then
                    DialogMrg.ShowDialog(TextMap.GetValue("Text1729"), function()
                        self:onRobOne()
                    end)
                else
                    self:onRobOne()
                end
            else
                self:onRobOne()
            end
        else
            self:onRobOne()
        end
    elseif name == "btn_rob_five" then --掠夺五次
        local needLv=TableReader:TableRowByID("trsRobConfig", "5_rob_lv").value
        local needVip=TableReader:TableRowByID("trsRobConfig", "5_rob_vip").value
        if Player.Info.level>=needLv or Player.Info.vip>=needVip then  
            if Player.Resource.vp<needvp then 
                local cb= function ()
                    self.delegate:refreshVp()
                end
                DialogMrg:BuyBpAOrSoul("vp", "", cb ,cb )
                return
            end
            self.btn_rob_five.isEnabled = false
            self:onRobFive()
        else 
            MessageMrg.show(TextMap.GetValue("Text_1_924") .. needLv .. TextMap.GetValue("Text_1_925") .. needVip .. TextMap.GetValue("Text_1_926"))
        end 
    end
end

return m