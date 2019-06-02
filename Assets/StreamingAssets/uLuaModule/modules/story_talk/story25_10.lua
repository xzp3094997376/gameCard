-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1317"), TextMap.GetValue("Text_1_1695"), 116, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1696"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1697"), TextMap.GetValue("Text_1_1698"), 273, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1317"), TextMap.GetValue("Text_1_1699"), 116, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1700"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1701"), 30, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1702"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1703"), 30, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_1704"), 146, ""},
		

        { "destroytalk"},
    },
}

return action_lists;