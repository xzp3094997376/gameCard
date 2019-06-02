local m = {} 
--右侧四个按钮的脚本
local taskList = {}

function m:update(data, index)
	self.data=data
	self.index = index
	self.text_title.text = self.data.title
	self.text_title2.text = self.data.title
	self.btn1.gameObject.transform.rotation = Quaternion.Euler(Vector3(0, 0, 90))
	self.click1.gameObject:SetActive(false)
	if self.index ~= nil and self.index == self.data.delegate.curr_tap_index then
		self.click1.gameObject:SetActive(true)
		self.data.delegate:updateRightTableData(self.data.taskList,self)
	end
	local red_state = false
	for i,v in ipairs(self.data.taskList) do
		local status = v.status.drop or 0 
		if red_state==false and status==1 then 
			red_state=true
		end 
	end
	self.Sprite_redPoint:SetActive(red_state)
end

function m:setRedPoint(bool)
	self.Sprite_redPoint:SetActive(bool)
end 

function m:onClick(go,name)
	if name == "btn1" then
		self.data.delegate.curr_tap_index=self.index
		self.click1.gameObject:SetActive(true)
		self.data.delegate:updateRightTableData(self.data.taskList,self)
		Events.Brocast("UpdateViewContent", self.index)
	end
end

function m:setBtnInit(index)
	if index ~= self.index  then
		self.click1.gameObject:SetActive(false)
	end
end

function m:Start()
	Events.AddListener("UpdateViewContent", function(params)
    	self:setBtnInit(params)
    end)
end

function m:OnDestroy()
    Events.RemoveListener("UpdateViewContent")
end

return m