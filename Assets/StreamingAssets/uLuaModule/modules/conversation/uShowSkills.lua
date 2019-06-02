local heroid = selectHeroID

local action_lists = {
    { "SelectChar" },
    -- { "in", false, 217, 4, 999999, 999999, 100 },
    -- { "spell", true, 1, 1, 4, 4832 },
    -- { "spell", true, 1, 2, 4, 29859 },
    { "animate", true, 1, "free" },
    { "wait", 0.6 },
    { "spell", true, 1, 3 },
    --{ "spell", true, 1, 0 },
    { "endSelect" },
}


--print(action_lists)

return action_lists;