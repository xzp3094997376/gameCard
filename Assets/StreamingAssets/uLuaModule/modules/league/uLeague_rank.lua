local m = {}

function m:update(args)
    self.datas = args
    self.svLeagueList:refresh(self.datas.list, self, true, 0)
    self.txt_rank.text = tostring(self.datas.pos)
end


function m:onClick(go, btnName)
    if btnName == "btn_close" then
        UIMrg:popWindow()
    end
end

return m