-- { "talk"--, 1, "朽木露琪亚", "又有虚了，一护，走！", 1 },
-- talk, 显示方式1左 2右 3中， "朽木露琪亚"--显示名字， "又有虚了，一护，走！"---对话内容， 1 --模型ID
--{ "destroytalk"}, --结束删除动画
--before --开始前
--after -- 结束后
local action_lists = {
    before = {
{ "talk", 1, TextMap.GetValue("Text_1_1152"), "……", 125, ""},	
{ "talk", 2, "player", TextMap.GetValue("Text_1_1950"), -1, ""},	
{ "talk", 1, TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_1951"), 132, ""},	
{ "talk", 2, TextMap.GetValue("Text_1_1152"), TextMap.GetValue("Text_1_1952"), 125, ""},	
{ "talk", 1, TextMap.GetValue("Text_1_1102"), TextMap.GetValue("Text_1_1953"), 132, ""},	
{ "talk", 2, TextMap.GetValue("Text_1_1112"), TextMap.GetValue("Text_1_1954"), 139, ""},	
{ "talk", 1, TextMap.GetValue("Text_1_1114"), TextMap.GetValue("Text_1_1955"), 16, ""},	
{ "talk", 2, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1956"), 2, ""},	
{"talk", 1, TextMap.GetValue("Text_1_227"), TextMap.GetValue("Text_1_1957"), 2, ""},

        { "destroytalk"},
    },

    
}

return action_lists;