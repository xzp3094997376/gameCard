using UnityEngine;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 设备质量评级
/// </summary>
public class QualityLevel
{
    public static uint Low = 0;

    public static uint Normal = 5;

    public static uint High = 10;
};
/// <summary>
/// 性能级别理器  判断设备的性能级别
/// 然后根据设备的性能采用不一样的决策
/// </summary>
public class QualityManager : MonoBehaviour {

	// Use this for initialization
    private static uint _DeviceLevel = QualityLevel.Low;
    private static bool isInit = false;
    //hash资源  如果为count为0申请释放
    private static Dictionary<string, int> m_AssetsCount = new Dictionary<string, int>();
    public static uint Level
    {
        get
        {
            if (!isInit)
            {
                _DeviceLevel = QualityLevel.Low;
                //MyDebug.Log(SystemInfo.systemMemorySize + " ...system ......................");
                if (SystemInfo.systemMemorySize > 1536 && SystemInfo.graphicsMemorySize > 168)
                    _DeviceLevel = QualityLevel.High;
                else if (SystemInfo.systemMemorySize >= 1536)
                    _DeviceLevel = QualityLevel.Normal;
            }
#if UNITY_IOS
            _DeviceLevel = QualityLevel.High;
#endif
            return _DeviceLevel;
        }
    }
    void Log(string format, params object[] arg)
    {
        var sf = new System.Diagnostics.StackFrame(1, true);
        string info = string.Format(format, arg);
        string log = string.Format(
            "{0}\tFile:{1}\tLine:{2}\t{3}\t{4}",
            System.DateTime.Now.ToString("MM-dd HH:mm:ss"),
            sf.GetFileName(),
            sf.GetFileLineNumber(),
            sf.GetMethod(),
            info
        );
        // ...
    }
    public static bool IsLow()
    {
        return Level == QualityLevel.Low;
    }

    public static void CacheAssets(string strName)
    {
        if(m_AssetsCount.ContainsKey(strName))
        {
            m_AssetsCount[strName]++;
        }
        else
        {
            m_AssetsCount[strName] = 2;
        }
    }
    /// <summary>
    /// 回收战斗资源  计数器为0的所有资源
    /// </summary>
    public static void RecycleAllAssets()
    {
      // Dictionary<string,int>.KeyCollection keys = m_AssetsCount.Keys;
        List<string> keys = new List<string>();
       foreach (var item in m_AssetsCount)
        {
            keys.Add(item.Key);
        }
       for (int i = 0; i < keys.Count; i++)
       {
           m_AssetsCount[keys[i]]--;
           if (m_AssetsCount[keys[i]] <= 0)
           {
               RecycleAssetBundle(keys[i], true);
               m_AssetsCount.Remove(keys[i]);
           }
       }
    }
    public static void RecycleAssetBundle(string path, bool isForce = false)
    {
        LoadManager.getInstance().removeResource(path, isForce);
        return;
    }

#region  对象单例化
    //private static QualityManager _ins = null;
    //private QualityManager()
    //{

    //}
    ///// <summary>
    ///// 单利对象
    ///// </summary>
    //public static QualityManager Inst
    //{
    //    get
    //    {
    //        if (_ins == null)
    //        {
    //            _ins = new QualityManager(); 
    //            _ins
    //        }
    //        return _ins;
    //    }
    //}
#endregion
}
