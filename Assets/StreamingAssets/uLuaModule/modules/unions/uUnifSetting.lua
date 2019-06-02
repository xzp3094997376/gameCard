--协会设置界面
unionSetting = {}
local memberListData = {}

--关闭界面
function unionSetting:OnDestroy()
    unionSetting = nil
    memberListData = nil
    -- print("清空数据")
end

function unionSetting:startShow()
    self.content:refresh(memberListData)
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("memberListData")
end


--初始化成员列表
function unionSetting:memberList()
    for i = 0, 9 do
        local unif = {}
        unif.image = ""
        unif.name = TextMap.GetValue("Text1437") .. i
        unif.lvl = 10 + i
        unif.id = i
        unif.zhiwei = ""
        unif.type = "setting"
        memberListData[i] = unif
        unif = nil
    end
    UluaModuleFuncs.Instance.uTimer:frameTime("memberListData", 2, 1, self.startShow, self)
end

function unionSetting:onClick(go, name)
    if name == "btn_breakup" then
        --    print("erqwe")
    elseif name == "btn_changeicon" then
        --   print("shezhi")
    elseif name == "btn_apply" then
        Tool.push("unifMemberList", "Prefabs/moduleFabs/unionModule/applyForList")
    elseif name == "btn_bangzhu" then
        --    print("shezhi")
    elseif name == "btn_fubangzhu" then
        --    print("shezhi")
    elseif name == "btn_getout" then
        --   print("34123")
    end
end

function unionSetting:Start()
    LuaMain:ShowTopMenu()
    unionSetting:memberList()
    -- print(Player.playerId)
end

--初始化
function unionSetting:create(binding)
    self.binding = binding
    return self
end

return unionSetting