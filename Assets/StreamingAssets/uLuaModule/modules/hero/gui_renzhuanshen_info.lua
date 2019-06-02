-- 选择角色列表
local m = {}
local isInited = false
function m:update(lua)
    --self.delegate = lua.delegate
	self.sourceChar = lua.sourceChar
	self.targetChar = lua.targetChar
	self.targetInfo = lua.targetInfo
	
	if not isInited then 
		m:initHerosData()
	end 
	self.left_Container:CallUpdate({tp = self.tp, char = self.sourceChar})
	self.right_Container:CallUpdate({tp = self.tp, char = self.targetChar, targetInfo = self.targetInfo})
end

function m:onCallBack(char, tp)
    self.delegate:onCallBack(char, tp)
end

function m:Start()
	self.tp = 1
	m:updateBtnStatus()
end

function m:initHerosData()
	self.shanren = {}
	self.eren = {}
	self.yingren = {}
	TableReader:ForEachTable("char",
		function(index, item)
			if item ~= nil and item.star >= 5 then
				local char = Char:new(nil, item.id)
				if self.sourceChar ~= nil then 
					m:copyInfo(self.sourceChar, char)
				end 
				if item.party == 1 then 
					table.insert(self.shanren, char)
				elseif item.party == 2 then 
					table.insert(self.eren, char)
				elseif item.party == 3 then 
					table.insert(self.yingren, char)
				end 
			end
		return false
	end)
	isInited = true
end

function m:copyInfo(source, target)
	target.info = source.info
	target.source = source.info
end

function m:OnDestroy()
	self.shanren = nil
	self.eren = nil
	self.yingren = nil
end
 
function m:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                d.realIndex = i + j
                li[j + 1] = d
                len = len + 1
				d.type = self._type
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end

    return list
end

function m:refresh(ret)
    self.charList = self:getChars(self.team, ret)
    self.scrollView:refresh(self.charList, self, false, 0)
    self:setInfo()
end

function m:onClick(go, name)
    if name == "btnBack" then
		UIMrg:popWindow()
	elseif name == "btn_lv" or name == "btn_lv_g" then
		self.tp = 1
		m:updateBtnStatus()
    elseif name == "btn_jinhua" or name == "btn_jinhua_g" then
		self.tp = 2
		m:updateBtnStatus()
    elseif name == "btn_peiyang" or name == "btn_peiyang_g" then
		self.tp = 3
		m:updateBtnStatus()
	elseif name == "btn_xuemai" or name == "btn_xuemai_g" then
		self.tp = 4
		m:updateBtnStatus()
	elseif name == "btn_juexing" or name == "btn_juexing_g" then
		self.tp = 5
		m:updateBtnStatus()
	elseif name == "btn_huashen" or name == "btn_huashen_g" then
		self.tp = 6
		m:updateBtnStatus()
    end
end

function m:updateBtnStatus()
	if self.tp == 1 then 
        self.btn_lv.gameObject:SetActive(true)
        self.btn_lv_g.gameObject:SetActive(false)
        self.btn_jinhua.gameObject:SetActive(false)
        self.btn_jinhua_g.gameObject:SetActive(true)
        self.btn_peiyang.gameObject:SetActive(false)
        self.btn_peiyang_g.gameObject:SetActive(true)
		self.btn_xuemai.gameObject:SetActive(false)
        self.btn_xuemai_g.gameObject:SetActive(true)
		self.btn_juexing.gameObject:SetActive(false)
        self.btn_juexing_g.gameObject:SetActive(true)
		self.btn_huashen.gameObject:SetActive(false)
        self.btn_huashen_g.gameObject:SetActive(true)
	elseif self.tp == 2 then 
        self.btn_jinhua.gameObject:SetActive(true)
        self.btn_jinhua_g.gameObject:SetActive(false)
        self.btn_lv.gameObject:SetActive(false)
        self.btn_lv_g.gameObject:SetActive(true)
		self.btn_peiyang.gameObject:SetActive(false)
        self.btn_peiyang_g.gameObject:SetActive(true)
		self.btn_xuemai.gameObject:SetActive(false)
        self.btn_xuemai_g.gameObject:SetActive(true)
		self.btn_juexing.gameObject:SetActive(false)
        self.btn_juexing_g.gameObject:SetActive(true)
		self.btn_huashen.gameObject:SetActive(false)
        self.btn_huashen_g.gameObject:SetActive(true)
	elseif self.tp == 3 then 	
        self.btn_jinhua.gameObject:SetActive(false)
        self.btn_jinhua_g.gameObject:SetActive(true)
        self.btn_lv.gameObject:SetActive(false)
        self.btn_lv_g.gameObject:SetActive(true)
		self.btn_peiyang.gameObject:SetActive(true)
        self.btn_peiyang_g.gameObject:SetActive(false)
		self.btn_xuemai.gameObject:SetActive(false)
        self.btn_xuemai_g.gameObject:SetActive(true)
		self.btn_juexing.gameObject:SetActive(false)
        self.btn_juexing_g.gameObject:SetActive(true)
		self.btn_huashen.gameObject:SetActive(false)
        self.btn_huashen_g.gameObject:SetActive(true)
	elseif self.tp == 4 then 
	    self.btn_jinhua.gameObject:SetActive(false)
        self.btn_jinhua_g.gameObject:SetActive(true)
        self.btn_lv.gameObject:SetActive(false)
        self.btn_lv_g.gameObject:SetActive(true)
		self.btn_peiyang.gameObject:SetActive(false)
        self.btn_peiyang_g.gameObject:SetActive(true)
		self.btn_xuemai.gameObject:SetActive(true)
        self.btn_xuemai_g.gameObject:SetActive(false)
		self.btn_juexing.gameObject:SetActive(false)
        self.btn_juexing_g.gameObject:SetActive(true)
		self.btn_huashen.gameObject:SetActive(false)
        self.btn_huashen_g.gameObject:SetActive(true)
	elseif self.tp == 5 then 
		self.btn_jinhua.gameObject:SetActive(false)
        self.btn_jinhua_g.gameObject:SetActive(true)
        self.btn_lv.gameObject:SetActive(false)
        self.btn_lv_g.gameObject:SetActive(true)
		self.btn_peiyang.gameObject:SetActive(false)
        self.btn_peiyang_g.gameObject:SetActive(true)
		self.btn_xuemai.gameObject:SetActive(false)
        self.btn_xuemai_g.gameObject:SetActive(true)
		self.btn_juexing.gameObject:SetActive(true)
        self.btn_juexing_g.gameObject:SetActive(false)
		self.btn_huashen.gameObject:SetActive(false)
        self.btn_huashen_g.gameObject:SetActive(true)
	elseif self.tp == 6 then 
	    self.btn_jinhua.gameObject:SetActive(false)
        self.btn_jinhua_g.gameObject:SetActive(true)
        self.btn_lv.gameObject:SetActive(false)
        self.btn_lv_g.gameObject:SetActive(true)
		self.btn_peiyang.gameObject:SetActive(false)
        self.btn_peiyang_g.gameObject:SetActive(true)
		self.btn_xuemai.gameObject:SetActive(false)
        self.btn_xuemai_g.gameObject:SetActive(true)
		self.btn_juexing.gameObject:SetActive(false)
        self.btn_juexing_g.gameObject:SetActive(true)
		self.btn_huashen.gameObject:SetActive(true)
        self.btn_huashen_g.gameObject:SetActive(false)		
	end
	self.left_Container:CallUpdate({tp = self.tp, char = self.sourceChar})
	self.right_Container:CallUpdate({tp = self.tp, char = self.targetChar, targetInfo = self.targetInfo})	
end 

return m

