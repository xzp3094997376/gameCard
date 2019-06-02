--未加入公会的界面
local applyfor = {}
local memberListData = {}



function applyfor:doresult(id)
    memberListData[id] = nil
    self.content:refresh(memberListData)
end

function applyfor:startShow()
    self.content:refresh(memberListData)
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("memberListData")
end

function applyfor:Start()
    LuaMain:ShowTopMenu()
    for i = 0, 9 do
        local unif = {}
        unif.image = ""
        unif.name = TextMap.GetValue("Text1435") .. i
        unif.lvl = 10 + i
        unif.id = 1000 + i
        unif.fun = self
        memberListData[unif.id] = unif
        unif = nil
    end
    UluaModuleFuncs.Instance.uTimer:frameTime("memberListData", 2, 1, self.startShow, self)
end

--初始化
function applyfor:create(binding)
    self.binding = binding
    return self
end

return applyfor