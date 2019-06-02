-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1815"), TextMap.GetValue("Text_1_1816"),-1 , ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1817"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1818"), 9, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1819"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1820"), 9, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1821"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1822"), 9, ""},
		

        { "destroytalk"},
    },
}

return action_lists;