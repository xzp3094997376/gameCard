uSuperLink = {}
local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
-- 根据超链接ID 打开对应模块
function uSuperLink.openModule(superID, replaceTolevel, openWay)
    local linkData = Tool.readSuperLinkById( superID)
    --超链接的等级限制
    if linkData == nil then
        MessageMrg.show(TextMap.GetValue("Text142") .. superID)
        return nil
    else
		local moduleName = linkData.arg[0] --模块名
		--print("module uSuperLink id = " .. superID .. "   moduleName = " .. moduleName .. "   path = ".. modulePrefabs.getPrefabByName(moduleName))
        local canGo = true
        if modulePrefabs.getPrefabByName(moduleName) == nil then
            MessageMrg.show(TextMap.GetValue("Text143") .. moduleName .. TextMap.GetValue("Text144"))
            return nil
        else
            --打开预设的方式
			if openWay == nil then 
				openWay = linkData.window
			end
            local unlockType = linkData.unlock[0].type --解锁条件
            if unlockType ~= nil then
                --解锁条件
                local level = linkData.unlock[0].arg
                local vipLV = linkData.vipLevel
                --等级方式节解锁
                if unlockType == "level" then
                    if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
                        MessageMrg.show(string.gsub(TextMap.TXT_OPEN_MODULE_BY_LEVEL, "{0}", level))
                        return nil
                    end

                elseif unlockType == "completeCommonChapter" then
                    --当前打的章节是否符合解锁条件
                    local lastChapter = Player.Chapter.lastChapter
                    local lastSection = Player.Chapter.lastSection
                    if level ~= 0 then
                        local row = TableReader:TableRowByID("commonChapter", level)
                        if lastChapter < row.chapter then
                            local dese = string.gsub(TextMap.TXT_OPEN_MODULE_BY_CHAPTER, "{0}", row.chapter)
                            MessageMrg.show(string.gsub(dese, "{1}", row.name))
                            return nil
                        elseif lastChapter == row.chapter and lastSection <= row.section then
                            local dese = string.gsub(TextMap.TXT_OPEN_MODULE_BY_CHAPTER, "{0}", row.chapter)
                            MessageMrg.show(string.gsub(dese, "{1}", row.name))
                            return nil
                        end
                    end

                elseif unlockType == "completeHardChapter" then
                    -- moduleName = "hardchapter"
                    local lastChapter = Player.HardChapter.lastChapter
                    local lastSection = Player.HardChapter.lastSection
                    if level ~= 0 then
                        local row = TableReader:TableRowByID("hardChapter", level)
                        if lastChapter < row.chapter then
                            local dese = string.gsub(TextMap.TXT_OPEN_MODULE_BY_CHAPTER, "{0}", row.chapter)
                            MessageMrg.show(string.gsub(dese, "{1}", row.name))
                            return nil
                        elseif lastChapter == row.chapter and lastSection <= row.section then
                            local dese = string.gsub(TextMap.TXT_OPEN_MODULE_BY_CHAPTER, "{0}", row.chapter)
                            MessageMrg.show(string.gsub(dese, "{1}", row.name))
                            return nil
                        end
                    end
                end
            else --没有解锁条件
            MessageMrg.show(TextMap.GetValue("Text145"))
            return nil
            end

            local counts = linkData.arg.Count
            local args = {}
            if counts > 1 then
                for i = 1, counts - 1 do
                    args[i] = linkData.arg[i]
                end
            end
            linkData = nil
            return uSuperLink.open(moduleName, args, openWay, replaceTolevel)
        end
    end
end

function uSuperLink.open(moduleName, arg, openWay, replaceTolevel)
    arg = arg or {}
    if moduleName == nil or moduleName == "" then
        return nil
    end
    print("moduleName = " .. moduleName)
    if moduleName == "xiehui" then --进入协会特殊处理
    GuildDatas:EnterLeague()
    return
    end
    local path = modulePrefabs.getPrefabByName(moduleName)
    local uluabing = nil

    if moduleName == "jingyingguanqia" then --对决
    chapterFightPanel.Show("heroChapter", arg[1], 3)
    return
    end
    if moduleName == "chapter" then
        local currentObj = TableReader:TableRowByUniqueKey("commonChapter", arg[1], arg[2])
        chapterFightPanel.Show("commonChapter", currentObj.id, -1)
        return
    end
    if moduleName == "hardChapter" then
        local currentObj = TableReader:TableRowByUniqueKey("hardChapter", arg[1], arg[2])
        chapterFightPanel.Show("hardChapter", currentObj.id, -1)
        return
    end

    if replaceTolevel ~= nil then
        if table.getn(arg) == 0 then arg = nil end
        uluabing = Tool.replaceToLevel(moduleName, path, replaceTolevel, arg)
        return nil
    end
    if table.getn(arg) == 0 then --不带参数的
		if openWay == 1 then --对与点石成金需要弹窗的方式
		uluabing = UIMrg:pushWindow(path)
		else
			if UIMrg:GetRunningModuleName() == moduleName then return end --如果当前最外层的模块等于你要打开的模块
			uluabing = Tool.push(moduleName, path)
		end
    else
        if openWay == 1 then
            uluabing = UIMrg:pushWindow(path, arg)
        else
            if UIMrg:GetRunningModuleName() == moduleName then return end
            uluabing = Tool.push(moduleName, path, arg)
            --uluabing:CallUpdate()
        end
    end
    return uluabing
end

return uSuperLink