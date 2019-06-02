//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

	using System.Collections;
	using System.Collections.Generic;
	using UnityEngine;
using System;
public class FrameTimerManager
{
    private static Dictionary<string, FrameTimer> _dic = new Dictionary<string, FrameTimer>();
    private static Dictionary<string, TimerFrame> _timerDic = new Dictionary<string, TimerFrame>();
    private static List<object> keyDic = new List<object>();
    public FrameTimerManager()
    {
    }

    /**
     * 返回帧的定时器 
     * @param id
     * @return 
     * 
     */
    public static FrameTimer getInstance(string name = "default")
    {
        if (!_dic.ContainsKey(name))
        {
            _dic[name] = new FrameTimer();
            keyDic.Add(_dic[name]);
        }
        return _dic[name];
    }

    public static void freeInstance(string name = "default")
    {
        if (_dic.ContainsKey(name))
        {
            _dic[name].dispose();
            keyDic.Remove(_dic[name]);
        }
        _dic.Remove(name);
    }


/// <summary>
/// 返回时间定时器，单位秒
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
    public static TimerFrame getTimer(string name = "default")
    {
        if (!_timerDic.ContainsKey(name))
        {
            _timerDic[name] = new TimerFrame();
            keyDic.Add(_timerDic[name]);
        }
        return _timerDic[name];
    }

    public static void freeTimer(string name = "default")
    {
        if (_timerDic.ContainsKey(name))
        {
            _timerDic[name].dispose();
            keyDic.Remove(_timerDic[name]);
        }
        _timerDic.Remove(name);
    }
    public static void frameHandle()
    {
        for (int i = 0; i < keyDic.Count; i++)
        {
            object obj = keyDic[i];
            if (obj is FrameTimer)
                (obj as FrameTimer).enterFrameHandler();
            if (obj is TimerFrame)
                (obj as TimerFrame).onTimer();
        }
    }
}
