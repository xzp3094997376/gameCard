local m = {}

function m:init()
    -- 初始化
    JPushManager.Instance:InitJPush();
    local id_basic = 1000
    -- 读取配置表
    -- TableReader:ForEachLuaTable("Pushconfig",
    --     -- 设置本地推送
    --     function(index, item)
    --         if item.type == "time" then
    --             local timeStr = "2015-01-01 " .. item.args1;
    --             --print("lzh ************* jpush.lua - init: " .. timeStr)
    --             local notification = item.des
    --             local gapTime = 86400000 --24*60*60*1000
    --             id_basic = id_basic + 1
    --             JPushManager.Instance:removeLocalNotification(id_basic)
    --             JPushManager.Instance:addLocalNotificationLoop2(id_basic, notification, timeStr, gapTime, 15);
    --         end
    --         return false
    --     end)
end

return m