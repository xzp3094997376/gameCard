local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = data.delegate
    self.txt_item_name.text = self.data.item:getDisplayColorName()

    self.desc.text = data.row.decs
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img.gameObject)
    end
    if self.data.row.drop[0].type == "treasure" then
        local tb = Treasure:new(self.data.row.drop[0].arg)
        self.__itemAll:CallUpdate({ "treasure" , tb, self.img.width, self.img.height,true})--"char"
     else
         self.__itemAll:CallUpdate({ "char" , data.item, self.img.width, self.img.height,true})--"char"
    end
    local iconName = Tool.getResIcon(data.row.consume[0].consume_type)
    self.cost.Url=UrlManager.GetImagesPath("itemImage/" .. iconName.. ".png")
    self.costNum.text=data.row.consume[0].consume_arg
    m:onUpdate()
end

function m:onUpdate()
    local data = self.data
    local drawNum1 = 0 
    local drawNum2 = 0 
    local isBuy =false -- 是否已购买
    if data.tp==1 then 
    	drawNum1 = Player.yuling.xihaoDrawTimes -- 每日普通召唤次数
        drawNum2 = Player.yuling.yulingDrawTimes -- 每日高级召唤次数
        if Player.yuling.dayRewards[data.row.id]~=nil then 
            isBuy=true
        end 
    else 
    	drawNum1 = Player.Times.totalXihaoDraw -- 普通召唤总次数
        drawNum2 = Player.Times.totalYulingDraw -- 高级召唤总次数
        if Player.yuling.lifetimeRewards[data.row.id]~=nil then 
            isBuy=true
        end
    end 
    data.state=2
    if isBuy== true then 
        data.state=3
    end  
    if data.row.type=="times_draw_yl" then 
        if tonumber(data.row.need)<= drawNum2 and isBuy==false then 
            data.state=1
        end 
    else 
        if tonumber(data.row.need)<= drawNum1 and isBuy==false then 
            data.state=1
        end 
    end 
    if data.state==1 then 
    	self.btn_name.text = TextMap.GetValue("Text_1_8")
    	self.btn_reward.isEnabled=true 
    elseif data.state==2 then 
    	self.btn_name.text = TextMap.GetValue("Text_1_8")
    	self.btn_reward.isEnabled=false
    elseif data.state==3 then 
    	self.btn_name.text = TextMap.GetValue("Text1465")
    	self.btn_reward.isEnabled=false
    end 
end

function m:getGXReward()
    local id = self.data.row.id
    if self.data.tp==1 then 
        Api:receiveDayReward(id, function(result)
            self.btn_name.text = TextMap.GetValue("Text1465")
            self.btn_reward.isEnabled=false
            packTool:showMsg(result, nil, 0)
        end)
    else 
        Api:receiveLifetimeReward(id, function(result)
            self.btn_name.text = TextMap.GetValue("Text1465")
            self.btn_reward.isEnabled=false
            packTool:showMsg(result, nil, 0)
        end)
    end 
end

function m:onClick(go, name)
    if name == "btn_reward" then
        if self.data.state==1 then 
            local totalNum = Tool.getCountByType(self.data.row.consume[0].consume_type)
            local costNum =self.data.row.consume[0].consume_arg
            if totalNum >= costNum then 
                m:getGXReward()
            else 
                DialogMrg.ShowDialog(TextMap.GetValue("Text368"), function()
                    DialogMrg.chognzhi()
                    end)
            end 
        elseif self.data.state==2 then  
            if self.data.tp ==1 then 
                if self.data.row.type=="times_draw_yl" then 
                    MessageMrg.show(TextMap.GetValue("Text_1_3023"))
                else
                    MessageMrg.show(TextMap.GetValue("Text_1_3024"))
                end
            else
                if self.data.row.type=="times_draw_yl" then 
                    MessageMrg.show(TextMap.GetValue("Text_1_3025"))
                else
                    MessageMrg.show(TextMap.GetValue("Text_1_3026"))
                end
            end
        end 
    end
end

function m:Start()

end

return m