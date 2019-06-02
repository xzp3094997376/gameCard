local m = {} 

local ziyuanCount = 1
local ziyuanType = ""
local newScale = Vector3(1.4, 1.4, 1.4)


function m:update(lua)
	if lua~=nil then 
		self.data=lua
		self.effect:SetActive(false)
		if self:typeId(lua.type) then 
			local bag = Player.Resource
			local ziyuan = bag['' .. lua.type] or 0
			if lua.type=="gold" then 
				--self.txt.text ="[FFE035]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan))) .."[-]"
				self.txt.text ="[FFFFFF]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan))) .."[-]"
				self.effect:SetActive(true)
				--self.img1.width=35
				--self.img1.height=35
			elseif lua.type=="bp" then 
				self.txt.text ="[FFFFFF]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan))) .. '/' .. bag.max_bp .. "[-]"
				--self.img1.width=45
				--self.img1.height=45
			elseif lua.type=="vp" then 	
				self.txt.text ="[FFFFFF]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan))) .. '/' .. bag.max_vp .. "[-]"
				--self.img1.width=45
				--self.img1.height=45
			else 
				self.txt.text ="[FFFFFF]" .. toolFun.moneyNumberShowOne(math.floor(tonumber(ziyuan))) .."[-]"
				--self.img1.width=35
				--self.img1.height=35
			end 
			if ziyuanType==lua.type and ziyuanCount~=ziyuan then 
				self:setResChange()
			end 
            local iconName = Tool.getResIcon(lua.type)
            self.img.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
        elseif lua.type=="item" then 
        	ziyuanType=""
        	local itemcell=uItem:new(lua.arg)
        	self.txt.text =toolFun.moneyNumberShowOne(math.floor(tonumber(itemcell.count)))
            local iconName = itemcell.Table.iconid
            self.img.Url=UrlManager.GetImagesPath("itemImage/" .. iconName .. ".png")
            --self.img1.width=45
			--self.img1.height=45
        end 
	else 
		self.binding.gameObject:SetActive(false)
	end 
end

-- 设置资源变化
function m:setResChange()
    local oldScale = Vector3.one
    self.binding:ScaleToGameObject(self.txt.gameObject, 0.1, newScale, nil)
	self.binding:CallAfterTime(0.2, function()
		self.binding:ScaleToGameObject(self.txt.gameObject, 0.1, oldScale, nil)
	end)
end


function m:onClick(go, btnName)
--	print_t(self.data)
	if btnName=="btn" and self.data~=nil then 
		if self:typeId(self.data.type) then
			if self.superLink~=nil then 
				if tonumber(self.superLink[0])==800 then 
                    Api:checkCross(function (reslut)
                        uSuperLink.openModule(self.superLink[0]) 
                        return 
                    end,function ()
                        return 
                    end)
                else 
                    uSuperLink.openModule(self.superLink[0]) 
                end 
			end 
		else 
			local temp = {}
			temp.obj = uItem:new(self.data.arg)
			temp._type = self.data.type
			MessageMrg.showTips(temp)
		end 
	end 
end 

function m:create(binding)
    self.binding = binding
    return self
end

function m:typeId(_type)
    local ret = false
    local drop = TableReader:TableRowByUnique("resourceDefine", "name", _type)
    if drop ~= nil then
    	self.superLink = drop.droptype
    end
    return Tool.typeId(_type)
end

return m