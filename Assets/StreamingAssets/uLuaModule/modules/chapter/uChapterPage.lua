local chapterpage = {}

local currentChapterType = "nothing" -- 当前章节类型
local currentSelectChapter = -1 --玩家选择打开的小节
local delegate = nil
local pageitem = {}
--关闭界面
function chapterpage:OnDestroy()
    chapterpage = nil
end

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 开始设置数据

--1.外部超链接或者固定链接打开关卡界面
--tables[2]   0表示超链接打开直接到最新章节   -1 超链接打开到指定章节
function chapterpage:update(tables, delegate)
  if GuideMrg:isPlaying() then 
    self.collider:GetComponent("BoxCollider").enabled=false
  else 
    self.collider:GetComponent("BoxCollider").enabled=true 
  end
  for j = 1, #pageitem do
      if pageitem[j] ~= nil then
        pageitem[j].gameObject:SetActive(false)
        --GameObject.Destroy(pageitem[j].gameObject)
        --pageitem[j] = nil
      end
  end
  self.currentChapterType = tables.chapter_type
  self.currentSelectChapter = tables.chapterPage
  self.delegate = tables.delegate
  local chapterData = TableReader:TableRowByUniqueKey("chapter", self.currentSelectChapter, self.currentChapterType)

  local imageUrl = UrlManager.GetImagesPath("fightbg/"..chapterData.chapter_map)
  if currentUrl ~= imageUrl then
      self.simpleImage.Url = imageUrl
      local len = chapterData["imageLen"]
      self.simpleImage:setSize(chapterData["imageWidth"], len)
      self.simpleImage.gameObject.transform.localPosition = Vector3(0, -len/2, 0)
  end

  if self.currentChapterType == "commonChapter" then
      tempLastSection = Player.Chapter.lastSection
      tempLastChapter = Player.Chapter.lastChapter
  elseif self.currentChapterType == "hardChapter" then
      tempLastSection = Player.HardChapter.lastSection
      tempLastChapter = Player.HardChapter.lastChapter
  elseif self.currentChapterType == "heroChapter" then
      tempLastSection = Player.NBChapter.lastSection
      tempLastChapter = Player.NBChapter.lastChapter
  end
  
  if tempLastSection == 0 then
      tempLastSection = 1
  end
  if tempLastChapter == 0 then
      tempLastChapter = 1
  end
  totelSection = chapterData.totelSection
  if self.currentSelectChapter == tempLastChapter and  totelSection > tempLastSection then
      totelSection = tempLastSection
  end
  for i=1,totelSection do
    if pageitem[i] == nil then
      pageitem[i] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/chapterPageItem", self.chapterPage)
      pageitem[i].gameObject.name="chapterPageItem" .. i
    end
    pageitem[i].gameObject:SetActive(true)

    local obj = {}
    obj.ZJType = self.currentChapterType
    obj.ZJ = self.currentSelectChapter
    obj.index = i
    obj.goIndex = tables.gotoindex
    obj.delegate = self.delegate
    obj.pageLen = chapterData["imageLen"]
    pageitem[i]:CallUpdate({obj})
  end
end

function chapterpage:onClick(go, name)
   -- if name == "closeBtn" then
   --     self:destory()
   -- end
end

return chapterpage
