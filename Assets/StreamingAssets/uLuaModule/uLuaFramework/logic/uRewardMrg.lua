RewardMrg = RewardMrg or {}
RewardMrg.isRegisterAll = false
--奖励列表
function RewardMrg.getList(data)
	if RewardMrg.isRegisterAll == false then 
		RewardMrg.registerRewardAllType()
	end 
    local dropArg
    local drop
    if data:ContainsKey("dropArr") then
        dropArg = json.decode(data.dropArr:toString())
    elseif data:ContainsKey("drop") and data.drop ~= nil then
        drop = json.decode(data.drop:toString())
    end
    local list = {}

    if dropArg then
        table.foreach(dropArg, function(i, o)
            o = dropArg[i]

            table.foreach(o, function(i, v)
                local fn = RewardMrg[i]
                if fn then
                    list = fn(v, list)
                else
                    print("掉落了未知类型" .. i)
                end
            end)
        end)
    else
        if drop then
            table.foreach(drop, function(i, v)
                local fn = RewardMrg[i]
                if fn then
                    list = fn(v, list)
                else
                    print("掉落了未知类型" .. i)
                end
            end)
        end
    end


    return list
end

function RewardMrg.getDrop(drop)
	if RewardMrg.isRegisterAll == false then 
		RewardMrg.registerRewardAllType()
	end 
    local dropArg
    local drop = json.decode(drop:toString())
    local list = {}
    if drop then
        table.foreach(drop, function(i, v)
            local fn = RewardMrg[i]
            if fn then
                list = fn(v, list)
            else
                print("掉落了未知类型" .. i)
            end
        end)
    end


    return list
end

function RewardMrg.getConsume(result)
	if RewardMrg.isRegisterAll == false then 
		RewardMrg.registerRewardAllType()
	end 
    local list = {}
    local drop = nil
    if result == nil then return list end
    if (type(result) == "table") then
        drop = result.consume
    elseif result:ContainsKey("consume") then
        drop = json.decode(result.consume:toString())
    end
    if drop == nil then return list end
    table.foreach(drop, function(i, v)
        local fn = RewardMrg[i]
        if fn then
            list = fn(v, list)
        end
    end)
    return list
end

--概率掉落
function RewardMrg.getProbdropByTable(probdrop)
    --print_t(probdrop)
    if probdrop == nil then return {} end
    local list = {}
    local start = 0
    local len = 0
    if type(probdrop) == "table" then
        start = 1
        len = #probdrop
    else
        len = probdrop.Count - 1
    end
    for i = start, len do
        local item = probdrop[i]
        local type = item.type
        local arg = item.arg
        local arg2 = item.arg2
        local it = {}
        if type == "equip" then
            it = Equip:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "item" then
            local it = uItem:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "equipPiece" then
            it = EquipPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "char" then
            it = Char:new(nil, arg)
            it.lv = 0
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "pet" then
            it = Pet:new(nil, arg)
            it.lv = 0
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "petPiece" then
            it = PetPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "yuling" then
            it = Yuling:new(arg)
            it.lv = 0
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "yulingPiece" then
            it = YulingPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "ghostPiece" then
            it = GhostPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "ghost" then
            it = Ghost:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "fashion" then
            it = Fashion:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "charPiece" then
            it = CharPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "renling" then
            it = RenLing:new(arg)
            it.rwCount = arg2
            table.insert(list, it) 
        elseif type == "reel" then
            it = Reel:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "reelPiece" then
            it = ReelPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "donate" then
            it = ReelPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "treasure" then
            it = Treasure:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type =="drop" then 
            local drop = TableReader:TableRowByID(arg,arg2)
            local droplist = RewardMrg.getProbdropByTable(drop.drop)
            for i=1,#droplist do
                table.insert(list, droplist[i])
            end
        else
            local it = uRes:new(type, arg)
            table.insert(list, it)
        end
        it = nil
    end
    return list
end

--概率掉落
function RewardMrg.getConsumeTable(probdrop, sameChardict)
    if probdrop == nil then return {} end
    local list = {}
    local start = 0
    local len = 0
    if type(probdrop) == "table" then
        start = 1
        len = #probdrop
    else
        len = probdrop.Count - 1
    end
    for i = start, len do
        local item = probdrop[i]
        local type = item.consume_type
        local arg = item.consume_arg
        local arg2 = item.consume_arg2
        local it = {}
        if type == "equip" then
            it = Equip:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "item" then
            local it = uItem:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "equipPiece" then
            it = EquipPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "char" then
            it = Char:new(nil, arg)
            it.lv = 0
            it.rwCount = arg2
            table.insert(list, it)
		elseif type == "sameChar" then 
            it = Char:new(nil, sameChardict)
            it.lv = 0
            it.rwCount = arg
            table.insert(list, it)
        elseif type == "charPiece" then
            it = CharPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
		elseif type == "pet" then
            it = Pet:new(nil, arg)
            it.lv = 0
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "petPiece" then
            it = PetPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "yuling" then
            it = Yuling:new(arg)
            it.lv = 0
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "yulingPiece" then
            it = YulingPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "fashion" then
            it = Fashion:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "reel" then
            it = Reel:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "ghostPiece" then
            it = GhostPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "ghost" then
            it = Ghost:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "reelPiece" then
            it = ReelPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "donate" then
            it = ReelPiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "renling" then
            it = RenLing:new(arg)
            it.rwCount = arg2
            table.insert(list, it) 
        elseif type == "treasure" then
            it = Treasure:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        elseif type == "treasurePiece" then
            it = TreasurePiece:new(arg)
            it.rwCount = arg2
            table.insert(list, it)
        else
            local it = uRes:new(type, arg)
            table.insert(list, it)
        end
        it = nil
    end
    return list
end

function RewardMrg.getDropItem(drop)
    local it = {}
    local type = drop.type
    if type == "equip" then
        it = Equip:new(drop.arg)
        it.rwCount = drop.arg2  
    elseif type == "item" then
        it = uItem:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "char" then
        it = Char:new(nil, drop.arg)
        it.rwCount = drop.arg2
    elseif type == "charPiece" then
        it = CharPiece:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "pet" then
        it = Pet:new(nil, drop.arg)
        it.rwCount = drop.arg2
    elseif type == "petPiece" then
        it = PetPiece:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "yuling" then
        it = Yuling:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "yulingPiece" then
        it = YulingPiece:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "fashion" then
        it = Fashion:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "ghostPiece" then
        it = GhostPiece:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "ghost" then
        it = Ghost:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "treasure" then
        it = Treasure:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "treasurePiece" then
        it = TreasurePiece:new(drop.arg)
        it.rwCount = drop.arg2
    elseif type == "renling" then
        it = RenLing:new(drop.arg)
        it.rwCount = drop.arg2
    else
        it = uRes:new(drop.type, drop.arg)
        it.rwCount = drop.arg
    end
    return it
end

--奖励类型
function RewardMrg.getConsumeByTable(consume)
    local list = {}
    for i = 0, consume.Count - 1 do
        local type = consume[i].consume_type
        local arg = consume[i].consume_arg
        local arg2 = consume[i].consume_arg2

        if arg2 ~= 0 and arg2 ~= "" then
            table.insert(list, {
                name = arg, --TableReader:TableRowByUnique(type,"name",arg),
                count = arg2,
                type = type
            })
        elseif type == "money" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_99"),
                count = arg,
                type = type
            })
        elseif type == "gold" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_170"),
                count = arg,
                type = type
            })
        elseif type == "hunyu" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_2903"),
                count = arg,
                type = type
            })
        elseif type == "vstime" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_2904"),
                count = arg,
                type = type
            })
        elseif type == "soul" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_2905"),
                count = arg,
                type = type
            })
        elseif type == "herotime" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_2906"),
                count = arg,
                type = type
            })
        elseif type == "donate" then
            table.insert(list, {
                name = TextMap.GetValue("Text_1_2907"),
                count = arg,
                type = type
            })
        end
    end
    return list
end

--注册奖励类型
function registerRewardType(type, func)
    if RewardMrg[type] then return end
    RewardMrg[type] = func
end

--角色
registerRewardType("char", function(list, mList)
    local count = table.getn(mList) or 0
    table.foreach(list, function(i, v)
        local ch = Char:new(nil, v)
        ch.lv = 0
        ch.rwCount = 1
        table.insert(mList, ch)
    end)
    return mList
end)

--宠物
registerRewardType("pet", function(list, mList)
    local count = table.getn(mList) or 0
    table.foreach(list, function(i, v)
        local ch = Pet:new(nil,i)
        ch.lv = 0
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

--宠物碎片
registerRewardType("petPiece", function(list, mList)
    table.foreach(list, function(id, v)
        local ch = PetPiece:new(id)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

--御灵
registerRewardType("yuling", function(list, mList)
    local count = table.getn(mList) or 0
    table.foreach(list, function(i, v)
        print(i)
        local ch = Yuling:new(i)
        ch.lv = 0
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

--御灵碎片
registerRewardType("yulingPiece", function(list, mList)
    table.foreach(list, function(id, v)
        local ch = YulingPiece:new(id)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)


--灵魂石
registerRewardType("charPiece", function(list, mList)
    table.foreach(list, function(id, v)
        local ch = CharPiece:new(id)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

registerRewardType("charPieceSplit", function(list, mList)
    table.foreach(list, function(id, v)
        local ch = CharPiece:new(id)
        ch.getType = function() return "charPieceSplit" end
        --        ch.star = v.star
        ch.typeIndex = 4
        ch.rwCount = v.num
        table.insert(mList, ch)
    end)
    return mList
end)

--道具
registerRewardType("item", function(list, mList)
    table.foreach(list, function(id, v)
        local it = uItem:new(id, v)
        it.rwCount = v
        table.insert(mList, it)
    end)
    return mList
end)

--忍灵
registerRewardType("renling", function(list, mList)
    table.foreach(list, function(id, v)
        local it = RenLing:new(id, v)
        it.rwCount = v
        table.insert(mList, it)
    end)
    return mList
end)

--时装转时装精华
registerRewardType("fashion1", function(list, mList)
    MessageMrg.show(TextMap.getText('FASHION_REPEAT'))
    table.foreach(list, function(k, m)
        table.foreach(m, function(i, v)
            local fn = RewardMrg[i]
            if fn then
                mList = fn(v, mList)
            else
                print("掉落了未知类型" .. i)
            end
        end)
    end)
    return mList
end)

--时装
registerRewardType("fashion", function(list, mList)
    table.foreach(list, function(id, v)
        local it = Fashion:new(v)
        it.rwCount = 1
        table.insert(mList, it)
    end)
    return mList
end)

--装备
registerRewardType("equip", function(list, mList)
    table.foreach(list, function(id, v)
        local eq = Equip:new(id)
        eq.rwCount = v
        table.insert(mList, eq)
    end)
    return mList
end)

--装备碎片
registerRewardType("equipPiece", function(list, mList)
    table.foreach(list, function(id, v)
        local eq = EquipPiece:new(id, v)
        eq.rwCount = v
        table.insert(mList, eq)
    end)
    return mList
end)



--卷轴
registerRewardType("reel", function(list, mList)
    table.foreach(list, function(id, v)
        local rl = Reel:new(id)
        rl.rwCount = v
        table.insert(mList, rl)
    end)
    return mList
end)

--卷轴碎片
registerRewardType("reelPiece", function(list, mList)
    table.foreach(list, function(id, v)
        local rl = ReelPiece:new(id)
        rl.rwCount = v
        table.insert(mList, rl)
    end)
    return mList
end)

registerRewardType("ghost", function(list, mList)
    table.foreach(list, function(i, v)
        local ch = Ghost:new(i)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

registerRewardType("ghostPiece", function(list, mList)
    local count = table.getn(mList) or 0
    table.foreach(list, function(i, v)
        local ch = GhostPiece:new(i)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

registerRewardType("treasure", function(list, mList)
    local count = table.getn(mList) or 0
    table.foreach(list, function(i, v)
        local ch = Treasure:new(i)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

registerRewardType("treasurePiece", function(list, mList)
    local count = table.getn(mList) or 0
    table.foreach(list, function(i, v)
        local ch = TreasurePiece:new(i)
        ch.rwCount = v
        table.insert(mList, ch)
    end)
    return mList
end)

local function getCurrency(key, list, mList)
    local rl = uRes:new(key, list)
    table.insert(mList, rl)
    return mList
end

function RewardMrg.registerRewardAllType()
    TableReader:ForEachLuaTable("resourceDefine", function(index, item)
        local tp = item.name
        registerRewardType(tp, function(list, mList)
            return getCurrency(tp, list, mList)
        end)
        return false
    end)
	RewardMrg.isRegisterAll = true
end

return RewardMrg