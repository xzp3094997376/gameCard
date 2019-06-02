--比武竞猜奖励icon
local m = {}

function m:update(data,index,delegate)
    if data == nil then return end
    self.data = data
    self.drop = json.decode(self.data.drop:toString())
    self.drop = self:updateTable(self.drop)
    self.delegate = delegate
    self.binding:CallManyFrame(function()
        self.rewardTable:refresh("Prefabs/moduleFabs/mailModule/mail_item_in", self.drop)
    end, 2)

    local title = TextMap.GetValue("Text1702")
    if self.data.topNum == 2 then      --总决赛
        title = TextMap.GetValue("Text1689")..self.data.nth
    elseif self.data.topNum == 3 then  --三四名决赛
        title = TextMap.GetValue("Text1690")..self.data.nth
    elseif self.data.topNum == 4 then
        if self.data.group <= 1 then
            title = TextMap.GetValue("Text1691")..self.data.nth
        else
            title = TextMap.GetValue("Text1692")..self.data.nth
        end
    else
        if self.data.topNum/4 >= self.data.group then --上半区
            title = TextMap.GetValue("Text1693")..(self.data.topNum/2)..TextMap.GetValue("Text1694")..self.group[self.data.group]..TextMap.GetValue("Text1695")..self.data.nth
        else                                                  --下半区
            title = TextMap.GetValue("Text1696")..(self.data.topNum/2)..TextMap.GetValue("Text1694")..self.group[self.data.group-self.data.topNum/4]..TextMap.GetValue("Text1695")..self.data.nth
        end
    end
    if self.data.win == true then --赢了
        title = TextMap.GetValue("Text1700")..title..TextMap.GetValue("Text_1_181")
    else                                      --输了
        title = title..TextMap.GetValue("Text1701")
    end
    self.txt_title.text = title
end

function m:updateTable(drop, isGet)
    local m = {}
    table.foreach(drop, function(k, v)
        local l = {}
        l.v = v
        l.showName = true
        l.isGet = isGet
        l.isShowTips = false
        table.insert(m, l)
        l = nil
    end)
    return m 
end

function m:onClick(go, name)
    if name == "btn_get" then
        local that = self
        Api:getGuessReward("only",self.data.topNum,self.data.nth,function (result)
            if that.delegate ~= nil then
                print("delegate is not nil")
                that.delegate:showMsg(result)
                that.delegate:refreshTimes()
            end
        end)
    end
end

function m:Start()
    self.group = {"A","B","C","D","E","F","G","H"}
end

return m