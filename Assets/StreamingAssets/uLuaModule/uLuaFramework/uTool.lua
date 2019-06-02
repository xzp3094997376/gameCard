local Tool = {}
Tool.CharPieceList = nil
Tool.mainTasks = nil
Tool.lastTaskPos = nil
Tool.ghostExp = nil
Tool.GhostPieceList = nil
Tool.targetTasks = nil
-- 索引读表ID
Tool.dictIds = nil 

local resourceTab = nil
local vipGiftTab = {}

local SevenDayData = nil
local SevenDayLimitTime = nil
local sevenDayActType = nil

--
local sevenDayData = nil
local fourteenDayData = nil
local spSevenDayFirData = nil
local spSevenDaySecData = nil
local spSevenDayYuanData = nil
local isRefreSevenDayData = true
--

local GodSkillMenuList = nil

--一些公共变量
qianchengta_currentSelect = 1
function Tool.CallFunctionByLuaTable(luaTable)
    return ClientTool.CallFunctionByLuaTable(luaTable)
end

function preZero(num)
    if string.len(num) == 1 then
        return "0" .. num
    end
    return num;
end

-- 时间格式化 00:00:00 样式
function Tool.FormatTime(times)
    local hour = math.floor(times / 3600) or 0
    local minute = math.floor((times % 3600) / 60) or 0
    local second = math.floor((times % 3600) % 60) or 0
    second = preZero(second .. "")
    minute = preZero(minute .. "")
    hour = preZero(hour .. "")
    return hour .. ":" .. minute .. ":" .. second
end

-- 时间格式化 XX天XX小时XX分 样式（没有秒）
function Tool.FormatTime4(times)
   return Tool.FormatTime3(times)
end

--时间格式化 00:00  样式(没有小时)
function Tool.FormatTime2(times)
    local minute = math.floor((times % 3600) / 60) or 0
    local second = math.floor((times % 3600) % 60) or 0
    minute = preZero(minute .. "")
    second = preZero(second .. "")
    return minute .. ":" .. second
end

--时间格式化3，返回的是xx小时，xx分钟，1分钟以内，传入值是秒
function Tool.FormatTime3(times)
    if times <= 0 then return TextMap.GetValue("Text1658") end
    local hour = math.floor(times / 3600) or 0
    local minute = math.floor((times % 3600) / 60) or 0
    local day = math.floor(hour / 24)
    if day>0 and hour>0 and minute >0 then 
        local msg = string.gsub(TextMap.GetValue("LocalKey_762"),"{0}",day)
        msg=string.gsub(msg,"{1}",hour)
        return string.gsub(msg,"{2}",minute)
    elseif day<=0 and hour>0 and minute >0 then 
        local msg = string.gsub(TextMap.GetValue("LocalKey_763"),"{0}",hour)
        return string.gsub(msg,"{1}",minute)
    elseif day>0 and hour<=0 and minute >0 then 
        local msg = string.gsub(TextMap.GetValue("LocalKey_764"),"{0}",day)
        return string.gsub(msg,"{1}",minute)
    elseif day>0 and hour>0 and minute <=0 then 
        local msg = string.gsub(TextMap.GetValue("LocalKey_765"),"{0}",day)
        return string.gsub(msg,"{1}",hour)
    elseif day<=0 and hour>0 and minute<=0 then 
        return string.gsub(TextMap.GetValue("LocalKey_766"),"{0}",hour)
    elseif day<=0 and hour<=0 and minute>0 then 
        return string.gsub(TextMap.GetValue("LocalKey_767"),"{0}",minute)
    elseif day>0 and hour<=0 and minute<=0 then 
        return string.gsub(TextMap.GetValue("LocalKey_768"),"{0}",day)
    else 
        return TextMap.GetValue("Text1476")
    end 
end

function Tool.getRefreshTime()
    local now = os.date("*t")
    local time =tonumber(now.hour)*60*60+tonumber(now.min)*60+tonumber(now.sec)
    local times=24*60*60-time+120
    return times
end 

-- 在顶部加入窗口，要手动销毁
function Tool.LoadToTop(path)
    return ClientTool.load(path, GlobalVar.Center)
end

Tool.green = "[00ff00]"
Tool.white = "[ffffff]"
Tool.bule = "[00b4ff]"
Tool.black = "[000000]"
Tool.gray = "[808080]"
Tool.purple = "[ff00ff]"
Tool.orange = "[ff9600]"
Tool.red = "[ff0000]"
Tool.golden = "[fff000]"

Frame = {
    [1] = {
        icon = "kuang_baise",
        icon_bg = "tubiao_1",
        num_icon = "juebiao_white",
        color = "[ffffff]"
    },
    [2] = {
        icon = "kuang_lvse",
        icon_bg = "tubiao_2",
        num_icon = "juebiao_green",
        color = "[00ff00]"
    },
    [3] = {
        icon = "kuang_lanse",
        icon_bg = "tubiao_3",
        num_icon = "juebiao_bule",
        color = "[00b4ff]"
    },
    [4] = {
        icon = "kuang_zise",
        icon_bg = "tubiao_4",
        num_icon = "juebiao_purple",
        color = "[ff00ff]"
    },
    [5] = {
        icon = "kuang_chengse",
        icon_bg = "tubiao_5",
        num_icon = "juebiao_orange",
        color = "[ff9600]"
    },
    [6] = {
        icon = "kuang_hongse",
        icon_bg = "tubiao_6",
        num_icon = "juebiao_red",
        color = "[ff0000]"
    },
	[7] = {
        icon = "kuang_jinse",
        icon_bg = "tubiao_7",
        num_icon = "juebiao_red",
        color = "[fff000]"
    },
}

local ItemFrame = {
    white = {
        icon = "kuang_baise",
        icon_bg = "tubiao_1",
        num_icon = "juebiao_white",
        color = "[ffffff]",
        stage = 1
    },
    green = {
        icon = "kuang_lvse",
        icon_bg = "tubiao_2",
        num_icon = "juebiao_green",
        color = "[00ff00]",
        stage = 1
    },
    blue = {
        icon = "kuang_lanse",
        icon_bg = "tubiao_3",
        num_icon = "juebiao_blue",
        color = "[00b4ff]",
        stage = 1
    },
    purple = {
        icon = "kuang_zise",
        icon_bg = "tubiao_4",
        num_icon = "juebiao_purple",
        color = "[ff00ff]",
        stage = 1
    },
    orange = {
        icon = "kuang_chengse",
        icon_bg = "tubiao_5",
        num_icon = "juebiao_purple",
        color = "[ff9600]",
        stage = 1
    },
    red = {
        icon = "kuang_hongse",
        icon_bg = "tubiao_6",
        num_icon = "juebiao_purple",
        color = "[ff0000]",
        stage = 1
    },
	golden = {
        icon = "kuang_jinse",
        icon_bg = "tubiao_7",
        num_icon = "juebiao_red",
        color = "[fff000]"
    },
}

--根据vip设置不同的头像框
function Tool.getVIPHeadK(vip)
    --通过读表显示对应的vip头像框
    local obj = TableReader:TableRowByUnique("vipHeadFrame", "lv", vip)
    if obj ~= nil then
        return obj.img_id
    else
        return nil
    end
end


--根据vip设置不同的昵称颜色
function Tool.getNameCol(vip, name)
    --通过读表得到vip对于的名字颜色
    local obj = TableReader:TableRowByUnique("vipHeadFrame", "lv", vip)
    if obj ~= nil then
        return "[" .. obj.name_color .. "]" .. name .. "[-]"
    else
        return name
    end
end

-- 文本颜色
function Tool.getTxtColor(stage)
    if stage == nil or stage <= 1 then
        return "ffffff"
    elseif stage == 2 then
        return "00ff00"
    elseif stage == 3 then
        return "00b4ff"
    elseif stage == 4 then
        return "ff00ff"
    elseif stage == 5 then
        return "ff9600"
    elseif stage == 6 then
        return "ff0000"
    end
end

-- 角色颜色
function Tool.getCharColor(stage)
    return Frame[stage]
end

function Tool.checkHuyou(petId)
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petId == petid then 
			return true
		end 
	end 
	return false
end 

function Tool.getFrame(star)
	if star == nil or star <= 1 then
        return Frame[1].icon
	end
	return Frame[star].icon
end

function Tool.getBg(star)
	if star == nil or star <= 1 then
        return Frame[1].icon_bg
	end
	return Frame[star].icon_bg
end
	
-- 道具颜色
function Tool.getItemColor(stage)
    if stage == nil or stage <= 1 then
        return ItemFrame.white
    elseif stage == 2 then
        return ItemFrame.green
    elseif stage == 3 then
        return ItemFrame.blue
    elseif stage == 4 then
        return ItemFrame.purple
    elseif stage == 5 then
        return ItemFrame.orange
    elseif stage == 6 then
        return ItemFrame.red
	elseif stage == 7 then
        return ItemFrame.golden
    end
end

local CharArgs = {}
local PetArgs = {}

function Tool.getPetDictId(petId)
	if petId == nil then return nil end 
	if type(petId) ~= "number" then petId = tonumber(petId) end 
	if Tool.petDictIds == nil then Tool.petDictIds = {} end 
	if petId > 0 then 
		if Tool.petDictIds[petId] == nil then 
			local pets = Player.Pets:getLuaTable()
			for k, v in pairs(pets) do
				if tonumber(k) == petId then 
					Tool.petDictIds[petId] = v.dictid
					break
				end 
			end
		end
	else
		print("Tool help: petId is nil ! " .. tostring(petId))
	end 
	return Tool.petDictIds[petId] or charId
end 

function Tool.readSuperLinkById(id)
	if id == nil or id == "" then return nil end 
	if Tool.superLink_index == nil then 
		Tool.superLink_index = {}
		TableReader:ForEachLuaTable("superLink_index", function(index, item)
			table.insert(Tool.superLink_index, item)
		end)
	end
	for i = 1, #Tool.superLink_index do 
		local data = Tool.superLink_index[i]
		if id <= data.id then 
			return TableReader:TableRowByID(data.table_name, id)
		end 
	end 
	
	return nil
end 

-- 考虑到有时候切换了卡片id后， 不及时更新， 先不缓存看看
function Tool.getDictId(charId)
	if charId == nil then return nil end 
	if type(charId) ~= "number" then charId = tonumber(charId) end 
	--if Tool.dictIds == nil then Tool.dictIds = {} end 
	if charId > 0 then 
		--if Tool.dictIds[charId] == nil then 
			local chars = Player.Chars:getLuaTable()
			for k, v in pairs(chars) do
				if tonumber(k) == charId then 
					--Tool.dictIds[charId] = v.dictid
                    return v.dictid
					--break
				end 
			end
		--end
	else
		--Debug.error("Tool help: charId is nil!")
		return charId
	end 
    return charId
	--return Tool.dictIds[charId] or charId
end 

-- 快速读取角色参数表
function Tool.GetCharArgs(key)
    local val = CharArgs[key]
    if val then return val end
    local tb = TableReader:TableRowByID("charArgs", key)
    if tb then
        val = tb.value
        CharArgs[key] = val
    else
        val = nil
    end
    return val
end

-- 快速读取宠物参数表
function Tool.GetPetArgs(key)
    local val = PetArgs[key]
    if val then return val end
    local tb = TableReader:TableRowByID("petArgs", key)
    if tb then
        val = tb.value
        PetArgs[key] = val
    else
        val = nil
    end
    return val
end

function split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

-- 每周开启时间判断
function Tool.IsOpen(type, arg)
    if type == "everyweek" then
        local args = split(arg, "|");
    end
end

function Tool.typeId(_type)
    local ret = false
    if resourceTab == nil then
        resourceTab = {}
        TableReader:ForEachLuaTable("resourceDefine", function(k, v)
           resourceTab[v.name] = v.name
        end)
    end
    if resourceTab[_type] == _type then
        return true
    end
    return ret  
end

function Tool.notResType(_type)
    local ret = false
    local typeAll = {"renling","yuling", "yulingPiece","equip", "equipPiece","treasure","treasurePiece","item", "char", "charPiece", "reel", "reelPiece","ghost", "ghostPiece","pet","petPiece","fashion",}
    for i, j in pairs(typeAll) do
        if _type == j then
            ret = true
        end
    end
    return ret
end

function Tool.vipGift(_vip)
    if #vipGiftTab == 0 then
        TableReader:ForEachLuaTable("vipLibaoConfig", function(index, item)
            if item.id ~= nil then
                vipGiftTab[item.vip_lv] = item
            end
            return false
        end)
    end
    return vipGiftTab[_vip]  
end


--获得取货币的数据。
function Tool.getCountByType(_type, arg)
    local res = Player.Resource
    if Tool.typeId(_type) ==true then 
        return res[_type] or 0
    elseif _type == "ghostPiece" then
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end

        local pieces = Player.GhostPieceBagIndex[id]
        return pieces.count
    elseif _type == "charPiece" then
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end

        local pieces = Player.CharPieceBagIndex[id]
        return pieces.count
    elseif _type == "equip" then
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end

        local pieces = Player.EquipmentBagIndex[id]
        return pieces.count
	elseif _type == "petPiece" then
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end

        local pieces = Player.petPieceBagIndex[id]
        return pieces.count
    elseif _type == "yulingPiece" then
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end

        local pieces = Player.yulingPieceBagIndex[id]
        return pieces.count
    elseif _type == "yuling" then 
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end 
        if Player.yuling[id].quality >0 then 
            return 1 
        else 
            return 0
        end 
    elseif _type == "item" then
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end
        if id ~= nil then
            return Player.ItemBagIndex[id].count
        end
	elseif _type == "char" then 
		local count = 0
		local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        end
		if id == nil or id < 0 then return count end 
		local chars = Player.Chars:getLuaTable() --获取所有英雄列表
		local charsList = {}
		local index = 1
		for k, v in pairs(chars) do
			local char = Char:new(k, v)
			if char.dictid == id then 
				local function onFilter(char)
					if char.star_level > 0 then return false end 
					if char.stage > 0 then return false end 
					if char.info.xilian_times > 0 then return false end
					if char.info.exp > 0 then return false end 
					for i = 1, 6 do
						local it = Player.Agency[i]
						if it.charId ~= nil and it.charId ~= 0  then
							if tonumber(it.charId) == tonumber(char.id) then return false end--it.charId
						end
					end
					return true
				end 
				
				if onFilter(char) then 
					count = count + 1
				end 
			end 
		end 
        return count
    elseif _type=="renling" then 
        local id
        if type(arg) == "number" then
            id = arg
        elseif tonumber(arg) ~= nil then
            id = tonumber(arg)
        else
            local row = TableReader:TableRowByUnique(_type, "name", arg)
            if row then id = row.id end
        end

        local renling = Player.renlingBagIndex[id]
        return renling.count
	else 
		print("不知道是什么: " .. _type)
    end
    return 0
end

function Tool.getPetStarList(star)
	local starLists = {}
	local showStar = false
    for i = 1, 5 do
		showStar = false
		if i <= star then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	return starLists
end 

function Tool.getFormatTime(time, format)

	if Localization.language == "EN" then
		--转换美国时间
		time = time - 3600 * 12
	end
	
    local tab = ""
    format = format or "%Y/%m/%d %X"
    if time then
        tab = os.date(format, time)
    else
        tab = os.date(format)
    end
    return tab
end

function Tool.getFormatDate(time)
    local tab = ""
    if time then
        tab = os.date('%Y/%m/%d', time)
    else
        tab = os.date('%Y/%m/%d')
    end
    return tab
end

function Tool.getDate(time)
    local tab
    if time then
        tab = os.date("*t", time)
    else
        tab = os.date("*t")
    end
    return tab
end

function Tool.getResIcon(_type)
    local obj = TableReader:TableRowByUnique("resourceDefine", "name", _type)
    if obj ~= nil then
        return obj["img"]
    else
        print("资源总表未查询成功。")
    end
end

function Tool.getResName(_type)
    local obj = TableReader:TableRowByUnique("resourceDefine", "name", _type)
    if obj ~= nil then
        return obj["cnName"]
    else
        print("资源总表未查询成功。")
    end
end

function Tool.checkCharPoint(char_id)
    local char = Char:new(char_id)
    return char:checkRedPoint()
end

local RedPointForHeroState = nil
local RedPointTaskState = nil
local _hasChar = nil
function Tool.resetRedPoint()
    RedPointForHeroState = nil
    RedPointTaskState = nil
    Tool.resetUnUseGhost()
    _hasChar = nil
end

local function getTeam()
    local list = {}
    local teams = Player.Team[0].chars
    for i = 0, 5 do
        local id = tonumber(teams[i])
        if id ~= nil and id > 0 then
            table.insert(list, id)
        end
    end
    return list
end

local function getYulingTeam()
    local list = {}
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do 
        local slot = ghostSlot[i]
        local yulingid = slot.yulingid
        if yulingid and yulingid ~= 0 then 
            table.insert(list, yulingid)
        end 
    end 
    return list
end

local function getPetTeam()
    local list = {}
    local id = Player.Team[0].pet
    if id ~= nil and tonumber(id) ~= 0 then
        table.insert(list, id)
    end
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petid and petid ~= 0 then 
			table.insert(list, petid)
		end 
	end 
    return list
end

local function isUsed(list, key)
    return list[key .. ""] == true
end

local function parseRedPointForEquip()
    RedPointForEquipState = {}
    local equips = Tool.getHasUseGhost()
	local ghost = Player.Ghost:getLuaTable() or {}
    local ret = false
	table.foreach(ghost, function(i, v)
        local gh = Ghost:new(v.id, i)
        if isUsed(equips, i) then
			ret = gh:redPointQianHua() 
			if ret == true and RedPointForEquipState.qianhua == nil then RedPointForEquipState.qianhua = ret end
			ret = gh:redPointJingLian()
			if ret == true and RedPointForEquipState.jinglian == nil then RedPointForEquipState.jinglian = ret end
            if RedPointForEquipState.qianhua ~= nil and RedPointForEquipState.qianhua ==true and  RedPointForEquipState.jinglian ~= nil and RedPointForEquipState.jinlian ==true then 
                return 
            end 
		end
    end)
end

local function parseRedPointForPet()
    RedPointForPetState = {}
    local pets = getPetTeam()
    local ret = false
    _hasPet = {}
    for i = 1, #pets do
        local k = pets[i]
        local pet = Pet:new(k)
		if ret == true and RedPointForPetState.lvup == nil then RedPointForPetState.lvup = ret end
		ret = pet:redPointForStrong()
        if ret == true and RedPointForPetState.jinhua == nil then RedPointForPetState.jinhua = ret end
        ret = pet:redPointForJinHua()
        
		if ret == true and RedPointForPetState.shenlian == nil then RedPointForPetState.shenlian = ret end
        ret = pet:redPointForShenlian()
        _hasPet[k .. ""] = true
    end
    pets = Player.Pets:getLuaTable()
    table.foreach(pets, function(i, v)
        _hasPet[i .. ""] = true
    end)
end

local function parseRedPointForYuling()
    RedPointForYulingState = {}
    local yulings = getYulingTeam()
    local ret = false
    _hasyuling = {}
    for i = 1, #yulings do
        local k = yulings[i]
        local yuling = Yuling:new(k)
        if RedPointForYulingState.lvup == nil or RedPointForYulingState.lvup==false then 
            ret = yuling:redPointForStrong()
            print(ret)
            if ret==true then RedPointForYulingState.lvup=ret end 
        end 
        if RedPointForYulingState.jinhua == nil or RedPointForYulingState.jinhua==false then 
            ret = yuling:redPointForJinHua()
            print(ret)
            if ret==true then RedPointForYulingState.jinhua=ret end 
        end
        _hasyuling[k .. ""] = true
    end
    yulings = Player.yuling:getLuaTable()
    table.foreach(yulings, function(i, v)
        _hasyuling[i .. ""] = true
    end)
end


local function parseRedPointForHero()
    RedPointForHeroState = {}
    local chars = getTeam()
    local ret = false
    _hasChar = {}
    for i = 1, #chars do
        local k = chars[i]
        local char = Char:new(k)
        ret = char:checkRedPoint()
        if ret == true and RedPointForHeroState.char == nil then RedPointForHeroState.char = ret end
        ret = char:redPointForCultivate()
        if ret == true and RedPointForHeroState.cultivate == nil then RedPointForHeroState.cultivate = ret end

        ret = char:redPointForJinHua()
        if ret == true and RedPointForHeroState.jinhua == nil then RedPointForHeroState.jinhua = ret end

        ret = char:redPointForXueMai()
        if ret == true and RedPointForHeroState.xuemai == nil then RedPointForHeroState.xuemai = ret end
		
		ret = char:redPointForJueXing() or char:redPointForEquip()
        if ret == true and RedPointForHeroState.juexing == nil then RedPointForHeroState.juexing = ret end
		
        _hasChar[k .. ""] = true
    end
    chars = Player.Chars:getLuaTable()
    table.foreach(chars, function(i, v)
        _hasChar[i .. ""] = true
    end)
end

local function parseRedPointForTask()
    RedPointTaskState = {}
    local ret = false
    local tasks = Player.Tasks:getLuaTable()
    table.foreach(tasks, function(k, v)
        if v.state == 2 then
            local row = TableReader:TableRowByID('allTasks', k)
            if row ~= nil and row.task_type == "major" and RedPointTaskState.task == nil then --是主线任务
            RedPointTaskState.task = true
            end
            if row ~= nil and row.task_type == "daily" and RedPointTaskState.daily == nil then --是主线任务
            RedPointTaskState.daily = true
            end
            if row ~= nil and row.task_type == "module" and RedPointTaskState.bleachRoad == nil then
                RedPointTaskState.bleachRoad = true
                RedPointTaskState.isShowBleachRoad = true
            end
            row = nil
        end
        if v.state == 0 then
            local row = TableReader:TableRowByID('allTasks', k)
            if row ~= nil and row.task_type == "module" and RedPointTaskState.isShowBleachRoad == nil then
                RedPointTaskState.isShowBleachRoad = true
            end
            row = nil
        end
    end)
	for i = 1, 4 do
        local s = Player.Tasks.pointReward[i]
        if s ~= 0 then
			RedPointTaskState.daily = true
			break
		end
    end
end

--可以用来消耗的特定宝物数量
function Tool.getTreasureCountByID(id, key)
    local unUse = Tool.getUnUseTreasure()
    local count = 0

    table.foreach(unUse, function(i, v)
        if id == v.value.id and v.value.level == 1 and v.value.power == 0  and key ~= v.key then
            count = count + 1
        end
    end)
    return count
end

local treasureKinds = 
{
	"fang",
	"gong"
}

function Tool.equipIsEmpty()
	local isEmpty = false
	local treasure = Player.Treasure
	local teams = Player.Team[0].chars
    local list = {}
    for j = 0, 5 do
		if teams[j] ~= nil and teams[j] ~= 0 and teams[j] ~= "0" then 
			--去掉升级判断
			--local char = Char:new(teams[j])
			--isEmpty = char:redPointForStrong()
			--if isEmpty == true then return isEmpty end 
			local treasureSlot = Player.Chars[teams[j]].treasure
			local list = {}
			for i=0,1 do
				if i > treasureSlot.Count then
					isEmpty = Tool.checkRedTreasureKind(treasureKinds[i])
					if isEmpty == true then return isEmpty end 
				else
					local key = treasureSlot[i]
					if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
						if treasure[key] == nil then
							isEmpty = Tool.checkRedTreasureKind(treasureKinds[i])
							if isEmpty == true then return isEmpty end 
						else 
							-- 检测更牛逼的宝物
							local ts = Treasure:new(treasure[key].id, key)
							isEmpty = Tool.checkRedTreasureStar(ts.star, ts.kind) or ts:redPointQianHua()
							if isEmpty == true then return isEmpty end
						end
					else
						isEmpty = Tool.checkRedTreasureKind(treasureKinds[i])
						if isEmpty == true then return isEmpty end 
					end
				end
			end	
			local ghostSlot = Player.ghostSlot
			local ghost = Player.Ghost
			local xx = ghostSlot:getLuaTable()
			local slot = ghostSlot[j]
			local postion = slot.postion
			local len = postion.Count
		
			for i = 1, 4 do
				if i > len then
					isEmpty = Tool.checkRedGhostKind(i-1)
					if isEmpty == true then return isEmpty end 
				else
					local key = postion[i - 1]
					if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
						local g = ghost[key].id
						if g == 0 then
							isEmpty = Tool.checkRedGhostKind(i-1)
							if isEmpty == true then return isEmpty end 
						else 
							local gh = Ghost:new(g, key)
							isEmpty = Tool.checkRedGhostStar(gh.star, gh.kind) or gh:redPointQianHua()
							if isEmpty == true then return isEmpty end
						end
					else
						isEmpty = Tool.checkRedGhostKind(i-1)
						if isEmpty == true then return isEmpty end 
					end
				end
			end
				
			--local petid = slot.petid
			--if petid == nil or tonumber(petid) == 0 then 
				isEmpty = Tool.checkRedPetKind(j)
				if isEmpty == true then return true end 
			--else 
			--end
		end
	end
	isEmpty = isEmpty or false
    return isEmpty
end

function Tool.checkRedTreasureStar(star, kind)
    if Player.Info.level >= Tool.getUnlockLevel(804) then
        local unUse = Tool.getUnUseTreasure()
        for i=1,#unUse do
            --local tre = Treasure:new(unUse[i].value.id,unUse[i].key)
			local tb = TableReader:TableRowByID("treasure", unUse[i].value.id)
            if tb ~= nil then
                if tb.kind == kind and tb.star > star then
                    return true
                end
            end
        end
    end
    return false
end

function Tool.checkRedTreasureKind(pos)
    if Player.Info.level >= Tool.getUnlockLevel(804) then
        local unUse = Tool.getUnUseTreasure()
        for i=1,#unUse do
			local tb = TableReader:TableRowByID("treasure", unUse[i].value.id)
            --local tre = Treasure:new(unUse[i].value.id,unUse[i].key)
            if tb ~= nil then
                if tb.kind == pos then
                    return true
                end
            end
        end
    end
    return false
end

-- 是否在上阵或者护佑中
local function isExitTeam(petId)
    local id = Player.Team[0].pet
    if id ~= nil and tonumber(id) ~= 0 and tonumber(id) == tonumber(petId) then
        return true
    end
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if tonumber(petId) == tonumber(petid) then 
			return true
		end 
	end 
    return false
end

-- 是否有同类型的宠物在护佑
local function isOneKindExitTeam(dictid)
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do 
        local slot = ghostSlot[i]
        local petid = slot.petid
        if petid ~=nil and petid ~=0 then 
            local petDictid = Tool.getPetDictId(petid)
            if dictid == petDictid then 
                return true
            end 
        end 
    end 
    return false
end

function Tool.checkRedPetKind(pos)
	if pos > 5 then return false end
	if Player.Info.level < Tool.getUnlockLevel(150) then return false end 
	local ghostSlot = Player.ghostSlot
	local slot = ghostSlot[pos]
	local petid = slot.petid
	if petid ~= nil and petid ~= "0" and petid ~= 0 then 
		return false
	end
	local pets = Player.Pets:getLuaTable()
	for k, v in pairs(pets) do
		local id = k
		if id then 
			local ret = isExitTeam(id)
			if ret == false then 
                local dictid = Tool.getPetDictId(id)
                ret = isOneKindExitTeam(dictid)
                if ret==false then 
                    return true
                end 
			end 
		end
	end
    return false
end

function Tool.checkRedYulingKind(pos)
    if pos > 5 then return false end
    if Player.Info.level < Tool.getUnlockLevel(27) then return false end 
    local ghostSlot = Player.ghostSlot
    local slot = ghostSlot[pos]
    local yulingid = slot.yulingid
    if yulingid ~= nil and yulingid ~= "0" and yulingid ~= 0 then 
        return false
    end
    local yulings = Player.yuling:getLuaTable()
    for k, v in pairs(yulings) do
        local id = k
        if id then 
            local info = Player.yuling[id] 
            if info.quality>0 and info.huyou<=0 then 
                return true 
            end 
        end
    end
    return false
end

function Tool.SortMagicList(list)
    local  magicList= {}
    local magic=Tool.getmagic(list,0)
    if magic~=nil then 
        table.insert(magicList,magic)
    end
    magic=Tool.getmagic(list,12)
    if magic~=nil then 
        table.insert(magicList,magic)
    end
    magic=Tool.getmagic(list,1)
    if magic~=nil then 
        table.insert(magicList,magic)
    end
    magic=Tool.getmagic(list,3)
    if magic~=nil then 
        table.insert(magicList,magic)
    end
    for i=1,#list do
        if list[i].magic_effect~=0 and list[i].magic_effect~=1 and list[i].magic_effect~=3 and list[i].magic_effect~=12 then 
            table.insert(magicList,list[i])
        end 
    end
    return magicList
end

function Tool.getmagic(list,id)
    for i=1,#list do
        if list[i].magic_effect==id then 
            return list[i]
        end 
    end 
    return nil      
end

function Tool.getAutoCostTreasure(myTre)
    local _canCost = Tool.getCanCostTreasure(myTre)

    --local length = #_canCost
    --for i=length,1,-1 do
    --    if _canCost[i].star >= 5 then
    --        table.remove(_canCost,i)
    --    end
    --end
    return _canCost
end
--手动
function Tool.getCanCostTreasure2(myTre)
    local unUse = Tool.getUnUseTreasure()
    local canCost = {}
    for k,v in pairs(unUse) do
        if v.value.power <= 0 and v.key~= myTre.key then
			local tr = Treasure:new(v.value.id, v.key)
			if tr.Table.can_lvup_yjtj == 1 then 
				table.insert(canCost,v)
			end 
        end
    end
    canCost = Tool.getCorrentCostTreasure(canCost)
    return canCost
end
--自动
function Tool.getCanCostTreasure(myTre)
    local unUse = Tool.getUnUseTreasure()
    local canCost = {}
    for k,v in pairs(unUse) do
        if v.value.power <= 0 and v.key~= myTre.key then
			local tr = Treasure:new(v.value.id, v.key)
			if tr.Table.can_lvup_yjtj_auto == 1 then 
				table.insert(canCost,v)
			end 
        end
    end
    canCost = Tool.getCorrentCostTreasure(canCost)
    return canCost
end


function Tool.getCorrentCostTreasure(_list)
    local list = _list
    local _canCost = {}
    --local _expCost = {}
    for k,v in pairs(list) do
        local tr = Treasure:new(v.value.id, v.key)
        table.insert(_canCost, tr)
    end
    
    print("//////..old#_canCost........"..#_canCost)
    --local length = #_canCost
    --for i=length,1,-1 do
    --    if _canCost[i].kind == "jing" then
    --        table.insert(_expCost,_canCost[i])
    --        table.remove(_canCost,i)
    --    end
    --end

    print("......_canCost...."..#_canCost)
    --print("......_expCost...."..#_expCost)
    --table.sort(_expCost, function(a, b)
    --    if a.star ~= b.star then
    --        return a.star < b.star
    --    end
    --    return a.id < b.id
    --end)

    table.sort(_canCost, function(a, b)
        if a.star ~= b.star then
            return a.star < b.star
        end

        if a.lv ~= b.lv then
            return a.lv > b.lv
        end
        return a.id < b.id
    end)

    local CanCostList = {}
    --for k,v in pairs(_expCost) do
    --    table.insert(CanCostList,v)
    --end
    for k,v in pairs(_canCost) do
        table.insert(CanCostList,v)
    end
    return CanCostList
end

function Tool.getHasUseTreasure()
    local treasures = Player.Treasure:getLuaTable()
    local list	= {}
	local index = 0
    for k,v in pairs(treasures) do
		index = index + 1
        if v.onPosition  then
            local data = {}
            data.key = k
            --data.value = v
			list[data.key .. ""] = true
        end
		
		if index >= 100 then 
			break
		end 
    end
    return list
end

function Tool.getUnUseTreasure()
    local treasures = Player.Treasure:getLuaTable()
    local unUse = {}
	local index = 0
    for k,v in pairs(treasures) do
		index = index + 1
        if not v.onPosition  then
            local data = {}
            data.key = k
            data.value = v
            table.insert(unUse,data)
        end
    end

    table.sort(unUse, function(a, b)
        if a.value.power ~= b.value.power then return a.value.power > b.value.power end
        if a.value.level ~= b.value.level then
            return a.value.level > b.value.level
        end
        return a.value.id < b.value.id
    end)
    return unUse
end

function Tool.checkRedGhostStar(star, kind)
    local unUse = Tool.getUnUseGhost()
	 for i=1,#unUse do
        local tre = unUse[i]
        if tre ~= nil then
            if tre.kind == kind and tre.star > star then
                return true
            end
        end
    end
    return false
end

function Tool.checkRedGhostKind(pos)
    local unUse = Tool.getUnUseGhostWithTable()
    return #unUse[pos + 1] > 0
end

function Tool.checkGhostRedPiont(pos)
    if pos > 5 then return false end
    local unUse = Tool.getUnUseGhostWithTable()
    local slot = Player.ghostSlot[pos]
    local position = slot.postion
    for j = 0, 3 do
        local key = position[j]
        if key == "" or key == nil or key == 0 or key == "0" then
            if unUse[j + 1] and #unUse[j + 1] > 0 then
                return true
            end
        end
    end
    return false
end

function Tool.checkRedPoint(type, char_id, refresh)
    if RedPointForHeroState == nil or refresh then
        parseRedPointForHero()
    end
	if RedPointForPetState == nil or refresh then 
		parseRedPointForPet()
	end
	if RedPointForEquipState == nil or refresh then
        parseRedPointForEquip()
    end
    if RedPointTaskState == nil or refresh then
        parseRedPointForTask()
    end
    local ret = false
    if type == "char" then
        --角色红点
        ret = RedPointForHeroState.char or RedPointForHeroState.cultivate or RedPointForHeroState.jinhua or RedPointForHeroState.xuemai or RedPointForHeroState.juexing or false
	elseif type == "pet" then
		ret = RedPointForPetState.lvup or RedPointForPetState.jinhua or RedPointForPetState.shenlian or false
    elseif type == "yuling" then
        parseRedPointForYuling()
        ret = RedPointForYulingState.lvup or RedPointForYulingState.jinhua or false
    elseif type == "skill" then
        ret = RedPointForHeroState.skill or false
    elseif type == "jinhua" then
        ret = RedPointForHeroState.jinhua or false
    elseif type == "linluo" then
        ret = RedPointForHeroState.linluo or false
    elseif type == "xuemai" then
        ret = RedPointTaskState.xuemai or false
    elseif type == "tujian" then
        --图鉴有合成
        --chars = Player.Chars:getLuaTable()
        --table.foreach(chars, function(i, v)
        --    _hasChar[i .. ""] = true
        --end)
        --有合成
        local pieces = Tool.getAllCharPiece()
        table.foreach(pieces, function(o, item)
			item:updateInfo() --更新碎片信息
			--local char = CharPiece:new(item.id)
             if item.count > 0 then
				if item.count >= item.needCharNumber then --合成
					ret = true
                    return ret
				end 
            end
        end)
        if ret == true then return ret end
	elseif type == "petPiece" then 
		--有合成
        local pieces = Tool.getAllPetPiece()
        table.foreach(pieces, function(o, item)
			item:updateInfo() --更新碎片信息
			local pet = PetPiece:new(item.id)
             if item.count > 0 then
				if pet.count >= pet.needCharNumber then --合成
					ret = true
                    return ret
				end 
            end
        end)
        if ret == true then return ret end
    elseif type == "yulingPiece" then 
        --有合成
        local pieces = Tool.getAllYulingPiece()
        table.foreach(pieces, function(o, item)
            item:updateInfo() --更新碎片信息
            local yuling = YulingPiece:new(item.id)
             if item.count > 0 then
                if Player.yuling[item.id].quality<=0 and yuling.count >= yuling.needCharNumber then --合成
                    ret = true
                    return ret
                end 
            end
        end)
        if ret == true then return ret end
    elseif type == "task" then
        --成就
        ret = RedPointTaskState.task or false

    elseif type == "sign" then
        --签到红点
        local ret = os.time() * 1000 > Player.Checkin.countdown
        if ret then return ret end
        if Player.Checkin.fulldrop then return false end
        local row = TableReader:TableRowByUniqueKey("checkinReward", Player.Checkin.month, Player.Checkin.times)
        if Player.Info.vip >= row.vip then
            ret = true
            return ret
        end
    elseif type == "active" then
        --日常
        if Player.Info.level < 10 then return false end
        ret = RedPointTaskState.daily or false
    elseif type == "draw" then
        local times = Player.Times or {}
        local norCurTime = times.moneytime or 0; --免费次数
        local CdTime = Player.CdTime or {}
        local nTime = ClientTool.GetNowTime(CdTime.moneyfree)

        if norCurTime > 0 and nTime <= 0 then
            ret = true
            return ret
        end
        local sTime = ClientTool.GetNowTime(CdTime.goldfree)
        if sTime <= 0 then
            ret = true
            return ret
        end

    elseif type == "jjc" then
    elseif type == "friend" then
        local friendLink = Tool.readSuperLinkById(120)
        local needLevel = 0
        if friendLink.unlock ~= nil and friendLink.unlock[0] ~= nil and friendLink.unlock[0].type == "level" then
            needLevel = friendLink.unlock[0].arg
        end
        local friend = Player.Social
        local row = TableReader:TableRowByUnique("BpConfig", "vip_level", Player.Info.vip)
        local num = row.bp_limit_times - Player.Social.acceptBpTimes
        if (friend.request.Count > 0 or friend.acceptBp.Count > 0) and Player.Info.level >= needLevel and num > 0 then
            ret = true
            return ret
        end
    elseif type == "mail" then
        local mails = Player.Mails:getLuaTable()
        table.foreach(mails, function(k, v)
            if v.read == false then
                ret = true
                return ret
            end
        end)
    elseif type == "renling" then 
        local openLv = TableReader:TableRowByID("renling_config",1).value2
        if Player.Info.level>=tonumber(openLv) then 
            local battle_free = TableReader:TableRowByID("resetChapter_show",5)["vip" .. Player.Info.vip] -- 每日免费试炼次数
            local battlenun=Player.renling.fightCount or 0
            local freen_nun=Player.Times.renlingfreetime
            if tonumber(battle_free)>tonumber(battlenun) then 
                return true 
            elseif tonumber(freen_nun) >0 then 
                return true 
            else 
                return Tool.getAllRenlingChapterRed()
            end 
        else 
            return false
        end 
    elseif type == "activity" or type=="fuli" or type=="recharge" or type=="holiday" or type=="grade" or type=="like" then
        if type == "activity" then 
            type="common"
        end 
        if Player.Activity ~= nil
                and Player.Activity.r ~= nil
                and Player.Activity.r[type] ~= nil
                and Player.Activity.r[type] == 1 then
            ret = true
        end
    elseif type == "vip" then
        if Player.Activity ~= nil
                and Player.Activity.r ~= nil
                and Player.Activity.r[type] ~= nil
                and Player.Activity.r[type] == 1 then
            ret = true
        end
        if ret ==false then 
            for i=0,Player.Info.vip do
                if Tool.vipGift(i)~=nil and Tool.vipGift(i).drop[0]~=nil and (Player.Vippkg[Tool.vipGift(i).id] == nil or Player.Vippkg[Tool.vipGift(i).id] ~= 1) then 
                    ret = true
                end 
            end
        end
    elseif type == "bleachRoad" then
        ret = RedPointTaskState.bleachRoad or false
    elseif type == "isHaveBleachRoad" then
        ret = RedPointTaskState.isShowBleachRoad or false
	elseif type == "guidao_qh" then 
		ret = RedPointForEquipState.qianhua or false
	elseif type == "guidao_jl" then 
		ret = RedPointForEquipState.jinglian or false
    elseif type == "guidao" then
        local lv = Tool.getUnlockLevel(241)
        if lv > Player.Info.level then
            return false
        end
		ret = Tool.equipIsEmpty()
		if ret == true then
            return ret
        end
    elseif type == "guidao_hecheng" then
        local ghostPiece = Player.GhostPieceBagIndex:getLuaTable()
        table.foreach(ghostPiece, function(i, v)
            local row = TableReader:TableRowByID("ghostPiece", i)
            if row then
                local consume = row.consume
                local _costList = RewardMrg.getConsumeTable(consume)
                for i = 1, #_costList do
                    local it = _costList[i]
                    if it:getType()=="ghostPiece" and it.count>1 and it.count > it.rwCount then
                        ret = true
                    end
                end
                --if ret then
                --    return ret
                --end
            end
        end)
		return ret
    elseif type == "friend" then
        ret = Tool.checkFriend()
    elseif type == "chuangguan" then
        --ret = Tool.checkChuangguan()
    elseif type == "chenghao" then
        ret = Tool.checkChenghao()
    elseif type == "gongxun" then
        ret =  Tool.checkGongXun()
    elseif type == "zhaomu" then 
        ret = Tool.checkZhaomu()
    elseif type == "beibao" then 
        ret = Tool.checkBeibao()
    elseif type =="renwu" then 
        ret = Tool.checkRenwu()
    elseif type =="yuling_total" then 
        ret = Tool.checkYulingTotal()   
    end
    return ret
end

function Tool.checkYulingTotal()
    local ret = false
    local freen_nun=Player.Times.xihaofreetime
    local freen_nun2=Player.Times.yulingfreetime
    ret=freen_nun>0 or freen_nun2>0
    if ret then return true end 
    ret=Tool.getCanYulingshu()
    if ret then return true end 
    ret=Tool.getCanReceiveReward()
    if ret then return true end 
    ret = Tool.checkRedPoint("yulingPiece") 
    if ret then return true end
    return Tool.checkRedPoint("yuling") or false
end
--检测御灵奖励是否可领
function Tool.getCanReceiveReward()
    local ret=false
    local drawNum1 = Player.yuling.xihaoDrawTimes -- 每日普通召唤次数
    local drawNum2 = Player.yuling.yulingDrawTimes -- 每日高级召唤次数
    TableReader:ForEachLuaTable("yuling_mrjl", function(index, item)
        if ret==false and Player.yuling.dayRewards[item.id]==nil then 
            if item.type=="times_draw_yl" then 
                if tonumber(item.need)<= drawNum2 then 
                   ret=true
                   if ret then return true end 
                end 
            else 
                if tonumber(item.need)<= drawNum1 then 
                    ret=true
                    if ret then return true end 
                end 
            end
        end 
        return false
    end)
    local drawNum1 = Player.Times.totalXihaoDraw -- 普通召唤总次数
    local drawNum2 = Player.Times.totalYulingDraw -- 高级召唤总次数
    TableReader:ForEachLuaTable("yuling_zsjl", function(index, item)
        if ret==false and Player.yuling.lifetimeRewards[item.id]==nil then 
            if item.type=="times_draw_yl" then 
                if tonumber(item.need)<= drawNum2 then 
                   ret=true
                   if ret then return true end 
                end 
            else 
                if tonumber(item.need)<= drawNum1 then 
                    ret=true
                    if ret then return true end 
                end 
            end
        end 
        return false
    end)
    return ret
end
--检测御灵术是否可提升
function Tool.getCanYulingshu()
    local ret = false
    local lv = Player.yuling.yulingshu.curLevel
    local totalCostNum=Player.Resource.haogandu
    TableReader:ForEachTable("yulingshu_magic_effect",
        function(index, item)
            if item ~= nil and tonumber(item.level)==lv then
                local needCostNum = item.consume[0].consume_arg
                local id = item.magic_effect
                local num=Player.yuling.yulingshu[lv][id] or 0
                local totalNum = item.magic_arg1
                if needCostNum<=totalCostNum and num<totalNum then 
                    ret = true 
                    if ret then return true end 
                end 
            end
            return false
        end)
    return ret
end

--检查背包
function Tool.checkBeibao()
    local bag = Player.ItemBag:getLuaTable()
    --print_t(bag)
    if not bag then error("bag have nothing") end
    for k, v in pairs(bag) do
        local vo = itemvo:new("item", v.count, v.id, v.time, k)
        if vo.itemTable.can_use == 1 and vo.itemCount > 0  and vo.itemID ~= 5 and vo.itemID ~= 6 and vo.itemID ~= 65 then --去除精力丹跟体力丹,讨伐令的判断
            return true
        end 
    end
    return false
end

--检查招募
function Tool.checkZhaomu()
    local times = Player.Times or {}
    local norCurTime = times.moneytime or 0; --免费次数
    local CdTime = Player.CdTime or {}
    local nTime = ClientTool.GetNowTime(CdTime.moneyfree)
    local sTime = ClientTool.GetNowTime(CdTime.goldfree)
    local linkData = Tool.readSuperLinkById( 7)
    local limitLv = linkData.unlock[0].arg
    local zCurTime =Player.Times.draw_party1time or 0
    if norCurTime >0 and nTime<=0 then 
        return true 
    elseif sTime<=0 then 
        return true
    elseif Player.Info.level >= limitLv and zCurTime>0 then
        return true  
    else 
        local consume=TableReader:TableRowByID("draw", 1).consume[i]
        if consume.consume_type=="item" then 
            local ziyuan=Player.ItemBagIndex[consume.consume_arg].count
            if ziyuan >0 then 
                return true 
            end
        end
        local consume1=TableReader:TableRowByID("draw",2).consume[i]
        if consume1.consume_type=="item" then 
            local ziyuan2=Player.ItemBagIndex[consume1.consume_arg].count
            if ziyuan2>0 then 
                return true 
            end 
        end
    end
    return false
end

--检查忍务，包括（碎片，试炼塔，巡逻）
function Tool.checkRenwu()
	local ret = Tool.checkIndiana() or Tool.checkShiLianTa() or Tool.checkXunLuo() or Tool.checkTaoRen() or Tool.checkChongWu()
	return ret or false
end

--检查逃忍状态
function Tool.checkTaoRen()
    local linkData = Tool.readSuperLinkById( 69)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.level < limitLv then 
        return false 
    end 
    if Player.DaXu ~= nil then
        if tonumber(Player.DaXu.totalHp) > 0 and tonumber(ClientTool.GetNowTime(Player.DaXu.CDTime)) > 0 then --
            return true
        end 
    end
    return false
end

--检查宠物百战沙场的领奖红点状态
function Tool.checkChongWu()
    if Player.PetChapter[13].status == 1 and Player.PetChapter.prizeTimes == 0 then
        return true
    end
    return false
end

--检查巡逻状态
function Tool.checkXunLuo()
    local linkData = Tool.readSuperLinkById( 68)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.level<limitLv then return false end 
	local ret = false
    TableReader:ForEachLuaTable("areaConfig", function(index, item)
		local data = Player.Agency[item.id]
        --old
		-- if data.state == "5" then
		-- 	ret = true
		-- 	return ret
		-- end
        --new
        if data.state == "1" then
            ret = true
            local charId = tonumber(data.charId) or 0
            if charId ~= 0 then
                local sTime = ClientTool.GetNowTime(data:getLong("PatrolTime"))
                ret = false
                if sTime <= 0 then
                    if data.dropState == "1" or data.dropState == "2"  then
                        ret = true
                        return ret
                    end
                end
            end
        end
        --
        return false
    end)
	return ret
end  

--检查试炼状态
function Tool.checkShiLianTa()
    local linkData = Tool.readSuperLinkById( 226)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.level<limitLv then return false end 
	local freeTime = TableReader:TableRowByID("tower_config", "freeResetTimes").args1 --每日可免费次数
    local times = freeTime + Player.qianCengTa.buyTimes - Player.qianCengTa.resetTimes
	print("__times for checkShiLianTa= " .. times)
    return times > 0
end 


--检查夺宝系统，是否有宝物可以合成
function Tool.checkIndiana()
    local linkData = Tool.readSuperLinkById( 803)
    local limitLv = linkData.unlock[0].arg
    if Player.Info.level < limitLv then return false end 
    local treasurePiece_list = Tool.getTreasurePiece()
    for k,v in pairs(treasurePiece_list) do
        local id = TableReader:TableRowByID("treasurePiece", v.id).treasureId
        local consume =TableReader:TableRowByID("treasure", id).consume
        local ishas=true
        for i = 0, consume.Count - 1 do
            if ishas==true then 
                ishas=Tool.checkOneTreasureCanSynthetic(consume[i].consume_arg,consume[i].consume_arg2,treasurePiece_list)
            end
        end 
        if ishas==true then 
            return true 
        end 
    end
    return false
end

--检查单个宝物，是否可以合成
function Tool.checkOneTreasureCanSynthetic(id,num,pieceList)
    for k,v in pairs(pieceList) do
        if v.id==id and v.count>=num then 
            return true 
        end 
    end 
    return false  
end


--检查神乐
function Tool.checkChenghao()
    if Player.Info.level < 13 then return false end
    local mystarlvup = TableReader:TableRowByID("playerstarlvup", Player.Info.ninjialvl + 1)
	if mystarlvup == nil then return false end 
    local type = mystarlvup.consume[i].consume_type
    local arg = mystarlvup.consume[i].consume_arg
    local arg2 = mystarlvup.consume[i].consume_arg2
    if type == "item" then
        local item = uItem:new(arg)
        local temcount = item.count
        if temcount >= arg2  then
            return true
        end
    end
    return false
end

--检查闯关
function Tool.checkChuangguan(chaptertype, selectChapter, timescheck)
    local tasks = Player.Tasks:getLuaTable() --任务表
	local tb = TableReader:TableRowByUniqueKey("chapter", selectChapter, chaptertype)
    if tb == nil then
        return false
    end
	local taskid = tb["taskID"]
    --章节宝箱
    for i=0,2 do   
        if taskid[i] ~= nil then
            local taskidv = taskid[i].taskID
            local row = TableReader:TableRowByID('allTasks', taskidv)
            if row == nil then
                break
            end
            if tasks[taskidv] ~= nil then
                if tasks[taskidv]["state"] == 2 then
                    return true
                end
            end 
        end
    end

    local chapterData = TableReader:TableRowByUniqueKey("chapter", selectChapter, chaptertype)
    --小关宝箱
    for j=1, chapterData.totelSection do
        local ta = TableReader:TableRowByUniqueKey(chaptertype, selectChapter, j)
        local  box = ta["box"]
        if box ~= nil and box.Count > 0 then
            local boxState = false
            local star = 0
            if chaptertype == "commonChapter" then
                if Player.Chapter.status[ta.id] ~= nil then
                    star = Player.Chapter.status[ta.id].star
                    boxState = Player.Chapter.status[ta.id].bGotBox
                end
            elseif chaptertype == "hardChapter" then
                if Player.HardChapter.status[ta.id] ~= nil then
                    star = Player.HardChapter.status[ta.id].star
                    boxState = Player.HardChapter.status[ta.id].bGotBox
                end
            elseif chaptertype == "heroChapter" then
                if Player.NBChapter.status[ta.id] ~= nil then
                    star = Player.NBChapter.status[ta.id].star
                    boxState = Player.NBChapter.status[ta.id].bGotBox
                end
            end

            if star~= nil and star > 0 then
                if boxState ~= nil and boxState == false then
                    return true
                end
            end
        end
    end

    if chaptertype == "heroChapter" and timescheck ~= nil and timescheck == true  then
        local linkData = Tool.readSuperLinkById( 5)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level >= limitLv then


            local row = TableReader:TableRowByID("heroChapter_config", "max_time")
            local totaltimes = 0
            if row.args1 ~= nil and tonumber(row.args1) ~= nil then
                totaltimes = row.args1
            end
            
            local lefttimes = totaltimes - Player.NBChapter.totaltimes
            if lefttimes > 0 then
                return true
            end
        end
    end

    return false

end
--检测功勋奖励是否有可以领取的
function Tool.checkGongXun()
    if Player.DaXu.gongxunReward ~= nil then
        local tb = Player.DaXu.gongxunReward:getLuaTable()
        if tb ~= nil then
            for i, v in pairs(tb) do
                return true
            end
        end
    end
    return false
end

--检测是否有小伙伴可以上阵
function Tool.checkFriend()
    local lv = Player.Info.level
    local levelList = {}
    TableReader:ForEachLuaTable("relationship_config", function(index, item) --等级限制列表
    levelList[index + 1] = item.arg2
    return false
    end)
    --可以上阵个数
    local count = 0
    for i = 1, 8 do
        if lv >= levelList[i] then
            count = count + 1
        end
    end
    --当前上阵个数
    local number = 0
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams[i] ~= nil and tonumber(teams[i]) ~= 0 then
            number = number + 1
        end
    end
    if count > number then
        return true
    else
        return false
    end
end

function Tool.replaceToLevel(moduleName, path, level, arg)
    if GlobalVar.currentScene ~= "main_scene" then
        --ClientTool.LoadLevel("main_scene", function()
            if arg ~= nil then
                UIMrg:replaceToLevel(moduleName, path, level, arg)
            else
                UIMrg:replaceToLevel(moduleName, path, level)
            end
        --end)
    else
        if arg ~= nil then
            UIMrg:replaceToLevel(moduleName, path, level, arg)
        else
            UIMrg:replaceToLevel(moduleName, path, level)
        end
    end
end

function Tool.jumeWithGUide(unlock)
    if unlock and unlock.guide and Player.guide[unlock.guide] == 2 then
        GuideConfig:End()
        return
    end
    GuideConfig:Playing()
    UIMrg:pushWindow("Prefabs/moduleFabs/alertModule/unlockDialog", unlock)
end

function Tool.checkLevelUnLock(id)
    local unlock = unlockMap[id]
    if unlock then
        Tool.jumeWithGUide(unlock)
        return true
    end
    return false
end

local cacheLvUnlock = nil
--通过等级获得解锁的模块
function Tool.checkLevelUnLockWithLevel(lv)
    if cacheLvUnlock == nil then
        cacheLvUnlock = {}
        table.foreach(unlockMap, function(id, v)
            if type(id) == "number" then
                local lv = Tool.getUnlockLevel(id)
                cacheLvUnlock[lv] = id
            end
        end)
    end
    if cacheLvUnlock[lv] then
        return Tool.checkLevelUnLock(cacheLvUnlock[lv])
    end
    return false
end

--检查超链接是否可以跳转,并返回字符
function Tool.CheckSuperLink(superID)
    local linkData = Tool.readSuperLinkById( superID)
    if linkData == nil then
        return "", false
    end
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        local vipLV = linkData.vipLevel
        --等级方式节解锁
        if unlockType == "level" then
            if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                return "[ff0000]" .. linkData.from .. "[-]", false
            end
        end
        --章节方式解锁
        if unlockType == "completeCommonChapter" then
            local lastChapter = Player.Chapter.lastChapter
            local lastSection = Player.Chapter.lastSection
            local row = TableReader:TableRowByID("commonChapter", level)
            if level == 0 then
                return "[0e9cff]" .. linkData.from .. "[-]", true
            end
            if lastChapter < row.chapter then
                return "[ff0000]" .. linkData.from .. "[-]", false
            elseif lastChapter == row.chapter and lastSection <= row.section then
                return "[ff0000]" .. linkData.from .. "[-]", false
            end
        end

        --章节方式解锁
        if unlockType == "completeHardChapter" then
            local lastChapter = Player.HardChapter.lastChapter
            local lastSection = Player.HardChapter.lastSection
            local row = TableReader:TableRowByID("hardChapter", level)
            if level == 0 then
                return "[0e9cff]" .. linkData.from .. "[-]", true
            end
            if lastChapter < row.chapter then
                return "[ff0000]" .. linkData.from .. "[-]", false
            elseif lastChapter == row.chapter and lastSection <= row.section then
                return "[ff0000]" .. linkData.from .. "[-]", false
            end
        end

        return "[0e9cff]" .. linkData.from .. "[-]", true
    end
    return "[0e9cff]" .. linkData.from .. "[-]", true
end

function Tool.getAllCharPiece()
	local list = {}
	local pieces = Player.CharPieceBagIndex:getLuaTable()
	for k,v in pairs(pieces) do 
		local piece = CharPiece:new(k) 
		table.insert(list, piece)
	end
	return list
end

function Tool.getAllPetPiece()
	local list = {}
	local pieces = Player.petPieceBagIndex:getLuaTable()
	for k,v in pairs(pieces) do 
		local piece = PetPiece:new(k) 
		table.insert(list, piece)
	end
	return list
end

function Tool.getAllYulingPiece()
    local list = {}
    local pieces =Player.yulingPieceBagIndex:getLuaTable()
    for k,v in pairs(pieces) do 
        local piece = YulingPiece:new(k) 
        table.insert(list, piece)
    end
    return list
end

--进游戏开始初始化主线任务  缓存
function Tool.initMainTasks(...)
    if Tool.mainTasks == nil then
        Tool.InitTasks()
    end
end

function Tool.InitTasks()
    if Tool.targetTasks == nil or Tool.mainTasks == nil then
        Tool.targetTasks = {}
        Tool.mainTasks = {}
        TableReader:ForEachLuaTable("allTasks", function(index, item)
            if item.stage ~= nil and item.task_type == "target" then --所有的目标任务
                if Tool.targetTasks[item.id] == nil then
                    Tool.targetTasks[item.id] = item
                end
            end
            if item.task_type == "major" then --如果是主线任务
                if Tool.mainTasks[item.id] == nil then
                    Tool.mainTasks[item.id] = item
                end
            end
            return false
        end)
        print("count------------------------"..#Tool.targetTasks)
    end
end
--检测某个任务是否属于目标任务
function Tool.checkTarget(task_id)
    if Tool.targetTasks == nil then
        Tool.InitTasks()
    end

    if task_id == nil then return false end
    local flag = false
    if Tool.targetTasks[task_id] ~= nil then
        flag = true
    end
    return flag
end

function Tool.saveTaskLastPos(index)
    if Tool.lastTaskPos == nil or index == nil then
        Tool.lastTaskPos = 1
    else
        Tool.lastTaskPos = index
    end
end

function Tool.ghostPowerUp(...)
    if Tool.ghostExp == nil then
        Tool.ghostExp = {}
        TableReader:ForEachLuaTable("ghostPowerUp", function(index, item)
            if Tool.ghostExp[tonumber(item.name)] == nil then
                Tool.ghostExp[tonumber(item.name)] = {}
            end
            
            local it = {}-- json.decode(item:toString())

            table.insert(Tool.ghostExp[tonumber(item.name)], it)
            local consume = item.consume
            local power = item.power or 0
            if Tool.ghostExp[tonumber(item.name)][tonumber(power)] == nil then
                Tool.ghostExp[tonumber(item.name)][tonumber(power)]= {}
            end
            if Tool.ghostExp[tonumber(item.name)][tonumber(power)].magic == nil then 
                Tool.ghostExp[tonumber(item.name)][tonumber(power)].magic = item.magic
            end
            if Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume == nil then 
                Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume = {}
            end
            for i = 0, consume.Count - 1 do
                local m = consume[i]
                local last = 0
                if Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1] == nil then 
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1] = {}
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg = m.consume_arg
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2 = m.consume_arg2
                end
                if m.consume_type == "ghost" then
                    if Tool.ghostExp[tonumber(item.name)][tonumber(power)] ~= nil then                       
                        last = Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2
                        --      print("last ghost "..last)
                    end
                    
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2 = Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2 + last
                    --  print("Tool ghost"..Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i].consume_arg2)
                elseif m.consume_type == "item" then
                    if Tool.ghostExp[tonumber(item.name)][tonumber(power)] ~= nil then                       
                        last = Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2
                    end
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_type = m.consume_type
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2 = Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg2 + last
                else
                    if Tool.ghostExp[tonumber(item.name)][tonumber(power)] ~= nil then
                        last = Tool.ghostExp[tonumber(item.name)][tonumber(power - 1)].consume[i+1].consume_arg
                        --   print("last consume"..last)
                    end
                     
                    Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg = Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i+1].consume_arg + last
                    -- print("Tool consume"..Tool.ghostExp[tonumber(item.name)][tonumber(power)].consume[i].consume_arg)
                end
            end

            return false
        end)
    end
end

function Tool.SetActive(go, ret)
    if go == nil then return end
    go.gameObject:SetActive(ret)
end

function Tool.getGhostOwer(key)
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                if tostring(pos) == tostring(key) then return slot end 
            end
        end
    end
    return nil
end

function Tool.sortChar(charList)
    table.sort(charList, function(a, b)
        if a.teamIndex ~= b.teamIndex then return a.teamIndex < b.teamIndex end
        if a.star ~= b.star then return a.star > b.star end
        if a.stage ~= b.stage then return a.stage > b.stage end
        if a.power ~= b.power then return a.power > b.power end
        return a.id < b.id
    end)
end

function Tool.LoadButtonEffect(go)
    local btn = ClientTool.load("Effect/Prefab/UI_commButton", go)
    btn:SetActive(false)
    return btn
end

function Tool.getHasUseGhost()
    local ghostSlot = Player.ghostSlot
    local list = {}
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local postion = slot.postion
        local len = postion.Count
        for j = 0, len - 1 do
            local pos = postion[j]
            if pos ~= nil and pos ~= "" and pos ~= 0 then
                list[pos .. ""] = true
            end
        end
    end
    return list
end

function Tool.isUsedGhost(key)
	local ghosts = Tool.getHasUseGhost()
	return isUsed(ghosts, key)
end 

function Tool.isUsedTreasure(key)
	local treas = Tool.getHasUseTreasure()
	return isUsed(treas, key)
end 

local unUseGhost = nil
function Tool.resetUnUseGhost()
    unUseGhost = nil
end

function Tool.getUnUseGhostWithTable()
    if unUseGhost ~= nil then return unUseGhost end
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = Tool.getHasUseGhost()
    local list = { {}, {}, {}, {} }
    table.foreach(ghost, function(i, v)
        if not isUsed(hasUse, i) then
            local gh = Ghost:new(v.id, i)
            local tp = gh.kind
            if tp == "po" then
                table.insert(list[1], gh)
            elseif tp == "hui" then
                table.insert(list[2], gh)
            elseif tp == "fu" then
                table.insert(list[3], gh)
            elseif tp == "jie" then
                table.insert(list[4], gh)
            end
        end
    end)
    unUseGhost = list
    return list
end

--未使用的鬼道
function Tool.getUnUseGhost()
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = Tool.getHasUseGhost()
    local list = {}
    table.foreach(ghost, function(i, v)
        if not isUsed(hasUse, i) then
            local gh = Ghost:new(v.id, i)
            table.insert(list, gh)
        end
    end)

    return list
end

--星级对应颜色
function Tool.getNameColor(star)
    star = star or 1
    local row = TableReader:TableRowByID("systemConfig", "name_color_star_" .. star)
    if row then
        return row.value
    end
    return Tool.white
end

--缓存解锁等级
local cache_superLink = {}
function Tool.getUnlockLevel(id)
    if cache_superLink[id] then return cache_superLink[id] end
    local row = Tool.readSuperLinkById( id)
    if row == nil then print(id .. " can't find") return 0 end
    local unlock = row.unlock
    if unlock and unlock.Count > 0 then
        local lv = unlock[0].arg
        cache_superLink[id] = lv
        return lv
    end
    return 0
end

--鬼道数量
function Tool.getGhostCountByID(id)
    local ghost = Player.Ghost:getLuaTable() or {}
    local hasUse = Tool.getHasUseGhost()
    local list = {}
    local count = 0
    table.foreach(ghost, function(i, v)
        if not isUsed(hasUse, i) then
            if id .. "" == v.id .. "" and v.level == 0 and v.power == 0 and v.xilian_times == 0 then
                count = count + 1
            end
        end
    end)
    return count
end

--存在的鬼道碎片列表
function Tool.getGhostPieceList()
    local pieces = Player.GhostPieceBagIndex:getLuaTable()
    local list = {}
    table.foreach(pieces, function(i, v)
        if v.count > 0 then
            local k = GhostPiece:new(i, v.count)
            table.insert(list, k)
        end
    end)
    Tool.GhostPieceList = list
    return Tool.GhostPieceList
end

--获取拥有的宝物碎片列表
function Tool.getTreasurePiece()
    if Player.treasurePieceBagIndex == nil then return {} end
    local pieces = Player.treasurePieceBagIndex:getLuaTable()
    local list = {}
    table.foreach(pieces, function(i, v)
        if v.count > 0 then
            local k = TreasurePiece:new(i, v.count)
            table.insert(list, k)
        end
    end)
    Tool.TreasurePiece = list
    return list
end

--推送活动
function Tool.pushActive()
    if GuideMrg:isPlaying() then
        return
    end
    local act = Player.Activity.d
    if act then
        local p = ""
        local tp = type(act)
        local ret = tp == "table"
        if ret or act:ContainsKey("p") then
            p = act.p
        end
        if p ~= "" and p ~= nil then
            local tp = type(p)
            if tp ~= "string" and p.Count > 0 then
                Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { p[0] })
                DataEye.pushAct(p[0])
            elseif tp == "string" then
                Tool.push("activity", "Prefabs/moduleFabs/activityModule/moduleActivity", { p })
                DataEye.pushAct(p)
            end
        end
    end
end

function Tool.gc(time)
    time = time or 1
    LuaTimer.Add(time * 1000, function(id)
        ClientTool.release()
        -- print("gc 回收")
        return false
    end)
end

function Tool.replace(...)
    local arg = { ... }
    DataEye.OpenModule(arg[1])
    return UIMrg:replace(...)
end

function Tool.push(a, b, c)
    DataEye.OpenModule(a)
    return UIMrg:push(a, b, c)
end

function Tool.loadTopTitle(gameObjectParent, title, close)
	local lua = Tool.popTopTitleByPool()
	if lua == nil then 
		lua = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/gui_top_title", gameObjectParent)
	else 
		lua.gameObject.transform.parent = gameObjectParent.transform
		lua.gameObject:SetActive(true)
	end
	lua:CallUpdate({title = title, close = close})
	return lua
end

function Tool.popTopTitleByPool()
	if Tool.poolTopTitle ~= nil then 
		if #Tool.poolTopTitle > 0 then 
			local top = Tool.poolTopTitle[#Tool.poolTopTitle]
			table.remove(Tool.poolTopTitle)
			return top
		end 
	end
	return nil
end  

function Tool.pushTopTitleByPool(topTitle)
	if Tool.poolTopTitle ~= nil then 
		if #Tool.poolTopTitle >= 4 then 
			-- 只缓存4个
			return 
		end 
		if topTitle ~= nil then 
			topTitle.gameObject:SetActive(false)
			topTitle.transform.parent = GlobalVar.MainUI.transform
			table.insert(Tool.poolTopTitle, topTitle)
		end 
	end
end

function Tool.setIcon(icon, img)
    if icon and img then
        local atlasName = packTool:getIconByName(img)
        icon:setImage(img, atlasName)
    end
end

function Tool.getTeamPower()
    local teamIndex = 0
    local t = Player.Team[teamIndex]
    local teams = t.chars
    local lingya = 0 --t.power
    if lingya == 0 then
        for i = 0, 5 do
            if teams.Count > i then
                if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then
                    local last_char = Char:new(teams[i .. ""])
                    lingya = lingya + last_char.power
                end
            end
        end
    end
    return lingya
end

function Tool.setFont(go, name)
    local tran = go.transform:Find(name)
    if tran == nil then return nil end
    local lab = tran.gameObject:GetComponent(UILabel)
    if lab and lab.bitmapFont == nil then
        lab.bitmapFont = GameManager.GetFont()
    end
end

function Tool:judgeBagCount(dropTypeList, limitCount, isChapter)
    if limitCount == nil then
        limitCount = 1
    end
    local isEnough = true
    if dropTypeList ~= nil then
        for i = 0, 10 do
            if dropTypeList[i] ~= nil then
                isEnough = Tool.CheckTypeBagCount(dropTypeList[i], limitCount, isChapter)
                if isEnough == false then return isEnough end
            end
        end
    end
    return isEnough
end

function Tool:ShowCount(data)
    local myCount = 0
    for k, v in pairs(data) do
        if v ~= nil then
            myCount = myCount + 1
        end
    end
    return myCount
end

function Tool.getAllRenlingChapterRed()
    local _bool = false
    local openLv = TableReader:TableRowByID("renling_config",5).value2
    local maxStar = TableReader:TableRowByID("renling_config",6).value2
    TableReader:ForEachLuaTable("renling_tujian",function (i,cell)
        if _bool==false and Tool.getRenLingLock(cell) then 
            _bool=Tool.getOneRenlingChapterRed(tonumber(cell.group))
        end 
        return false
    end)
    return _bool
end

function Tool.getOneRenlingChapterRed(group)
    local _bool = false
    local openLv = TableReader:TableRowByID("renling_config",5).value2
    local maxStar = TableReader:TableRowByID("renling_config",6).value2
    local group_item = TableReader:TableRowByUnique("renling_tujian","group",group)
    if Tool.getRenLingLock(group_item) then 
        TableReader:ForEachLuaTable("renling_group", function(index, _item) --shopPurchase
            if _bool == false and tonumber(_item.group)== group then
                if Player.renling[group]~=nil and Player.renling[group][_item.id] ~=nil and tonumber(Player.renling[group][_item.id].level)>=1 then 
                    local star = tonumber(Player.renling[group][_item.id].level)
                    if Player.Info.level>=tonumber(openLv) and star<tonumber(maxStar) then 
                        if Tool.getCanActive(_item.consume) then
                            _bool = true
                        end  
                    end 
                else
                    if Tool.getCanActive(_item.consume) then
                        _bool = true
                    end 
                end 
            end   
            return false
            end)
    end 
    return _bool
end

function Tool.getRenLingLock(item)
    for i=0,item.unlock.Count-1 do
        local type = item.unlock[i].unlock_condition
        if type=="level" then 
            if Player.Info.level<tonumber(item.unlock[i].unlock_arg) then 
                return false 
            end 
        elseif string.sub(type,0,5) == "group" then  
            local chapterNum =tonumber(string.sub(type,6,-1))
            local num = Tool.getChartNumByGroup(chapterNum) -- 灵阵图第chapterNum章的已激活数目
            if num< tonumber(item.unlock[i].unlock_arg) then 
                return false
            end 
        end 
    end
    return true
end

function Tool.getChartNumByGroup(group)
    local num =0 
    if Player.renling[group]~=nil and Player.renling[group].totolcnt~=nil then 
        num=num+tonumber(Player.renling[group].totolcnt)
    end
    return num
end

function Tool.getCanActive(consume)
    local bag = Player.renlingBagIndex
    for i=0,consume.Count do
        if consume[i]~=nil then 
            if consume[i].consume_type == "renling" then
                local temp = bag[consume[i].consume_arg]
                if temp==nil then 
                    return false
                else 
                    if temp.count<tonumber(consume[i].consume_arg2) then 
                        return false
                    end 
                end  
            end 
        end
    end 
    return true
end

function Tool.CheckTypeBagCount(itemType, limitCount, isChapter)
    if limitCount == nil then
        limitCount = 1
    end
    local dic
    if itemType == "char" then
        dicCount = TableReader:TableRowByID("bagMax", "maxChar")["vip"..Player.Info.vip]
        local data = Player.Chars:getLuaTable()
        if Tool:ShowCount(data) > dicCount - limitCount then
            if isChapter ~= nil and isChapter then
                MessageMrg.show(TextMap.GetValue("Text_1_2864"))
            else
                MessageMrg.show(TextMap.GetValue("Text_1_2865"))
            end
            return false
        end
    elseif itemType == "treasure" then
        dicCount = TableReader:TableRowByID("bagMax", "maxTreasure")["vip"..Player.Info.vip]
        local data = Player.Treasure:getLuaTable()
        if Tool:ShowCount(data) > dicCount - limitCount then
            if isChapter ~= nil and isChapter then
                MessageMrg.show(TextMap.GetValue("Text_1_2866"))
            else
                MessageMrg.show(TextMap.GetValue("Text_1_2867"))
            end
            return false
        end
    elseif itemType == "item" then
        dicCount = TableReader:TableRowByID("bagMax", "maxItem")["vip"..Player.Info.vip]
        if Player.ItemBag.count > dicCount - limitCount then
            if isChapter ~= nil and isChapter then
                MessageMrg.show(TextMap.GetValue("Text_1_2868"))
            else
                MessageMrg.show(TextMap.GetValue("Text_1_2869"))
            end
            return false
        end
     elseif itemType == "ghost" then
        dicCount = TableReader:TableRowByID("bagMax", "maxGhost")["vip"..Player.Info.vip]
        local data = Player.Ghost:getLuaTable()
        if Tool:ShowCount(data) > dicCount - limitCount then
            if isChapter ~= nil and isChapter then
                MessageMrg.show(TextMap.GetValue("Text_1_2870"))
            else
                MessageMrg.show(TextMap.GetValue("Text_1_2871"))
            end
            return false
        end    
     elseif itemType == "equip" then
        dicCount = TableReader:TableRowByID("bagMax", "maxEquip")["vip"..Player.Info.vip]
        local data = Player.EquipmentBag:getLuaTable()
        if Tool:ShowCount(data) > dicCount - limitCount then
             if isChapter ~= nil and isChapter then
                MessageMrg.show(TextMap.GetValue("Text_1_2872"))
            else
                MessageMrg.show(TextMap.GetValue("Text_1_2873"))
            end
            return false
        end
    elseif itemType == "pet" then
        dicCount = TableReader:TableRowByID("bagMax", "maxPet")["vip"..Player.Info.vip]
        local data = Player.Pets:getLuaTable()
        if Tool:ShowCount(data) > dicCount - limitCount then
             if isChapter ~= nil and isChapter then
                MessageMrg.show(TextMap.GetValue("Text_1_2874"))
            else
                MessageMrg.show(TextMap.GetValue("Text_1_2875"))
            end
            return false
        end
    end
    return true
end

function Tool.CheckBagCount(count)
    if count == nil then
        count = 1
    end

    local limitcount =  TableReader:TableRowByID("bagMax", "maxChar")["vip"..Player.Info.vip]
    local data = Player.Chars:getLuaTable()
    local myCount = 0
    for k, v in pairs(data) do
        if v ~= nil then
            myCount = myCount + 1
        end
    end
    if myCount > limitcount - count then
         MessageMrg.show(TextMap.GetValue("Text_1_2865"))
         return false
    end

    limitcount =  TableReader:TableRowByID("bagMax", "maxTreasure")["vip"..Player.Info.vip]
    data = Player.Treasure:getLuaTable()
    myCount = 0
    for k, v in pairs(data) do
        if v ~= nil then
            myCount = myCount + 1
        end
    end
    if myCount > limitcount - count then
         MessageMrg.show(TextMap.GetValue("Text_1_2876"))
         return false
    end

    limitcount =  TableReader:TableRowByID("bagMax", "maxEquip")["vip"..Player.Info.vip]
    myCount = Player.EquipmentBag.count
    if myCount  > limitcount - count then
         MessageMrg.show(TextMap.GetValue("Text_1_2877"))
         return false
    end

    limitcount =  TableReader:TableRowByID("bagMax", "maxGhost")["vip"..Player.Info.vip]
    data = Player.Ghost:getLuaTable()
    myCount = 0
    for k, v in pairs(data) do
        if v ~= nil then
            myCount = myCount + 1
        end
    end
    if myCount  > limitcount - count then
         MessageMrg.show(TextMap.GetValue("Text_1_2878"))
         return false
    end

    limitcount =  TableReader:TableRowByID("bagMax", "maxItem")["vip"..Player.Info.vip]
    myCount = Player.ItemBag.count
    for k, v in pairs(data) do
        if v ~= nil then
            myCount = myCount + 1
        end
    end
    if myCount  > limitcount - count then
         MessageMrg.show(TextMap.GetValue("Text_1_2879"))
         return false
    end

    return true
end

function Tool:isAllLeagueLevelRewardsOver()
    local list = {}
    local isOver = true
    TableReader:ForEachLuaTable("guildPackage", function(index, item) --奖励物品可以在道具商店和奖励商店显示，只能领取一次
    if item.id ~= nil then
        if item.which_shop == 22 then
            local i = 0
            if type(item.drop) == "table" then
                i = 1
            end
            local itemdata = { type = "", id = 0, count = 1, posid = -1, per_limit_num = 1, guild_level_limit = 1, guild_limit_num = 0, guild_buy_num = 0, buy_num = 0, sell = false, sell_type = "gold", sell_num = 0, sell_discount = 100, sell_price = 888, step = 1, inc = 0 }
            if item.drop[i]~=nil then
                itemdata.type = item.drop[i].type
                itemdata.id = item.drop[i].arg
                itemdata.count = item.drop[i].arg2
                itemdata.per_limit_num = item.drop[i].limit
            end 
            itemdata.posid = item.id
            if item.consume[i]~=nil then 
                itemdata.sell_type = item.consume[i].consume_type
                itemdata.sell_price = item.consume[i].consume_arg
            end 
            itemdata.guild_level_limit = item.guildlevel_limit
            table.insert(list, itemdata)

        end
    end
    return false
    end)
    
    for k,v in pairs(list) do
        if v.posid ~= nil and v.posid ~= -1 then 
            if Player.GuildPkg ~= nil and Player.GuildPkg[v.posid] == 1 then
                --
            else
                isOver = false
                return isOver
            end
        end
    end

    return isOver
end

function Tool.ChapterDraw(chapter,_name,cb)
    local step="chapter".. chapter
    if Player.guide[step]~=nil and Player.guide[step] == 2 then 
        if cb then cb() end 
    else
        local StepData = require("uLuaModule/modules/guide/guide_setting")
        if StepData[step] == nil then
            if cb then cb() end 
            return 
        end
        local data=StepData[step] 
        if data[1]==nil then   
            if cb then cb() end 
            return 
        end
        local name =""
        if _name~="" then 
            local tb=split(_name, "：")
            name=string.gsub(TextMap.GetValue("LocalKey_666"),"{0}",tb[1])
            name =string.gsub(name,"{1}",tb[2])
        end 
        local content =data[1]
        local text=ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/conversationModule/wenzhang", GuideManager.getInstance().gameObject);
        text:CallUpdate({content[2], content[3], content[4],"chapter",step,name,cb})
    end 
end

local sevenDayDataRed = nil
local fourteenDayDataRed = nil
local spSevenDayFirDataRed = nil
local spSevenDaySecDataRed = nil
local spSevenDayYuanDataRed = nil


function Tool:LoadSevenDayData(actType)
    local list = {}
    if actType ~= nil then
        if actType == "day7" then
            if sevenDayData ~= nil then
                list = sevenDayData
            else
                sevenDayData, sevenDayDataRed = Tool:setTheSevenDayData("day7")
                list = sevenDayData
            end
        elseif actType == "Day14s" then
            if fourteenDayData ~= nil then
                list = fourteenDayData
            else
                fourteenDayData, fourteenDayDataRed = Tool:setTheSevenDayData("day14")
                list = fourteenDayData
            end
        elseif actType == "offyear" then
            if spSevenDayFirData ~= nil then
                return spSevenDayFirData
            else
                spSevenDayFirData, spSevenDayFirDataRed = Tool:setTheSevenDayData("offyear")
                return spSevenDayFirData
            end
        elseif actType == "SpringFestival" then
            if spSevenDaySecData ~= nil then
                return spSevenDaySecData
            else
                spSevenDaySecData, spSevenDaySecDataRed = Tool:setTheSevenDayData("SpringFestival")
                return spSevenDaySecData
            end
        elseif actType == "yuanxiaojie" then
            if spSevenDayYuanData ~= nil then
                return spSevenDayYuanData
            else
                spSevenDayYuanData, spSevenDayYuanDataRed = Tool:setTheSevenDayData("yuanxiaojie")
                return spSevenDayYuanData
            end
        end
        -- if actType ~= sevenDayActType then
        --     SevenDayData = nil
        --     sevenDayActType = actType
        -- end
    end
    --print_t(list)
    --print_t(sevenDayData)
    return list
    -- if SevenDayData == nil then
    --     SevenDayLimitTime = {}
    --     SevenDayData = {}
    --     TableReader:ForEachLuaTable(tableName, function(index, item)
    --             if SevenDayData[item.day_num] == nil then
    --                 SevenDayData[item.day_num]= {}
    --                 SevenDayData[item.day_num][item.tab_id]= {}
    --                 table.insert(SevenDayData[item.day_num][item.tab_id], item)

    --             elseif SevenDayData[item.day_num][item.tab_id] == nil then
    --                 SevenDayData[item.day_num][item.tab_id] = {}
    --                 table.insert(SevenDayData[item.day_num][item.tab_id], item)
                    
    --             elseif SevenDayData[item.day_num][item.tab_id] ~= nil then
    --                 table.insert(SevenDayData[item.day_num][item.tab_id], item)
    --             end
    --             --if item.day_num <= Player.Day7s.day then
    --                 local data = {}
    --                 data.taskId = item.id
    --                 data.dayNum = item.day_num
    --                 table.insert(SevenDayLimitTime, data)
    --             --end
    --         end)
    -- end
end

function Tool:setTheSevenDayData(tableName)
    local list1 = {}
    local list2 = {}
    --if list1 == nil then
        SevenDayLimitTime = {}
        TableReader:ForEachLuaTable(tableName, function(index, item)
                if list1[item.day_num] == nil then
                    list1[item.day_num]= {}
                    list1[item.day_num][item.tab_id]= {}
                    table.insert(list1[item.day_num][item.tab_id], item)

                elseif list1[item.day_num][item.tab_id] == nil then
                    list1[item.day_num][item.tab_id] = {}
                    table.insert(list1[item.day_num][item.tab_id], item)
                    
                elseif list1[item.day_num][item.tab_id] ~= nil then
                    table.insert(list1[item.day_num][item.tab_id], item)
                end
                --if item.day_num <= Player.Day7s.day then
                    local data = {}
                    data.taskId = item.id
                    data.dayNum = item.day_num
                    table.insert(list2, data)
                --end
            end)
    --end
    return list1, list2
end

function Tool:SevenDayRedPoint(choiseType)
    Tool:LoadSevenDayData(choiseType)
    local list = {}
    local judeList = Player.DayNs[choiseType]
    local day = Player.DayNs[choiseType].day

    if choiseType == "day7" then
        list = sevenDayDataRed
        judeList = Player.Day7s
        day = Player.Day7s.day
    elseif choiseType == "Day14s" then
        list = fourteenDayDataRed
    elseif choiseType == "offyear" then
        list = spSevenDayFirDataRed
    elseif choiseType == "SpringFestival" then
        list = spSevenDaySecDataRed
    elseif choiseType == "yuanxiaojie" then
        list = spSevenDayYuanDataRed
    end

    if list ~= nil then
        for i = 1, #list do
            if list[i] ~= nil and list[i].taskId ~= nil then
                local taskItem = list[i] 
                if judeList[taskItem.taskId].state ~= nil then
                    if judeList[taskItem.taskId].state == 2 and taskItem.dayNum <= day then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Tool.updateActivityOpen()
    if holiday_open == false then 
        Api:getActivity("","holiday", function(result)
            if result.ids == nil then 
                holiday_open=false
            else
                local count = result.ids.Count
                if count == 0 then 
                    holiday_open=false
                else 
                    holiday_icon=result.ids[0].icon
                    holiday_open=true
                end
            end 
        end)
    end 
    if like_open == false then 
        Api:getActivity("","like", function(result)
            if result.ids == nil then 
                like_open=false
            else
                local count = result.ids.Count
                if count == 0 then 
                    like_open=false
                else 
                    like_open=true
                end
            end 
        end)
    end 
end

function Tool:isRefreSevenDay()
    local state = false
    if isRefreSevenDayData then
        state = isRefreSevenDayData
        isRefreSevenDayData = false
    end
    return state
end

function Tool:getGodSkillListInfo()
    if GodSkillMenuList == nil then
        GodSkillMenuList = {}
        TableReader:ForEachLuaTable("shenbingSkill", function(index, item)
            table.insert(GodSkillMenuList,item)
        end)
    end
    return GodSkillMenuList
end

return Tool
