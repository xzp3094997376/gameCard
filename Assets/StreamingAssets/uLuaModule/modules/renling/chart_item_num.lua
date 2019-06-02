local m = {} 
local time_id = 0

function m:update(item, index, myTable, delegate)
	self.index=index+1
	self.item=item
	self.delegate=item.delegate
	self.num.text=self.item.renlingzhi
	self.effect:SetActive(false)
	if self.item.relIndex%2==1 then
		self.notLockLine.transform.localEulerAngles = Vector3(0,0,27);
		self.lockLine.transform.localEulerAngles = Vector3(0,0,27);
		self.lockSp.transform.localPosition=Vector3(0,40,0);
		self.notLockSp.transform.localPosition=Vector3(0,40,0);
		self.num.transform.localPosition=Vector3(0,40,0);
		self.effect.transform.localPosition=Vector3(0,40,0);
	else 
		self.notLockLine.transform.localEulerAngles = Vector3(0,0,-27);
		self.lockLine.transform.localEulerAngles = Vector3(0,0,-27);
		self.lockSp.transform.localPosition=Vector3(0,110,0);
		self.notLockSp.transform.localPosition=Vector3(0,110,0);
		self.num.transform.localPosition=Vector3(0,110,0);
		self.effect.transform.localPosition=Vector3(0,110,0);
	end 
	m:onupdate()
end

function m:onupdate()
	if self.item.isShow==2 then 
		self.lockSp:SetActive(true)
		self.notLockSp:SetActive(false)
	else 
		self.lockSp:SetActive(false)
		self.notLockSp:SetActive(true)
	end 
	LuaTimer.Delete(time_id)
	if self.item.isShow==1 then 
		time_id = LuaTimer.Add(0, 1000, function(id)
	        if self.effect.transform.position.x>0.75 or self.effect.transform.position.x<-0.75 then
	        	self.effect:SetActive(false)
	        else 
	        	self.effect:SetActive(true)
	        end 
	        end) 
	end 
	if self.item.isShowLine==2 then 
		self.notLockLine:SetActive(false)
		self.lockLine:SetActive(true)
	elseif self.item.isShowLine==1 then 
		self.notLockLine:SetActive(true)
		self.lockLine:SetActive(false)
	else  
		self.notLockLine:SetActive(false)
		self.lockLine:SetActive(false)
	end 
	if self.delegate.targetIndex==self.item.relIndex then
		self.delegate:moveToTarget(self.binding.transform)
	end 
end

function m:OnDestroy()
    LuaTimer.Delete(time_id)
end

function m:Start()
	
end 

function m:create(binding)
    self.binding = binding
    return self
end

return m