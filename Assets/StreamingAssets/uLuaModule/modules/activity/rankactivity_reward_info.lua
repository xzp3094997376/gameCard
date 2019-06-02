local m = {}

function m:update(data)
    ClientTool.UpdateGrid("", self.Grid, data._rlist)
    self.list = data._rlist
    self.dangwei = data._dangweilist
    for k,v in pairs(self.dangwei) do
        v.delegate = self
    end

    self.delegate_old = data._delegate
    self.id = data._id
    self.btn_getall.isEnabled = (data._status == 1)
    if  data._status == 2 then
        self.btn_getall:GetComponentInChildren(UILabel).text = TextMap.GetValue("Text1671")
    else
        self.btn_getall:GetComponentInChildren(UILabel).text = TextMap.GetValue("Text1672")
    end

    if data.rank > 9998 then 
        self.txt_myinfo.text = TextMap.GetValue("Text1673")
    else
        self.txt_myinfo.text = TextMap.GetValue("Text1674").."[00ff00]"..data.rank
    end
    --self.dangwei = nil
    if self.dangwei == nil or #self.dangwei == 0 then
        self.btn_dangwei.gameObject:SetActive(false)
        self.Grid_btn:Reposition()
    end

    ClientTool.AddClick(self.btn_getall,function()
        if data._status == 1 then
            self.delegate_old.delegate:getDropPackage(self, self.id, "", function()
            print(".....领取排名奖励成功....")
            self.btn_getall:GetComponentInChildren(UILabel).text = TextMap.GetValue("Text_1_64")
            self.btn_getall.isEnabled = false
            end)
        end
    end)

end

function m:getCallBack()
    
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btn_dangwei" then
    	ClientTool.UpdateGrid("", self.Grid, self.dangwei)
    	self.btn_dangwei.transform:FindChild("bg1").gameObject:SetActive(true)
    	self.btn_dangwei.transform:FindChild("bg2").gameObject:SetActive(false)
    	self.btn_mingci.transform:FindChild("bg1").gameObject:SetActive(false)
		self.btn_mingci.transform:FindChild("bg2").gameObject:SetActive(true)
        self.myinfo.gameObject:SetActive(false)
	elseif name == "btn_mingci" then
		ClientTool.UpdateGrid("", self.Grid, self.list)
		self.btn_mingci.transform:FindChild("bg1").gameObject:SetActive(true)
		self.btn_mingci.transform:FindChild("bg2").gameObject:SetActive(false)
		self.btn_dangwei.transform:FindChild("bg1").gameObject:SetActive(false)
    	self.btn_dangwei.transform:FindChild("bg2").gameObject:SetActive(true)
        self.myinfo.gameObject:SetActive(true)
    end
    self.ScrollView:ResetPosition()
end

function m:DwCallBack(id,status)
    for k,v in pairs(self.dangwei) do
        if tonumber(v.dw_id) == id then
            v.dw_status = status
        end
    end
end


return m

