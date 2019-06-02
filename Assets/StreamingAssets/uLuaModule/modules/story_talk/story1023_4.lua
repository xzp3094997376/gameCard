-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_1303"), 160, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_246"), TextMap.GetValue("Text_1_1304"), 167, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_1305"), 160, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_246"), TextMap.GetValue("Text_1_1306"), 167, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_270"), TextMap.GetValue("Text_1_1307"), 160, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_246"), TextMap.GetValue("Text_1_1308"), 167, ""},

        { "destroytalk"},
    },

    
}

return action_lists;