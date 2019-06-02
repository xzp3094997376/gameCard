--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/14
-- Time: 17:03
-- To change this template use File | Settings | File Templates.
-- 排行奖励
local m = {}

function m:update(list, index,delegate)
    ClientTool.UpdateGrid("Prefabs/moduleFabs/activityModule/itemActivity", self.grid, list.li,list.delegate)
    if self.img_rank~=nil then 
        if tonumber(list.rank)~=nil and tonumber(list.rank)<=3 then
            self.txt_rank.text=""
            self.img_rank.gameObject:SetActive(true)
            self.img_rank.spriteName="jiangpai_" .. list.rank
        else 
            self.img_rank.gameObject:SetActive(false)
            local str = "[F0E77B]" .. TextMap.GetValue("Text402") .. "[-]"
            self.txt_rank.text =string.gsub(str, "{0}", "[-]" .. list.rank .. "[F0E77B]")
        end 
    else 
        local str = "[F0E77B]" .. TextMap.GetValue("Text402") .. "[-]"
        self.txt_rank.text =string.gsub(str, "{0}", "[-]" .. list.rank .. "[F0E77B]")
    end 
    if self.drag~=nil then 
        if #list.li<=2 then
            self.drag:SetActive(false)
        else 
            self.drag:SetActive(true)
        end 
    end
end 

function m:Start()
    -- self.binding:Hide("img_rank")
    Tool.SetActive(self.img_rank, false)
    if self.txt_rank == nil then
        local go = GameObject("txt_rank")
        go.transform.parent = self.gameObject.transform
        go.transform.localScale = Vector3.one
        go.transform.localPosition = Vector3(-164, 0, 0)
        self.txt_rank = go:AddComponent(UILabel)
        -- self.txt_rank.bitmapFont = actFont
        self.txt_rank.overflowMethod = UILabel.Overflow.ResizeFreely
        self.txt_rank.fontSize = 32
        self.txt_rank.depth = 10
    end
end

return m

