using UnityEngine;
//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class TimeFrameItem
{
    /** 速度，等待多少秒执行一次 */
    public int delay;
    /** 重复次数，0为无限次 */
    public int repeat;
    /** 回调函数 */
    public FrameTimeItem.OnTick0 callback;
    /** 结束函数 **/
    public FrameTimeItem.OnTick0 onOver;
    /** 上次调用时间 */
    public int lastTime = 0;
    public TimeFrameItem(int delay, int repeat, FrameTimeItem.OnTick0 callBack, FrameTimeItem.OnTick0 onOver = null)
    {
        this.delay = delay;
        this.repeat = repeat;
        this.callback = callBack;
        this.onOver = onOver;
    }

    /**执行函数**/
    public bool exec(int nowTime)
    {
        int delay = this.delay;
        if (lastTime == 0)
            lastTime = nowTime - 1;
        int dif_time = nowTime - lastTime;
        if (dif_time >= delay)
        {
            lastTime = nowTime;
            callback();
            return true;
        }
        return false;
    }
}
