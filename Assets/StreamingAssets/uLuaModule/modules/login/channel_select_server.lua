local m = {}

function m:update(data)
    local serverList = data.line
    self:showServerList(serverList)
end

function m:onClick(go, name)
    if name == "btn_close" then
        --这个窗口是用pushWindow弹进来的，用popWindow弹出
        UIMrg:popWindow()
    end
end

--显示服务器列表
function m:showServerList(serverList)
    local grid = self.serversParent:GetComponent("UIGrid")
    ClientTool.UpdateGrid("Prefabs/moduleFabs/loginModule/ChannelServerItem", grid, serverList, self)
end

function m:Start()
end

return m