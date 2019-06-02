local richTextEditor = {}

function richTextEditor:destory()
    SendBatching.DestroyGameOject(self.binding.gameObject)
end

--设置基本信息
function richTextEditor:setData()
end

function richTextEditor:update(tableData)
end

function richTextEditor:onClick(go, name)
    if name == "btn_close" then
        self:destory()
    else
        self.RichTextEditor:changeContent()
    end
end

function richTextEditor:Start()
    LuaMain:ShowTopMenu()
end

--初始化
function richTextEditor:create(binding)
    self.binding = binding
    return self
end

return richTextEditor