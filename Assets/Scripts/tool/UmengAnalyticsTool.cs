/*************************************************************************************
 * 类 名 称：       UmengAnalyticsTool
 * 命名空间：       
 * 创建时间：       2014/8/8 10:56:16
 * 作    者：       Benhuang
 * 说    明：       UmengAnalytics封装
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Umeng;
using System;

public static class UmengAnalyticsTool
{
	/// <summary>
	/// 标记是否开启数据收集。
	/// 如果为false则不关闭UmengAnalytics 
	/// </summary>
	#if UNITY_EDITOR
	public static bool IsOpenUmengAnalytics = false;
	#else
	public static bool IsOpenUmengAnalytics = true;
	#endif
	/// <summary>
	/// 应用ID,用来定位游戏在统计过程中的唯一性，需要在UmengAnalytics网站创建应用产生。
	/// </summary>
	#if UNITY_ANDROID
	public static string APP_ID = "58c0d02acae7e77e6200004b";//58d8de6faed179485c00084b 自己的测试
	#elif UNITY_IOS
	public static string APP_ID = "58c0d058a40fa34299001f7b";//58d9ca0ebbea831ee30009f0
	#endif

	/// <summary>
	/// 渠道号
	/// </summary>
	public static string CHANNEL_ID = GlobalVar.dataEyeChannelID;

	public static bool isOpenSetLog = true;


	/// <summary>
	/// 初始化UmengAnalytics,用于统计设备激活数量，ACU,PCU,平时登陆次数
	/// </summary>
	public static void OnStart()
	{
//		#if UNITY_ANDROID
//			GA.StartWithAppKeyAndChannelId ("58c0d02acae7e77e6200004b", "UNKNOW");
//		#elif UNITY_IOS
//			GA.StartWithAppKeyAndChannelId ("58c0d058a40fa34299001f7b", "Appstore");
//			GA.SetLogEnabled (true);
//		#endif
//
//		//调试开启，发布的时候关闭
//		Debug.Log ("Umeng SDK Start：" + APP_ID + "-" + CHANNEL_ID);
	}

	/// <summary>
	/// 充值
	/// </summary>
	/// <param name="cash">真实币数量.</param>
	/// <param name="source">支付渠道.</param>
	/// <param name="coin">虚拟币数量.</param>
	public static void Pay(string cash, string source, string coin)
	{
		//if (!IsOpenUmengAnalytics) return;
//		GA.PaySource paySource = (GA.PaySource)Enum.Parse(typeof(GA.PaySource),source);
//		GA.Pay (Convert.ToDouble(cash), paySource, Convert.ToDouble(coin));
//		Debug.Log ("Umeng SDK Pay:" + cash + "-" + paySource + "-" + coin);
	}

	/// <summary>
	/// 充值并购买道具.
	/// </summary>
	/// <param name="cash">真实币数量.</param>
	/// <param name="source">支付渠道.</param>
	/// <param name="item">道具ID.</param>
	/// <param name="amount">道具数量.</param>
	/// <param name="price">道具单价.</param>
	public static void PayButItem(string cash, string source, string item, string amount, string price)
	{
		//if (!IsOpenUmengAnalytics) return;
//		GA.PaySource paySource = (GA.PaySource)Enum.Parse(typeof(GA.PaySource),source);
//		GA.Pay (Convert.ToDouble(cash), paySource, item, Convert.ToInt32(amount), Convert.ToDouble(price));
//		Debug.Log ("Umeng SDK PayButItem:"+ cash + "-" + paySource + "-" + item + "-" + amount+ "-" + price);
	}


	/// <summary>
	/// 购买道具.
	/// </summary>
	/// <param name="item">道具ID.</param>
	/// <param name="amount">道具数量.</param>
	/// <param name="price">道具单价.</param>
	public static void Buy(string item, string amount, string price)
	{
		//if (!IsOpenUmengAnalytics) return;
//		GA.Buy (item, int.Parse(amount), Convert.ToDouble(price));
//		Debug.Log ("Umeng SDK Buy:"+ item + "-" + amount + "-" + price);
	}

	/// <summary>
	/// 玩家使用道具的情况.
	/// </summary>
	/// <param name="item">道具ID.</param>
	/// <param name="amount">道具数量.</param>
	/// <param name="price">道具单价.</param>
	public static void Use(string item, string amount, string price)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.Use (item, int.Parse(amount), Convert.ToDouble(price));
//		Debug.Log ("Umeng SDK Use:"+ item + "-" + amount + "-" + price);
	}

	/// <summary>
	/// 进入关卡
	/// </summary>
	/// <param name="level">Level.</param>
	public static void StartLevel(string level)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.StartLevel (level);
//		Debug.Log ("Umeng SDK StartLevel:"+ level);
	}

	/// <summary>
	/// 通过关卡
	/// </summary>
	/// <param name="level">Level.</param>
	public static void FinishLevel(string level)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.FinishLevel (level);
//
//		Debug.Log ("Umeng SDK FinishLevel:"+ level);

	}

	/// <summary>
	/// 未通过关卡
	/// </summary>
	/// <param name="level">Level.</param>
	public static void FailLevel(string level)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.FailLevel (level);
//
//		Debug.Log ("Umeng SDK FailLevel:"+ level);
	}

	/// <summary>
	/// 账号统计
	/// </summary>
	/// <param name="userId">用户ID.</param>
	public static void ProfileSignIn(string userId)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.ProfileSignIn (userId);
//		Debug.Log ("Umeng SDK ProfileSignIn:"+ userId);

	}

	/// <summary>
	/// 账号统计
	/// </summary>
	/// <param name="userId">用户ID.</param>
	/// <param name="provider">使用第三方账号登录信息，ex"WB".</param>
	public static void ProfileSignInPro(string userId, string provider)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.ProfileSignIn (userId, provider);
//		Debug.Log ("Umeng SDK ProfileSignInPro:"+ userId + "-" + provider);

	}


	/// <summary>
	/// 账号登出
	/// </summary>
	public static void ProfileSignOff()
	{
		//if (!IsOpenUmengAnalytics) return;
//
//		GA.ProfileSignOff ();
//		Debug.Log ("Umeng SDK ProfileSignOff");

	}

	/// <summary>
	/// 玩家等级统计
	/// </summary>
	/// <param name="level">Level.</param>
	public static void SetUserLevel(string level)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.SetUserLevel (int.Parse(level));
//		Debug.Log ("Umeng SDK SetUserLevel:"+ level);

	}


	/// <summary>
	/// 额外奖励, 游戏中发生的金币、赠送行为
	/// </summary>
	/// <param name="coin">虚拟币数量.</param>
	/// <param name="source">奖励渠道.</param>
	public static void BonusCoin(string coin, string source)
	{
		//if (!IsOpenUmengAnalytics) return;
//		GA.BonusSource bonusSource = (GA.BonusSource)Enum.Parse(typeof(GA.BonusSource),source);
//		GA.Bonus (Convert.ToDouble(coin), bonusSource);
//		Debug.Log ("Umeng SDK BonusCoin:"+ coin + "-" + bonusSource);

	}

	/// <summary>
	/// 额外奖励道具赠送行为
	/// </summary>
	/// <param name="item">道具ID.</param>
	/// <param name="amount">道具数量.</param>
	/// <param name="price">道具单价.</param>
	/// <param name="source">奖励渠道.</param>
	public static void BonusItem(string item, string amount, string price, string source)
	{
		//if (!IsOpenUmengAnalytics) return;
//		GA.BonusSource bonusSource = (GA.BonusSource)Enum.Parse(typeof(GA.BonusSource),source);
//		GA.Bonus (item, int.Parse(amount), Convert.ToDouble(price), bonusSource);
//		Debug.Log ("Umeng SDK BonusItem:"+ item + "-" + amount+ "-" + price+ "-" + bonusSource);

	}

	/// <summary>
	/// 事件数量统计.
	/// </summary>
	/// <param name="eventId">事件ID.</param>
	/// <param name="eventDesc">事件描述.</param>
	public static void Event(string eventId, string eventDesc)
	{
		#if UNITY_ANDROID
			Dictionary<string,string> dict = new Dictionary<string,string>();
			dict[eventId] = eventDesc;
			GA.Event(eventId, dict);
			Debug.Log ("Umeng SDK Event:"+ eventId + "-" + eventDesc);
		#endif
	}

	/// <summary>
	/// 事件时长统计
	/// </summary>
	/// <param name="eventId">Event identifier.</param>
	public static void EventBegin(string eventId)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.EventBegin (eventId);
//		Debug.Log ("Umeng SDK EventBegin:"+ eventId);

	}

	/// <summary>
	/// 事件时长统计结束
	/// </summary>
	/// <param name="eventId">Event identifier.</param>
	public static void EventEnd(string eventId)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.EventEnd (eventId);
//		Debug.Log ("Umeng SDK EventEnd:"+ eventId);

	}


	/// <summary>
	/// 使用UI界面访问统计
	/// </summary>
	/// <param name="UIname">Uiname.</param>
	public static void PageBegin(string UIname)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.PageBegin (UIname);
//		Debug.Log ("Umeng SDK PageBegin:"+ UIname);

	}

	/// <summary>
	/// 使用UI界面访问统计结束
	/// </summary>
	/// <param name="UIname">UIname.</param>
	public static void PageEnd(string UIname)
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.PageEnd (UIname);
//		Debug.Log ("Umeng SDK PageEnd:"+ UIname);

	}

	/// <summary>
	/// 集成测试请使用此函数获得 设备的识别信息
	/// </summary>
	public static void GetDeviveInfo()
	{
		//if (!IsOpenUmengAnalytics) return;

//		GA.GetDeviceInfo ();
	}




}