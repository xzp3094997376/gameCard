local m = {}

function m:Start()
    self.btn_cdkey.isEnabled = self.inputCDKey.value ~= ""
end

function m:update(info)
    self.data = info.data
    self.delegate = info.delegate

    --self.Content.text = self.data.desc
    self.btn_cdkey.isEnabled = self.inputCDKey.value ~= ""

    --self.hero:LoadByCharId(74, "idle", function(ctl) end, false, -1)

    local keyMap = self._keyMap
    table.foreach(keyMap, function(k, v)
        if self[k] then
            self[k].Url = UrlManager.GetImagesPath(v)
        end
    end)

end

--兑换
function m:gift_key(...)
    local key = self.inputCDKey.value
    if key == "" then
        MessageMrg.show(TextMap.GetValue("Text452"))
        return
    else
        Api:CDKEy(key, function(result)
            --UIMrg:pushWindow("Prefabs/moduleFabs/userinfoModule/cdgiftList", { obj = result })
            packTool:showMsg(result, nil, 1)
        end, function(...)
            return false
        end)
    end
end

function m:onClick(go, btName)
    if btName == "btn_cdkey" then
        self:gift_key()
    end
end

return m