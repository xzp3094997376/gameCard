--
-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    Events.Brocast('select_char')
    m:isSelect(true)
    self.delegate:updateItem(self.char.realIndex)
    --[[if eventName == "button" then
        if self.char.tab == 1 then --跳转英雄培养界面
        UIMrg:push("new_hero", "Prefabs/moduleFabs/hero/newHero", { char = self.char, tp = 1 })
        elseif self.char.tab == 2 then --跳转抽卡界面
        -- uSuperLink.openModule(8)
        local piece = CharPiece:new(self.char.id)
        DialogMrg.showPieceDrop(piece)
        elseif self.char.tab == 3 then --碎片合成
        m:showSummon(self.char)
        elseif self.char.tab == 4 then --跳去进化
        local piece = CharPiece:new(self.char.id)
        -- local name = piece:getDisplayName()
        -- local tb = TableReader:TableRowByUnique("avter","name",name)
        -- local char = Char:new(tb.id)
        -- if char ~= nil then
        --     UIMrg:push("new_hero","Prefabs/moduleFabs/hero/newHero",{char = char,tp = 2})
        -- end
        DialogMrg.showPieceDrop(piece)
        end
    elseif eventName == "btn_hero" then
        self:showInfoPanel()
    end--]]
    -- self:check()
end

function m:isSelect(ret)
	self.binding:CallManyFrame(function()
		self.select:SetActive(ret)
	end
	)
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
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	self.txt_fight.gameObject:SetActive(true)
	
	--属性信息
	--self.txt_lv.text = TextMap.GetValue("Text_1_306") .. "[00ff00]" .. char.lv .. "[-]"
	self.txt_name.text = char:getDisplayName()
	--self.txt_xuemai.text = TextMap.GetValue("Text_1_796") .. "[00ff00]" .. Player.Chars[char.id].bloodline.level .. "[-]"
	self.txt_fight.text = "[00ff00]" .. char.power .. "[-]"
	if self:checkChar(tonumber(self.char.id)) == true then
		--self.pos:SetActive(true)
		--self.friend_sprite:SetActive(false)
		self.red_point:SetActive(self:check())
		self.in_teams:SetActive(true)
	else
		--self.pos:SetActive(false)
		self.in_teams:SetActive(false)
		self.red_point:SetActive(self:check())
		if self.delegate:checkFriend(self.char.id) == true then
			--self.friend_sprite:SetActive(true)
		else
			--self.friend_sprite:SetActive(false)
		end
	end
end

--判断角色是否上阵
function m:checkChar(charid)
    local teams = Player.Team[0].chars
    local list = {}
    for i = 0, 5 do
        if charid == tonumber(teams[i]) then
            return true
        end
    end
    return false
end

--召唤
function m:showSummon(piece)
    local name = piece.Table.name
    local money = piece.Table.consume[1].consume_arg
    local dese = string.gsub(TextMap.TXT_SUMMON_CHAR_NEED_COST_MONEY, "{1}", money .. "")

    desc = string.gsub(dese, "{0}", name)
    DialogMrg.ShowDialog(desc, function(result)
        Api:combineFunc(piece:getType(), piece.id, function(result)
            local list = RewardMrg.getList(result)
            local luaTable = {
                char = list[1],
                cb = function()
                    self.delegate:onUpdate()
                    UIMrg:pop()
                end
            }
            Tool.push("RewardChar", "Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
        end)
    end)
end


--检测角色是否可以培养
function m:check()
    if self.char == nil then return false end
    local char = self.char
    return char:checkRedPoint() or char:redPointForJinHua() or char:redPointForTransform() or char:redPointForSkill() or char:redPointForXueMai()
end

--显示英雄详细信息面板
function m:showInfoPanel()
    if self.char == nil then return end
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info", self.char)
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
	--print("data = " .. json.encode(lua))
    self.index = lua.realIndex
    self.char = lua
	--print("index = " .. tostring(lua.index))
    self.delegate = lua.delegate
    -- self.type = self.delegate:getTab()
    self:updateChar()
	
	self:onUpdate()
end

function m:onUpdate()
	m:isSelect(self.delegate.selectIndex == self.char.realIndex)
end

function m:Start()
	Events.AddListener("select_char", function()
		m:isSelect(false)
    end)
	Events.AddListener("updateChar", funcs.handler(self, m.updateChar))
end

function m:OnDestroy()
    Events.RemoveListener('select_char')
    Events.RemoveListener('updateChar')
end

return m

