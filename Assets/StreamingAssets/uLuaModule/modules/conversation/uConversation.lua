local Conversation = {}
Conversation.isLeft = true;
function Conversation:create(binding)
    self.binding = binding
    self.isClick = false
    self.gameObject = self.binding.gameObject
    return self
end

function Conversation:hide()
 
end

function Conversation:onClick(go, name)
    --self:talk(false, "your sister", nil);
    --    print("self.object")
    if self.talk_label_eff.isActive == true then
        self.talk_label_eff:Finish()
        return
    end
    if self.isClick and self.object ~= nil and self.object.CallNextStep ~= nil then
        self.isClick = false
        self.object:CallNextStep()
    elseif self.isClick  then 
        GuideMrg.CallNextStep()
        self.gameObject:SetActive(false)
    end
    -- if self.isLeft then
    --     self:talk(false, "碎风","呃！我手上拿的是什么？", UrlManager.GetImagesPath("cardImage/full_suifeng_t.png"));
    --     Conversation.isLeft = false;
    -- else
    --     self:talk(true, "恋次","嘿！靓女，你的斩魄刀掉了！", UrlManager.GetImagesPath("cardImage/full_lianci_b.png"));
    --     Conversation.isLeft = true;
    -- end
end

--isLeft 左边说话 不然就是右边  name说话角色的名称  text内容 head头像
function Conversation:talk(isLeft, name, text, head, black,pic)

    self.pic.gameObject:SetActive(false)
    if name == "player" then
        name = Player.Info.nickname
        head = Tool.getDictId(Player.Info.playercharid)
    end

    if string.find(text, 'xx') ~= nil then
        text = string.gsub(text, "xx", "[E64242FF]"..name.."[-]")
    end

    self.talk_label.text = text
    if black == "balck" then
        self.binding:Show("bg")
    else
        self.binding:Hide("bg")
    end
    if pic ~=nil then 
        self.pic.gameObject:SetActive(true)
        self.pic.Url=UrlManager.GetImagesPath("fightbg/"..pic)
    end 
    if isLeft == nil or isLeft == 1  or isLeft==true then
        self.binding:Hide("right")
        self.binding:Hide("right_head")
        self.binding:Show("left")
        self.binding:Show("left_head")

        self.left_label.text = name
        if head ~= nil and tonumber(head) > 0 then
            self.left_head:LoadByModelId(tonumber(head), "idle", function(ctl) end, false, 0, 1, 255, 0)
        end
    else
        self.binding:Hide("left")
        self.binding:Hide("left_head")
        self.binding:Show("right")
        self.binding:Show("right_head")
        self.right_label.text = name
        if head ~= nil and tonumber(head)> 0 then
            self.right_head:LoadByModelId(tonumber(head), "idle", function(ctl) end, false, 0, 1, 255, 0)
        end
    end
end

function Conversation:Show(data)
    self:talk(data[1], data[2], data[3], data[4], data[5],data[6]);
    self.isClick = true
end

--add for c# modify
function Conversation:update(object, isLeft, name, context, img, balck,pic)
    self.object = object
    --     print(object)
    if context == nil then
        context = "" 
    end
    if balck == nil then
        black = false
    end
    self:talk(isLeft, name, context, img, balck,pic);
    self.isClick = true
end

return Conversation