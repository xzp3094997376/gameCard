local m = {}

function m:OnDestroy()
    print("OnDestroy")
end

function m:update(data, index)
    self.data = data
    local id = data.droptype[0]
    self.id = id
    self.img.Url = UrlManager.GetImagesPath("sl_fight/" .. data.img .. ".png")
	self.title.Url = UrlManager.GetImagesPath("sl_fight/" .. data.title_img .. ".png")
    -- self.img_title.Url = UrlManager.GetImagesPath("fighting/"..data.title_img..".png")
    -- self._texture:MakePixelPerfect()


    if id == 0 or id == "" or id == nil then
        self.txt_desc.text = data.desc_lock
        BlackGo.setBlack(0.5, self.img.transform)
        self.lock:SetActive(true)
    else
        local linkData = Tool.readSuperLinkById( id)
        BlackGo.setBlack(1, self.img.transform)

        local unlockType = linkData.unlock[0].type --解锁条件
        local level = linkData.unlock[0].arg
        self.txt_desc.text = data.desc_lock
        if unlockType == "level" then
            if Player.Info.level < level then
                self.txt_desc.text = data.desc_lock
                BlackGo.setBlack(0.5, self.img.transform)
                self.lock:SetActive(true)
            else
                self.txt_desc.text = data.desc_unlock
                BlackGo.setBlack(1, self.img.transform)
                self.lock:SetActive(false)
            end
        end
    end
end

function m:onClick(go, name)
    local id = self.id
    if id == 0 or id == "" or id == nil then
        MessageMrg.show(self.data.desc_lock)
        return
    end
    if id.."" == "800" then --若为跨服竞技场，请求活动是否开启
        Api:checkCross(function (reslut)
			uSuperLink.openModule(id)
            return 
        end,function (re)
            local row = TableReader:TableRowByID("errCode", re);
            if row ~= nil then
                local desc = row.desc
                local type = row.type
                if desc == "" or desc == nil then return end
                MessageMrg.show(desc)
            end
            return 
        end)
    elseif id.."" == "805" then --跨服比武
        Api:checkContest(function (reslut)
            if reslut.flag == 1 then --比武正在进行
                uSuperLink.openModule(id)
                -- Tool.push("attack_result", "Prefabs/moduleFabs/attack/attack_result",{})
            elseif reslut.flag == 2 then --比武已结束，未关闭
                Tool.push("attack_result", "Prefabs/moduleFabs/attack/attack_result",{})
            end
        end)
    else
        uSuperLink.openModule(id)
    end
end

function m:Start()
    -- self._texture = self.img_title:GetComponent(UITexture)
end


return m