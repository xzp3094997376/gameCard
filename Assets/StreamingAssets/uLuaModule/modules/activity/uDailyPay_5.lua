local m = {} 
local infobindinglist = {}
local REFRESH_TIMER = 0 

function m:Start()
	Api:checkRes(function(result)
    end)
end

function m:update( all_lua_data )
	local lua_data = all_lua_data.lua_data
	self.delegate = all_lua_data.delegate
	self.data = lua_data

    --[[local end_time = lua_data._source_data["end_time"]--1446800000000
    --倒计时
    local time = ClientTool.GetNowTime(end_time or 0)
    LuaTimer.Delete(REFRESH_TIMER)
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


	local today = self:Get24hTimeOs()
	local today_recharge = 0
	if Player.Activity[lua_data.id] == nil or Player.Activity[lua_data.id]["pay"] == nil or Player.Activity[lua_data.id]["pay"][today..""] == nil then
		today_recharge = 0
	else
	 	today_recharge = Player.Activity[lua_data.id]["pay"][today..""] or 0
	end

	print("...今日充值了..."..today_recharge)
	local menKan = lua_data.menKan
	local have_recharge = false
	local need_recharge = 0
	if tonumber(today_recharge) >= tonumber(menKan) then 
		have_recharge = true
	else
		need_recharge = tonumber(menKan) - tonumber(today_recharge)
	end
	self.actDes_txt.text =string.gsub(TextMap.GetValue("LocalKey_743"),"{0}",#lua_data.drop)
	local _Data = {}
	self.Grid.cellWidth = 480/(#lua_data.drop-1)
	for k,v in pairs(lua_data.drop) do
		local data = {}
		data.id = k
		data.tp = "dailyPay"
		data.reward = v
		data.act_id = lua_data.id
		if Player.Activity[data.act_id] == nil or Player.Activity[data.act_id]["drop"] == nil or Player.Activity[data.act_id]["drop"][k..""] == nil then
			data.point = 0
		else
			data.point = Player.Activity[data.act_id]["drop"][k..""] or 0
		end
		table.insert( _Data, data )
	end
	ClientTool.UpdateGrid("",self.Grid,_Data)


	local show_index = 1
	if have_recharge then
		for k,v in pairs(_Data) do
			if v.point == 1 or v.point == 2 then
				show_index = k
			end
		end
	else
		for k,v in pairs(_Data) do
			if v.point == 0 then
				show_index = k
				break
			end
		end
	end
	
	local slider_index = 1
	for k,v in pairs(_Data) do
		if v.point == 1 or v.point == 2 then
			slider_index = k
		end
	end

	self.slider.value = ((slider_index-1)*self.Grid.cellWidth)/450


	print("...............showindex是多少呢?"..show_index)
	--self.showGrid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", lua_data.drop[show_index])
	--self:ShowRewards(lua_data.drop[show_index])
	--self.lastGrid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", lua_data.finalReward)
	self.view1:refresh(lua_data.finalReward, self, true, 0)
	self.binding:CallAfterTime(0.1,function()
        self.view1:goToIndex(0)
    end)
    if lua_data._source_data.val_package~=nil and lua_data._source_data.val_package[''..show_index]~=nil then 
    	self.title.text=lua_data._source_data.val_package[''..show_index]
    else 
    	self.title.text=TextMap.GetValue("Text_1_767") .. menKan .. TextMap.GetValue("Text_1_766")
    end 
	self.view2:refresh(lua_data.drop[show_index], self, true, 0)
	self.binding:CallAfterTime(0.1,function()
        self.view2:goToIndex(0)
    end)
	
	local final_status = 0
	if Player.Activity[lua_data.id] == nil or Player.Activity[lua_data.id]["drop"] == nil or Player.Activity[lua_data.id]["drop"]["finalReward"] == nil then
		final_status = 0
	else
		final_status = Player.Activity[lua_data.id]["drop"]["finalReward"] or 0
	end
	self.last_bt.gameObject:SetActive(true)
	self.finish2:SetActive(false)
	if final_status==1 then 
		self.Label.text=TextMap.GetValue("Text_1_22") 
	elseif final_status==2 then 
		self.last_bt.gameObject:SetActive(false)
		self.finish2:SetActive(true)
		self.Label.text=TextMap.GetValue("Text_1_138") 
	else
		self.Label.text=TextMap.GetValue("Text_1_139") 
	end


	local btn_status = 0

	if Player.Activity[lua_data.id] == nil or Player.Activity[lua_data.id]["drop"] == nil or Player.Activity[lua_data.id]["drop"][show_index..""] == nil then
		btn_status = 0
	else
		btn_status = Player.Activity[lua_data.id]["drop"][show_index..""] or 0
	end
	self.btn_cg.gameObject:SetActive(true)
	self.finish1:SetActive(false)
	print(btn_status)
	if btn_status == 0 then
		self.txt_btn_name.text = TextMap.GetValue("Text_1_139") 
		self.btn_cg.isEnabled = true
	elseif btn_status == 1 then 
		self.txt_btn_name.text = TextMap.GetValue("Text_1_22")
		self.btn_cg.isEnabled = true
	elseif btn_status == 2 then
		self.btn_cg.gameObject:SetActive(false)
		self.finish1:SetActive(true)
		--self.btn_cg:GetComponentInChildren(UILabel).text = TextMap.GetValue("Text1671")
		--self.btn_cg.isEnabled = false
	end
	
	ClientTool.AddClick(self.btn_cg,function()
		if btn_status == 0 then
			UIMrg:pop()
			DialogMrg.chognzhi()
		elseif btn_status == 1 then
			Api:getActGift(lua_data.id.."",show_index.."" ,function(result)
            packTool:showMsg(result, nil, 1)
            self.delegate.delegate:refreshEveryPay()
        	end)
		end
	end)


	ClientTool.AddClick(self.last_bt,function()
		if final_status == 0 then
			MessageMrg.show(TextMap.GetValue("Text_1_768"))
			uSuperLink.openModule(218)
			return
		elseif final_status == 2 then
			MessageMrg.show(TextMap.GetValue("Text1681"))
			return
		elseif final_status==1 then 
			m:onReward()
		end

		--[[local temp = {}
        temp.title = TextMap.GetValue("Text1682")
        temp.onOk = function()
            m:onReward()
        end
        temp.type = "showInfo"
        temp.state = final_status == 1
        local drop =  lua_data.finalReward
        drop.number = nil
        temp.drop = drop

        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)]]
	end)
end

function m:onReward()
    Api:getActGift(self.data.id.."","finalReward" ,function(result)
        UIMrg:popWindow()
        packTool:showMsg(result, nil, 1)
    end)
end

function m:ShowRewards(item_list)
	for i=1,#item_list do
		_data = item_list[i]
		local _type = _data.type
	    local infobinding = nil
	    if i > #infobindinglist then
	        --infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.showGrid.gameObject)
	        infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/qiancengta/boxGetitem", self.showGrid.gameObject)
	        table.insert(infobindinglist,infobinding)
	    else
	        infobinding = infobindinglist[i]
	    end
	    if infobinding == nil then return end

	    infobinding:CallUpdate(_data)
	end


end



function m:Get24hTimeOs()
	local cur_timestamp = os.time()
	cur_timestamp = Network:serverToClientTime(cur_timestamp*1000,"logic")
	local temp_date = os.date("*t", cur_timestamp/1000)
	return os.time({year=temp_date.year, month=temp_date.month, day=temp_date.day, hour=0})*1000
end

return m