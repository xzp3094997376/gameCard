local m = {}

function m:update(data)
    self.data = data
    local row = TableReader:TableRowByID("GuildSacrifice", self.data.typeId .. "")
    self.txt_jindu.text = row.progress
    self.txt_exp.text = row.exp
    self.txt_donate.text = row.contribution
    self.txt_price.text = row.consume[0].consume_arg
    self.row = row

    self.extInfo = GuildDatas:getMyGuildExt()
    if self.extInfo.sacrificeType ~= 0 then
        self.btn_canbai.isEnabled = false
        --self.hedi:SetActive(true)
    else
        self.btn_canbai.isEnabled = true
        --self.hedi:SetActive(false)
    end
    self.yichanbai:SetActive(false)
    if self.extInfo.sacrificeType == self.data.typeId then
        self.txt_btn_canbai.text = TextMap.GetValue("Text290")
        self.yichanbai:SetActive(true)
    else
        self.txt_btn_canbai.text = TextMap.GetValue("Text290")
    end
end

function m:onClick(go, btnName)
    if btnName == "btn_canbai" then
        if self.extInfo.sacrificeType ~= 0 then
            MessageMrg.show(TextMap.GetValue("Text1305"))
            -- local sprite = self.btn_canbai.gameObject:GetComponent(UISprite)
            -- sprite.color = Color.black
        elseif Player.Info.vip < tonumber(self.row.vipLimit) then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_733"),"{0}",self.row.vipLimit))
        else
            self:onWorship()
        end
        --self:onWorship()
    end
end

function m:onWorship()
    Api:worship(self.data.typeId, function(result)
        if tonumber(result.ret) == 0 then
            self.basicInfo = GuildDatas:getMyGuildInfo()
            print(self.basicInfo.experience)
            print(result.info.experience)
            self.basicInfo.experience = self.basicInfo.experience + result.info.experience
            self.basicInfo.sacrificeAmount = result.info.sacrificeAmount
            self.basicInfo.sacrificeProgress = result.info.sacrificeProgress
            self.extInfo = GuildDatas:getMyGuildExt()
            self.extInfo.contribution = self.extInfo.contribution + result.info.contribution
            self.extInfo.sacrificeType = self.data.typeId
            self.data.delegate:setBasicInfo()
            self.data.delegate:setWorkship_Process()
            self.data.delegate:setWorshipItems()

            local msg = string.gsub(TextMap.GetValue("LocalKey_734"),"{0}",result.info.sacrificeProgress)
            msg=string.gsub(msg,"{1}",result.info.experience)
            msg=string.gsub(msg,"{2}",result.info.contribution)
            if result.info.isOdds then
                msg = TextMap.GetValue("Text1310") .. msg
            end
            MessageMrg.showMove(msg)
        else
            MessageMrg.show(TextMap.GetValue("Text1188"))
        end
    end, function(result)
        print("lzh print: worship() 2222222222222222")
        print(result)
    end)
end

return m