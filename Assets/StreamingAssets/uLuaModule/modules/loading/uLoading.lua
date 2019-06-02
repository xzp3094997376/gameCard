local m = {}

function m:update(count, cb)
    self.loading_slider.value = count / 100
    if cb ~= nil then
         self.binding:CallAfterTime(0.05,
         function() cb() end)
    end
end

function m:Start(...)
    math.randomseed(os.time()) 
    self.loading_slider.value = 0
    local romand = math.random(1, 30)
    local img = "img_loading_" .. romand
    self.loading_bg.Url = UrlManager.GetImagesPath("loading/" .. img .. ".png")
    self.tips.text = LuaMain:getTips()

end

return m