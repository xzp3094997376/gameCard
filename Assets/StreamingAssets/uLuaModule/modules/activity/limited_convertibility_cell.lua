--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/19
-- Time: 15:52
-- To change this template use File | Settings | File Templates.
-- 限时兑换
local m = {}

function m:create(binding)
    self.binding = binding
    return self
end

function m:update(data, index, delegate)
    self.canClick=true
    self.dropTypeList = {}
    if data~=nil then
        self.data = data
    end
    self.delegate = self.data.delegate
    local drop = self.data.drop
    local extra_item= self.data.extra_drop
    local consume2 = self.data.consume2
    if extra_item ~= nil then
        for k, v in pairs(extra_item) do
            table.insert(self.dropTypeList, v.itemType)
        end
    end
    if tonumber(self.data.disc)==10 or self.data.disc==nil or self.data.disc=="" then 
        self.discLabel.gameObject:SetActive(false)
    else 
        self.discLabel.gameObject:SetActive(true)
        self.discLabel.text=string.gsub(TextMap.GetValue("LocalKey_789"),"{0}",self.data.disc)
    end 
    self.data.times=self.delegate.data._source_data.times[self.data.k] or 1
    if self.delegate.data._source_data.selectPackageName~=nil then 
        self.data.titleName=self.delegate.data._source_data.selectPackageName[self.data.k] 
    end 
    if self.data.titleName~=nil and self.data.titleName~="" then 
        self.Title.text=self.data.titleName
    else 
        self.Title.text=TextMap.GetValue("Text_1_17")
    end
    self.canbuyNum=tonumber(self.data.times) or 0
    local desc = self.data.times
    if self.data.times == 0 then
        desc = "[ff0000]" .. self.data.times .. "[-]"
    else
        desc = "[ffff00]" .. self.data.times .. "[-]"
    end
    if self.data.tp == "daily" then
        self.txt_change_count.text = TextMap.GetValue("Text399") .. desc
    elseif self.data.tp == "all_time" then
        self.txt_change_count.text = TextMap.GetValue("Text400") .. desc
    else
        self.txt_change_count.text = TextMap.GetValue("Text401") .. desc
    end
    local package = self.data.package
    self.gid = package.id
    self.cost:SetActive(false)
    self.cost2:SetActive(false) 
    if consume2~=nil and #drop<=2 and #extra_item==1 then 
        self.teams={}
        self.table.gameObject:SetActive(true)
        local consumeData = {}
        local consume = consume2
        consume.isAdd=true 
        for i=1,tonumber(consume2.num) do
            table.insert(consumeData,consume)
        end
        self.table:refresh(consumeData, self, true, 0)
        self.binding:CallAfterTime(0.1,function()
            self.table:goToIndex(consume2.num-1)
        end)
        if tonumber(consume2.num)==1 then 
            self.num.text=""
            self.table.gameObject.transform.localPosition = Vector3(15,0, 0)
        else 
            self.num.text="0/" .. consume2.num
        end 
        self.itemActivity1.gameObject:SetActive(false)
        self.canbuyNum=1
        if #drop<=2 then 
            for i=1,#drop do
                local itemcell=RewardMrg.getDropItem(drop[i].item)
                local iconName = itemcell:getHead()
                if i==1 then 
                    self.cost:SetActive(true)
                    self.costIcon.Url=iconName
                    if Tool.typeId(drop[i].item.type) then 
                        self.costNum.text=drop[i].item.arg
                    else 
                        self.costNum.text=drop[i].item.arg2
                    end 
                else 
                    self.cost2:SetActive(true) 
                    self.costIcon2.Url=iconName
                    if Tool.typeId(drop[i].item.type) then 
                        self.costNum2.text=drop[i].item.arg
                    else 
                        self.costNum2.text=drop[i].item.arg2
                    end 
                end 
            end
            if #drop==2 then 
                self.con.transform.localPosition=Vector3(0,0,0)
                elseif #drop==1 then 
                self.con.transform.localPosition=Vector3(0,-15,0)
            else 
                self.con.transform.localPosition=Vector3(0,-25,0)
            end 
        else 
            print (TextMap.GetValue("Text_1_49"))
            self.con.transform.localPosition=Vector3(0,-15,0)
            self.cost:SetActive(false)
            self.cost2:SetActive(false)
        end
        self.itemActivity2:CallUpdateWithArgs(extra_item[1],1,nil,self)
    else 
        self.table.gameObject:SetActive(false)
        self.itemActivity1.gameObject:SetActive(true)
        self.num.text=""
        if #drop<=3 and #drop>0 and #extra_item==1 then 
            local resList = {}
            local notResList = {}
            for i=1,#drop do
                if self:typeId(drop[i].item.type) then 
                    table.insert(resList,drop[i])
                else 
                    table.insert(notResList,drop[i])
                end
            end
            if #notResList>0 then 
                self.itemActivity1:CallUpdateWithArgs(notResList[1],1,nil,self)
                m:getCanbuyNum(notResList[1].item)
                local xiaohaoIndex=1
                for i=2,#notResList do
                    local itemcell=RewardMrg.getDropItem(notResList[i].item)
                    local iconName = itemcell:getHead()
                    if xiaohaoIndex==1 then 
                        self.cost:SetActive(true)
                        self.costIcon.Url=iconName
                        if Tool.typeId(notResList[i].item.type) then 
                            self.costNum.text=drop[i].item.arg
                        else 
                            self.costNum.text=drop[i].item.arg2
                        end 
                    else 
                        self.cost2:SetActive(true) 
                        self.costIcon.Url=iconName
                        if Tool.typeId(notResList[i].item.type) then 
                            self.costNum2.text=drop[i].item.arg
                        else 
                            self.costNum2.text=drop[i].item.arg2
                        end     
                    end 
                    m:getCanbuyNum(notResList[i].item)
                    xiaohaoIndex=xiaohaoIndex+1 
                end
                for i=1,#resList do
                    local itemcell=RewardMrg.getDropItem(resList[i].item)
                    local iconName = itemcell:getHead()
                    if xiaohaoIndex==1 then 
                        self.cost:SetActive(true)
                        self.costIcon.Url=iconName
                        if Tool.typeId(resList[i].item.type) then 
                            self.costNum.text=drop[i].item.arg
                        else 
                            self.costNum.text=drop[i].item.arg2
                        end
                    else 
                        self.cost2:SetActive(true) 
                        self.costIcon2.Url=iconName
                        if Tool.typeId(resList[i].item.type) then 
                            self.costNum2.text=drop[i].item.arg
                        else 
                            self.costNum2.text=drop[i].item.arg2
                        end
                    end 
                    local canbuyNum = math.floor(Tool.getCountByType(resList[i].item.type)/tonumber(resList[i].item.arg))
                    self.canbuyNum=math.min(self.canbuyNum,canbuyNum)
                    xiaohaoIndex=xiaohaoIndex+1 
                end
            else 
                self.itemActivity1:CallUpdateWithArgs(resList[1],1,nil,self)
                local canbuyNum = math.floor(Tool.getCountByType(resList[1].item.type)/tonumber(resList[1].item.arg))
                self.canbuyNum=math.min(self.canbuyNum,canbuyNum)
                local xiaohaoIndex=1
                for i=2,#resList do
                    local itemcell=RewardMrg.getDropItem(resList[i].item)
                    local iconName = itemcell:getHead()
                    if xiaohaoIndex==1 then 
                        self.cost:SetActive(true)
                        self.costIcon.Url=iconName
                        if Tool.typeId(resList[i].item.type) then 
                            self.costNum.text=drop[i].item.arg
                        else 
                            self.costNum.text=drop[i].item.arg2
                        end
                    else 
                        self.cost2:SetActive(true) 
                        self.costIcon2.Url=iconName
                        if Tool.typeId(resList[i].item.type) then 
                            self.costNum2.text=drop[i].item.arg
                        else 
                            self.costNum2.text=drop[i].item.arg2
                        end
                    end 
                    local canbuyNum = math.floor(Tool.getCountByType(resList[i].item.type)/tonumber(resList[i].item.arg))
                    self.canbuyNum=math.min(self.canbuyNum,canbuyNum)
                    xiaohaoIndex=xiaohaoIndex+1 
                end
            end 
            if #drop==3 then 
                self.con.transform.localPosition=Vector3(0,0,0)
            elseif #drop==2 then  
                self.con.transform.localPosition=Vector3(0,-15,0)
            elseif #drop==1 then  
                self.con.transform.localPosition=Vector3(0,-25,0)
            end
            self.itemActivity2:CallUpdateWithArgs(extra_item[1],1,nil,self)
        else 
            self.con.transform.localPosition=Vector3(0,0,0)
            print (TextMap.GetValue("Text_1_49"))
        end
    end 
end

function m:onPress(go,name,bPress)
    
    if (self.delegate == nil or self.delegate.getScrollView == nil) then
        return
    end
    local sv = self.delegate:getScrollView()
    if sv ~= nil then
        sv:Press(bPress);
    end
end

function m:OnDrag(go,name,detal)
    
    if (self.delegate == nil or self.delegate.getScrollView == nil) then
        return
    end
    local sv = self.delegate:getScrollView()        
    if sv ~= nil then
        sv:Drag();
    end
end

function m:getScrollView()
    return self.delegate:getScrollView()
end

function m:AfterAddItem(teams)
    self.teams=teams
    local consumeData = {}
    for i,v in ipairs(teams) do
        table.insert(consumeData,v)
    end
    local consume = self.data.consume2
    consume.isAdd=true 
    for i=#teams+1,tonumber(self.data.consume2.num) do
        table.insert(consumeData,consume)
    end
    self.table:refresh(consumeData, self, true, 0)
    self.binding:CallAfterTime(0.1,function()
        self.table:goToIndex(self.data.consume2.num-1)
    end)
    if tonumber(self.data.consume2.num)==1 then 
        self.num.text=""
        self.table.gameObject.transform.localPosition = Vector3(15,0, 0)
    else 
        self.num.text=#teams .. "/" .. self.data.consume2.num
    end 
end

function m:getBtnTitleName(data)
    local text = TextMap.GetValue("Text_1_28")
    local star =tonumber(data.star)
    self.add_bg1.spriteName="tubiao_" .. star
    if star==1 then 
        text=text .. TextMap.GetValue("Text_1_29")
        self.add_bg2.spriteName="kuang_baise"
    elseif star==2 then 
        text=text .. TextMap.GetValue("Text_1_30")
        self.add_bg2.spriteName="kuang_lvse"
    elseif star==3 then 
        text=text .. TextMap.GetValue("Text_1_31")
        self.add_bg2.spriteName="kuang_lanse"
    elseif star==4 then 
        text=text .. TextMap.GetValue("Text_1_32")
        self.add_bg2.spriteName="kuang_zise"
    elseif star==5 then 
        text=text .. TextMap.GetValue("Text_1_33")
        self.add_bg2.spriteName="kuang_chengse"
    elseif star==6 then 
        text=text .. TextMap.GetValue("Text_1_34")
        self.add_bg2.spriteName="kuang_hongse"
    end
    local type = data.type
    if type == "char" then
        text=text .. TextMap.GetValue("Text_1_35")
    elseif type == "charPiece" then
        text=text .. TextMap.GetValue("Text_1_36")
    elseif type == "equip" then
        text=text .. TextMap.GetValue("Text_1_37")
    elseif type == "equipPiece" then
        text=text .. TextMap.GetValue("Text_1_38")
    elseif type == "item" then
        text=text .. TextMap.GetValue("Text_1_39")
    elseif type == "fashion" then
        text=text .. TextMap.GetValue("Text_1_40")
    elseif type == "pet" then
        text=text .. TextMap.GetValue("Text_1_41")
    elseif type == "petPiece" then
        text=text .. TextMap.GetValue("Text_1_42")
    elseif type == "ghost" then
        text=text .. TextMap.GetValue("Text_1_43")
    elseif type == "ghostPiece" then
        text=text .. TextMap.GetValue("Text_1_44")
    elseif type == "treasure" then
        text=text .. TextMap.GetValue("Text_1_45")
    elseif type == "treasurePiece" then
        text=text .. TextMap.GetValue("Text_1_46")
    else
        text=text .. TextMap.GetValue("Text_1_47")
    end
    return text
end

function m:checkFriend(char)
    local teams = Player.Team[12].chars
    local list = {}
    local len = teams.Count
    for i = 0, 7 do
        if i < len then
            if char.id .. "" == teams[i] .. "" then
                return true
            end
        end
    end
    return false
end
function m:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

function m:getCanbuyNum(cell)
    local _Count = 0
    local type = cell.type
    if type == "char" then
        local chars = Player.Chars:getLuaTable() --获取所有英雄
        --遍历所有角色
        for k, v in pairs(chars) do
            local char = Char:new(k, v)
            local blood = 0
            local bloodline = Player.Chars[char.id].bloodline
            if bloodline ~= nil then
                blood= bloodline.level
            end
            if char.info.exp==0 and blood==0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
                if tonumber(char.dictid)==tonumber(cell.arg) then 
                    _Count=_Count+1
                end  
            end 
        end
    elseif type == "charPiece" then
        local item = CharPiece:new(cell.arg)
        _Count=item.count
    elseif type == "equip" then
        local item = Equip:new(cell.arg)
        _Count=item.count
    elseif type == "equipPiece" then
        local item = EquipPiece:new(cell.arg)
        _Count=item.count
    elseif type == "item" then
        local item = uItem:new(cell.arg)
        _Count=item.count
    elseif type == "ghost" then
        local ghost = Tool.getUnUseGhost()
        for k,v in pairs(treasures) do
            if tonumber(v.id)==tonumber(cell.arg) and v.level == 1 and v.power == 0 then
                _Count=_Count+1
            end
        end
    elseif type == "ghostPiece" then
        local item = GhostPiece:new(cell.arg)
        _Count=item.count
    elseif type == "treasure"then
        local treasures = Player.Treasure:getLuaTable()
        for k,v in pairs(treasures) do
            if tonumber(v.id)==tonumber(cell.arg) and v.level == 1 and v.power == 0 and not v.onPosition then
                _Count=_Count+1
            end
        end
    elseif type == "fashion" then
        local item = Fashion:new(cell.arg)
        _Count=item.count 
    elseif type == "pet" then
        local item = Pet:new(nil, cell.arg)
        _Count=item.count
    elseif type == "petPiece" then
        local item = PetPiece:new(cell.arg)
        _Count=item.count  
    elseif type == "treasurePiece"then
        local item = TreasurePiece:new(cell.arg)
        _Count=item.count
    end
    _Count=_Count or 0
    if cell.arg2=="" then cell.arg=1 end 
    local canbuyNum = math.floor(_Count/cell.arg2)
    self.canbuyNum=math.min(self.canbuyNum,canbuyNum) 
end

function m:typeId(_type)
    -- local ret = false
    -- TableReader:ForEachLuaTable("resourceDefine", function(k, v)
    --     if _type == v.name then
    --         ret = true
    --         return false
    --     end
    -- end)
    return Tool.typeId(_type)
end

function m:onClick()
    if self.canClick==true  then 
        self.delegate.selectItem_cur=self
        if self.data.consume2 ~=nil and self.canbuyNum==1 and tonumber(self.data.times)>= 1 then 
                if #self.teams>=tonumber(self.data.consume2.num) then 
                    local idArr={}
                    if self.data.consume2.type=="ghost" or self.data.consume2.type=="treasure" then 
                        for i,v in ipairs(self.teams) do
                            table.insert(idArr, v.key)
                        end
                    else 
                        for i,v in ipairs(self.teams) do
                            table.insert(idArr, v.id)
                        end
                    end   
                    Api:exchange(self.delegate.data.id, self.gid,1,idArr, function(result)
                    packTool:showMsg(result, nil, 1)
                    m:getCallBack(1)
                    end,function ()
                        self.teams={}
                        m:AfterAddItem(self.teams)
                    end)
                else 
                    MessageMrg.show(TextMap.GetValue("Text_1_50"))
                end 
         elseif tonumber(self.data.times)> 1 then
         print(self.canbuyNum) 
            if self.canbuyNum>1 then 
                UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/act_exchangemore", {data=self.data,title="limitChange",delegate=self})
            else 
                Api:exchange(self.delegate.data.id, self.gid,1,nil, function(result)
                packTool:showMsg(result, nil, 1)
                m:getCallBack(1)
                end)
            end 
        else 
            Api:exchange(self.delegate.data.id, self.gid,1,nil,function(result)
                packTool:showMsg(result, nil, 1)
                m:getCallBack(1)
                end)
        end 
    end 
end

function m:exchangeMore(num)
    Api:exchange(self.delegate.data.id, self.gid,num,nil,function(result)
            packTool:showMsg(result, nil, 1)
            m:getCallBack(num)
            end)
end


function m:getCallBack(num)
    self.delegate:countMutliPoint(false)
    self.data.times=self.data.times-num
    self.delegate.gid_cur=self.gid
    self.delegate.delegate:refreshEveryPay()
    if num==1 and self.data.consume2~=nil then 
        self.teams={}
        m:AfterAddItem(self.teams)
    end 
end

return m

