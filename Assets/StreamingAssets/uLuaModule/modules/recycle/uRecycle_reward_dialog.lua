local m = {}

local _data = 
{
	title = "",
	content = "",
	btnContent = TextMap.GetValue("Text_1_25"),
	custom = {},
	delegate = nil,
	callback = nil
}

function m:create(binding)
    self.binding = binding
    return self
end

function m:Start(...)

    self:onUpdate()
end

--初始状态为空
function m:update(data)
    _data.delegate = data.delegate
	_data.callback = data.callback
	_data.title = data.title
	_data.content = data.content
    _data.content1=data.content1
	self.txtTitle.text = _data.title
	self.txtContent.text = _data.content
    self.tip2.text =data.content1
    if data.content1== "" then 
        self.btn.transform.localPosition = Vector3(0, 40, 0)
        self.cousume:SetActive(true)
        self.zs_num.text=data.consume
    else 
        self.btn.transform.localPosition = Vector3(0, 0, 0)
        self.cousume:SetActive(false)
    end 
	self.txtBtnContent.text = _data.btnContent
	self.teams = data.teams
	self.rewardList = data.rewardList
	
	self:showReward()
end

function m:onUpdate(...)
    --初始状态没有任何选择的对象
    
end

function m:onClick(go, name)
	if name == "btnCall" then 
		if _data.callback ~= nil then 
			_data.callback(_data.delegate) 
			m:destory()
		end
	elseif name == "btnClose" then 
		UIMrg:popWindow()
    elseif name == "btnreturn" then 
        UIMrg:popWindow()
	end
end

function m:showReward(...)
    local _list = self.rewardList
    self.rewardView:refresh(_list, self)
    _list = nil
end

function m:getRewardList(...)
    local _list = {}
    local num = 0
    local money = 0
    local soul = 0
    local hunyu = 0
    table.foreach(self.teams, function(k, v)
        num = 0
        if v.char:getType() == "char" then
            local star = v.char.star
            local obj = TableReader:TableRowByUnique("charPiece", "id", v.char.id)
            if obj ~= nil then
                -- print("obj.consume[0].consume_arg2"..obj.consume[0].consume_arg2)
                num = v.num * obj.consume[0].consume_arg2
            end
        elseif v.char:getType() == "charPiece" then
            num = v.num
        end
        local char_obj = TableReader:TableRowByID("charPiece", v.char.id)
        if char_obj ~= nil then
            money = money + char_obj["sell_money"] * num
            soul = soul + char_obj["sell_soul"] * num
            hunyu = hunyu + char_obj["sell_hunyu"] * num
        end
        char_obj = nil
    end)
    if money > 0 then
        local m = {}
		m.type = "money"
        m.arg = money
        m.arg2 = ""
        table.insert(_list, m)
        m = nil
    end
	if soul > 0 then
        local m = {}
		m.type = "soul"
        m.arg = soul
        m.arg2 = ""
        table.insert(_list, m)
        m = nil
    end
	if hunyu > 0 then
        local m = {}
		m.type = "hunyu"
        m.arg = hunyu
        m.arg2 = ""
        table.insert(_list, m)
        m = nil
    end
    self.rewardList = _list
    return _list
end

function m:destory()
	_data = nil
    UIMrg:popWindow()
end
return m