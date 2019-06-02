local m = {}


function m:update(data)
    self.txt_time.text = data.time
    self.txt_history.text = data.desc
end

return m