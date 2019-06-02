-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, TextMap.GetValue("Text_1_1201"), TextMap.GetValue("Text_1_2197"), 102, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2198"), 88, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1201"), TextMap.GetValue("Text_1_2199"), 102, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2200"), 88, ""},	

        { "destroytalk"},
    },

    after = {
		{ "talk", 1, TextMap.GetValue("Text_1_1201"), "(¯﹃¯)……", 102, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2201"), 88, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1201"), TextMap.GetValue("Text_1_2202"), 102, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2203"), 88, ""},	

        { "destroytalk"},
    },
}

return action_lists;