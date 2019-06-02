local mysdk = {}
--------- 登录--------
function mysdk:login(fn)

    Debug.Log("login")
    MySdk.Instance:setLoginDelegate(fn)
    MySdk.Instance:Login("Login")
    -- if battle.win then
    --     dataEye.levelsDrop(type, battleid, result)
    -- end
end

--------- 登出--------
function mysdk:logout(str_info)
    Debug.Log("logout")
    MySdk.Instance:Logout(str_info)
    -- if battle.win then
    --     dataEye.levelsDrop(type, battleid, result)
    -- end
end
--登陆成功服务器返回的透传字段
function mysdk:getDataExtend(exd)
	MySdk.Instance:getDataExtend(exd)
end

function mysdk:joinQQGroup(str)
    MySdk.Instance:joinQQGroup(str)
end

function mysdk:setEvent(eventName)
    MySdk.Instance:setEvent(eventName)
end

function mysdk:getDeviceID()		
	MySdk.Instance:getDeviceID();
end
function mysdk:getDeviceIDFV()		
	return MySdk.Instance:getDeviceIDFV();
end


--------- 支付弹框--------
--- int total=定额支付总金额，单位为人民币分,
--- string unitName=游戏币名称,
--- int count=数量,
--- string callBackInfo=pid+"|"+分服id+"|"+"付费类型",
--- string callBackUrl=请求服务器获取:getPayUrl()
-- money:总金额  productId :商品id  productName:商品名称  count:商品数量  info：订单号   url:回调地址
function mysdk:pay(total, productId, unitName, count, callBackInfo, callBackUrl, accountId, sign, payType, _cb, _fail_cb)
    Debug.Log("pay")
    MySdk.Instance:pay(total, productId, unitName, count, Player.playerId, Player.Info.nickname, PlayerPrefs.GetString("serverId"), PlayerPrefs.GetString("serverName"), Player.Info.level, callBackInfo, callBackUrl, accountId, sign, payType);
    local cb = function(result)
        _cb(result)
        --if(GlobalVar.dataEyeChannelID == "ios" or GlobalVar.dataEyeChannelID == "yl1" or GlobalVar.dataEyeChannelID == "yl2" ) then
		print("111111111111 GlobalVar.iosVerfy:"..tostring(GlobalVar.iosVerfy))
		if GlobalVar.iosVerfy then
            Debug.Log("pay222222")
            self:OnPaySuccessBack(result,callBackInfo);
        end
        --收集充值
        DataEye.pay(total, unitName, count)
    end
    local fail_cb = function()
        _fail_cb()
        --收集充值失败
        DataEye.payFail(total, unitName, count)
    end
    UmengAnalytics.GetPayCount(count)
    MySdk.Instance:setPayDelegate(cb, fail_cb)
    -- if battle.win then
    --     dataEye.levelsDrop(type, battleid, result)
    -- end
end
--------- 分割字符串--------
function mysdk:split(pString, pPattern)
    local Table = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end
function mysdk:OnPaySuccessBack(data,callBackInfo)
    Debug.Log("OnPaySuccessBack")
    local data1 = self:split(data,"|")
    for i,v in ipairs(data1) do
    	print("mysdk:index:" .. i .. "data:" .. v)
    end
    Debug.Log("mysdk:callBackInfo:" .. callBackInfo)
    -- body
    Api:verfyIOSPay(data1[3],callBackInfo,function ( result)
        if(result.status == "success") then
            MySdk.Instance:FinishDeal(data1[2]);
        end
        if(result.status == "duplicate") then
            MySdk.Instance:FinishDeal(data1[2]);
        end
        -- body
    end,function (result)
        print(result)
        -- body
    end)
end

--------- 退出游戏--------
function mysdk:exit(popup_cb, exit_cb)
    Debug.Log("exit")
    MySdk.Instance:setExitCallback(popup_cb, exit_cb)
    MySdk.Instance:exit();
    -- if battle.win then
    --     dataEye.levelsDrop(type, battleid, result)
    -- end
end

function mysdk:enterServer(roleId, roleName, roleLevel, zoneId, zoneName, balance, vip, partyName)
    -- body

    Debug.Log("enterServer")
    Debug.Log(roleId)
    Debug.Log(roleName)
    Debug.Log(roleLevel)
    Debug.Log(zoneId)
    Debug.Log(zoneName)
    Debug.Log(balance)
    Debug.Log(vip)
    Debug.Log(partyName)

    MySdk.Instance:setExtData("enterServer", Player.playerId, roleName, roleLevel, zoneId, zoneName, balance, vip, TextMap.GetValue("Text1472"));
end

function mysdk:createRole(roleId, roleName, roleLevel, zoneId, zoneName, balance, vip, partyName)
    -- body
    Debug.Log("createRole")
    Debug.Log(roleId)
    Debug.Log(roleName)
    Debug.Log(roleLevel)
    Debug.Log(zoneId)
    Debug.Log(zoneName)
    Debug.Log(balance)
    Debug.Log(vip)
    Debug.Log(partyName)
    MySdk.Instance:setExtData("createRole", Player.playerId, roleName, roleLevel, zoneId, zoneName, balance, vip, TextMap.GetValue("Text1472"));
end

function mysdk:init(fn)
    if (self.inited == nil) then
        self.inied = 1;
    else
        return
    end

    Debug.Log("initing sdk...")
    MySdk.Instance:initSDK(fn);

    MySdk.Instance:setLogoutDelegate(function()
        Debug.Log("logout")
        LuaMain:SDKlogout()
    end)
end

function mysdk:userCenter(str)
    -- body
    MySdk.Instance:userCenter(str)
end

function mysdk:levelUp(roleId, roleName, roleLevel, zoneId, zoneName, balance, vip, partyName)

    -- body
    Debug.Log("levelUp")
    Debug.Log(roleId)
    Debug.Log(roleName)
    Debug.Log(roleLevel)
    Debug.Log(zoneId)
    Debug.Log(zoneName)
    Debug.Log(balance)
    Debug.Log(vip)
    Debug.Log(partyName)
    local zoneID = tonumber(zoneId) or 0
    MySdk.Instance:setExtData("levelUp", Player.playerId, roleName, roleLevel, zoneID, zoneName, balance, vip, TextMap.GetValue("Text1472"));
end

--------- 传入玩家信息--------
---- string id, string roleId, string roleName, int roleLevel, int zoneId, string zoneName, int balance, int vip, string partyName
-- function MySDK:setExtData(id, roleId, roleName, roleLevel, zoneId, zoneName, balance, vip, partyName)
-- MySDK:setExtData(id, roleId, roleName, roleLevel, zoneId, zoneName, balance, vip, partyName);
-- if battle.win then
-- dataEye.levelsDrop(type, battleid, result)
-- end
-- end

return mysdk