using SLua;
using System.Collections.Generic;

public class UluaTimer
{

    private static UluaTimer _instance = null;
    private UluaTimer() { }
    //帧频定时器字典
    private Dictionary<string, FrameTimeClass> frameTimeDic = new Dictionary<string, FrameTimeClass>();
    //时间定时器字典
    private Dictionary<string, SecondTimeClass> secondTimeDic = new Dictionary<string, SecondTimeClass>();
    public static UluaTimer Instance
    {
        get
        {
            if (_instance == null)
                _instance = new UluaTimer();
            return _instance;
        }
    }

    /// <summary>
    /// 帧频定时器，供lua调用，C#请自觉滚犊子
    /// </summary>
    /// <param name="timerName">该定时器名字，方便删除定时器，一定要有名字</param>
    /// <param name="_delay">多少帧执行一次</param>
    /// <param name="_counts">定时器执行次数</param>
    /// <param name="_callBack">回调方法</param>
    public void frameTime(string timerName, double _delay, double _counts, LuaFunction _callBack,LuaTable target=null)
    {
        FrameTimeClass frame = new FrameTimeClass(timerName, System.Convert.ToInt32(_delay), System.Convert.ToInt32(_counts), _callBack, target);
        frameTimeDic[timerName] = frame;
    }

    /// <summary>
    /// 根据名字移除帧频定时器
    /// </summary>
    /// <param name="timeName"></param>
    public void removeFrameTime(string timeName)
    {
        if (frameTimeDic.ContainsKey(timeName))
        {
            frameTimeDic[timeName].removeTimes();
            frameTimeDic[timeName] = null;
            frameTimeDic.Remove(timeName);
        }
    }

    /// <summary>
    /// 时间定时器，供lua调用，C#请自觉滚犊子
    /// </summary>
    /// <param name="timerName">该定时器名字，方便删除定时器，一定要有名字</param>
    /// <param name="_delay">多少秒执行一次</param>
    /// <param name="_counts">定时器执行次数</param>
    /// <param name="_callBack">回调方法</param>
    public void secondTime(string timerName, double _delay, double _counts, LuaFunction _callBack,LuaTable target = null)
    {
        SecondTimeClass second = new SecondTimeClass(timerName, System.Convert.ToInt32(_delay), System.Convert.ToInt32(_counts), _callBack, target);
        secondTimeDic[timerName] = second;
    }

    /// <summary>
    /// 根据名字移除时间定时器
    /// </summary>
    /// <param name="timeName"></param>
    public void removeSecondTime(string timeName)
    {
        if (secondTimeDic.ContainsKey(timeName))
        {
            secondTimeDic[timeName].removeTimes();
            secondTimeDic[timeName] = null;
            secondTimeDic.Remove(timeName);
        }
    }
}

/// <summary>
/// 帧频定时器
/// </summary>
class FrameTimeClass
{
    public int timeCounts = 1; //定时器执行的次数
    public int delayFrame = 1;//定时器隔多少帧执行一次;
    public LuaFunction callbackFun;// 定时器回调Lua代码;
    public bool isLoop = false;//是否是循环次数
    public string curentTimeName = "";
    public LuaTable mTarget;
    public FrameTimeClass(string _timeName,int _delayFrame, int _timeCounts, LuaFunction _callbackFun,LuaTable _target=null)
    {
        curentTimeName = _timeName;
        timeCounts = _timeCounts;
        delayFrame = _delayFrame;
        callbackFun = _callbackFun;
        mTarget = _target;

        if (timeCounts == 0)
        {
            isLoop = true;
        }
        FrameTimerManager.getInstance().add(delayFrame, timeCounts, timers);
    }

    private void timers()
    {
        if (isLoop)
        {
            callbackFun.call(mTarget);
            return;
        }
        callbackFun.call(mTarget);
        timeCounts--;
        if (timeCounts <= 0)
        {
            UluaTimer.Instance.removeFrameTime(curentTimeName);
            return;
        }
    }

    /// <summary>
    /// 移除定时器
    /// </summary>
    public void removeTimes()
    {
        FrameTimerManager.getInstance().remove(timers);
        timeCounts = 1;
        delayFrame = 1;
        callbackFun = null;
    }
}

/// <summary>
/// 时间定时器
/// </summary>
class SecondTimeClass
{
    public int timeCounts = 1; //定时器执行的次数
    public int delayTime = 1;//定时器隔多少秒执行一次;
    public LuaFunction callbackFun;// 定时器回调Lua代码;
    public bool isLoop = false;//是否是循环次数
    public string curentTimeName = "";
    private LuaTable mTarget;
    public SecondTimeClass(string _curentTimeName, int _delayTime, int _timeCounts, LuaFunction _callbackFun, LuaTable target = null)
    {
        curentTimeName = _curentTimeName;
        timeCounts = _timeCounts;
        delayTime = _delayTime;
        callbackFun = _callbackFun;
        mTarget = target;
        if (timeCounts == 0)
        {
            isLoop = true;
        }
        FrameTimerManager.getTimer().add(delayTime, timeCounts, timers);
    }

    private void timers()
    {
        if (isLoop)
        {
            callbackFun.call(mTarget);
            return;
        }
        callbackFun.call(mTarget);
        timeCounts--;
        if (timeCounts <= 0)
        {
            UluaTimer.Instance.removeSecondTime(curentTimeName);
            return;
        }
    }

    /// <summary>
    /// 移除定时器
    /// </summary>
    public void removeTimes()
    {
        FrameTimerManager.getTimer().remove(timers);
        timeCounts = 1;
        delayTime = 1;
        callbackFun = null;
    }
}
