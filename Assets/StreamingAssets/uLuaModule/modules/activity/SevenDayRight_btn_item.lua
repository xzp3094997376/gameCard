local m = {} 
--右侧四个按钮的脚本
local taskList = {}

function m:update(data, index)
	self.dayNum = data.dayNum
	self.delegate = data.delegate
	self.actType = data.delegate.actType
	self.index = data.index
	self.initIndex = index
	self.text_title.text = data.title
	self.text_title2.text = data.title
	taskList = data.taskList
	self.btn1.gameObject.transform.rotation = Quaternion.Euler(Vector3(0, 0, 90))
	self.click1.gameObject:SetActive(false)
	if self.initIndex ~= nil and self.initIndex == 0 then
		self.click1.gameObject:SetActive(true)
	end

	if self.actType == "day7" then
		m:setRedPointState(Player.Day7s)
    	self.PlayactTypeList = Player.Day7s
	else
		m:setRedPointState(Player.DayNs[self.actType])
    	self.PlayactTypeList = Player.DayNs[self.actType]
    end
end

function m:setRedPointState(PlayactTypeList)
	self.Sprite_redPoint.gameObject:SetActive(false)
	if self.dayNum ~= nil and PlayactTypeList~=nil then
		if self.dayNum <= PlayactTypeList.day then
			self.Sprite_redPoint.gameObject:SetActive(m:judgeRedPoint(PlayactTypeList))--红点判断，需要根据后台数据来显示
		end
	end
end

function m:judgeRedPoint(PlayactTypeList)
	local state = false
	for i = 1, #taskList do
		if taskList[i] ~= nil then
			if PlayactTypeList[taskList[i]].state == 2 then
				state = true
				return true
			end
		end
	end
	return state
end

function m:onClick(go,name)
	if name == "btn1" then
		self.click1.gameObject:SetActive(true)
		Events.Brocast("SevenDayBtnItemLis", self.index)
		if self.delegate ~= nil then
		    self.delegate.isScroll = true
			self.delegate:TypeChoiseCb(self.index)
		end
	end
end

function m:setBtnInit(index)
	if index ~= self.index  then
		self.click1.gameObject:SetActive(false)
	end
end

function m:Start()
	Events.AddListener("SevenDayBtnItemLis", function(params)
    	self:setBtnInit(params)
    end)
    Events.AddListener("UpdateRedPoint", function(params)
    	self:setRedPointState(self.PlayactTypeList)
    end)
end

function m:OnDestroy()
    Events.RemoveListener("SevenDayBtnItemLis")
    Events.RemoveListener("UpdateRedPoint")
end

return m