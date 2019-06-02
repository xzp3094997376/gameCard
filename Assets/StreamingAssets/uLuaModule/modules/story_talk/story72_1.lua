-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
		{ "talk", 1, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2228"), 125, ""},	
		{ "talk", 2, TextMap.GetValue("Text_1_1175"), TextMap.GetValue("Text_1_2399"), 46, ""},	
		{ "talk", 1, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_2400"), 125, ""},	

        { "destroytalk"},
    },

    
}

return action_lists;