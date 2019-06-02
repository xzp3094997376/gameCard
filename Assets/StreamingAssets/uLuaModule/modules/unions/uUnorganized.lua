--未加入公会的界面
local unorganized = {}
local joinData = {}
local searchData = {}

function unorganized:setCheckinData()
end

function unorganized:update()
end



function unorganized:startNorTime()
    self.joinScrollView:refresh(joinData)
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureJoinData")
end

function unorganized:initJoin()
    for i = 0, 9 do
        local unif = {}
        unif.image = ""
        unif.name = TextMap.GetValue("Text1437") .. i
        unif.number =string.gsub(TextMap.GetValue("LocalKey_760"),"{0}",i)
        unif.needlvl =string.gsub(TextMap.GetValue("LocalKey_761"),"{0}",(10 + i))
        unif.id = i
        unif.desc = TextMap.GetValue("Text1440") .. i
        joinData[i] = unif
        unif = nil
    end
    UluaModuleFuncs.Instance.uTimer:frameTime("sureJoinData", 2, 1, self.startNorTime, self)
end

--创建界面，创建协会
function unorganized:createUnif()
    --  print("创建界面")
end


function unorganized:startSearchData()
    self.serchScrollView:refresh(searchData)
    UluaModuleFuncs.Instance.uTimer:removeFrameTime("sureSearchData")
end

--查找界面，查找协会
function unorganized:searchUnif()
    for i = 0, 2 do
        local unif = {}
        unif.image = ""
        unif.name = TextMap.GetValue("Text1437") .. i
        unif.number = string.gsub(TextMap.GetValue("LocalKey_760"),"{0}",i)
        unif.needlvl = string.gsub(TextMap.GetValue("LocalKey_761"),"{0}",(10 + i))
        unif.id = i
        unif.desc = TextMap.GetValue("Text1441") .. i
        searchData[i] = unif
        unif = nil
    end
    UluaModuleFuncs.Instance.uTimer:frameTime("sureSearchData", 2, 1, self.startSearchData, self)
end

function unorganized:onClick(go, name)
    if name == "CheckBox1" then
        unorganized:initJoin()
    elseif name == "create_btn" then
        unorganized:createUnif()
    elseif name == "btn_search" then
        unorganized:searchUnif()
    end
end

function unorganized:Start()
    LuaMain:ShowTopMenu()
    unorganized:initJoin()
end

--初始化
function unorganized:create(binding)
    self.binding = binding
    return self
end

return unorganized