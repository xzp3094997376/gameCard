local zerochapter = {}

--关闭界面
function zerochapter:OnDestroy()
end

--开始
function zerochapter:Start()
    LuaMain:ShowTopMenu(2)
    local tableMap = self.binding.Map
    table.foreach(tableMap,
        function(i, v)
            if i ~= "button1" and i ~= "button2" then
                v.Url = UrlManager.GetImagesPath("chapterImage/" .. i .. ".png")
                if i ~= "0_1" and i ~= "0_2" then
                    v:changeColor({ 0.4, 0.4, 0.4 })
                end
            end
        end)
end

function zerochapter:onClick(go, name)
    UIMrg:pushObject(GameObject())
    if name == "button1" then
        TranslateScripts.Inst:ExcuteLuaFile("uLuaModule/modules/conversation/battle_show1.lua")
    else
        TranslateScripts.Inst:ExcuteLuaFile("uLuaModule/modules/conversation/battle_show2.lua")
    end
end

--初始化
function zerochapter:create(binding)
    self.binding = binding
    return self
end

return zerochapter
