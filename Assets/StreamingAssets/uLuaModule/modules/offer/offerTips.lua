local m = {}

function m:update(tb)
    local desc = ""
    local cfg = TableReader:TableRowByID("specialChapter_config", tb.chapter)
    desc = desc .. cfg.remark
    self.binding:SetLabelAlignment(self.txt_only, cfg.desc, 16)
    self.txt_only.text = cfg.desc
    self.txt_time.text = desc
    local img = cfg.stage_icon
    self.img_tittle.Url = UrlManager.GetImagesPath("offer_challenge_image/" .. img .. ".png")
    local probdrop = tb.probdrop
    local list = RewardMrg.getProbdropByTable(probdrop)
    ClientTool.UpdateGrid("Prefabs/moduleFabs/offer_challenge/item_icon", self.itemList, list, self)
end

function m:create()
    return self
end

return m