using UnityEngine;
using System.Collections;

public class MyDebug
{

    public static bool isDebug = true;

    public static void Log(object str)
    {
        if (isDebug)
        {
            Debug.Log(str);
        }
    }
    public static void Log(object str, Object context)
    {
        if (isDebug)
        {
            Debug.Log(str, context);
        }
    }

    public static void LogError(object msg)
    {
        if (isDebug)
        {
            Debug.LogError(msg);
        }
    }

    public static void LogError(object str, Object context)
    {
        if (isDebug)
        {
            Debug.LogError(str, context);
        }
    }
    public static void LogWarning(object msg)
    {
        if (isDebug)
        {
            Debug.LogWarning(msg);
        }
    }

    public static void LogWarning(object msg, Object context)
    {
        if (isDebug)
        {
            Debug.LogWarning(msg, context);
        }
    }
}
