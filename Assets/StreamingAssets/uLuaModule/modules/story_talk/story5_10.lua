-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2209"), -1, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_294"), "……", 9, ""},
		{ "talk",1 , "player", TextMap.GetValue("Text_1_2210"), -1, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2211"), 132, ""},
		{ "talk", 1, "player", TextMap.GetValue("Text_1_2212"), -1, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2213"), 132, ""},

        { "destroytalk"},
    },

    after = {
		{ "talk",2 , TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2214"), 139, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2215"), 132, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_2216"), 139, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_1102"), "……", 132, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2217"), 132, ""},
		

        { "destroytalk"},
    },
}

return action_lists;