local startID = 0

local action_lists = {
    { "scene", "wuXianHuiLang_zhanDou" }, --加载场景
}


TableReader:ForEachLuaTable("avter",
    function(index, item)
        if index < startID then
            return false
        end
        --print(item.id)
        table.insert(action_lists, { "load", item.id })
        return false
    end)


table.insert(action_lists, { "audio", "bgm_battle03" })
table.insert(action_lists, { "enter" })
table.insert(action_lists, { "in", false, 19, 1, 99999999, 99999999, 100 })

TableReader:ForEachLuaTable("avter",
    function(index, item)
        if index < startID then
            return false
        end
        table.insert(action_lists, { "in", true, item.id, 1, 9999999, 9999999, 100 })
        table.insert(action_lists, { "wait", 2 })
        table.insert(action_lists, { "spell", true, 1, 1, 1, 17898 })
        table.insert(action_lists, { "spell", true, 1, 2, 1, 17898 })
        table.insert(action_lists, { "spell", true, 1, 3, 1, 17898 })
        table.insert(action_lists, { "spell", true, 1, 4, 1, 17898 })
        table.insert(action_lists, { "remove_char", true, 1 })
        table.insert(action_lists, { "wait", 1 })
        return false
    end)


return action_lists;