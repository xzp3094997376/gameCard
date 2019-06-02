local lasnochesClick = {}

--设置基本信息
function lasnochesClick:setData()
end

function lasnochesClick:update(tableData)
    self.data = tableData
end

--小于当前领奖进度的： 显示敌人详细信息
--等于当前领奖进度的： 点击领取奖励
--等于当前进度的：  显示敌人详细信息，并显示挑战
--大于当前领奖进度的：显示宝箱的信息
function lasnochesClick:onClick(go, name)
    if self._keyMap["index"] > (Player.XuYeGong.jindu + 1) then
        local temp = {}
        temp.money = Player.XuYeGong.prizeMoney[self._keyMap["index"]]
        UIMrg:pushWindow("Prefabs/moduleFabs/xuyegongModule/xuyegongTips", temp)
        temp = nil
        return
    end

    if self._keyMap["index"] == Player.XuYeGong.jindu and self._keyMap["index"] == (Player.XuYeGong.prize + 1) then --可领取奖励
    Api:XuYeGongPrize(self._keyMap["index"],
        function(result)
            if result.drop ~= nil then
                local someData = {}
                someData.obj = result
                UIMrg:pushWindow("Prefabs/moduleFabs/xuyegongModule/xuyegongGet", someData)
                someData = nil
            end
        end)
    return
    end

    if self._keyMap["index"] <= Player.XuYeGong.jindu then
        local temp = {}
        temp.currentIndex = self._keyMap["index"]
        UIMrg:pushWindow("Prefabs/moduleFabs/xuyegongModule/xuYeGong_anemy", temp)
        temp = nil
        return
    end

    if self._keyMap["index"] == (Player.XuYeGong.jindu + 1) and self._keyMap["index"] == (Player.XuYeGong.prize + 1) then --可战斗
    local temp = {}
    temp.currentIndex = self._keyMap["index"]
    UIMrg:pushWindow("Prefabs/moduleFabs/xuyegongModule/xuYeGong_anemy", temp)
    temp = nil
    return
    end
end

--初始化
function lasnochesClick:create(binding)
    self.binding = binding
    return self
end

return lasnochesClick