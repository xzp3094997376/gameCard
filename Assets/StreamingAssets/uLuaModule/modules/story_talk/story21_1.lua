-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1630"), 37, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_1631"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1632"), 37, ""},
		{ "talk", 1, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1633"), 30, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1126"), TextMap.GetValue("Text_1_1634"), 37, ""},

        { "destroytalk"},
    },

    
}

return action_lists;