local m = {}

local curTab = 1 -- 1:表示加入页面，2:表示创建协会页面，3:表示创建协会页面

function m:Start()
    curTab = 1
    LuaMain:ShowTopMenu()
    Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text548"))
    self.page_for_add:CallUpdate()
end

-- function m:onEnter()
--     	print("lzh print:******** uLeague_main_no_join.lua ** onEnter()")
-- end

-- function m:onExit()
-- 	print("lzh print:******** uLeague_main_no_join.lua ** onExit()")
-- end

-- function m:OnDestroy()
-- 	print("lzh print:******** uLeague_main_no_join.lua ** OnDestroy()")
-- end

function m:onClick(go, btnName)
    if btnName == "CheckBox1" then
        if curTab == 1 then return end
        curTab = 1
        self.page_for_add:CallUpdate()
    elseif btnName == "CheckBox2" then
        if curTab == 2 then return end
        curTab = 2
    elseif btnName == "CheckBox3" then
        if curTab == 3 then return end
        curTab = 3
    end
end

return m