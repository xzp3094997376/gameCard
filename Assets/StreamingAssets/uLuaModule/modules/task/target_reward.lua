local m = {}

function m:onClose(go)
    UIMrg:popWindow()
end

function m:onClick()
    self:onClose()
end

function m:update(data)
    self.data = data 
    if self.data == nil then return end
    if self.data.drop ~= nil then
        self.scrollView:refresh(self.data.drop, self, true, 0)
    end
    if self.data.data ~= nil then
        local tb = TableReader:TableRowByID("allTasks", self.data.data.id)
		local target_desc = tb.target_desc
		self.img_hero:LoadByCharId(tb.icon, "idle", function(ctl)
		end, false, -1)
        local progress = self.data.data.progress
        if tonumber(self.data.data.progress) > tonumber(self.data.data.total) then
            progress = self.data.data.total
        end
        local text = target_desc.."  [00ff00]("..progress.."/"..self.data.data.total..")[-]"
        self.txt_target.text = text
    else
        self.txt_target.text = ""
    end
end

function m:Start()
    ClientTool.AddClick(self.back, funcs.handler(self, self.onClose))
end

return m