local youwant = {}

--关闭界面
function youwant:destory()
    self.Label.text = ""
    SendBatching.OpenOrCloseModule('YOUWANT', "Prefabs/moduleFabs/alertModule/youwant", { -1 }, function() end)
end


function youwant:callBack()
    self:destory()
end

function youwant:onClick(go, name)
    if name == "sure" then
        if self.Label.text ~= "" then
            local list = Split(self.Label.text, ",")
            if #list == 2 then
                Api:getWhatYouNeed2(list[1], tonumber(list[2]), toolFun:handler(self, youwant.callBack))
            elseif #list == 3 then
                Api:getWhatYouNeed(list[1], list[2], tonumber(list[3]), toolFun:handler(self, youwant.callBack))
            end
        end
    else
        self:destory()
    end
end

function Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

--初始化
function youwant:create(binding)
    self.binding = binding
    return self
end

return youwant
