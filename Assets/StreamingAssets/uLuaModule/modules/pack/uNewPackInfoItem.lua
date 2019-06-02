local newPackInfoItem = {}

function newPackInfoItem:update(vo)
    self.vo = vo
    -- if vo.type == "equip" then
    --     --local itemvo = itemvo:new(vo.type, 1, vo.obj, 1, 1)
    --     --self.img_kuangzi.spriteName = itemvo.itemColor
    --     self.img_item.Url = UrlManager.GetImagesPath('itemImage/' .. vo.obj.icon .. ".png")
    --     self.Label.text = itemvo.itemName
    --     return
    -- end
    -- if vo.type == "tujing" then
    self.img_kuangzi.gameObject:SetActive(false)
    self.img_item.Url = UrlManager.GetImagesPath('tasksImage/' .. vo.obj.icon .. ".png")
    self.Label.text, self.iscanGo = Tool.CheckSuperLink(vo.obj.id)

    if self.iscanGo ~= nil then
        self.newpackitem.gameObject:SetActive(self.iscanGo)
    end
    -- end
end

function newPackInfoItem:onClick(go, name)
    local targetName = ""
    local targetFunc
	print("ppppppppppppp")
    if self.vo.obj.arg[0] ~= nil then
            targetName = self.vo.obj.arg[0]
        if targetName == "chapter" or targetName == "commonChapter" or targetName == "hardChapter" or targetName == "heroChapter" then
            if self.vo.proxy then self.vo.proxy:destory() end
            UIMrg:popWindow()
			Tool.replace(self.vo.obj.arg[0], "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.vo.obj.arg[1], self.vo.obj.arg[2], self.vo.obj.arg[3]})
			uluabing = uSuperLink.openModule(self.vo.obj.id)
        elseif self.vo.obj.arg.Count >= 1 then
			UIMrg:popWindow()
            uSuperLink.openModule(self.vo.obj.id)
        end
    end

    -- UIMrg:popWindow()
    -- if self.vo.type == "tujing" then
    --     if self.vo.proxy then self.vo.proxy:destory() end
    --     Tool.replace(self.vo.obj.arg[0], "Prefabs/moduleFabs/chapterModule/chapterModule_new", { self.vo.obj.arg[1], self.vo.obj.arg[2], self.vo.obj.arg[3]})
    --     uluabing = uSuperLink.openModule(self.vo.obj.id)
    -- elseif self.vo.type == "equip" or self.vo.type == "item"then
    --     LuaMain:showShop(1) --远征商店
    -- end

end


--初始化
function newPackInfoItem:create(binding)
    self.binding = binding
    return self
end

return newPackInfoItem