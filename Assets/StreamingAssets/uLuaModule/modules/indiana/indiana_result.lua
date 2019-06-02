--宝物一键掠夺与掠夺五次结果界面
local m = {}

local iswin=false

function m:Start(...)
    self.icon_list = {}
end

function m:update(data)
    if data == nil then return end
    local result = data.result
    if data.piecelist~=nil  then 
        self.piecelist=data.piecelist
    end
    if data.delegate~=nil then 
        self.delegate=data.delegate
    end 
    local data = json.decode(result:toString())
    self.rob_result = data.robRet
    self.closeBtn.isEnabled = false
    self:refreshList()
end

--刷新掠夺列表
function m:refreshList()
    if self.rob_result == nil then return end
    self.list = {}
    local count = #self.rob_result
    for i=1,count do
        if self.rob_result[i].ret == 0 then
            local temp = {}
            temp.win = self.rob_result[i].win
            temp.consume = self.rob_result[i].consume
            for k,v in pairs(self.rob_result[i].drop) do --副本掉落
                if k == "exp" then
                    temp.exp = v
                elseif k == "money" then
                    temp.money = v
                end
            end
            for k,v in pairs(self.rob_result[i].turnDrop) do --翻牌掉落
                local drop = {}
                if self:isUsedType(k) == true then
                    drop.type = k
                    drop.arg2 = v
                    drop.arg = v
                else 
                    drop.type = k
                    for n,m in pairs(v) do
                        drop.arg = n
                        drop.arg2 = m
                    end
                end
                temp.drop = drop
            end
            temp.real_index = i
            table.insert(self.list,temp)
        end
    end
    self:playAnimation()
end


function m:isUsedType(_type)
    local typeAll = {"gold", "soul","money"}
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

local pieceIndex=1
function m:playAnimation()
    if self.list == nil then return end
    self:loadPrefab(1)
end
function m:loadPrefab(index)
    if index == nil then return end
    if self.list[index] == nil then return end
    local count = #self.rob_result
    self.binding:CallAfterTime(0.5,function()
        self.icon_list[index] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/indiana/indiana_result_icon", self.grid.gameObject)
        self.icon_list[index]:CallUpdate({self.list[index],self.piecelist[pieceIndex]})
        if self.list[index].win==true then 
            pieceIndex=pieceIndex+1
            iswin=true
        end 
        self.grid.repositionNow = true
        if index > 3 then  --若个数大于三，每次添加移动一次滚动条，固定值为120
            local v = self.scrollview.gameObject.transform.localPosition
           SpringPanel.Begin(self.scrollview.gameObject,Vector3(v.x, v.y+120, v.z),10)
        end
        if index>=count then 
            self.closeBtn.isEnabled = true
        end 
        self:loadPrefab(index+1)
    end)
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
        if self.delegate~=nil and self.delegate.isClose~=nil and self.delegate.isClose==true then
            UIMrg:pop()
        end 
        Events.Brocast("refreshData")
        DialogMrg.levelUp()
    elseif name == "closeBtn" then
        UIMrg:popWindow()
        if self.delegate~=nil and self.delegate.isClose~=nil and self.delegate.isClose==true then 
            UIMrg:pop()
        end 
        Events.Brocast("refreshData")
        DialogMrg.levelUp()
    end
end

return m