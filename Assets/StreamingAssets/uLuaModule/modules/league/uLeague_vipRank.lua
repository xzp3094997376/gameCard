-- 会员战绩榜
local m = {}

function m:update(args)
    self.datas = args
    if self.datas.pos <= 0 then
        self.txt_my_rank.text = TextMap.GetValue("Text404")
    else
        self.txt_my_rank.text = tostring(self.datas.pos)
    end
    self.txt_attack_times.text = tostring(self.datas.amount)
    self.txt_hit_num.text = tostring(self.datas.hurt)

    self.svVipList:refresh(self.datas.list, self, true, 0)
    if #self.datas.list <= 0 then
        self.lbl_tip.text = TextMap.GetValue("Text1304")
        self.lbl_tip.gameObject:SetActive(true)
    else
        self.lbl_tip.gameObject:SetActive(false)
    end
end

function m:onClick(go, btnName)
    if btnName == "btn_close" then
        UIMrg:popWindow()
    end
end

return m