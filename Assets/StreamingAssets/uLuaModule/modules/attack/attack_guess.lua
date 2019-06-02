-- 比武竞猜主界面
local m = {}

function m:Start(...)
    LuaMain:ShowTopMenu()
    self.answer_count = 1
    local row  = TableReader:TableRowByUnique("relateTimes", "vip_level", Player.Info.vip)
    self.max_count = row.quiz_times
    self.consume = TableReader:TableRowByID("Contest", "quiz_consume").arg2
    self.txt_cost.text = TextMap.GetValue("Text1688")..self.answer_count*self.consume
    self.quiz_count = Player.Resource.quiz_point --Player.ItemBagIndex[1007].count
    self.txt_guess_count.text = self.quiz_count
    self.group = {"A","B","C","D","E","F","G","H"}
    local that = self
    Api:getQuestion(function (result)
        local queArr = result.queArr
        local temp = json.decode(queArr:toString())
        that.length = #temp
        that.result = result.result
        that.period = result.period --txt_num
        that:initData(queArr)
    end)
end

function m:update(data)
end

--初始化数据
function m:initData(data)
    if data == nil then return end
    self.que_list = {}
    for i=0,self.length-1 do
        if i == 0 then  --现在题目
            self.my_que = data[0] 
            if self.my_que.index ~= nil then
                table.insert(self.que_list,data[i])
            end
        else              --历史题目
            table.insert(self.que_list,data[i])
        end
    end
    --刷新历史列表
    self.scrollview:refresh(self.que_list, self, true)
    --刷新现在题目
    if self.my_que ~= nil then
        local title = ""
        if self.my_que.topNum == 2 then      --总决赛
            title = TextMap.GetValue("Text1689")..self.my_que.nth
        elseif self.my_que.topNum == 3 then  --三四名决赛
            title = TextMap.GetValue("Text1690")..self.my_que.nth
        elseif self.my_que.topNum == 4 then
            if self.my_que.group <= 1 then
                title = TextMap.GetValue("Text1691")..self.my_que.nth
            else
                title = TextMap.GetValue("Text1692")..self.my_que.nth
            end
        else
            if self.my_que.topNum/4 >= self.my_que.group then --上半区
                title = TextMap.GetValue("Text1693")..(self.my_que.topNum/2)..TextMap.GetValue("Text1694")..self.group[self.my_que.group]..TextMap.GetValue("Text1695")..self.my_que.nth
            else                                                  --下半区
                title = TextMap.GetValue("Text1696")..(self.my_que.topNum/2)..TextMap.GetValue("Text1694")..self.group[self.my_que.group-self.my_que.topNum/4]..TextMap.GetValue("Text1695")..self.my_que.nth
            end
        end
        title = "[00ff00]"..title.."[-]\n"

        local id = self.my_que.question_id
        local row = TableReader:TableRowByID("quiz", id)
        if row ~= nil then 
            title = title..row.question_desc
        end
        self.txt_guess.text = title
        local option = {"A. ","B. ","C. ","D. "}
        for i=1,4 do
            if row["show_arg"..i] ~= nil and row["show_arg"..i] ~="" then
                self["btn_choose_"..i].gameObject:SetActive(true)
                self["txt_ti_"..i].text = option[i]..row["show_arg"..i]
            else
                self["btn_choose_"..i].gameObject:SetActive(false)
            end
        end
    end
    local result = self.result[self.my_que.topNum..self.my_que.nth]
    if result == nil then
        self:onChoose(1)
        self:setChoose(true)
    else
        self:onChoose(result.index)
        self.btn_guess.isEnabled = false
        self:setChoose(false)
    end 
    self.txt_num.text = self.period or 1
end

function m:onChoose(index)
    if index == nil then return end
    for i = 1,4 do
        if i == index then
            self["select_"..i]:SetActive(true)
            self.cur_select = index
        else
            self["select_"..i]:SetActive(false)
        end
    end
end

function m:setChoose(flag)
    if flag == nil then return end
    for i=1,4 do
        self["btn_choose_"..i].isEnabled = flag
        -- self.btn_guess.isEnabled = false
    end
end

function m:refreshTimes()
    -- print("refreshTimes==========")
    self.quiz_count = Player.Resource.quiz_point 
    self.txt_guess_count.text = self.quiz_count
end

function m:onClick(go, name)
    if name == "btn_choose_1" then
        self:onChoose(1)
    elseif name == "btn_choose_2" then
        self:onChoose(2)
    elseif name == "btn_choose_3" then
        self:onChoose(3)
    elseif name == "btn_choose_4" then
        self:onChoose(4)
    elseif name == "btn_add" then --增加下注
        if self.answer_count >= self.max_count or (self.answer_count+1)*self.consume>self.quiz_count then return end
        self.answer_count = self.answer_count + 1 
        self.txt_add.text = self.answer_count
        self.txt_cost.text = TextMap.GetValue("Text1688")..self.answer_count*self.consume
    elseif name == "btn_reduction" then --减少下注
        if self.answer_count <= 1  then return end
        self.answer_count = self.answer_count - 1
        self.txt_add.text = self.answer_count
        self.txt_cost.text = TextMap.GetValue("Text1688")..self.answer_count*self.consume
    elseif name == "btn_guess" then --竞猜
        local that = self
        Api:answerQuestion(self.my_que.topNum,self.my_que.nth,self.cur_select,self.answer_count,function (result)
           that.btn_guess.isEnabled = false
           that:setChoose(false)
           MessageMrg.show(TextMap.GetValue("Text_1_180"))
           that:refreshTimes()
        end)
    elseif name == "btn_reward" then
        UIMrg:pushWindow("Prefabs/moduleFabs/attack/attack_guess_reward",{delegate = self})
    elseif name == "btn_add_count" then
        DialogMrg:BuyBpAOrSoul("jcq", "", toolFun.handler(self, self.refreshTimes),toolFun.handler(self, self.refreshTimes))
    elseif name == "btn_max" then
        local count = math.floor(self.quiz_count/self.consume)
        if count >self.max_count then
            self.answer_count = self.max_count
        else
            if count ~= 0 then
                self.answer_count = count
            else
                self.answer_count = 1
            end
        end
        self.txt_add.text = self.answer_count
        self.txt_cost.text = TextMap.GetValue("Text1688")..self.answer_count*self.consume
    elseif name == "btn_min" then
         self.answer_count = 1
         self.txt_add.text = self.answer_count
         self.txt_cost.text = TextMap.GetValue("Text1688")..self.answer_count*self.consume
    elseif name == "btn_rule" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {16,title = TextMap.GetValue("Text1779")})
    end
end

return m