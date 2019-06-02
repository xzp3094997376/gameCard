--未加入公会的界面
local worship = {}
function worship:destory()
    --SendBatching.DestroyGameOject(self.binding.gameObject)
    worship = nil
    UIMrg:popWindow()
end

function worship:setData()
    local worshipData = TableReader:TableRowByUnique("unionWorship", "vip", 0)
    if worshipData == nil then
        --    print("没有值"..Player.Info.vip)
        return
    end
    self.times_txt.text = TextMap.GetValue("Text1442") .. worshipData.times
    self.labVit1.text = TextMap.GetValue("Text1443") .. worshipData.drop[0].argDrop
    self.labVit2.text = TextMap.GetValue("Text1443") .. worshipData.drop[1].argDrop
    self.labVit3.text = TextMap.GetValue("Text1443") .. worshipData.drop[2].argDrop
    self.gold_txt.text = TextMap.GetValue("Text1444") .. worshipData.drop[1].argCost
    self.crystal_txt.text = TextMap.GetValue("Text1445") .. worshipData.drop[2].argCost
end

function worship:Start()
    worship:setData()
end

function worship:onClick(go, name)
    if name == "closeBtn" then
        worship:destory()
    elseif name == "btn_1" then
        -- print("免费膜拜")
    elseif name == "btn_2" then
        --  print("金币膜拜")
    elseif name == "btn_3" then
        --    print("钻石膜拜")
    end
end

--初始化
function worship:create(binding)
    self.binding = binding
    return self
end

return worship