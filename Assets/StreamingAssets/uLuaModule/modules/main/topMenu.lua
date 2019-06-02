local topMenu = {
    close = nil
}

function topMenu:onUpdate()
    self.currency:CallUpdate(self.data)
end

--type
-- 1. 4个属性的 
-- 2. 3个属性的 不要精力
-- 3. 3个属性的 不要体力
--4.2个属性，不要体力和精力的
--5.4个属性的 ,修改Depth
--6.商店资源条的展示

Toptype = {
    [1] = {
        
    },
    [2] = {
        [1]={ 
            type="bp"
        },
        [2]={ 
            type="money"
        },
        [3]={ 
            type="gold"
        }
    },
    [3] = {
        [1]={ 
            type="vp"
        },
        [2]={ 
            type="money"
        },
        [3]={ 
            type="gold"
        }
    },
    [4] = {
        [1]={ 
            type="money"
        },
        [2]={ 
            type="gold"
        }
    },
    [5] = {
        [1]={ 
            type="bp"
        },
        [2]={ 
            type="vp"
        },
        [3]={ 
            type="money"
        },
        [4]={ 
            type="gold"
        }
    },
}
	
--更新信息
function topMenu:update(lua)
    if lua ==nil or lua.type==1 then 
        self.type=1 
    end 
    self.close = lua.close
	self.type = lua.type or 1
    if lua.data~=nil then 
        self.data=lua.data
    end 
	self:sort()
    self:onUpdate()
end

function topMenu:sort()
	if self.type == 1 then 
        self.data={[1]={ type="bp"},[2]={ type="vp"},[3]={ type="money"},[4]={ type="gold"}}
        self.Panel.depth=5
	elseif self.type == 2 then 
		self.data={[1]={ type="bp"},[2]={ type="money"},[3]={ type="gold"}}
        self.Panel.depth=5
	elseif self.type == 3 then 
		self.data={[1]={ type="vp"},[2]={ type="money"},[3]={ type="gold"}}
        self.Panel.depth=5
    elseif self.type == 4 then 
        self.data={[1]={type="money"},[2]={ type="gold"}}
        self.Panel.depth=7
    elseif self.type == 5 then 
        self.data={[1]={ type="bp"},[2]={ type="vp"},[3]={ type="money"},[4]={ type="gold"}}
        self.Panel.depth=15
    elseif self.type == 6 then 
        self.Panel.depth=15
	end 
end 

function topMenu:addTexture(p, name, w, h, depth, pos)
    local go = NGUITools.AddChild(p.gameObject)
    go.name = name
    local tx = go:AddComponent(UITexture)
    tx.depth = depth or 5
    tx.width = w
    tx.height = h
    tx.pivot = UIWidget.Pivot.Left
    go.transform.localPosition = pos
    local simple = go:AddComponent(SimpleImage)
    return simple
end

function topMenu:listener()
    local that = self
    Player.Resource:addListener("topMenucurrency", "gold", function(key, attr, newValue)
        that:onUpdate()
    end)
	Player.Resource:addListener("topMenucurrency", "vp", function(key, attr, newValue)
        that:onUpdate()
    end)
    Player.Resource:addListener("topMenucurrency", "money", function(key, attr, newValue)
        that:onUpdate()
    end)
    Player.Resource:addListener("topMenucurrency", "bp", function(key, attr, newValue)--bp体力
        that:onUpdate()
    end)
    Player.Resource:addListener("topMenucurrency", "soul", function(key, attr, newValue)
        that:onUpdate()
    end)
    Player.Resource:addListener("topMenucurrency", "max_bp", function(key, attr, newValue)
        that:onUpdate()
    end)
end

function topMenu:onClick(go, name)
    if self.close ~= nil then self.close() return end
    UIMrg:pop()
end


function topMenu:Start()
    GameManager.showFrame(self.gameObject)
    self:listener()
	--self.maxmMw = self.bg.width
    --self.middleMw = 560
	--self.minMw = 390
	--self.bpPos = self.bp.transform.localPosition
	--self.vpPos = self.vp.transform.localPosition
end

return topMenu