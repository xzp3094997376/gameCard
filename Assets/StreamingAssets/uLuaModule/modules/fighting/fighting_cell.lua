local m = {}

function m:OnDestroy()
    Events.RemoveListener("refreshData")
end

function m:update(data, index)
    self.data = data
    local id = data.droptype[0]
    self.id = id
    self.img.Url = UrlManager.GetImagesPath("sl_fight/" .. data.img .. ".png")
	self.title.Url = UrlManager.GetImagesPath("sl_fight/" .. data.title_img .. ".png")
    --self.title.spriteName= data.title_img
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
                self.red_point:SetActive(false)
            else
                self.txt_desc.text = data.desc_unlock
                BlackGo.setBlack(1, self.img.transform)
                self.lock:SetActive(false)
                if data.name == TextMap.GetValue("Text_1_341")  then 
                    m:checkIndiana()
                    Events.RemoveListener("refreshData")
                    Events.AddListener("refreshData", funcs.handler(self, self.checkIndiana)) 
				elseif data.name == TextMap.GetValue("Text_1_342") then
					self.red_point:SetActive(Tool.checkShiLianTa() or false)
				elseif data.name == TextMap.GetValue("Text_1_343") then 
					self.red_point:SetActive(Tool.checkXunLuo() or false)
				elseif data.name == TextMap.GetValue("LocalKey_595") then 
					self.red_point:SetActive(Player.TaoRenBoss.open == true)
                   Api:checkTaoRenBoss(function(result)
                        --if result.hp then
                        --    self.red_point:SetActive(true)
                        --end
                   end)
				elseif data.name == TextMap.GetValue("Text_1_344") then 
                    self.red_point:SetActive(false)
                    Api:checkBoss(function(result)
                        if result.hp then
                            self.red_point:SetActive(true)
                        end
                    end)

					-- row = TableReader:TableRowByID("worldBoss_config", 1)
					-- local arg1 = m:getTime(row.arg1)
					-- local arg2 = m:getTime(row.arg2)
					-- local h = os.date( "%H", os.time() )
					-- local min = os.date( "%M", os.time() )
     --                local tarh = tonumber(arg1[1])
     --                local tarMin = tonumber(arg1[2])
     --                if h >= arg1[1] and arg1[2] < min then
     --                   print("arg2 = " .. time)
     --                   print("t1 = " .. min)
     --               end
                elseif data.name == TextMap.GetValue("Text_1_221") then
                    self.red_point:SetActive(Tool.checkTaoRen() or false)
                elseif data.name == TextMap.GetValue("Text_1_345") then
                    self.red_point:SetActive(Tool.checkChongWu() or false)
                end
            end
        end
    end
end

function m:formatitTime(arg)
    local h = arg[1]
    local m = arg[2]
    local s = arg[3]
    local str = ""
    if h < 10 then
        str = str .. "0" .. h .. ":"
    else
        str = str .. h .. ":"
    end

    if m < 10 then
        str = str .. "0" .. m
    else
        str = str .. m
    end
    if s > 0 and s < 10 then
        str = str .. ":0" .. s
    elseif s > 0 then
        str = str .. ":" .. s
    end
    return str
end

function m:getTime(time)
    local p = string.find(time, "h")
    local h = 0
    if p then
        h = string.sub(time, 1, p - 1) or 0
    else
        p = 0
    end

    local p_m = string.find(time, "m")
    local m = 0
    if p_m then
        m = string.sub(time, p + 1, p_m - 1) or 0
    else
        p_m = p
    end
    local p_s = string.find(time, "s")
    local s = 0
    if p_m and p_s then
        s = string.sub(time, p_m + 1, p_s - 1) or 0
    end
    return { tonumber(h), tonumber(m), tonumber(s) }
end

function m:checkIndiana()
    if Tool.checkIndiana()==true then 
        self.red_point:SetActive(true)
    else 
        self.red_point:SetActive(false)
    end
end



function m:onClick(go, btnName)
    m:onSelected()
end

function m:onSelected()
    local id = self.id
    if id == 0 or id == "" or id == nil then
        MessageMrg.show(self.data.desc_lock)
        return
    end
    uSuperLink.openModule(id)
end

function m:Start()
    --ClientTool.AddClick(self.gameObject, function()
    --    m:onSelected()
    --end)
    -- self._texture = self.img_title:GetComponent(UITexture)
end

return m