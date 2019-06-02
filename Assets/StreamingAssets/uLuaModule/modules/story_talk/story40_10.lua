-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1935"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1936"), 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1937"), 2, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1938"), 16, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_1939"), 139, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1940"), 16, ""},
		

        { "destroytalk"},
    },

    after = {
		{ "talk", 2, TextMap.GetValue("Text_1_1810"), TextMap.GetValue("Text_1_1941"),-1 , ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1942"), 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_1943"), 132, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), "……", 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1944"), 125, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_1945"), 139, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_1946"), 146, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1158"), TextMap.GetValue("Text_1_1947"), 146, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1110"), TextMap.GetValue("Text_1_1948"), 153, ""},
		{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1949"), 125, ""},

        { "destroytalk"},
    },
}

return action_lists;