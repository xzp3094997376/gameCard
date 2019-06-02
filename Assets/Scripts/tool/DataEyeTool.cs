/*************************************************************************************
 * 类 名 称：       DataEyeTool
 * 命名空间：       Assets.Scripts.tool
 * 创建时间：       2014/8/8 10:56:16
 * 作    者：       Oliver shen
 * 说    明：       DataEye封装
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using SLua;
using System.Collections.Generic;
using Facebook.Unity;
using System.Runtime.InteropServices;

public static class DataEyeTool
{
    /// <summary>
    /// 标记是否开启数据收集。
    /// 如果为false则不关闭DataEye
    /// </summary>
#if UNITY_EDITOR
    public static bool IsOpenDataEye = false;
#else
    public static bool IsOpenDataEye = true;
#endif
    /// <summary>
    /// 应用ID,用来定位游戏在统计过程中的唯一性，需要在DataEye网站申请。
    /// </summary>
    public static string APP_ID = "948A09C61899A3DBD631B0257A378E76";

    

    #if UNITY_EDITOR || UNITY_IOS
        public static string Testin_ID = "aa27211a875b88e6549504f736002377";
    #else
        public static string Testin_ID = "b899c2ee954b74d8bcb94d9cf4175cfe";
    #endif

    /// <summary>
    /// 渠道号
    /// </summary>
    public static string CHANNEL_ID = "cmge_test";

    /// <summary>
    /// 初始化DataEye,用于统计设备激活数量，ACU,PCU,平时登陆次数
    /// </summary>
    public static void OnStart()
    {
        if (!IsOpenDataEye) return;
        DCAgent.setReportMode(DCReportMode.DC_AFTER_LOGIN);
        Init(APP_ID, CHANNEL_ID);
        //JPushManager.Instance.InitJPushWithDataeye(APP_ID);
        //PushManager.InitPushWithDataeye(APP_ID);
        DCAgent.uploadNow();

    }

	public static void AFEvent(string eventId, string evntDesc)
	{
		#if UNITY_ANDROID
			Dictionary<string, string> eventValue = new Dictionary<string,string> ();
			eventValue.Add("af_content_type",evntDesc);
			eventValue.Add ("af_content_id", eventId);
			AppsFlyer.trackRichEvent(eventId, eventValue);
			Debug.Log ("appsflyer id:" +eventId + ", desc:" + evntDesc);
		#endif
	}

	public static void FBEvent(string eventId, string evntDesc)
	{
		#if UNITY_ANDROID
//		if (FB.IsInitialized) {
//			var tutParams = new Dictionary<string, object>();
//			tutParams[AppEventParameterName.ContentID] = eventId;
//			tutParams[AppEventParameterName.Description] = evntDesc;
//			tutParams[AppEventParameterName.Success] = "1";
//			FB.LogAppEvent (
//				AppEventName.CompletedTutorial,
//				parameters: tutParams
//			);
//			Debug.Log("FB->" + eventId + "事件执行完成");
//		} else {
//			Debug.Log("Failed to Initialize the Facebook SDK");
//		}
		#endif
	}


    public static void Init(string appId, string channelid)
    {
        DCAgent.getInstance().initWithAppIdAndChannelId(appId,channelid);

		//Testin ios 初始化
  //       #if UNITY_IOS
		// TestinManager._initTestin(Testin_ID,channelid);
  //       #endif

        //Testin 插件
        #if UNITY_ANDROID || UNITY_IOS
                UnityEngine.Debug.Log(Testin_ID+ channelid);
        #endif
    }
       
    /// <summary>
    /// Android专用
    /// 用于监听游戏是否最小化到后台或从后台返回而暂停定时器或开启定时器。
    /// </summary>
    public static void OnPause(bool pauseStatus)
    {
        if (!IsOpenDataEye) return;


    }

    /// <summary>
    /// 登陆DataEye
    /// 用户重新登陆或者切换账号登陆时仍需要调用该接口。
    /// 必须调用该接口，调用后才能正常上传数据。
    /// 收集项：玩家注册数量， ACU，PCU，平均在线时长，平均登陆次数，玩家留存/流失/回流。
    /// </summary>
    /// <param name="accountId"></param>
    public static void Login(string accountId,string gameServer)
    {
        if (!IsOpenDataEye) return;
        DCAccount.login(accountId, gameServer);

        //Testin 插件
        #if UNITY_ANDROID || UNITY_IOS
            string userInfo = string.Format("accountId={0}#gameServer={1}", accountId, gameServer);
            UnityEngine.Debug.Log(userInfo); 
        #endif

//#if UNITY_ANDROID
//        if (GlobalVar.isPush != "0")
//        {
//            JPushBinding.registerPushByDataEye("dataeyeAppId", (int)JPushManager.DCPushPlatfrom.DC_JPush);
//        }
//#endif

    }

    /// <summary>
    /// 退出DataEye
    /// 用户切换登陆账户时，回退到登陆界面前调用。
    /// </summary>
    public static void Logout()
    {
        if (!IsOpenDataEye) return;
        DCAccount.logout();
    }

    /// <summary>
    /// 设置帐号类型，如QQ、微博等。
    /// 收集玩家账号类型分布
    /// 按需调用
    /// </summary>
    /// <param name="accountType">帐号类型</param>
    public static void SetAccountType(DCAccountType accountType = DCAccountType.DC_Anonymous)
    {
        if (!IsOpenDataEye) return;
        DCAccount.setAccountType(accountType);
    }

    /// <summary>
    /// 收集玩家等级分布，玩家升级时长分布，等级自定义分析模块。
    /// 按需调用
    /// </summary>
    /// <param name="level"></param>
    public static void SetLevel(int level = 1)
    {
        if (!IsOpenDataEye) return;
        DCAccount.setLevel(level);
    }

    /// <summary>
    /// 按区服统计的所有统计项。
    /// 按需调用
    /// </summary>
    /// <param name="gameServer"></param>
    public static void SetGameServer(string gameServer)
    {
        if (!IsOpenDataEye) return;
        DCAccount.setGameServer(gameServer);
    }

    /// <summary>
    /// 玩家性别分布。
    /// 按需调用
    /// </summary>
    /// <param name="gender"></param>
    public static void SetGender(DCGender gender)
    {
        if (!IsOpenDataEye) return;
        DCAccount.setGender(gender);
    }

    /// <summary>
    /// 收集年龄
    /// 按需调用
    /// </summary>
    /// <param name="age"></param>
    public static void SetAge(int age)
    {
        if (!IsOpenDataEye) return;
        DCAccount.setAge(age);
    }

    /// <summary>
    /// 自定义事件
    /// </summary>
    /// <param name="key"></param>
    /// <param name="table"></param>
    public static void onEvent(string key, LuaTable table)
    {
        if (!IsOpenDataEye) return;
        if (table == null) return;
        Dictionary<string, string> map = new Dictionary<string, string>();
        foreach (var i in table)
        {
            string k = i.key.ToString();
            string val = i.value.ToString();
            map.Add(k, val);
        }
        DCEvent.onEvent(key, map);
    }



    /// <summary>
    /// 退出游戏保存数据。。
    /// </summary>
    public static void Quit()
    {
#if UNITY_EDITOR
#elif UNITY_ANDROID
        if (!IsOpenDataEye) return;
        DCAgent.onKillProcessOrExit();
#endif
    }

    /// <summary>
    /// 收集api返回的数据，如获得、消耗金币，钻石等
    /// </summary>
    /// <param name="api"></param>
    /// <param name="jo"></param>
    internal static void callForApi(string api, SimpleJson.JsonObject jo)
    {
        if (!IsOpenDataEye) return;

        if (jo.ContainsKey("drop") || jo.ContainsKey("consume"))
        {
            //Loom.StartSingleThread(() =>
            //{
            //LuaTable dataEye = TTLuaMain.Instance.luaState["DataEye"] as LuaTable;
            //UluaBinding.CallLuaFunction(dataEye, "res", api.Replace('.', '_'), jo);
            LuaManager.getInstance().CallLuaFunction("GameManager.CallForDataEye", api.Replace('.', '_'), jo);
            //}, System.Threading.ThreadPriority.Lowest, true);
        }

    }

    public static void DcLevelsBegin(int id, string levelId)
    {
        if (!IsOpenDataEye) return;
        DCLevels.begin(id + "_" + levelId);
    }

    public static void DcLevelsComplete(string levelId)
    {
        if (!IsOpenDataEye) return;
        DCLevels.complete(levelId);
    }

    public static void DcLevelsFail(string levelId, string desc = "战败")
    {
        if (!IsOpenDataEye) return;
        DCLevels.fail(levelId, desc);
    }

    /// <summary>
    /// 购买道具
    /// </summary>
    /// <param name="itemId"></param>
    /// <param name="itemType"></param>
    /// <param name="itemCount"></param>
    /// <param name="vituralCurrency"></param>
    /// <param name="currencyType"></param>
    /// <param name="consumePoint"></param>
    public static void DcItemBuy(string itemId, string itemType, int itemCount, long vituralCurrency, string currencyType, string consumePoint)
    {
        if (!IsOpenDataEye) return;
        DCItem.buy(itemId, itemType, itemCount, vituralCurrency, currencyType, consumePoint);
    }

    /// <summary>
    /// 消耗道具
    /// </summary>
    /// <param name="itemId">道具名</param>
    /// <param name="itemType">道具类型</param>
    /// <param name="itemCnt">数量</param>
    /// <param name="reason">原因</param>
    public static void DcItemConsume(string itemId, string itemType, int itemCnt, string reason)
    {
        if (!IsOpenDataEye) return;
        //MyDebug.LogWarning("消耗道具----->道具名:" + itemId + " 道具类型:" + itemType + " 数量:" + itemCnt + " 原因:" + reason);
        DCItem.consume(itemId, itemType, itemCnt, reason);
    }

    /// <summary>
    /// 获得道具
    /// </summary>
    /// <param name="itemId"></param>
    /// <param name="itemType"></param>
    /// <param name="itemCnt"></param>
    /// <param name="reason"></param>
    public static void DcItemGet(string itemId, string itemType, int itemCnt, string reason)
    {
        if (!IsOpenDataEye) return;
        DCItem.get(itemId, itemType, itemCnt, reason);
    }

    /// <summary>
    /// 方法用来记录玩家当前虚拟币的数量
    /// </summary>
    /// <param name="coinNum">数量</param>
    /// <param name="coinType">类型</param>
    public static void DCCoinSetCoinNum(long coinNum, string coinType)
    {
        if (!IsOpenDataEye) return;
        DCCoin.setCoinNum(coinNum, coinType);
    }
    /// <summary>
    /// 获得虚拟币
    /// </summary>
    /// <param name="id"></param>
    /// <param name="coinType"></param>
    /// <param name="gain"></param>
    /// <param name="left"></param>
    public static void DCCoinGain(string id, string coinType, long gain, long left)
    {
        if (!IsOpenDataEye) return;
        DCCoin.gain(id, coinType, gain, left);
    }
    /// <summary>
    /// 虚拟币消耗
    /// </summary>
    /// <param name="id">名称</param>
    /// <param name="coinType">类型</param>
    /// <param name="lost">失去</param>
    /// <param name="left">剩下</param>
    public static void DCCoinLost(string id, string coinType, long lost, long left)
    {
        //MyDebug.LogWarning("虚拟币消耗----->名称:" + id + " 类型:" + coinType + " 失去:" + lost + " 剩下:" + left);
        if (!IsOpenDataEye) return;
        DCCoin.lost(id, coinType, lost, left);
    }

    /// <summary>
    /// 充值
    /// </summary>
    /// <param name="orderId"></param>
    /// <param name="currencyAmount"></param>
    /// <param name="currencyType"></param>
    /// <param name="paymentType"></param>
    public static void paymentSuccess(string orderId, double currencyAmount, string currencyType, string paymentType)
    {
        if (!IsOpenDataEye) return;
        DCVirtualCurrency.paymentSuccess(orderId, currencyAmount, currencyType, paymentType);
    }
}
