local m = {}

--local challengeCount = 0
local challengeTimes = 0

function m:update(info)
	self.data = info.data
	self.isUseItem = info.isUseItem
	self.times = info.times
	self.isRunChallenge = true
	self.txt_complete.text = TextMap.GetValue("Text_1_162")
	self.Label_Item_Value.text =  Player.ItemBagIndex[6].count
	self.costValue = tonumber(info.useCost)
	self.twmpList = {}
	self.totalList = {}
	self.useItemNum = false
	self.challengeCount = info.times
	challengeTimes = 0
	m:apiChallengePlayer()
end

function m:apiChallengePlayer()
	self.useItemNum = false
	if self.costValue > Player.Resource.vp and self.isUseItem and Player.ItemBagIndex[6].count > 0 then --  and 
		 Api:useItem('item', 6 .. "", 1,
		 	function(result)
			 	self.useItemNum = true
			 	m:apiRequite()
				self.Label_Item_Value.text =  Player.ItemBagIndex[6].count
	        	end, 6)--现在先写死6为精力得代码，后面需要做健全
	else --  self.costValue <= Player.Resource.vp and self.isUseItem == false then
		m:apiRequite()
	end
end

function m:apiRequite()
	self.challengeCount = self.challengeCount - 1
	Api:fastChallenge(self.data.arr, self.data.pid, self.data.teamId, self.data.sid, self.data.rank,
	    function(result)
	    	local dropList = {}
	    	dropList.isWin = result.change_rank.win
	    	dropList.dropInfo = RewardMrg.getList(result)
	    	dropList.times = challengeTimes + 1
	    	dropList.isUse = self.useItemNum
        	dropList.delegate = self
        	m:colAllItemValue(dropList.dropInfo)
       	    local tmp = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/ArenaEasyFightItem", self.grid.gameObject)
       	    tmp:CallUpdate(dropList)
	    	challengeTimes = challengeTimes + 1
       	 	self.grid.repositionNow = true

       	 	if challengeTimes > 2 then  --若个数大于三，每次添加移动一次滚动条
	            local v = self.scrollview.gameObject.transform.localPosition
	           SpringPanel.Begin(self.scrollview.gameObject,Vector3(v.x, v.y+185, v.z),10)
	        end
       	 	if self.challengeCount <= 0 then
       	 		m:lastItemCreate()
       	 	else
       	 		self.binding:CallAfterTime(1, function()
					m:apiChallengePlayer()
				end)
       	 	end
       	end,
	function(ret)
     	m:lastItemCreate()
	end)
end

function m:lastItemCreate()
	local tempTotal = {}
	tempTotal.times = 0
	tempTotal.dropInfo = self.totalList
	tempTotal.delegate = self
	tempTotal.isUse = false
    local tmp = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/ArenaEasyFightItem", self.grid.gameObject)
	tmp:CallUpdate(tempTotal)
	challengeTimes = challengeTimes + 1
    self.grid.repositionNow = true
    self.binding:CallAfterTime(0.3, function()
    	if challengeTimes > 2 then  --若个数大于三，每次添加移动一次滚动条
           local v = self.scrollview.gameObject.transform.localPosition
           SpringPanel.Begin(self.scrollview.gameObject,Vector3(v.x, v.y+185, v.z),10)
        end
	end)
end

function m:colAllItemValue(dropList)
	if #self.totalList == 0 then
		self.totalList = dropList
		return 
	end

	for i = 1, #dropList do
		for j = 1, #self.totalList do
			if self.totalList[j].name == dropList[i].name then
				self.totalList[j].rwCount = self.totalList[j].rwCount + dropList[i].rwCount
			end
		end
	end
end

function m:onFinishChl()
	self.txt_complete.text = TextMap.GetValue("Text_1_163")
	self.isRunChallenge = false 
end

function m:onClick(go, name)
	if name == "Btn_close" then
		UIMrg:popWindow()
		DialogMrg.levelUp()
	elseif name == "Btn_complete" then
		if self.isRunChallenge == true then
			self.txt_complete.text = TextMap.GetValue("Text_1_163")
			self.challengeCount = 0
			self.isRunChallenge = false 
		elseif self.isRunChallenge == false then
			UIMrg:popWindow()
			DialogMrg.levelUp()
		end
	end
end

return m