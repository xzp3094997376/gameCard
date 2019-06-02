local ChatFacePanel = {}
local faceFont = nil --表情字体，UIFont
local symbolList = nil --表情BMSymbol列表
local hasSetSymbol = false --是否已经设置过了
local LaBa = "/lb" --喇叭图片，需要屏蔽
local WoShiLang = "/wsl" --我是狼图片，需要屏蔽

function ChatFacePanel:Start()
    self:Init()
    self.binding:CallManyFrame(function()
        self.gameObject:SetActive(false)
        self.panel:SetActive(true)
    end)
end

function ChatFacePanel:OnDestroy()
    faceFont = nil
    symbolList = nil
end

--初始化表情
function ChatFacePanel:Init()
    local prefab = ClientTool.Pureload("AllAtlas/fontAltlas/emotionFont")
    faceFont = prefab:GetComponent(UIFont)
    symbolList = faceFont.symbols
end

--显示
function ChatFacePanel:update(info)
    self.gameObject:SetActive(true)

    self.delegate = info.delegate
    self.input = info.input --输入框，UIInput
    self:SetFaceSymbols()
end

--设置每个表情
function ChatFacePanel:SetFaceSymbols()
    --设置过了就返回
    if hasSetSymbol then return end

    hasSetSymbol = true
    local count = symbolList.Count

    for i = 0, count - 1 do
        local symbol = symbolList[i]

        if symbol.sequence ~= LaBa and symbol.sequence ~= WoShiLang then
            local prefab = ClientTool.Pureload("Prefabs/moduleFabs/chatModule/FaceItem")
            local itemGo = GameObject.Instantiate(prefab)

            itemGo.transform.parent = self.grid.transform
            itemGo.transform.localRotation = Quaternion.identity
            itemGo.transform.localScale = Vector3.one
            itemGo.name = "item" .. i
            local faceItem = itemGo:GetComponent(UluaBinding)
            faceItem:CallUpdate({ symbol = symbol, input = self.input, delegate = self })
        end
    end

    self.grid.repositionNow = true
end

--点击事件
function ChatFacePanel:onClick(go, name)
    if name == "btn_bg" then
        self:OnClose()
    end
end

--关闭面板
function ChatFacePanel:OnClose()
    self.gameObject:SetActive(false)
end

return ChatFacePanel