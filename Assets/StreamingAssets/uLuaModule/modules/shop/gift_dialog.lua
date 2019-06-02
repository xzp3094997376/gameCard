local page = {}

function page:create()
    return self
end

function page:update(data)
    self.delegate = data.delegate
    self.data = data.item
    -- self.icon =
    self.label.text = "VIP" .. self.data.id .. TextMap.GetValue("Text1397")
    self.txt_price.text = self.data.consume[0].consume_arg
    self.icon.spriteName = self.data.icon
end

function page:onClick(go, name)
    UIMrg:popWindow()
    if name == "btn_yes" then
        local delegate = self.delegate
        Api:buyVipPackage(self.data.id, function(result)
            if result.ret == 0 then
                delegate:onGetGift(self.data.id)
            end
        end)
    end
end

return page