-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1635"), 9, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1636"), 37, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_1637"), 9, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1638"), 37, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1639"), 37, ""},


        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1640"), 37, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1641"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1642"), 37, ""},
		

        { "destroytalk"},
    },
}

return action_lists;