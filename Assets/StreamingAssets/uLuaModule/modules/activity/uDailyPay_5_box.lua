local m = {}


function m:update(lua_data)
	self.gameObject.transform.localScale = Vector3(0.7,0.7,0.7)
    self.id = lua_data.id
    self.tp = lua_data.tp
    self.reward = lua_data.reward
    self.act_id = lua_data.act_id
    self.point = lua_data.point
 	if self.tp == "dailyPay" then
        local state = self.point
        self.txt_jifen.text = lua_data.id
        self:updateState(state)
    end
end


function m:updateState(state)
    self.eff:SetActive(state == 1)
    self.box_un_open:SetActive(state ~= 2)
    self.box_opened:SetActive(state == 2)
    self.state = state
end

function m:onReward()
    local id = self.id
    if self.tp == "dailyPay" then
        Api:getActGift(self.act_id.."",self.id.."" ,function(result)
            --m:update(id, "dailyPay")
            UIMrg:popWindow()
            packTool:showMsg(result, nil, 1)
        end)
    end
end

function m:onClickItem()
    --if self.state == 2 then
    --    return
    --end
    local temp = {}
    if self.tp == "dailyPay" then
        temp.title = TextMap.GetValue("Text_1_23")
        temp.onOk = function()
            m:onReward()
        end
        temp.type = "showInfo"
        temp.state = self.state 
        local drop =  self.reward
        drop.number = nil
        temp.drop = drop
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
    end
end

function m:Start()
    ClientTool.AddClick(self.gameObject, function()
        m:onClickItem()
    end)
    local img = self.box_un_open:GetComponent(SimpleImage)
    if img then img.Url = UrlManager.GetImagesPath("task_img/boxClose.png") end

    local img = self.box_opened:GetComponent(SimpleImage)
    if img then img.Url = UrlManager.GetImagesPath("task_img/boxEmpty.png") end
end

return m