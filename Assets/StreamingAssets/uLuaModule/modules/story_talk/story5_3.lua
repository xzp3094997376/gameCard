-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk",1 , TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2218"), 9, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2219"), 132, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2220"), 9, ""},
		{ "talk",1 , "player", TextMap.GetValue("Text_1_2221"), -1, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2222"), 132, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2223"), 132, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2224"), 9, ""},
		{ "talk",2 , TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_2225"), 132, ""},
		{ "talk",1 , TextMap.GetValue("Text_1_294"), TextMap.GetValue("Text_1_2226"), 9, ""},

        { "destroytalk"},
    },

    
}

return action_lists;