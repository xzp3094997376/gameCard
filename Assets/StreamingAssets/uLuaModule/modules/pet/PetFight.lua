local m = {} 
--Player.PetChapter.item[]:getLuaTable()
local itemList = {}

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_948"))
    Api:InitPetChapterData(function(reuslt)
		LuaMain:ShowTopMenu(6, nil, {[1]={type="shouhun"},[2]={type="money"},[3]={type="gold"}})
		m:update()
	end)
	Events.AddListener("RefreshPetGQInfo", funcs.handler(self, self.update))
end

function m:update()
	--m:judgeItemNum()
	self.Middle:CallUpdate()
	self.Bottom:CallUpdate()
	--m:OnUpdateInfo()
end

--关闭界面
function m:OnDestroy()
    Events.RemoveListener("RefreshPetGQInfo")
end

function m:onEnter()
	LuaMain:ShowTopMenu(6, nil, {[1]={type="shouhun"},[2]={type="money"},[3]={type="gold"}})
    --m:OnUpdateInfo()
end

-- function m:judgeItemNum()
-- 	itemList = {}
-- 	for i = 1, 12 do
-- 		if Player.PetChapter[i].playerId ~= "" then
-- 			itemList[i] = Player.PetChapter[i]
-- 		end
-- 	end
-- end

--右侧原本资源图标，目前UI没有
-- function m:OnUpdateInfo()
-- 	self.Label_Value.text = toolFun.moneyNumberShowOne(math.floor(tonumber(Player.Resource.shouhun)))--Player.Resource.shouhun
-- 	local info = TableReader:TableRowByID("petChapterPrize", 1)
-- 	local iconName = Tool.getResIcon(info.drop[0].type)
-- 	self.Sprite_Shouhun.Url = UrlManager.GetImagesPath("itemImage/"..iconName..".png")
-- end

function m:onClick(go, name)
	if name == "btnBack" then
		UIMrg:pop()
	elseif name == "Pet_shop" then
		uSuperLink.openModule(15) 
	elseif name == "Btn_guize" then
        UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {17, title = TextMap.GetValue("Text_1_949")})
	end
end



return m