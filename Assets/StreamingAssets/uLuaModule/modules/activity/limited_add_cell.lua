local m = {}

function m:create(binding)
    self.binding = binding
    return self
end

function m:update(data, index, delegate)
	self.data=data
	self.delegate=delegate
	if data.isAdd~=nil and data.isAdd==true then 
		self.btn_add_name.text=m:getBtnTitleName(data)
		self.sprite.gameObject:SetActive(true)
		self.btn_pic.gameObject:SetActive(false)
	else 
		self.btn_add_name.text=""
		self.sprite.gameObject:SetActive(false)
		self.btn_pic.gameObject:SetActive(true)
		local atlasName = packTool:getIconByName(self.data:getHeadSpriteName())
		self.pic:setImage(self.data:getHeadSpriteName(), atlasName)
	end 
end 

function m:onPress(go,name,bPress)
    if (self.delegate == nil or self.delegate.getScrollView == nil) then
        return
    end
  local sv = self.delegate:getScrollView()
    if sv ~= nil then
        sv:Press(bPress);
    end
end

function m:OnDrag(go,name,detal)
    if (self.delegate == nil or self.delegate.getScrollView == nil) then
        return
    end
        
    local sv = self.delegate:getScrollView()
    
    if sv ~= nil then
        sv:Drag();
    end
end

function m:onClick(go, name)
    self.teams=self.delegate.teams
    if self.data.isAdd~=nil and self.data.isAdd==true then 
    	local bind = UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/limited_select")
        bind:CallUpdate({ data = self.data, teams = self.teams, delegate = self.delegate })
    else 
        local bind = UIMrg:pushWindow("Prefabs/moduleFabs/activityModule/limited_select")
        bind:CallUpdate({ data = self.delegate.data.consume2, teams = self.teams, delegate = self.delegate })
        --local temp = {}
        --temp.obj = self.data
        --temp._type = self.data:getType()
        --temp.type = 1
        --MessageMrg.showTips(temp)
    end 
end
function m:getBtnTitleName(data)
    local text = TextMap.GetValue("Text_1_28")
    local star =tonumber(data.star)
    self.add_bg1.spriteName="tubiao_" .. star
    if star==1 then 
        text=text .. TextMap.GetValue("Text_1_29")
        self.add_bg2.spriteName="kuang_baise"
    elseif star==2 then 
        text=text .. TextMap.GetValue("Text_1_30")
        self.add_bg2.spriteName="kuang_lvse"
    elseif star==3 then 
        text=text .. TextMap.GetValue("Text_1_31")
        self.add_bg2.spriteName="kuang_lanse"
    elseif star==4 then 
        text=text .. TextMap.GetValue("Text_1_32")
        self.add_bg2.spriteName="kuang_zise"
    elseif star==5 then 
        text=text .. TextMap.GetValue("Text_1_33")
        self.add_bg2.spriteName="kuang_chengse"
    elseif star==6 then 
        text=text .. TextMap.GetValue("Text_1_34")
        self.add_bg2.spriteName="kuang_hongse"
    end
    local type = data.type
    if type == "char" then
        text=text .. TextMap.GetValue("Text_1_35")
    elseif type == "charPiece" then
        text=text .. TextMap.GetValue("Text_1_36")
    elseif type == "equip" then
        text=text .. TextMap.GetValue("Text_1_37")
    elseif type == "equipPiece" then
        text=text .. TextMap.GetValue("Text_1_38")
    elseif type == "item" then
        text=text .. TextMap.GetValue("Text_1_39")
    elseif type == "fashion" then
        text=text .. TextMap.GetValue("Text_1_40")
    elseif type == "pet" then
        text=text .. TextMap.GetValue("Text_1_41")
    elseif type == "petPiece" then
        text=text .. TextMap.GetValue("Text_1_42")
    elseif type == "ghost" then
        text=text .. TextMap.GetValue("Text_1_43")
    elseif type == "ghostPiece" then
        text=text .. TextMap.GetValue("Text_1_44")
    elseif type == "treasure" then
        text=text .. TextMap.GetValue("Text_1_45")
    elseif type == "treasurePiece" then
        text=text .. TextMap.GetValue("Text_1_46")
    else
        text=text .. TextMap.GetValue("Text_1_47")
    end
    return text
end

return m