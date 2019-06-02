local m = {} 
local datas = {}
-- local list = {}

function m:update(lua)
	self.char = lua.char
    self.delegate = lua.delegate
    self:onUpdate(lua.char, true)
    self.isClick = false
    m:createDengLong()
	self.effect.gameObject:SetActive(false)
	self.DetailInfo.gameObject:SetActive(false)
	self.DetailInfoForDa.gameObject:SetActive(false)
end

function m:createDengLong()
	local infoList = {}
	for i = 1, 31 do
		local info = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, i)
		if info ~= nil and info ~= "" then
			local detail = {}
			detail.data = info
			detail.char = self.char
			detail.delegate = self
			table.insert(infoList, detail)
		end
	end
	local qlv = Player.Chars[self.char.id].qualitylvl
	if qlv > 9 then
		qlv = qlv - 5
	else
		qlv = 0
	end
	self.scrollView:refresh(infoList, self, true, qlv)
end

function m:onUpdate(char)
	--print_t(char)
	self.char = char
	self.delegate:updateRedPoint(self.char)
	datas.char = self.char
	self.hero_name.text = self.char:getDisplayName()
	self.img_hero:LoadByModelId(self.char.modelid, "idle", function() end, false, -1, 1)
	if self.char.star == 5 then
		self.Label_huashen_Jie.text = TextMap.GetValue("Text_1_825")
		self.Label_shengjiang.text = TextMap.GetValue("Text_1_826")
	elseif self.char.star == 6 then
		self.Label_huashen_Jie.text = ""
		self.Label_shengjiang.text = ""
	end

 	local info = {}
 	local preInfo

	local qlv = Player.Chars[self.char.id].qualitylvl
	self.curQlv = qlv
 	local targetlvInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv + 1)


 	if targetlvInfo == nil then
 	   targetlvInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv)
		self.btn_huashen.isEnabled = false
		self.Label_huashen_Jie.text = TextMap.GetValue("Text_1_827")
		self.Label_shengjiang.gameObject:SetActive(false)
	else
		self.btn_huashen.isEnabled = true
 	end

 	if qlv >= 1 then
 		preInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv)
 	end

 	info.data = targetlvInfo
 	info.preData = preInfo
 	info.char = self.char
 	datas.data = targetlvInfo
 	datas.preData = preInfo

	if targetlvInfo ~= nil then
		self.content:CallUpdate(info)
		m:calculationAddPro(info)
	end
end

function m:calculationAddPro(info)
	local preInfo = info.preData
	local nextInfo = info.data
	local title = ""
	local content = ""
	self.addList = {}

	if nextInfo.level > 5 then
		text = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, (math.ceil(nextInfo.level / 5) - 1) * 5).desc
	else
		text = TextMap.GetValue("Text_1_828")
	end

	level = nextInfo.desc

	title = text..level

	if nextInfo.quality == 5 then
		title = "[ff9600]"..title.."[-]"
	elseif nextInfo.quality == 6 then
		title = "[ff0000]"..title.."[-]"
	end

	for j = 0, 7 do
		if nextInfo.magic[j] ~= nil then
			content = content.."\n".."[F0E77B]"..string.gsub(nextInfo.magic[j]._magic_effect.format, "{0}", "[-][05fc17]+"..nextInfo.magic[j].magic_arg1).."[-]"
		end
	end
	self.addList[1] = title..content
end


function m:showJinJieInfo()
	local qlv = Player.Chars[self.char.id].qualitylvl 
	local targetlvInfo = TableReader:TableRowByUniqueKey("qualitylevel", self.char.dictid, qlv)
	self.Label_levelD1.text = targetlvInfo.desc
end

function m:onCharQualityUp()
	if self.isClick == true then return end
	self.isClick = true
	 Api:charQualityUp(self.char.id, function(result)
		self.btn_huashen.isEnabled = false
	 	m:showEffect()
	 	end)
	self.binding:CallAfterTime(1.5, function()
			self.isClick = false
			self.btn_huashen.isEnabled = true
	    end)
end

--显示升星效果
function m:showEffect()
	local lv = Player.Chars[self.char.id].qualitylvl
	if lv > self.curQlv then
		if lv >= 5 and lv % 5 ==0 then
			UIMrg:pushWindow("Prefabs/moduleFabs/guidao/HuaShenSuccessTip", self.char)
		else
			OperateAlert.getInstance:showToGameObject(self.addList, self.node)
		end
		self.effect.gameObject:SetActive(false)
		self.effect.gameObject:SetActive(true)
		m:onUpdate(self.char)
		m:createDengLong()
	end
end

function m:showDLDetail(target)
	--print_t(target)
end

function m:onClick(go, name)
	if name == "btn_huashen" then
		m:onCharQualityUp()
	end
end

return m