--宝物一键掠夺确认界面
local m = {}

function m:Start(...)
    self.isChoose = true
    local  item = TableReader:TableRowByID("item", 6)
    self.txt_count.text = Player.ItemBagIndex[6].count
    self.Sprite.Url="images/itemImage/" .. item.iconid
    self.Label1.text=TextMap.GetValue("Text_1_930") .. item.show_name
    self.Label2.text=TextMap.GetValue("Text_1_814") .. item.show_name .. ":"
end

function m:update(data)
    if data == nil then return end
    self.piece_list = data
end

function m:onCheck()
    if self.isChoose == true then 
        self.isChoose = false
        self.select:SetActive(false)
    else
        self.isChoose = true
        self.select:SetActive(true)
    end
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    elseif name == "btn_sure" then 
        if Player.Resource.vp>=TableReader:TableRowByID("trsRobConfig", "rob_vp").value then
            Api:oneStepRob(self.piece_list,self.isChoose,function (result)
                UIMrg:popWindow()
                UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_result", {result=result,piecelist=self.piece_list})
                end)
        else 
            if Player.ItemBagIndex[6].count>0 then 
                if self.isChoose==true then 
                    Api:oneStepRob(self.piece_list,self.isChoose,function (result)
                        UIMrg:popWindow()
                        UIMrg:pushWindow("Prefabs/moduleFabs/indiana/indiana_result", {result=result,piecelist=self.piece_list})
                        end)
                else 
                    MessageMrg.show(TextMap.GetValue("Text_1_931"))
                    UIMrg:popWindow()
                end
            else
                if self.isChoose==true then 
                    local cb= function () 
                        if self.topMenu~=nil then 
                            self.topMenu.gameObject:SetActive(true)
                            self.topMenu:CallTargetFunction("onUpdate",true)
                        end 
                    end
                    DialogMrg:BuyBpAOrSoul("vp", "", cb ,cb )
                else 
                    MessageMrg.show(TextMap.GetValue("Text_1_931"))
                    UIMrg:popWindow()
                end
            end
        end
    elseif name == "btn_cancel" then
        UIMrg:popWindow()
    elseif name == "btn_check" then
        self:onCheck()
    end
end

return m