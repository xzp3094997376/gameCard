local saodangItem = {}


--从父item获取该item的相关信息
function saodangItem:update(_table)
    if _table == nil then
        self.gameObject:SetActive(false)
        return
    end
    self.gameObject:SetActive(true)
    self.saodangInfo = _table
	self.delegate = _table.delegate
    self.saodangInfo.forDelegate = self
    self.saodangInfo.saodang = _table.saodang
    self.saodangInfo.key = _table.key

    local temp = {}
    if self.saodangInfo.key == 0 then 
        self.diban:SetActive(false)
        self.itemsdi:SetActive(false)
        self.diban2:SetActive(true)
        self.itemsdi2:SetActive(true)
        local totalMoeny = 0
        local totalExp = 0
        table.foreach(self.saodangInfo.saodang, function(k, v) 
            totalMoeny = totalMoeny + v.dropArr[0].money
            totalExp = totalExp + v.dropArr[0].exp
            local m = RewardMrg.getList(v)
                table.foreach(m, function(k, v) 
                    --if v:getType() ~= "money" and  v:getType() ~= "exp" then
                    table.insert(temp, v)
                    --end   
                end)        
            m = nil
        end)
        self.txt_num.text = TextMap.GetValue("Text_1_175")
        self.txt_money.text = totalMoeny
        self.txt_exp.text = totalExp
        totalMoeny = nil
        totalExp = nil
    else
        self.diban:SetActive(true)
        self.itemsdi:SetActive(true)
        self.diban2:SetActive(false)
        self.itemsdi2:SetActive(false)

        self.txt_num.text =string.gsub(TextMap.GetValue("LocalKey_777"),"{0}",self.saodangInfo.key)
        self.txt_money.text = self.saodangInfo.saodang.dropArr[0].money
        self.txt_exp.text = self.saodangInfo.saodang.dropArr[0].exp
        temp =  RewardMrg.getList(self.saodangInfo.saodang)   
    end



    --------------去掉金钱和经验   合并相同的物品
    local list = {}
    table.foreach(temp, function(k, v) 
        if v.id ~= "money" and v.id ~= "exp" then
            local txd = false
            table.foreach(list, function(kl, vl)
                if vl:getType()  == "char" then
                    if v.dictid == vl.dictid then
                        txd = true
                        if  vl.rwCount == nil or  vl.rwCount  < 1 then
                             vl.rwCount = 1
                        end
                        vl.rwCount = vl.rwCount + 1
                    end
                else
                    if v.id == vl.id and v:getType() == vl:getType() then
                        txd = true
                        if  vl.rwCount == nil or  vl.rwCount  < 1 then
                             vl.rwCount = 1
                        end
                        vl.rwCount = vl.rwCount + v.rwCount
                    end

                end
            end) 
            if txd == false then
                table.insert(list,v)
            end
        end
    end)  
    if #list == 0 then 
        self.sroll:SetActive(false)
        self.Label:SetActive(true)
    else
        self.Label:SetActive(false)
        self.sroll:SetActive(true)
        ClientTool.UpdateMyTable("Prefabs/moduleFabs/chapterModule/saodangItem", self.fujianTable, list)       
    end
    temp = nil
    list = nil
end



function saodangItem:onClick(go, btName)
	if btName == "btnclose" then 
		UIMrg:popWindow()
    end
end

function saodangItem:onPress(go,name,bPress)       
    if (self.delegate == nil or self.delegate.getScrollView == nil) then
        return
    end
    local sv = self.delegate:getScrollView()
    if sv ~= nil then
        sv:Press(bPress);
    end
end

function saodangItem:OnDrag(go,name,detal)
    if (self.delegate == nil or self.delegate.getScrollView == nil) then
        return
    end
    local sv = self.delegate:getScrollView()
    
    if sv ~= nil then
        sv:Drag();
    end
end

return saodangItem