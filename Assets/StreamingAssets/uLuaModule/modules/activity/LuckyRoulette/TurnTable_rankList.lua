local m = {}

function m:Start()
end

function m:update(data)
    self.list = data.list
    self.me = data.me
    if self.list == nil or self.me == nil then return end
    self.jifen.text ="[F0E77B]" .. TextMap.GetValue("Text407") .. "[-]" ..self.me.point
    if self.me.rank.."" == "9999" then
        self.rank.text = "[F0E77B]" .. TextMap.GetValue("Text1674") .. "[-]" .. TextMap.GetValue("Text404")
    else 
        self.rank.text = "[F0E77B]" .. TextMap.GetValue("Text1674") .. "[-]" .. self.me.rank
    end
    self.scrollView:refresh(self.list, self, false, 0)
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m