local arenaRecordCell = {}

function arenaRecordCell:update(tableData)
    self.tableData = tableData
    if tableData.win then --到时候改成win
    self.winorfail.spriteName = "Jingjichang_sheng"
    self.img_lOSEarrow.spriteName = "Jingjichang_shang"
    self.number_txt.gameObject:SetActive(false)
    self.txt_wIN3000.gameObject:SetActive(true)
    else
        self.txt_wIN3000.gameObject:SetActive(false)
        self.number_txt.gameObject:SetActive(true)
        self.winorfail.spriteName = "Jingjichang_bai"
        self.img_lOSEarrow.spriteName = "Jingjichang_xia"
    end
    self.txt_time1.text =string.gsub(TextMap.GetValue("LocalKey_685"),"{0}",Tool.FormatTime3(os.time() - math.ceil(tableData.timechok / 1000)))
    self.txt_wIN3000.text = tableData.rank_num
    self.number_txt.text = tableData.rank_num
    self.txt_lv.text = "" .. tableData.Info.level --到时候记得要加头像和框
    self.txt_name.text = tableData.Info.nickname
    local headimg = "default"
    if tableData.Info.head ~= "" then
        headimg = tableData.Info.head
    end
    self.simpleImage:setImage(headimg, "headImage")
end

function arenaRecordCell:onClick(go, name)
    Api:getVSRecord(self.tableData.type, self.tableData.index - 1, function(result)
        local fightData = {}
        fightData["battle"] = result
        fightData["mdouleName"] = "arenaPlayback"
        UIMrg:pushObject(GameObject())
        UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
        fightData = nil
    end)
end

--初始化
function arenaRecordCell:create(binding)
    self.binding = binding
    return self
end

return arenaRecordCell