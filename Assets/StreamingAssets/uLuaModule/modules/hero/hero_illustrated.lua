--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/23
-- Time: 20:02
-- To change this template use File | Settings | File Templates.
-- 图鉴

local m = {}

function m:onUpdate(ret)
    local chars = Player.Chars:getLuaTable()
    local charsList = {}
    local hasChar = {}
    local index = 1

    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        charsList[index] = char
        hasChar[char.id] = true
        index = index + 1
    end
    local piecesList = {}
    local pieceEnoughtList = {}
    local pieces = Tool.getAllCharPiece()
    table.foreachi(pieces, function(index, piece)
        if (hasChar[piece.id] == nil) then
            piece:updateInfo()
            if piece.count >= piece:maxPiece() then
                --碎片已够召唤
                table.insert(pieceEnoughtList, piece)
            elseif piece.count > 0 or piece.Table.show == 1 then
                table.insert(charsList, piece)
            end
        end
    end)
    --    charsList = self:sort(charsList)

    table.sort(charsList, function(a, b)
        if a.teamIndex ~= b.teamIndex then return a.teamIndex < b.teamIndex end
        if a.star ~= b.star then return a.star > b.star end
        return a.id < b.id
    end)
    table.foreachi(pieceEnoughtList, function(i, v)
        table.insert(charsList, 1, v)
    end)
    if self.scrollView then
        self.scrollView:refresh(charsList, self, false, 0)
        self.binding:CallManyFrame(function()
            self.scrollView.gameObject:SetActive(false)
            self.scrollView.gameObject:SetActive(true)
        end, 3)
    end
    if ret == nil then
        self.binding:CallManyFrame(function()
            self.view:ResetPosition()
        end, 1)
    end
end

function m:showDrop(char)
    DialogMrg.showPieceDrop(char)
    self._click = true
end

function m:onClick()
    uSuperLink.openModule(232)
end

function m:OnEnable()
    m:onUpdate(false)
end

-- function m:onEnter()
--     self._click = false
--     if self._exit then
--         m:onUpdate(false)
--     end
-- end

-- function m:onExit()
--     if self._click then
--         self._exit = true
--     end
-- end

--召唤
function m:showSummon(piece)
    local name = piece.Table.name
    local money = piece.Table.consume[1].consume_arg
    local dese = string.gsub(TextMap.TXT_SUMMON_CHAR_NEED_COST_MONEY, "{1}", money .. "")

    desc = string.gsub(dese, "{0}", name)
    DialogMrg.ShowDialog(desc, function(result)
        Api:combineFunc(piece:getType(), piece.id, function(result)
            local list = RewardMrg.getList(result)
            local luaTable = {
                char = list[1],
                cb = function()
                    m:onUpdate()
                    UIMrg:pop()
                end
            }
            Tool.push("RewardChar", "Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
        end)
    end)
end


function m:Start()
    LuaMain:ShowTopMenu()
    m:onUpdate()
end

return m

