friendUtil =
{
    Recommend = { View = nil, MinRefreshTime = 5, CurRefreshTime = 0, TimeId = nil, },
}

--设置好友推荐刷新时间
function friendUtil.SetRecommendRefreshTime(time)
    friendUtil.Recommend.MinRefreshTime = time
end

--设置好友推荐界面
function friendUtil.SetRecommendView(view)
    friendUtil.Recommend.View = view

    if not view and friendUtil.Recommend.CurRefreshTime == friendUtil.Recommend.MinRefreshTime then
        friendUtil.Recommend.CurRefreshTime = 0
    end

    if view and friendUtil.Recommend.CurRefreshTime == 0 then
        friendUtil.CountDownRefresh()
    end
end

--好友推荐刷新
function friendUtil.CountDownRefresh()
    local recommend = friendUtil.Recommend
    if recommend.CurRefreshTime == 0 then recommend.CurRefreshTime = recommend.MinRefreshTime end

    if recommend.CurRefreshTime > 0 and not recommend.TimeId then
        recommend.TimeId = LuaTimer.Add(1000, 1000, function()
            recommend.CurRefreshTime = recommend.CurRefreshTime - 1
            --刷新View
            if recommend.View then
                recommend.View:SetRefreshTime(recommend.CurRefreshTime)
            end

            if recommend.CurRefreshTime <= 0 then
                recommend.CurRefreshTime = recommend.MinRefreshTime
                LuaTimer.Delete(recommend.TimeId)
                recommend.TimeId = nil
            end
        end)
    end
end



return friendUtil