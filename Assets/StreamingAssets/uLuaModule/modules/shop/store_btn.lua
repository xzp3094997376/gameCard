local page = {}

function page:create()
    return self
end

function page:update(data)
    self.delegate = data.delegate
    self.data = data
    self.store_name1.text = data.desc
    self.store_name11.text = data.desc
    if self.data.id==self.delegate.type then 
        self.check:SetActive(true)
    else 
        self.check:SetActive(false)
    end 
end

function page:onClick(go, name)
    if self.delegate.type~=self.data.id then 
        self.delegate:update({self.data.id})
    end 
end

return page