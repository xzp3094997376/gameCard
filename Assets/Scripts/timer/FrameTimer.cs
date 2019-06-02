//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

using System.Collections.Generic;

public class FrameTimer
{
    /**默认帧频**/
    public static int DEFAULT_FRAME_RATE = 30;
    /**当前实际帧频**/
    public static int STAGE_FRAME_RATE = 30;
    private Dictionary<object, bool> _itemDic = new Dictionary<object, bool>();
    private List<FrameTimeItem> callList = new List<FrameTimeItem>();
    private int _itemNum = 0;

    /// </summary>
    /// <param name="delay">帧频</param>
    /// <param name="repeat">重复次数  为0表示无限次</param>
    /// <param name="callback">回调函数</param>
    /// <param name="onOver">结束函数</param>
    /// <param name="frameRate">帧频设置（如非必要，勿设置该参数）</param>
    /// </summary>
    public void add(int delay, int repeat, FrameTimeItem.OnTick0 callback, FrameTimeItem.OnTickEnd onOver = null, int frameRate = -1)
    {
        if (!_itemDic.ContainsKey(callback))
        {
            _itemNum++;
            callList.Add(new FrameTimeItem(delay, repeat, callback, onOver, frameRate));
        }
        _itemDic[callback] = true;
    }

    /**是否已存在**/
    public bool hasFunction(object callback)
    {
        return _itemDic.ContainsKey(callback);
    }

    /**移除**/
    private void removeCallback(object callback)
    {
        if (!hasFunction(callback))
        {
            //没找到
            return;
        }
        _itemNum--;
        _itemDic.Remove(callback);
    }
    public void remove(FrameTimeItem.OnTick0 callback)
    {
        removeCallback(callback);
    }
    public void remove(FrameTimeItem.OnTick2 callback)
    {
        removeCallback(callback);
    }

    private int elapsedTime = 0;
    /**EnterFrame事件处理**/
    public void enterFrameHandler()
    {
        elapsedTime++;
        int calllistcount = callList.Count;
        for (int i = 0; i < calllistcount; i++)
        {
            FrameTimeItem item = callList[i];
            if (item.callback != null && !_itemDic.ContainsKey(item.callback))
            {
                callList.Remove(item);
                i--;
                calllistcount--;
                continue;
            }
            if (item.callback2 != null && !_itemDic.ContainsKey(item.callback2))
            {
                callList.Remove(item);
                i--;
                calllistcount--;
                continue;
            }
            if (item.exec(elapsedTime))
            {
                if (item.repeat > 0)
                {
                    item.repeat--;
                    if (item.repeat < 1)
                    {
                        if (item.callback != null)
                        {
                            callList.Remove(item);
                            _itemDic.Remove(item.callback);
                        }
                        if (item.callback2 != null)
                        {
                            callList.Remove(item);
                            _itemDic.Remove(item.callback2);
                        }
                        i--;
                        calllistcount--;
                        if (item.onOver != null)
                        {
                            item.onOver();
                        }
                    }
                }
            }
        }
    }

    /**销毁**/
    public void dispose()
    {
        _itemNum = 0;
        _itemDic.Clear();
    }
}