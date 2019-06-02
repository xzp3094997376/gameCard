local m = {}

function m:Start()
    print("lzh print:******** uLeague_ChapterList.lua ** Start()")
end

function m:onEnter()
    print("lzh print:******** uLeague_ChapterList.lua ** onEnter()")
end

function m:update(args)
    self.delegate = args.delegate
    self.chapterDatas = args.chapterDatas
    self.curchapter = args.curchapter
    self.svChapterList:refresh(self.chapterDatas, self, true, self.curchapter - 1)
    self.binding:CallManyFrame(function()
        self.svChapterList.gameObject:SetActive(false)
        self.svChapterList.gameObject:SetActive(true)
    end, 3)
end

function m:OnClick_CurChapterItem_Callback(chaterId)
    self.delegate:OnClick_CurChapterItem_Callback(chaterId)
end

function m:onClick(go, btnName)
    if btnName == "btn_right" then
        self.view:Scroll(6)
    elseif btnName == "btn_left" then
        self.view:Scroll(-6)
    end
end

function m:IsLastData(index)
    if index == #self.chapterDatas then
        return true
    else
        return false
    end
end

return m