local m = {}

function m:create(binding)
    self.binding = binding
    return self
end

function m:Start(...)
	UIEventListener.Get(self.mask).onClick = self.onClick
    self:onUpdate()
end

function m:onClick()
	m:destory()
end

--初始状态为空
function m:update(data)
	self.data = data
	self:showReward()
end

function m:onUpdate(...)
    --初始状态没有任何选择的对象
    
end

function m:showReward()
    self.rewardView:refresh(self.data, self)
end


function m:destory()
	_data = nil
    UIMrg:popWindow()
end
return m