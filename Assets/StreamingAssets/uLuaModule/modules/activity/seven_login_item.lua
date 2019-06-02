--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/14
-- Time: 18:17
-- To change this template use File | Settings | File Templates.
-- 边登7天。

local page = {}

function page:create()
    return self
end

function page:update(data, index)
    self.isExt = false
    self.delegate = data.delegate
    self._index = index
    local drop = data.drop
    self.data = data
    local package = data.package
    self.gid = package.id
    self.status = self.delegate.data.status[self.gid]
    if self.status == 1 then
        self.delegate:countMutliPoint(true)
    end
    self.Title.text = package.name

    self.binding:Hide('txt_login_cost')
    self.btn_name.text = TextMap.GetValue("Text376")
    self.btGet.isEnabled = true
    self.finish:SetActive(false)
    self.btGet.gameObject:SetActive(true)
    if self.status ~= nil then
        if self.status == 2 then
            table.foreach(drop, function(i, v)
                v.has = true
            end)
        end
        if self.status == 1 then
            self.btn_name.text = TextMap.GetValue("Text376")
            self.btGet.isEnabled = true
        elseif self.status == 2 then
            self.finish:SetActive(true)
            self.btGet.gameObject:SetActive(false)
            --self.btn_name.text = TextMap.GetValue("Text397")
            --self.btGet.isEnabled = false
        elseif self.status == 7 then
            self.btn_name.text = TextMap.GetValue("Text410")
            self.btGet.isEnabled = true
            --补签
            self.txt_login_cost.text = self.delegate.data._source_data.cost
            self.binding:Show('txt_login_cost')
        end
    else
        self.btGet.isEnabled = false
        self.btn_name.text = TextMap.GetValue("Text376")
    end
    self.drag:SetActive(true)
    self.Grid:refresh("Prefabs/moduleFabs/activityModule/itemActivity", drop,data.delegate)
    --self.table:refresh(drop,data.delegate,true,0)


    if self.slider then
        self.binding:CallManyFrame(function()
            self.slider.value = 0
            local len = table.getn(drop)
            if self.slider then
                self.slider.gameObject:SetActive(len > 3)
            end
            if len <= 3 then
                self.drag:SetActive(false)
                self.binding:Hide("btn_left")
                self.binding:Hide("btn_right")
            end
        end, 2)
    end
end

function page:onBtGet()
    if self.status == 1 then
        --领取
        self.delegate.delegate:getMutliPackage(self, self.delegate.data.id, self.gid)
    elseif self.status == 7 then
        page:fillCheckIn()
    end
end

function page:fillCheckIn()
    Api:fillCheckIn(self.delegate.data.id, self._index + 1, function(result)
        packTool:showMsg(result, nil, 1)
        page:getCallBack()
    end)
end

function page:onClick(go, name)
    if name == "btGet" then
        if self.status ~= nil then
            self:onBtGet()
        end
    elseif name == "btn_left" then
        self.slider.value = 0
    elseif name == "btn_right" then
        self.slider.value = 1
    end
end

function page:getCallBack()
    self.delegate:countMutliPoint(false)
    if self.delegate.mutliPoint < 1 then
        self.delegate.delegate:hideEffect()
    end
    self.delegate:getCallBack()
end

function page:onPress(go,name,bPress)		
		if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
  local sv = self.delegate:getScrollView()
	if sv ~= nil then
		sv:Press(bPress);
	end
end

function page:OnDrag(go,name,detal)
		if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
	local sv = self.delegate:getScrollView()
	
	if sv ~= nil then
		sv:Drag();
	end
end


return page