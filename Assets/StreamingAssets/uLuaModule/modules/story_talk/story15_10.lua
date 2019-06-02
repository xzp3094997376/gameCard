-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1507"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1508"), 2, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1509"),-1 , ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1510"),-1 , ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1511"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1512"), 2, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1513"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_227"), "……￣△￣", 2, ""},
		

        { "destroytalk"},
    },
}

return action_lists;