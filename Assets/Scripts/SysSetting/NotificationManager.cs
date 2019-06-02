/*********************************************************************
* 类 名 称：       NotificationManager
* 命名空间：       
* 创建时间：       2014/10/29 10:19:20
* 作    者：       张晶晶
* 说    明：       针对Android和ios平台提供不同的消息通知接口
* 最后修改时间：   2014/10/29
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class NotificationManager : MonoBehaviour
{

    private static string message = "吃鸡腿时间到了，快来吃呀，好好吃的";
    private static string message1 = "商店已经刷新可以购买物品了哦";
    private static string message2 = "精力已经恢复满了";
    private static string message3 = "技能点已经满了，可以给各位英雄添加技能了哦";
    private static string message4 = "竞技场被攻击了，看是那个坏人过来扫荡";
    /// <summary>
    //进入游戏就清除通知栏的信息
    /// </summary>
    /// 
    void Start()
    {
        //一开始如果设置为空设置系统默认设置   
        setDefault();
#if !UNITY_EDITOR
#if UNITY_IPHONE
            NotificationManager.ClearNotification();
#endif
#endif
    }

    public static void setDefault()
    {
    //    string on = MusicSetting.SE
        
        if (PlayerPrefs.GetString("music") != "")
        {
            PlayerPrefs.SetString("music", ""); //获取音效设置
        }
        if (PlayerPrefs.GetString("sound") != "")
            PlayerPrefs.SetString("sound", "1");
        if (PlayerPrefs.GetString("strength") != "")
            PlayerPrefs.SetString("strength", "0");
        if (PlayerPrefs.GetString("refreshStore") != "")
            PlayerPrefs.SetString("refreshStore", "0");
        if (PlayerPrefs.GetString("energy") == "")
            PlayerPrefs.SetString("energy", "0");
        if (PlayerPrefs.GetString("skill") == "")
            PlayerPrefs.SetString("skill", "0");
        if (PlayerPrefs.GetString("arena") == "")
            PlayerPrefs.SetString("arena", "0");

    }
    /// <summary>
    /// 当游戏进入后台时判断各种推送消息是否打开，打开了到了设定的条件就发送消息
    /// </summary>
    /// <param name="paused"></param>
    void OnApplicationPause(bool paused)
    {
        //程序进入后台时
#if !UNITY_EDITOR
        if(!paused)
        {
#if UNITY_IPHONE
           
                //程序从后台进入前台时
                NotificationManager.ClearNotification();
#endif
        }
#endif

    }

    public static void setAlarmBySet()
    {
     //   MyDebug.Log("setting success");
        #if UNITY_ANDROID
            string musicState = PlayerPrefs.GetString("music"); //获取音效设置
            string soundState = PlayerPrefs.GetString("sound");
            string strengthState = PlayerPrefs.GetString("strength");
            string refreshStoreState = PlayerPrefs.GetString("refreshStore");
            string energyFullState = PlayerPrefs.GetString("energy");
            string skillFullState = PlayerPrefs.GetString("skill");
            string arenaState = PlayerPrefs.GetString("arena");
       //     MyDebug.Log("setting success");
            sendNotificationBySet(12, 18, 1, 2, strengthState, "strengthAlarmSet", message);
            sendNotificationBySet(14, 21, 3, 4, refreshStoreState, "refreshStoreAlarmSet", message1);
#endif
    }

    public static void sendNotificationBySet(int hour1, int hour2, int id1, int id2, string type, string prefType, string message)
    {
        if (type == "1")
        {
            MyDebug.Log("prefType");
            if (PlayerPrefs.GetString(prefType) == "" || (PlayerPrefs.GetString(prefType) != "" && PlayerPrefs.GetString(prefType) == "false"))
            {
                {
                    MyDebug.Log("开始吃鸡腿通知");
                    Notification(hour1, id1, message);  //参数1标识消息提醒时间，参数二标识消息id，参数三标识消息内容
                    Notification(hour2, id2, message);
                    PlayerPrefs.SetString(prefType, "true");
                }
            }
        }
        else
        {
            if (PlayerPrefs.GetString(prefType) != "" && PlayerPrefs.GetString(prefType) == "true")
            {
                MyDebug.Log("取消id" + id2);
                cancleAlarm(id1);
                cancleAlarm(id2);
                PlayerPrefs.SetString(prefType, "false");
            }
        }
    }
    public static void cancleAlarm(int id)
    {
#if !UNITY_EDITOR
       #if UNITY_ANDROID
             MyDebug.Log("开始调用Android代码");
                AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
                jo.Call("cancleAlarm", ""+id);
#endif
#endif

    }
    /// <summary>
    /// 判断传过来的时间点到点发布通知
    /// </summary>
    /// <param name="title"></param>
    /// <param name="message"></param>
    public static void Notification(int hour, int id, string message)
    {
        // 推送已被删除
        /*
#if !UNITY_EDITOR
#if UNITY_ANDROID
            MyDebug.Log("开始调用Android代码");
            AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
            string pars = hour + "/0/0/" + id + "/" + message;
            jo.Call("setAlarmService", pars);
#endif

	#if UNITY_ANDROID
            int year = System.DateTime.Now.Year;
            int month = System.DateTime.Now.Month;
            int day = System.DateTime.Now.Day;
            System.DateTime newDate = new System.DateTime(year, month, day, hour, 0, 0);
            LocalNotification localNotification = new LocalNotification();
            localNotification.fireDate = newDate;
            localNotification.alertBody = message;
            localNotification.applicationIconBadgeNumber = 1;
            localNotification.hasAction = true;
            localNotification.soundName = LocalNotification.defaultSoundName;
            NotificationServices.ScheduleLocalNotification(localNotification);
#endif
#endif
         */
    }

    //针对ios平台第一次进入游戏的时候清空
    public static void ClearNotification()
    {
        // 推送已被删除
        /*
#if !UNITY_EDITOR
	#if UNITY_ANDROID
            LocalNotification l = new LocalNotification();
            l.applicationIconBadgeNumber = -1;
            NotificationServices.PresentLocalNotificationNow(l);
            NotificationServices.CancelAllLocalNotifications();
            NotificationServices.ClearLocalNotifications();
#endif
#endif
         * */
    }


}
