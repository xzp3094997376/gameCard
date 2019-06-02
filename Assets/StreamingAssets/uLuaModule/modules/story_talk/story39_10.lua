-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1901"), 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_1902"), 146, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1903"), 125, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_1810"), TextMap.GetValue("Text_1_1904"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1810"), TextMap.GetValue("Text_1_1905"),-1 , ""},

        { "destroytalk"},
    },
}

return action_lists;