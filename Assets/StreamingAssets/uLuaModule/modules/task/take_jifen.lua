local m = {}


function m:update()
    for i = 1, 4 do
        self["box" .. i]:CallUpdateWithArgs(i, "task")
    end
    self.txt_jife.text = "[ffff96]" ..string.gsub(TextMap.GetValue("Text129"),"{0}","[-][ffffff]"..Player.Tasks.point.."[-]")

    self.slider.value = Player.Tasks.point / self.maxJiFei
end

function m:Start()
    -- self.txt_jife.bitmapFont = GameManager.GetFont()
    -- self.txt_desc.bitmapFont = GameManager.GetFont()
    self.slider.value = 0
    self.maxJiFei = TableReader:TableRowByID("allTasks_config", 1).arg1
    local desc = TableReader:TableRowByID("allTasks_config", 2).type
    self.txt_desc.text = desc
end

return m