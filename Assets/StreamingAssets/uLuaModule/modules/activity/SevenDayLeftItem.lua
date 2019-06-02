local SevenDayLeftItem = {} 
--左边七日按钮的脚本
local sdData = {}

function SevenDayLeftItem:update(data, delegate)
	sdData = data.delegate.Data
	self.delegate = data.delegate
	self.actType = data.delegate.actType
	--print_t("状态："..self.actType)
	self.index = data.index
	self.initIndex = delegate
	--self.actType = data.actType
	self.Content_on.text = data.title
	self.Content_un.text = data.title
	self.Content_Lock.text = data.title
	--self.LockClick_1.gameObject:SetActive(false)
	self.Sprite_Tip.gameObject:SetActive(false)
	if self.index ~= nil and self.initIndex == 0 then
		self.OnClick_1.gameObject:SetActive(true)
		self.UnClick_1.gameObject:SetActive(false)
	else
		self.OnClick_1.gameObject:SetActive(false)
		self.UnClick_1.gameObject:SetActive(true)
	end

	if self.actType == "day7" then
		self.Sprite_redPoint.gameObject:SetActive(self:judgeRedPoint(Player.Day7s))--红点判断，需要根据后台数据来显示
		self.PlayactTypeList = Player.Day7s
	else
		self.Sprite_redPoint.gameObject:SetActive(self:judgeRedPoint(Player.DayNs[self.actType]))--红点判断，需要根据后台数据来显示
		self.PlayactTypeList = Player.DayNs[self.actType]
    end
	--根据后台给的时间状态判断是否变灰按钮，读表
	-- if Player.Day7s.day ~= nil and self.index ~= 0 then
	-- 	if self.index + 1 > Player.Day7s.day then
	-- 		self.Sprite_redPoint.gameObject:SetActive(false)
	-- 		--self.LockClick_1.gameObject:SetActive(true)
	-- 		self.OnClick_1.gameObject:SetActive(false)
	-- 		self.UnClick_1.gameObject:SetActive(false)
	-- 	end
	-- end
	local tipLocal = TableReader:TableRowByUnique("day7_setting", "id", "desc_day"..self.index)
	if tipLocal ~= nil and tipLocal.value1 == 1 and self.actType == "day7" then
		self.Sprite_Tip.gameObject:SetActive(true)
		self.Label_Tip.text = tipLocal.value2
	end
	-- if self.index == 7 and self.actType == "day7" then
	-- 	self.Sprite_Tip.gameObject:SetActive(true)
	-- end
	--判断红点
end

function SevenDayLeftItem:judgeRedPoint(PlayactTypeList)
	local state = false
	--这里直接读sevenday.lua中的数据表，都是根据这个来显示
	-- if self.delegate ~= nil then
	-- 	sdData = self.delegate.Data --Tool:LoadSevenDayData("day7")
	-- else
	-- 	sdData = Tool:LoadSevenDayData(self.actType)
	-- end
	--print("天数："..self.index)
	if sdData[self.index] ~= nil and PlayactTypeList~=nil then
		local dayInfo = {}
		dayInfo = sdData[self.index]
		for i = 1, #dayInfo do
			if dayInfo[i] ~= nil then
				for j = 1, #dayInfo[i] do
					if dayInfo[i][j] ~=nil then 
						local id = dayInfo[i][j].id
						--print("任务id:"..id.."，名称：.."..dayInfo[i][j].target_desc..".., 状态:"..Player.Day7s[id].state)
						if PlayactTypeList[id]~=nil and PlayactTypeList[id].state == 2 and PlayactTypeList.day >= self.index then--需要增加当前天数是否开启活动
							state = true
							return state
						end
					end 
				end
			end
		end
	end
	return state
end

function SevenDayLeftItem:onClick(go,name)
	if name == "UnClick_1" then
		Events.Brocast("SevenDayItemLis", self.index)
		self.OnClick_1.gameObject:SetActive(true)
		self.UnClick_1.gameObject:SetActive(false)
		if self.delegate ~= nil then
			self.delegate:DayChoiseCb(self.index)
		end
	elseif name == "LockClick_1" then
		MessageMrg.show(TextMap.GetValue("Text_1_89"))
	end
end

function SevenDayLeftItem:setBtnInit(index)
	--if index ~= self.index and self.index + 1 <= Player.Day7s.day then
	--	print("index::"..index.."self.index::"..self.index)
		self.OnClick_1.gameObject:SetActive(false)
		self.UnClick_1.gameObject:SetActive(true)
		--self.LockClick_1.gameObject:SetActive(false)
	--end
end

function SevenDayLeftItem:Start()
	Events.AddListener("SevenDayItemLis", function(params)
    	self:setBtnInit(params)
    end)
    Events.AddListener("UpdateRedPoint", function(params)
    	self.Sprite_redPoint.gameObject:SetActive(SevenDayLeftItem:judgeRedPoint(self.PlayactTypeList))
    end)
end

function SevenDayLeftItem:OnDestroy()
    Events.RemoveListener("SevenDayItemLis")
    Events.RemoveListener("UpdateRedPoint")
end

return SevenDayLeftItem