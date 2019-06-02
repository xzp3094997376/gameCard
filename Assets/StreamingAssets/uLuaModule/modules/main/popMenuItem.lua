

local m = {}


local m = {}
function m:update(data)
	if data==nil or data[1]==nil then return end 
	self.type = data
	--self.txtName.text = self:getNameByType()
	if self.pic~=nil then 
		self.pic.Url=UrlManager.GetImagesPath("shopImage/" .. data[1].icon .. ".png")
	end 
end

function m:onClick(go, name)
	UIMrg:popWindow()
	if name =="btnmenu" then 
		uSuperLink.openModule(self.type[1].superLink)
	elseif self.type == "fenjie" then 
		Tool.push("recycle", "Prefabs/moduleFabs/recycleModule/recycle", {})
	elseif self.type == "tujian" then
		MessageMrg.showMove(TextMap.GetValue("Text_1_938"))	
		--uSuperLink.openModule(231)
	elseif self.type == "haoyou" then 
		MessageMrg.showMove(TextMap.GetValue("Text_1_938"))
		--uSuperLink.openModule(120)
	elseif self.type == "paihangbang" then 
		m:onPaiHangbang()
	elseif self.type == "chongzhi" then 
		--Tool.push("purchase", "Prefabs/moduleFabs/vipModule/vip")
		Tool.push("activity", "Prefabs/moduleFabs/activityModule/activity_vip",{"","vip"})
	elseif self.type == "shangcheng" then 
		uSuperLink.openModule(1)
	elseif self.type == "shangdian" then 
		local shoptype = 0
		TableReader:ForEachLuaTable("shop_refresh", function(k, v)
			if v.shop ==7 then 
				shoptype=v.sell_type
			end
			return false
			end)
		if shoptype==0 then 
			Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/store",{7})
		else 
			Tool.push("store","Prefabs/moduleFabs/puYuanStoreModule/storeTwo",{7})
		end
	elseif self.type == "zhaohuan" then 
		uSuperLink.openModule(8)
	elseif self.type == "yingxiong" then 
		uSuperLink.openModule(73)
	elseif self.type == "buzhen" then 
		uSuperLink.openModule(802)
	end
end


function m:Start()
  
end

function m:onPaiHangbang()
	if uSuperLink.openModule(122, nil, 1) ~= nil then
        MusicManager.playByID(16)
    else
        MusicManager.playByID(19)
    end
end

-- 背包
local isSelectBag = false
function m:onBag()
    --if Player.Info.level >= Tool.getUnlockLevel(804) then
    --    isSelectBag = not isSelectBag
    --    self.beibao_new:SetActive(isSelectBag)
    --else
        Tool.push("PACK", "Prefabs/moduleFabs/packModule/newpack")
    --end
end

function m:getNameByType()
	local ret = ""
	if self.type == "fenjie" then 
		ret = TextMap.GetValue("LocalKey_404")
	elseif self.type == "tujian" then 
		ret = TextMap.GetValue("Text326")
	elseif self.type == "haoyou" then 
		ret = TextMap.GetValue("Text1804")
	elseif self.type == "paihangbang" then 
		ret = TextMap.GetValue("Text321")
	elseif self.type == "beibao" then 
		ret = TextMap.GetValue("Text337")
	elseif self.type == "chongzhi" then 
		ret = TextMap.GetValue("Text68")
	elseif self.type == "shangcheng" then 
		ret = TextMap.GetValue("Text1805")
	elseif self.type == "shangdian" then 
		ret = TextMap.GetValue("Text197")
	elseif self.type == "zhaohuan" then 
		ret = TextMap.GetValue("Text317")
	elseif self.type == "yingxiong" then 
		ret = TextMap.GetValue("Text324")
	elseif self.type == "buzhen" then 
		ret = TextMap.GetValue("Text331")
	end
		return ret
end

return m

