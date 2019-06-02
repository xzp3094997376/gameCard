local r = {}

function r:update(data)
    local titleName = data.title
    local list = data.drop
    self.delegate = data.delegate
    MusicManager.playByID(51)
    print("guolaie ")
    --	table.foreach(list, function ( k, d )
    --- -		local v = d.v
    -- -- print("v .type "..v.type)
    -- -- print("v arg "..v.arg)
    -- -- print("v arg2 "..v.arg2)
    --
    -- end)
    -- print(titleName)
    -- print("list length "..table.getn(list))
    if titleName == nil then
        titleName = "jingliicon"
    end

    self.title.Url = UrlManager.GetImagesPath("tasksImage/" .. titleName .. ".png")
    --ClientTool.UpdateGrid("Prefabs/moduleFabs/chapterModule/ItemIcon", self.Grid, list)
    self.itemsList = ClientTool.UpdateGrid("Prefabs/moduleFabs/achievementModule/taskItemIcon", self.Grid, list)
end

function r:Start(...)
    ClientTool.AddClick(self.bg, function()
        self.delegate:playAnimation()
        UIMrg:popWindow()
        if GuideMrg:isPlaying() then
            Messenger.Broadcast("RewardTaskSucc")
        end
    end)
end

return r