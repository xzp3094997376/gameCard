local Conversation = {}
Conversation.isLeft = true;
function Conversation:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function Conversation:onClick(go, name)
    --self:talk(false, "your sister", nil);
    -- print("self.object")
    if self.object ~= nil then
        self.object:CallNextStep()
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
function Conversation:talk(isLeft, name, text, head)

    if isLeft then
        self.binding:Hide("right");
        self.binding:Show("left");

        self.left_label.text = name;
        self.talk_label.text = text;
        self.left_head.Url = head;
    else
        self.binding:Hide("left");
        self.binding:Show("right");
        self.right_label.text = name;
        self.talk_label.text = text;
        self.right_head.Url = head;
    end
end

--add for c# modify
function Conversation:update(object, isLeft, name, context, img)
    self:talk(isLeft, name, context, UrlManager.GetImagesPath("cardImage/" .. img .. ".png"));
    self.object = object;
end

return Conversation