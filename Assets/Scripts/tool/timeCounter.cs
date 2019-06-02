using UnityEngine;
using System.Collections;
using System;

public class timeCounter : IDisposable
{
    private long m_start;
    private long m_end;
    private string m_name;
    public timeCounter(string name)
    {
        m_name = name;
        m_start = DateTime.Now.Ticks;
    }

    public void Dispose()
    {
        m_end = DateTime.Now.Ticks;
        long ms = (m_end - m_start) / 10000;
        MyDebug.Log("任务 " + m_name + " 耗时:" + ms.ToString() + "ms");
    }
}
