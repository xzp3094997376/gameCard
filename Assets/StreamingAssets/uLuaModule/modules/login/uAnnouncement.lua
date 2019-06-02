--通知界面
local mNotice = {}

function mNotice:Start()
 
end

function mNotice:onClick(go, name)
    UIMrg:popWindow()
    if self.data ~= nil and self.data.fun ~= nil then
        self.data:fun()
        self.data = nil
    end
    mNotice = nil
end

function mNotice:update(tableData)
    self.data = tableData
    if self.data ~= nil and self.data.fun ~= nil then
        local str = decodeURI(self.data.msg)
        self.richText:ParseValueURL(str)
    else
        Api:getNoticeInfo(function(result)
            if result ~= nil and result.info ~= "" then
                local str = decodeURI(result.info)
                self.richText:ParseValueURL(str)
            else
                self.richText:ParseValue(TextMap.GetValue("Text1318"))
            end
        end)
    end
end

return mNotice
