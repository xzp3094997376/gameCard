local m = {}

function m:update(data)
    self.Sprite:SetActive(false)
    self.rank.text = data.rank
    self.gx_reward.text = data.gongxun
    self.dps_reward.text = data.dps
    if data.index % 2 == 0 then
    	self.Sprite:SetActive(true)
    end
end

return m