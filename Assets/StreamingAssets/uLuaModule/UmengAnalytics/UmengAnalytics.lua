local umengAnalytics = {} 

--支付接口
--<param name="cash">真实币数量.</param>
--<param name="source">支付渠道.</param
--<param name="coin">虚拟币数量.</param>
function umengAnalytics.Pay(cash, source, coin)
	print ("umengAnalytics:Pay:"..cash.." + "..source.." + "..coin)
	--UmengAnalyticsTool.Pay(cash, source, coin)
end

--支付并且购买道具
--<param name="cash">真实币数量.</param>
--<param name="source">支付渠道.</param>
--<param name="item">道具ID.</param>
--<param name="amount">道具数量.</param>
--<param name="price">道具单价.</param>
function umengAnalytics.PayButItem(cash, source, item, amount, price)
	print ("umengAnalytics:PayButItem:"..cash.." + "..source.." + "..item.." + "..amount.." + "..price)
	--UmengAnalyticsTool.PayButItem(cash, source, item, amount, price)
end

--购买道具
--<param name="item">道具ID.</param>
--<param name="amount">道具数量.</param>
--<param name="price">道具单价.</param>
function umengAnalytics.Buy(item, amount, price)
	print ("umengAnalytics:Buy:"..item.." + "..amount.." + "..price)
	--UmengAnalyticsTool.Buy(item, amount, price)
end

--使用道具
--<param name="item">道具ID.</param>
--<param name="amount">道具数量.</param>
--<param name="price">道具单价.</param>
function umengAnalytics.Use(item, amount, price)
	print ("umengAnalytics:Use:"..item.." + "..amount.." + "..price)
	--UmengAnalyticsTool.Use(item, amount, price)
end

--进入关卡
function umengAnalytics.StartLevel(level)
	print ("umengAnalytics:StartLevel:"..level)
	--UmengAnalyticsTool.StartLevel(level)
end

--通过关卡
function umengAnalytics.FinishLevel(level)
	print ("umengAnalytics:FinishLevel:"..level)
	--UmengAnalyticsTool.FinishLevel(level)
end

--未通过关卡
function umengAnalytics.FailLevel(level)
	print ("umengAnalytics:FailLevel:"..level)
	--UmengAnalyticsTool.FailLevel(level)
end

--账号统计
function umengAnalytics.ProfileSignIn(userId)
	print ("umengAnalytics:ProfileSignIn:"..userId)
	--UmengAnalyticsTool.ProfileSignIn(userId)
end

--账号统计 使用第三方登录
--<param name="userId">用户ID.</param>
--<param name="provider">使用第三方账号登录信息，ex"WB".</param>
function umengAnalytics.ProfileSignInPro(userId, provider)
	print ("umengAnalytics:ProfileSignInPro:"..userId.."+"..provider)
	--UmengAnalyticsTool.ProfileSignInPro(userId, provider)
end

--账号登出
function umengAnalytics.ProfileSignOff()
	print ("umengAnalytics:ProfileSignOff:")
	--UmengAnalyticsTool.ProfileSignOff()
end

--玩家等级统计
function umengAnalytics.SetUserLevel(level)
	print ("umengAnalytics:SetUserLevel:"..level)
	--UmengAnalyticsTool.SetUserLevel(level)
end

--额外奖励, 游戏中发生的金币、赠送行为
--<param name="coin">虚拟币数量.</param>
--<param name="source">奖励渠道.</param>
function umengAnalytics.BonusCoin(coin, source)
	print ("umengAnalytics:BonusCoin:"..coin.."+"..source)
	--UmengAnalyticsTool.BonusCoin(coin, source)
end

--额外奖励道具赠送行为
--<param name="item">道具ID.</param>
--<param name="amount">道具数量.</param>
--<param name="price">道具单价.</param>
--<param name="source">奖励渠道.</param>
function umengAnalytics.BonusItem(item, amount, price, source)
	print ("umengAnalytics:BonusItem:"..item.."+"..amount.."+"..price.."+"..source)
	--UmengAnalyticsTool.BonusItem(item, amount, price, source)
end

--事件数量统计
--<param name="eventId">事件ID.</param>
--<param name="eventDesc">事件描述.</param>
function umengAnalytics.Event(eventId, eventDesc)
	if GlobalVar.sdkPlatform == "gump" or GlobalVar.sdkPlatform == "hw" then
		print ("umengAnalytics:Event:"..eventId.."+"..eventDesc)
		if ClientTool.Platform == "android" then
			UmengAnalyticsTool.Event(eventId, eventDesc)
			DataEyeTool.FBEvent(eventId, eventDesc)
			DataEyeTool.AFEvent(eventId, eventDesc)
		elseif ClientTool.Platform == "ios" then
			MySdk.Instance:sendSdkEvent(eventId, eventDesc);
		end
	end
end

--事件时长统计
function umengAnalytics.EventBegin(eventId)
	print ("umengAnalytics:EventBegin:"..eventId)
	--UmengAnalyticsTool.EventBegin(eventId)
end

--事件时长统计结束
function umengAnalytics.EventEnd(eventId)
	print ("umengAnalytics:EventEnd:"..eventId)
	--UmengAnalyticsTool.EventEnd(eventId)
end

--使用UI界面访问统计
function umengAnalytics.PageBegin(UIname)
	print ("umengAnalytics:PageBegin:"..UIname)
	--UmengAnalyticsTool.PageBegin(UIname)
end

--使用UI界面访问统计结束
function umengAnalytics.PageEnd(UIname)
	print ("umengAnalytics:PageEnd:"..UIname)
	--UmengAnalyticsTool.PageEnd(UIname)
end

--集成测试请使用此函数获得
function umengAnalytics.GetDeviveInfo()
	print ("umengAnalytics:GetDeviveInfo:")
	--UmengAnalyticsTool.GetDeviveInfo()
end



---充值行为事件判断
function umengAnalytics.GetPayCount(count)
	if GlobalVar.sdkPlatform == "gump" or GlobalVar.sdkPlatform == "hw" then
	    local eventId = "pay_1"
		local payCount = ""
		local isPayMore = true
		local mCount = tonumber(count)
		--玩家有充值
	    	UmengAnalytics.Event(eventId, TextMap.GetValue("Text_1_129"))
	    --玩家充值超过一定数量的钻石
	    if mCount > 20000 then 
	    	eventId = "pay_6"
	    	payCount = ">2000" 
	    elseif mCount > 10000 then 
	    	eventId = "pay_5"
	    	payCount = ">10000"
	    elseif mCount > 5000 then 
	    	eventId = "pay_4"
	    	payCount = ">5000"
	    elseif mCount > 1000 then
	    	eventId = "pay_3"
	    	payCount = ">1000"
	    elseif mCount > 100 then 
	    	eventId = "pay_2"
	    	payCount = ">100"
	    else
	    	isPayMore = false
	    end
	    if isPayMore  then
	    	UmengAnalytics.Event(eventId, TextMap.GetValue("LocalKey_47")..payCount)
	    end
    end
end


return umengAnalytics