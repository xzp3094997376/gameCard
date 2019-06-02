using UnityEngine;
using System;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************
public class FrameTimeItem
{
    /** 速度，等待多少帧执行一次 */
    public int delay;
    /** 等待计数 */
    public int counter;
    /** 重复次数，0为无限次 */
    public int repeat;
    /** 回调函数 */
    public OnTick0 callback;
    /** 回调函数 */
    public OnTick2 callback2;
    /** 结束函数 **/
    public OnTickEnd onOver;
    /** 帧频 */
    public int frameRate;
    /** 上次调用时间 */
    public int lastTime;

    public delegate void OnTick0();
    public delegate void OnTick2(int old, int now);
    public delegate void OnTickEnd();
    public FrameTimeItem(int delay, int repeat, OnTick0 callBack, OnTickEnd onOver = null, int frameRate = -1)
    {
        this.delay = delay;
        this.counter = delay * FrameTimer.STAGE_FRAME_RATE / (frameRate == -1 ? FrameTimer.STAGE_FRAME_RATE : frameRate);
        this.repeat = repeat;
        this.callback = callBack;
        this.onOver = onOver;
        this.frameRate = frameRate;
        this.lastTime = 0;//DateTime.Now.Millisecond;
    }
    public FrameTimeItem(int delay, int repeat, OnTick2 callBack, OnTickEnd onOver = null, int frameRate = -1)
    {
        this.delay = delay;
        this.counter = delay * FrameTimer.STAGE_FRAME_RATE / (frameRate == -1 ? FrameTimer.STAGE_FRAME_RATE : frameRate);
        this.repeat = repeat;
        this.callback2 = callBack;
        this.onOver = onOver;
        this.frameRate = frameRate;
        this.lastTime = DateTime.Now.Millisecond;
    }

    /**执行函数**/
    public bool exec(int nowTime)
    {
        /*
        int rate = frameRate == -1 ? FrameTimer.STAGE_FRAME_RATE : frameRate;
        int interval = 1000 / rate;
        int delay = this.delay;
        int dif_time = nowTime - lastTime;
        */
        if (lastTime == 0)
            lastTime = nowTime;
        int delay = this.delay;
        int dif_time = nowTime - lastTime;
        if (dif_time >= delay)
        {
            lastTime = nowTime;
         
            if (callback2 != null)
            {
                callback2(nowTime, dif_time);
            }
            else
            {
                callback();
            }
            return true;
        }
        return false;
    }
}