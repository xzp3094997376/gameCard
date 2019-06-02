-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1530"), 16, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1531"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1532"), 16, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1533"),-1 , ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1534"), 16, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1535"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1536"), 16, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1537"), 16, ""},
		

        { "destroytalk"},
    },
}

return action_lists;