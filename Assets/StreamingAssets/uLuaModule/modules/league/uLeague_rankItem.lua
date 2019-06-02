local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.index = index
    self.delegate = delegate

    self:setData(data)
    self:setRankUI(index)
end

function m:setData(data)
    self.img_icon.spriteName = tostring(data.icon)
    self.lbl_level.text = tostring(data.guildLevel)
    self.lbl_leagueName.text = data.guildName
    self.lbl_masterName.text = data.masterNickname
    self.lbl_memberNum.text = data.playerAmount .. "/" .. data.playerAmountLimit
end

function m:setRankUI(rank)
    rank = rank + 1
    if rank > 3 then
        self.lbl_rank.gameObject:SetActive(true)
        self.img_rank.gameObject:SetActive(false)
        self.lbl_rank.text = tostring(rank)
    else
        self.lbl_rank.gameObject:SetActive(false)
        self.img_rank.gameObject:SetActive(true)
        if rank == 1 then
            self.img_rank.spriteName = "Jingjichang_paihang_1"
        elseif rank == 2 then
            self.img_rank.spriteName = "Jingjichang_paihang_2"
        else
            self.img_rank.spriteName = "Jingjichang_paihang_3"
        end
    end
end

return m