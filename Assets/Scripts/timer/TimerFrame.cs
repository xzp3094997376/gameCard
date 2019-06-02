//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************
	using System.Collections.Generic;
	using UnityEngine;

public class TimerFrame
{
    private List<TimeFrameItem> callList = new List<TimeFrameItem>();
    private int _itemNum = 0;
    private int elapsedTime = 0;
    public TimerFrame()
    {
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="delay">秒</param>
    /// <param name="repeat">重复次数 0表示无数粗</param>
    /// <param name="callback">回调函数</param>
    /// <param name="onOver">结束函数</param>
    public void add(int delay, int repeat, FrameTimeItem.OnTick0 callback, FrameTimeItem.OnTick0 onOver = null)
    {
        if (getIndex(callback) == -1)
        {
            callList.Add(new TimeFrameItem(delay, repeat, callback, onOver));
            _itemNum++;
        }
    }

    /**移除**/
    public void remove(FrameTimeItem.OnTick0 callback)
    {
        int index = getIndex(callback);
        if (index != -1)
        {
            callList.RemoveAt(index);
            _itemNum--;
        }
    }
    private int getIndex(FrameTimeItem.OnTick0 callback)
    {
        for (int i = 0; i < callList.Count; i++)
        {
            if (callList[i].callback == callback)
                return i;
        }
        return -1;
    }

    private float lastTime = 0;
    public void onTimer()
    {
        if (Time.realtimeSinceStartup - lastTime > 1)
        {
            lastTime = Time.realtimeSinceStartup;
            timerHandler();
        }
    }

    /**timer事件处理**/
    public void timerHandler()
    {
        elapsedTime++;
        for (int i = callList.Count - 1; i >= 0; i--)
        {

            TimeFrameItem item = callList[i];
            if (item.exec(elapsedTime))
            {
                if (item.repeat > 0)
                {
                    item.repeat--;
                    if (item.repeat < 1)
                    {
                        remove(item.callback);
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
        callList.Clear();
    }
}
