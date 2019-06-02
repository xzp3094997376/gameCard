local m = {} 

function m:update(info)
    self.gameObject:SetActive(true)
	self.infoList = info.info
	self.delegate = info.delegate
end

function m:pay(payType)
    self.gameObject:SetActive(false)
    mysdk:pay(self.infoList[1], self.infoList[2], self.infoList[3], self.infoList[4], self.infoList[5], self.infoList[6], self.infoList[7], self.infoList[8], payType, function(result)
    	if self.delegate ~= nil then
    		self.delegate:showISPaySuccess(true)
            UIMrg:popWindow()
    	end
    end, function()
        if self.delegate ~= nil then
    		self.delegate:showISPaySuccess(false)
            UIMrg:popWindow()
    	end
    end)
end

function m:onClick(go, name)
    if name == "btn_close" then
        UmengAnalytics.Event("pay_cancle", Player.Info.nickname)
        self.delegate:returnPay()
    	UIMrg:popWindow()
    elseif name == "btn_pay" then
		m:pay("1")
    elseif name == "btn_morePay" then
		m:pay("0")
    end
end

return m