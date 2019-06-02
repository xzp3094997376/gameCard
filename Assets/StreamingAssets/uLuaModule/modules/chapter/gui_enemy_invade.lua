
-- 敌方入侵
local m = {}

function m:update(lua)
	self.delegate = lua.delegate
	m:onUpdate()
end

function m:onUpdate()
	local list = m:getEnemyList()
	self.scrollView:refresh(list, self)
end 

function m:Start()
	self.isDown = true
	self.min = self.anim.from
	self.max = Vector3(0, math.floor(self.binding.height / 1.5), 0)  --self.anim.to
end

function m:onEnter()
	m:onUpdate()
end

function m:gotoChapter(id)
	self.delegate:jumpToSelectedChapter(id)
end

function m:getEnemyList()
	local list = {}
	local cps = Player.ninjaIntrusion:getLuaTable()
	for k, v in pairs(cps) do
		if v.status > 0 then
			table.insert(list, {cid = k, status = v.status, section = v.section})
		end 
	end
	table.sort(list, function(a, b)
		return a.cid < b.cid
	end)
	return list
end

function m:onClick(go, name)
    if name == "btn_opt" then
		if self.isDown then 
			m:moveUp()
		else
			m:moveDown()
		end
		self.isDown = not self.isDown
    end
end

function m:moveUp()
	self.anim.from = self.min
	self.anim.to = self.max
	self.anim.enabled = true
	self.anim:ResetToBeginning()
	self.btn_opt.transform.localRotation = Quaternion.Euler(0, 0, 0)
	self.btn_opt.transform.localPosition = self.posdown.transform.localPosition
end

function m:moveDown()
	self.anim.from = self.max
	self.anim.to = self.min
	self.anim.enabled = true
	self.anim:ResetToBeginning()
	self.btn_opt.transform.localRotation = Quaternion.Euler(0, 0, 180)
	self.btn_opt.transform.localPosition = self.posup.transform.localPosition
end

return m

