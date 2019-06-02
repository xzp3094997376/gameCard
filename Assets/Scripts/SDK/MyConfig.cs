using UnityEngine;
using System.Collections;


//此类用于对参数进行集中管理
public static class MyConfig
{

	//联调环境参数
	public static int cpid = 51742;
	public static int gameid = 320676;
	public static int serverid = 0;
	public static string servername = "sdk";

	//add by lihui 2017-3-2 anysdk参数
	public static string anysdk_appkey = "E1AB55F4-DC13-99A5-1633-A69D171EFEE6";
	public static string anysdk_appsecret = "38413c0a0f227f1a90ce89715b35a75e";
	public static string anysdk_privately = "31C188C7A489736677C5954918967412";
	public static string anysdk_loginserver = "http://pay.99play.cc:7934/checkAnySDKLogin";

	//正式环境参数
	//public static int cpid = ;
	//public static int gameid = ;
	//public static int serverid = ;
	//public static string servername = ;


	public static bool debugMode = false;
	public static int logLevel = MyConstants.LOGLEVEL_DEBUG;
    public static int orientation = MyConstants.ORIENTATION_LANDSCAPE;
	public static bool enablePayHistory = false;
	public static bool enableLogout = true;


	public static bool inited = false;
	public static int initRetryTimes = 0;
	public static bool logined = false;

    public static int loginUISwitch = MyConstants.USE_WIDGET;

}
