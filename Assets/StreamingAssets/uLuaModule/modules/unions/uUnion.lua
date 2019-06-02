--已加入协会界面
local union = {}
local memberListData = {}

function union:update()
end

function union:startShow()
    self.content:refresh(memberListData)
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureMemberData")
end

--初始化成员列表
function union:memberList()
    for i = 0, 9 do
        local unif = {}
        unif.image = ""
        unif.name = TextMap.GetValue("Text1437") .. i
        unif.lvl = 10 + i
        unif.id = i
        unif.zhiwei = ""
        memberListData[i] = unif
        unif = nil
    end
    UluaModuleFuncs.Instance.uTimer:frameTime("sureMemberData", 2, 1, self.startShow, self)
end

function union:onClick(go, name)
    if name == "btn_shop" then
        LuaMain:showShop(3)
    elseif name == "btn_xuanyan" then
        local temp = {}
        temp["label"] = self.txt_xuanyan
        local binding = UIMrg:pushWindow("Prefabs/moduleFabs/unionModule/changeExplain", temp)
        temp = nil
    elseif name == "btn_kick" then
        Tool.push("unifMoBai", "Prefabs/moduleFabs/unionModule/Worship")
    elseif name == "btn_setting" then
        Tool.push("unifSetting", "Prefabs/moduleFabs/unionModule/unionSetting")
    end
end

function union:Start()
    LuaMain:ShowTopMenu()
    union:memberList()
end

--初始化
function union:create(binding)
    self.binding = binding
    return self
end

return union