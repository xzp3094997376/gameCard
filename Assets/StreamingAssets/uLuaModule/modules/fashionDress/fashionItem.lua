local m = {} 

--点击事件
function m:onClick(uiButton, eventName)
	if self.char.isHas==true then 
		Events.Brocast('change_fashion')
		self.delegate.selectIndex = self.index
		m:isSelect(true)
		self.delegate:updateItem(self.index,ret)
	else 
		local temp = {}
		temp.obj = self.char
		temp._type = "fashion"
	-- 	MessageMrg.showTips(temp)
		MessageMrg.showDaoJuTips(temp)
	end 
end

function m:isSelect(ret)
	self.select:SetActive(ret)
    if ret == true then
        self.delegate.selectIndex = self.char.realIndex
    end
end

function m:updateChar()
    local char = self.char
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height, true, nil, })
	self.name.text = char:getDisplayColorName()
	if char.isHas==false then 
		self.goto:SetActive(true)
		self.lvBg.gameObject:SetActive(false)
	else 
		self.goto:SetActive(false)
		if char:getType()== "fashion" then 
			self.lvBg.gameObject:SetActive(true)
			if char.star==1 then 
	            self.lvBg.spriteName="dengji_baise"
	        elseif char.star==2 then 
	            self.lvBg.spriteName="dengji_lvse"
	        elseif char.star==3 then 
	            self.lvBg.spriteName="dengji_lanse"
	        elseif char.star==4 then 
	            self.lvBg.spriteName="dengji_zise"
	        elseif char.star==5 then 
	            self.lvBg.spriteName="dengji_chengse"
	        elseif char.star==6 then 
	            self.lvBg.spriteName="dengji_hongse"
	        end 
			self.lv.text=char.lv
		else 
			self.lvBg.gameObject:SetActive(false)
			self.name.text=""
		end 
	end
	if char:getType()== "fashion" and Player.fashion.curEquipID>0 and Player.fashion.curEquipID==char.id then 
		self.zhuangbei:SetActive(true)
	else 
		self.zhuangbei:SetActive(false)
	end 
end


--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(data,index,delegate)
    self.index = index
    self.char = data
    self.delegate = delegate
    self:updateChar()
	
	self:onUpdate()
end

function m:onUpdate()
    self.select:SetActive(false)
	m:isSelect(self.delegate.selectIndex == self.char.realIndex)
end

function m:Start()
    Events.AddListener("change_fashion", function()
    	self.char:updateInfo()
    	m:updateChar()
    	m:isSelect(false)
        end)
end

function m:OnDestroy()
    self.select:SetActive(false)
    Events.RemoveListener('change_fashion')
end

return m