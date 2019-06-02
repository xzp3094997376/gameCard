local m = {}
local isStart = false
function m:OnDestroy()
    collectgarbage("collect")
    isStart = false
    Events.RemoveListener('xuyegong_getReward')
    m = nil
end

function m:resetStart()
    Api:XuYeReset(function()
        Api:XuYeGongCheckInit(function()
            m:setData()
        end)
    end)
end

function m:onClick(go, name)
    if name == "btn_rule" then
        UIMrg:pushWindow("Prefabs/moduleFabs/xuyegongModule/xuYeGong_rule")
    elseif name == "btn_exchange" then
        --虚夜宫商店
        LuaMain:showShop(5)
    elseif name == "btn_again" then
        if (Player.XuYeGong.maxFightTimes - Player.XuYeGong.fightTimes) == 0 then
            MessageMrg.show(TextMap.GetValue("Text1147"))
            return
        else
            DialogMrg.ShowDialog(TextMap.GetValue("Text1148"), m.resetStart)
        end
    end
end

function m:create()
    return self
end

function m:setData()
    self.content:SetActive(true)
    self.road1.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong_road1.png")
    self.road2.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong_road2.png")
    self.road3.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong_road3.png")
    self.progressBar.value = Player.XuYeGong.prize / 15
    self.txt_ciShu.text = TextMap.GetValue("Text1149") .. (Player.XuYeGong.maxFightTimes - Player.XuYeGong.fightTimes)
    print(isStart)
    for i = 0, 14 do
        local simpleImage = self.binding.Map["simpleImage" .. (i + 1)]
        local box = self.binding.Map["box" .. (i + 1)]
        --  simpleImage:isShowGray(false)

        if isStart == false then
            if i == 14 then
                simpleImage.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong15.png")
            else
                if (i + 1) % 3 == 0 then
                    simpleImage.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong3.png")
                else
                    simpleImage.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong1.png")
                end
            end
        end

        if i >= Player.XuYeGong.jindu then
            simpleImage:isShowGray(true)
        else
            simpleImage:isShowGray(false)
        end

        if i == Player.XuYeGong.prize then
            self.content.transform.localPosition = Vector3(box.gameObject.transform.localPosition.x, box.gameObject.transform.localPosition.y, 0)
        end

        if i < Player.XuYeGong.prize then
            if i == 14 then
                simpleImage.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong15L.png")
            else
                if (i + 1) % 3 == 0 then
                    simpleImage.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong3L.png")
                else
                    simpleImage.Url = UrlManager.GetImagesPath("xuyegongImage/xuyegong1L.png")
                end
            end
        end
        simpleImage = nil
        box = nil
    end
    if Player.XuYeGong.prize == 15 then
        self.content:SetActive(false)
    end
    isStart = true
end

Events.AddListener("xuyegong_getReward",
    function(params)
        m:setData()
    end)

function m:onEnter()
    if self._onExit ~= true then return end
    self._onExit = false
    Api:XuYeGongCheckInit(function()
        m:setData()
    end)
end

function m:onExit()
    self._onExit = true
end

function m:Start()
    LuaMain:ShowTopMenu()
    Api:XuYeGongCheckInit(function(result)
        self:setData()
    end)
end

return m