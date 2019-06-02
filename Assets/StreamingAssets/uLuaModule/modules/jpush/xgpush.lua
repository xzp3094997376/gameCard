local m = {}

function m:init()
    -- 初始化
    PushManager.InitPush(GlobalVar.dataEyeChannelID,true);
    PushManager.ClearLocalNotifications();

    local cur_timestamp = os.time()
    cur_date_timestamp = math.floor(cur_timestamp/(24*60*60))*60*60*24
    print(cur_date_timestamp)
    local one_hour_timestamp = 24*60*60;
    TableReader:ForEachLuaTable("Pushconfig",
        -- 设置本地推送
        function(index, item)
            if item.type == "time" then
                local notification = item.des or ""
                local hour = tonumber(string.sub(item.args1, 1, 2)) - 8 or 0
                local minute = tonumber(string.sub(item.args1, 4, 5)) or 0
                for i=0,10 do
                    repeat
                        local timestamp = hour*60*60+minute*60+i*one_hour_timestamp+cur_date_timestamp
                        if timestamp < cur_timestamp then
                            break
                        end
                        -- print("推送时间:"..timestamp)
                        PushManager.addLocalNotification(TextMap.GetValue("Text1146"),notification,tostring(timestamp))
                    until true
                end
            end
            return false
        end)
    -- PushManager.addLocalNotificationLoop("测试测试","notification",1,1)
end

return m