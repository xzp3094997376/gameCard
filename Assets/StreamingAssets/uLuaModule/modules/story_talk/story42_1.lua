-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
	{ "talk", 1, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_1966"), 139, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1967"), 16, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_1968"), 139, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_236"), TextMap.GetValue("Text_1_1969"), 30, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1970"), 125, ""},	

        { "destroytalk"},
    },

    
}

return action_lists;