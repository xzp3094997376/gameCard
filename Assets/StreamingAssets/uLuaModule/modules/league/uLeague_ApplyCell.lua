-- 申请公会列表页面下的一个item项
local m = {}

function m:update(data, index, delegate)
    self.data = data
    self.delegate = delegate
    self:setData(data)
end

function m:setData(data)
    self.img_touxiang:setImage(data.icon, packTool:getIconByName(data.icon))
    self.txt_lv.text = tostring(data.level)
    self.txt_mingzi.text = data.nickname
    self.txt_zhanli.text = tostring(data.fight)
    self.createTime = data.createTime
    self:setCreateTime(data.createTime)
    --self.txt_lixian.text = data.online		-- 缺少信息
end

function m:getFormatTime(time)
    local tab = ""
    if time then
        tab = os.date('{%m-%d %H:%H}', time)
    else
        tab = os.date('{%m-%d %H:%H}')
    end
    return tab
end

function m:setCreateTime(createTime)
    if createTime == 0 then
        self.txt_lixian.text = TextMap.GetValue("Text1169")
    else
        local now = os.date("*t")
        local offtime = os.date("*t", createTime / 1000)
        if now.year > offtime.year or now.month > offtime.month then
            self.txt_lixian.text = "[00ff35]" .. TextMap.GetValue("Text1170")
        else
            local strTime = self:getFormatTime(tonumber(createTime) / 1000)
            print(strTime)
            if now.day > offtime.day then
                self.txt_lixian.text =string.gsub(TextMap.GetValue("LocalKey_713"),"{0}",now.day - offtime.day)
            else
                if now.hour > offtime.hour then
                    self.txt_lixian.text =string.gsub(TextMap.GetValue("LocalKey_714"),"{0}",now.hour - offtime.hour)
                else
                    if now.min > offtime.min then
                        self.txt_lixian.text =string.gsub(TextMap.GetValue("LocalKey_715"),"{0}",now.min - offtime.min)
                    else
                        self.txt_lixian.text = TextMap.GetValue("Text1174")
                    end
                end
            end
        end
    end
end

-- 批准
function m:onApprove(...)
    print(self.data.playerId)
    Api:agreeJoin(true, self.data.playerId, function(result)
        print("lzh print: agreeJoin 1111111111111111")
        print(result.ret)
        local intRet = tonumber(result.ret)
        if intRet == 0 then
            MessageMrg.show(TextMap.GetValue("Text1175"))
            self.delegate:getApplyList()
        elseif intRet == 1010 then
            MessageMrg.show(TextMap.GetValue("Text1176"))
            self.delegate:getApplyList()
        elseif intRet == 1037 then
            MessageMrg.show(TextMap.GetValue("Text1177"))
        else
            MessageMrg.show(TextMap.GetValue("Text1178") .. result.ret)
        end
    end, function(result)
        print("lzh print: agreeJoin 2222222222222222")
    end)
end

-- 拒绝
function m:onRefuse(...)
    print("222222222222xxxxxxxxxxxxxxxxxxxx")
    print(self.data.playerId)
    Api:agreeJoin(false, self.data.playerId, function(result)
        print("lzh print: agreeJoin 1111111111111111")
        print(result.ret)
        local intRet = tonumber(result.ret)
        if intRet == 0 then
            MessageMrg.show(TextMap.GetValue("Text1179"))
            self.delegate:getApplyList()
        else
            MessageMrg.show(TextMap.GetValue("Text1180") .. result.ret)
        end
    end, function(...)
        print("lzh print: agreeJoin 2222222222222222")
        print(result)
    end)
end

function m:onClick(go, name)
    if name == "btn_approve" then
        self:onApprove()
    elseif name == "btn_refuse" then
        self:onRefuse()
    end
end

return m