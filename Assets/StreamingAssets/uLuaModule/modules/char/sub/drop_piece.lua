--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2014/11/21
-- Time: 16:54
-- To change this template use File | Settings | File Templates.
-- 碎片掉落

local m = {}

function m:onUpdate()
    self.piece:updateInfo()
    local piece = self.piece
    --    local data = self.data
    local info = nil
    --    if data:getType() == "char" then
    --        --获取进化所需要的灵魂石数据
    --        info = piece:pieceInfo(data.star_level)
    --        self.txt_num.text = "(" .. info.desc .. ")"
    --        self.txt_name.text = data.name
    --
    --    else
    --        info = piece:pieceInfo(nil)
    --        self.txt_name.text = data.Table.name
    --    end
    self.txt_name.text = Tool.getNameColor(piece.star) .. piece.name .. "[-]"
    --获取进化所需要的灵魂石数据
    self.txt_num.text = TextMap.GetValue("Text521") .. piece.count
end

function m:update(data)
    local piece = data
    self.data = data
    self.btn_sell.isEnabled = false
    if data:getType() == "char" then
        piece = data:getPiece()
    end
    self.piece = piece
    self:onUpdate()

    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
        --self.binding:CallAfterTime(0.2, function()
        --    ClientTool.AdjustDepth(self.__itemAll.gameObject, self.img_frame.depth)
        --end)
    end
    self.__itemAll:CallUpdate({ "char", piece, self.img_frame.width, self.img_frame.height })


    local drop_info = {}
    local source = piece.Table.droptype
    for i = 0, source.Count - 1 do
        local sc = source[i]
        local tb = Tool.readSuperLinkById( sc)
        if tb then
            table.insert(drop_info, { source = tb })
        end
    end
    self.txt_desc:SetActive(source.Count == 0)
    if piece.count > 0 then
        self.btn_sell.isEnabled = true
    end
    self.dropList:refresh("Prefabs/moduleFabs/charModule/sub/drop_info", drop_info, self)
end


function m:onEnter()
    print ("onEnter")
    LuaMain:ShowTopMenu()
    self:onUpdate()
end

function m:onSell()
    if self.piece then
        if self.piece.count <= 0 then
            MessageMrg.show(TextMap.GetValue("Text522"))
            return
        end
        local temp = {}
        temp.obj = itemvo:new("charPiece", self.piece.count, self.piece.id, 0, self.piece.id .. "")
        temp.type = "sell"
        UIMrg:pushWindow("Prefabs/moduleFabs/charModule/sub/linghunshiSell", temp)
        temp = nil
    end
end

function m:onClick(go, name)
    if name == "btn_back" or name == "btn_close" then
        self:onClose()
    elseif name == "btn_sell" then
        self:onSell()
    end
end

function m:onClose()
    UIMrg:popWindow()
end

function m:create()
    return self
end

function m:Start()
    self.img_frame.enabled = false
    ClientTool.AddClick(self.btn_back, funcs.handler(self, self.onClose))
end

return m

