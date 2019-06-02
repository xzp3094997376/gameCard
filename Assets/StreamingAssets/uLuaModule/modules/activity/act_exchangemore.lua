local m = {} 

function m:update(lua)
	self.delegate = lua.delegate
    local drop = lua.data.drop
    self.data = lua.data
    local  extra_item= lua.data.extra_drop
    local package = lua.data.package
    self.gid = package.id
    self.extraNum=0
    self.dropNum=0
    self.costNum={}
    self.canbuyNum=lua.data.times
    self.desc.text=string.gsub(TextMap.GetValue("LocalKey_779"),"{0}",lua.data.times)
    self.txt_huodeyinbi:SetActive(false)
    self.img_coin2.gameObject:SetActive(false)
    self.txt_huodeyinbi.transform.localPosition=Vector3(0,-125,0)
    if #extra_item==1 and #drop>=1 and #drop<=3 then 
        self.itemActivity2:CallUpdate(extra_item[1])
        self.itemActivity2:CallTargetFunctionWithLuaTable("setNum")
        local resList = {}
        local notResList = {}
        for i=1,#drop do
            if self:typeId(drop[i].item.type) then 
                table.insert(resList,drop[i])
            else 
                table.insert(notResList,drop[i])
            end
        end
        if #drop==3 then 
            self.txt_huodeyinbi.transform.localPosition=Vector3(-50,-125,0)
        end 
        if #notResList>0 then 
            self.itemActivity1:CallUpdateWithArgs(notResList[1])
            self.itemActivity1:CallTargetFunctionWithLuaTable("setNum")
            if notResList[1].item.arg2=="" then 
                notResList[1].item.arg2=1 
            end 
            self.num1.text=toolFun.moneyNumberShowOne(math.floor(tonumber(notResList[1].item.arg2)))
            self.dropNum=notResList[1].item.arg2
            m:getCanbuyNum(notResList[1].item)
            local xiaohaoIndex=0
            for i=2,#notResList do
                xiaohaoIndex=xiaohaoIndex+1 
                local itemcell=RewardMrg.getDropItem(notResList[i].item)
                local iconName = itemcell:getHead()
                self["img_coin" .. xiaohaoIndex].Url=iconName
                if Tool.typeId(notResList[i].item.type) then 
                    self["money" .. xiaohaoIndex].text=notResList[i].item.arg
                    self.costNum[xiaohaoIndex]=notResList[i].item.arg
                else 
                    self["money" .. xiaohaoIndex].text=notResList[i].item.arg2
                    self.costNum[xiaohaoIndex]=notResList[i].item.arg2
                end
                m:getCanbuyNum(notResList[i].item)
            end
            for i=1,#resList do
                xiaohaoIndex=xiaohaoIndex+1 
                local itemcell=RewardMrg.getDropItem(resList[i].item)
                local iconName = itemcell:getHead()
                self["img_coin" .. xiaohaoIndex].Url=iconName
                if Tool.typeId(resList[i].item.type) then 
                    self["money" .. xiaohaoIndex].text=resList[i].item.arg
                    self.costNum[xiaohaoIndex]=resList[i].item.arg
                else 
                    self["money" .. xiaohaoIndex].text=resList[i].item.arg2
                    self.costNum[xiaohaoIndex]=resList[i].item.arg2
                end
                local canbuyNum = math.floor(Tool.getCountByType(resList[i].item.type)/tonumber(resList[i].item.arg))
                self.canbuyNum=math.min(self.canbuyNum,canbuyNum)
            end
            if xiaohaoIndex>0 then 
                self.txt_huodeyinbi:SetActive(true)
            else 
                self.txt_huodeyinbi:SetActive(false)
            end 
            if xiaohaoIndex==2 then 
                self.img_coin2.gameObject:SetActive(true)
            else 
                self.img_coin2.gameObject:SetActive(false)
            end 
        else 
            self.itemActivity1:CallUpdateWithArgs(resList[1],1,nil,self)
            self.itemActivity1:CallTargetFunctionWithLuaTable("setNum")
            self.num1.text=toolFun.moneyNumberShowOne(math.floor(tonumber(resList[1].item.arg)))
            self.dropNum=resList[1].item.arg
            local canbuyNum = math.floor(Tool.getCountByType(resList[1].item.type)/tonumber(resList[1].item.arg))
            self.canbuyNum=math.min(self.canbuyNum,canbuyNum)
            local xiaohaoIndex=0
            for i=2,#resList do
                xiaohaoIndex=xiaohaoIndex+1 
                local itemcell=RewardMrg.getDropItem(resList[i].item)
                local iconName = itemcell:getHead()
                self["img_coin" .. xiaohaoIndex].Url=iconName
                if Tool.typeId(resList[i].item.type) then 
                    self["money" .. xiaohaoIndex].text=resList[i].item.arg
                    self.costNum[xiaohaoIndex]=resList[i].item.arg
                else 
                    self["money" .. xiaohaoIndex].text=resList[i].item.arg2
                    self.costNum[xiaohaoIndex]=resList[i].item.arg2
                end
                local canbuyNum = math.floor(Tool.getCountByType(resList[i].item.type)/tonumber(resList[i].item.arg))
                self.canbuyNum=math.min(self.canbuyNum,canbuyNum)
            end
            if xiaohaoIndex>0 then 
                self.txt_huodeyinbi:SetActive(true)
            else 
                self.txt_huodeyinbi:SetActive(false)
            end 
            if xiaohaoIndex==2 then 
                self.img_coin2.gameObject:SetActive(true)
            else 
                self.img_coin2.gameObject:SetActive(false)
            end 
        end 
        if self:typeId(extra_item[1].item.type)==true then 
            self.num2.text=toolFun.moneyNumberShowOne(math.floor(tonumber(extra_item[1].item.arg)))
            self.extraNum=extra_item[1].item.arg
        else 
            self.num2.text=toolFun.moneyNumberShowOne(math.floor(tonumber(extra_item[1].item.arg2)))
            self.extraNum=extra_item[1].item.arg2
        end 
    end   
    local desc = lua.data.times
    if lua.data.times == 0 then
        desc = "[ff0000]" .. lua.data.times .. "[-]"
    else
        desc = "[ffff00]" .. lua.data.times .. "[-]"
    end
    if lua.data.tp == "daily" then
        self.desc.text = TextMap.GetValue("Text399") .. desc
    elseif lua.data.tp == "all_time" then
        self.desc.text = TextMap.GetValue("Text400") .. desc
    else
        self.desc.text = TextMap.GetValue("Text401") .. desc
    end
    if lua.title=="limitChange" then 
    	self.btntxt_nor.text =TextMap.GetValue("Text_1_16")
    	self.titleName.text=TextMap.GetValue("Text_1_17")
    end
    self.price={}
    self.selectNum.text=1 
    self.numberSelect.selectNum = 1
    self.numberSelect:setCallFun(m.setMoneyChange, self)
    self.numberSelect:maxNumValue(self.canbuyNum)
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
    local Count = 0
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
                    Count=Count+1
                end  
            end 
        end
    elseif type == "charPiece" then
        local item = CharPiece:new(cell.arg)
        Count=item.count
    elseif type == "equip" then
        local item = Equip:new(cell.arg)
        Count=item.count
    elseif type == "equipPiece" then
        local item = EquipPiece:new(cell.arg)
        Count=item.count
    elseif type == "item" then
        local item = uItem:new(cell.arg)
        Count=item.count
    elseif type == "ghost" then
        local item = Ghost:new(cell.arg)
        Count=item.count
    elseif type == "ghostPiece" then
        local item = GhostPiece:new(cell.arg)
        Count=item.count
    elseif type == "treasure"then
        local item = Treasure:new(cell.arg)
        Count=item.count
    elseif type == "fashion" then
        local item = Fashion:new(cell.arg)
        Count=item.count
    elseif type == "pet" then
        local item = Pet:new(nil, cell.arg)
        Count=item.count
    elseif type == "petPiece" then
        local item = PetPiece:new(cell.arg)
        Count=item.count  
    elseif type == "treasurePiece"then
        local item = TreasurePiece:new(cell.id)
        Count=item.count
    end
    if cell.arg2=="" then cell.arg=1 end 
    local canbuyNum = math.floor(Count/cell.arg2)
    self.canbuyNum=math.min(self.canbuyNum,canbuyNum) 
end

function m:onClick(go, name)
    if name == "btn_quxiao" or name == "btnClose" then
        UIMrg:popWindow()
    end
    if name == "btn_queren" then
        self.delegate:exchangeMore(tonumber(self.selectNum.text))
        UIMrg:popWindow()
    end
end

function m:setMoneyChange()
    local num = tonumber(self.selectNum.text)
    for i=1,#self.costNum do
        self["money" .. i].text =toolFun.moneyNumberShowOne(math.floor(tonumber(self.costNum[i])*num))
    end 
    self["num1"].text=toolFun.moneyNumberShowOne(math.floor(tonumber(self.dropNum)*num))
    self["num2"].text=toolFun.moneyNumberShowOne(math.floor(tonumber(self.extraNum)*num))
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



return m