local item = {}


function item:update(data, index)

end

function item:onClick(go, btnName)
    if self.btnName == btn_close then
        --  print("self.id "..self.id)
        UIMrg:popWindow()
    end
end

function item:Start(...)
    
end


return item