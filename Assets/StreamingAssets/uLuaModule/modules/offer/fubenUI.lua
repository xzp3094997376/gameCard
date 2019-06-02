local m = {}

local fubenItems = {} --副本的binding
local moduleBaseData = {} --悬赏试炼，模块基本数据

function m:Start()
    LuaMain:ShowTopMenu()
end

function m:onEnter()
    for i, v in ipairs(fubenItems) do
        v.bind:CallUpdate(v.data)
    end
end

--打开悬赏试炼，1为悬赏，其他为试炼
function m:update(lua)
    local _type = lua[1]
    self._type = _type

    if _type == 1 then
        self._typeEN = "tiaozhan"
    else
        self._typeEN = "xuanshang"
    end

    self:onUpdate()
end

function m:onUpdate()
    TableReader:ForEachLuaTable("specialChapter_config", function(index, item)
        if item.type == self._typeEN then
            moduleBaseData[item.id] = item
            local tempData = {}
            tempData.data = item
            --tempData.callBack = self.callBackClick

            local infobind = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/offer_challenge/fubenItem", self.Grid.gameObject)
            infobind:CallUpdate(tempData)
            table.insert(fubenItems, { bind = infobind, data = tempData })
        end

        return false
    end)

    self.binding:CallManyFrame(function()
        self.scrollview:ResetPosition()
    end)
end

return m