local m = {}
local coustValue

-- type 0 = 巡逻，  1 = 设置
function m:Start()
	self.type = 0
	self.timeType = 0
	self.kindType = 0
    for i = 1, 3 do
        local row = TableReader:TableRowByID("modelConfig", i)
        self["model_type" .. i]:CallUpdate(row)
    end
    for i = 1, 3 do
        local row = TableReader:TableRowByID("timeConfig", i)
        self["btn_check" .. i]:CallUpdate(row)
    end
    --self.Label1.bitmapFont = myFont
    -- self.Label.bitmapFont = myFont
	Events.AddListener("select_time", funcs.handler(self, m.select_time))
    Events.AddListener("select_type", funcs.handler(self, m.select_type))
end

function m:select_time(id)
    self.timeType = id
	m:setSelect(self.kindType, self.timeType)
end

function m:select_type(id, isLocked, msg)
	self.kindType = id
	m:setSelect(self.kindType, self.timeType)
end

function m:notifyDataChange()
	self.delegate:updateItem(self.timeType, self.kindType)
end 

function m:update(data)
    self.delegate = data.delegate
	self.type = data.type or 0
	if self.type == 0 then 
		self.timeType = self.delegate._curSelectTime
		self.kindType = self.delegate._curSelectType
	elseif self.type == 1 then 
		self.timeType = data.timeType
		self.kindType = data.kindType
	end 
    m:updateState()
end

function m:updateState()
    if self.type == 0 then 
	    local rowTime = TableReader:TableRowByID("timeConfig", self.timeType)
		local rowModel = TableReader:TableRowByID("modelConfig", self.kindType)
		self.btn_delete.gameObject:SetActive(false)
		self.btn_start_going.gameObject:SetActive(true)
		local res = uRes:new(rowModel.consume_type)
		local img = res:getHeadSpriteName()
		local atlasName = packTool:getIconByName(img)
		self.icon_cost:setImage(img, atlasName)
		local cost = rowTime["consume_model" .. self.kindType]
		self.txt_cost.text = cost
		coustValue = cost
	elseif self.type == 1 then 
		self.cost:SetActive(false)
		self.btn_delete.gameObject:SetActive(true)
		self.btn_start_going.gameObject:SetActive(false)
	end 

    self.binding:CallManyFrame(function()
        m:setSelect(self.kindType, self.timeType)
    end)
    --self.txt_type_name.text = rowModel.name
end

function m:OnDestroy()
    Events.RemoveListener('select_time')
    Events.RemoveListener('select_type')
end

function m:setSelect(index_1, index_2)
    for i= 1,3 do
        if i == index_1 then 
             self["model_type" .. i].target:setSelect(true)
        else
             self["model_type" .. i].target:setSelect(false)
        end
    end
    for j=1,3 do
        if j == index_2 then
            self["btn_check" .. j].target:setSelect(true)
        else
            self["btn_check" .. j].target:setSelect(false)
        end
    end
end

function m:findSprite(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    m:setAssets(tran.gameObject:GetComponent(UISprite))
end

function m:setAssets(sp)
    if sp then
        sp.atlas = myAtlas
    end
end

function m:findFont(name)
    local tran = self.gameObject.transform:Find(name)
    if tran == nil then return nil end
    local lab = tran.gameObject:GetComponent(UILabel)
    if lab then
        lab.bitmapFont = myFont
    end
end

function m:onClick(go, name)
    if name == "btn_close" then
		if self.type == 1 then 
			m:notifyDataChange()
		end 
        UIMrg:popWindow()
	elseif name == "btn_delete" then 
		m:notifyDataChange()
        UIMrg:popWindow()
    elseif name == "btn_start_going" then
        if self.delegate._curSelectType == 1 and Player.Resource.vp < coustValue then
            DialogMrg:BuyBpAOrSoul("vp", "")
            return 
        end 
        m:onStartGoing()
        UIMrg:popWindow()
    end
end

function m:onStartGoing()
    self.delegate:onStartGoing()
end

return m