using UnityEngine;
using System.Collections;
using Umeng;
using Facebook.Unity;

public class sdkManager : MonoBehaviour {

	// Use this for initialization
	void Start () {
		#if UNITY_ANDROID
			sdkForAppsFlyer ();
			sdkForUmeng ();
			//sdkForFaceBook ();
		#endif
	}

	void sdkForAppsFlyer()
	{
//		#if UNITY_IOS
//			AppsFlyer.setAppsFlyerKey ("3g3NMHGkG9kiFGx3uzkyTH");
//			AppsFlyer.setAppID ("1219186153");
//			AppsFlyer.getConversionData ();
//			AppsFlyer.trackAppLaunch ();
//			Debug.Log("这里完成IOS的APPSFLYER初始化，setAPPID：1219186153");
//			byte[] token = UnityEngine.iOS.NotificationServices.deviceToken;
//			if(token != null)
//			{
//				AppsFlyer.registerUninstall(token);
//			}
//		#el
		#if UNITY_ANDROID
			Application.runInBackground = true;
			AppsFlyer.setIsDebug (false);
			//Mandatory - set your Android package name
			AppsFlyer.init ("3g3NMHGkG9kiFGx3uzkyTH");
			AppsFlyer.setAppID ("com.sl.ftzw.gtad"); 
			Debug.Log("这里完成安卓的APPSFLYER初始化，setAPPID：com.sl.ftzw.gtad");
		#endif
	}

	void sdkForUmeng()
	{
		#if UNITY_ANDROID
			GA.SetLogEnabled (false);
			GA.StartWithAppKeyAndChannelId ("58c0d02acae7e77e6200004b", "UNKNOW");
//		#elif UNITY_IOS
//			GA.StartWithAppKeyAndChannelId ("58c0d058a40fa34299001f7b", "Appstore");
//			GA.SetLogEnabled (false);
		#endif
	}

	void sdkForFaceBook()
	{
		#if UNITY_ANDROID
			//FB.ActivateApp();			
		#endif
	}
}
