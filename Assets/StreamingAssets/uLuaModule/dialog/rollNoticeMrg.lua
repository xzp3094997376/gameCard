RollNoticeMrg = {}

function RollNoticeMrg:show(msg, times, weight)
    if RollNoticeMrg._tvmsg then
        RollNoticeMrg._tvmsg:CallUpdateWithArgs(msg, times, weight)
    else
        -- RollNoticeMrg._tvmsg = UIMrg:pushNotice("Prefabs/moduleFabs/annunciateModule/notice")
        -- RollNoticeMrg._tvmsg:CallUpdateWithArgs(msg,times,weight)
        RollNoticeMrg._tempMsg = { times = times, weight = weight }
    end
end

function RollNoticeMrg.create()
    if RollNoticeMrg._tvmsg == nil then
        RollNoticeMrg._tvmsg = UIMrg:pushNotice("Prefabs/moduleFabs/annunciateModule/notice")
        if RollNoticeMrg._tempMsg ~= nil then
            local obj = RollNoticeMrg._tempMsg
            local times = obj.times
            local weight = obj.weight
            RollNoticeMrg._tvmsg:CallUpdateWithArgs(msg, times, weight)
            RollNoticeMrg._tempMsg = nil
        end
    end
end



return RollNoticeMrg
