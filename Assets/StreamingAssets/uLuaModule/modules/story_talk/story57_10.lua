-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
	{ "talk", 2, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2176"), 81, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2177"), 88, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2178"), 81, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2179"), 88, ""},	

        { "destroytalk"},
    },

    after = {
	{ "talk", 2, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2180"), 81, ""},	
	{ "talk", 1, TextMap.GetValue("Text_1_32"), TextMap.GetValue("Text_1_2181"), 88, ""},	
	{ "talk", 2, TextMap.GetValue("Text_1_1219"), TextMap.GetValue("Text_1_2182"), 81, ""},	

        { "destroytalk"},
    },
}

return action_lists;