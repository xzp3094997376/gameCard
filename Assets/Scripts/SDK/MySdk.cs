using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using LitJson;
#if IOS_GENUINE_ANYSDK
using game;
#endif
public class MySdk : MonoBehaviour
{
    public static MySdk _instance;

    //正版的IDFE
    public static string Idfa = "我是 IDFA ";
	public string uid = "";
	
	LuaFunction _callBack;
    LuaFunction _login_fail_callBack;
	LuaFunction _logout_callBack;
	LuaFunction _pay_callBack;
	LuaFunction _pay_fail_callBack;
	LuaFunction _exit_callBack;
	LuaFunction _exit_popup_callBack;
	LuaFunction _init_callBack;
	private static bool isInitAnysdk = false;
    public static MySdk Instance
	{
		get
		{
			return _instance;
		}
	}
	void Awake()
	{
		_instance = this;
	}

	public void initSDK(LuaFunction fn){

		_init_callBack = fn;
        MyGameSdk.setLogLevel(MyConfig.logLevel);
       // MyDebug.Log("setLogLevel..." + MyConfig.logLevel);

		//设置屏幕方向
        MyGameSdk.setOrientation(MyConfig.orientation);
      //  MyDebug.Log("setOrientation..." + MyConfig.orientation);

		//设置使用登录界面类型
        MyGameSdk.setLoginUISwitch(MyConfig.loginUISwitch);
    //    MyDebug.Log("setLoginUISwitch..." + MyConfig.loginUISwitch);
		//调用初始化  
		MyGameSdk.initSDK (MyConfig.debugMode, MyConfig.logLevel, MyConfig.cpid, MyConfig.gameid, MyConfig.serverid, MyConfig.servername, MyConfig.enablePayHistory, MyConfig.enableLogout);

		#if IOS_GENUINE_ANYSDK
		GameUser.getInstance ().setListener (this, "UserExternalCall");

		GameIAP.getInstance ().setListener (this, "IAPExternalCall");
		if (isInitAnysdk){			
			onInitFinished ();
		}
		#endif
	}
		

	//登录接口 
	public void Login(string customparams){
		MyGameSdk.login (false, "");
	}

    /// <summary>
    /// 进入第三方sdk的用户中心
    /// </summary>
    /// <param name="CallBackJson"></param>
    public void userCenter(string str)
    {
        Debug.Log("ucsdk_________userCenter");

       
    }

	//login接口 
	public void setLoginDelegate(LuaFunction fn){
		Debug.Log ("MySdk setLoginDelegate");
		_callBack = fn;
     //   _login_fail_callBack = fn_fail;
	}
	//logout接口 
    public void setLogoutDelegate(LuaFunction fn)
    {
		MyDebug.Log ("setLogoutDelegate");
		_logout_callBack = fn;
	}
	//lua登录接口 
	public void setPayDelegate(LuaFunction fn,LuaFunction fn_fail){
		MyDebug.Log ("setPayDelegate");
		_pay_callBack = fn;
		_pay_fail_callBack = fn_fail;
	}
	public void setExitCallback(LuaFunction popup_fn,LuaFunction fn){
		MyDebug.Log ("setExitDelegate");
		_exit_callBack = fn;
		_exit_popup_callBack = popup_fn;
	}
	public void onInitFinished(){
		_init_callBack.call();
	}
	//定额支付接口 
	public void pay(string total, string productID, string unitName, string count, string roleId, string roleName, string serverID, string serverName, string level, string callbackInfo, string callBackUrl, string accountId, string sign, string payType) {
		MyDebug.Log("pay"+" "+total+" "+count+ " "+ 0+" "+ roleId+" "+ roleName+" "+ level+" "+ callbackInfo+" "+ callBackUrl + " 支付方式：" + payType);

		MyGameSdk.pay(true, total, productID, unitName, count, roleId, roleName, serverID, serverName, level, callbackInfo, callBackUrl, payType, sign);	
	}
	public void sendSdkEvent(string enevntId, string eventDesc)
	{
		#if UNITY_IOS
			MyGameSdk.setEvent (enevntId, eventDesc);
		#endif
	}

    //加QQ群
	//加QQ群
	public void joinQQGroup(string key)
	{
		#if IOS_GENUINE_ANYSDK
		MyDebug.Log ("serali joinQQGroup:"+GameUser.getInstance().isFunctionSupported("joinQQGroup")+",key="+key);
		string[] keyTemp = key.Split('|') ;
		if (keyTemp.Length > 1)
		{
		MyDebug.Log ("serali joinQQGroup:"+keyTemp[1]+",key="+keyTemp[0]);
		if(GameUser.getInstance().isFunctionSupported("joinQQGroup")){
		Dictionary<string,string> dic=new Dictionary<string, string>();
		//dic.Add(keyTemp[1],keyTemp[0]);
		dic["key"] = keyTemp[1];
		dic["groupUin"] = keyTemp[0];
		GameParam param=new GameParam(dic);
		GameUser.getInstance().callFuncWithParam("joinQQGroup", param);
		}
		}

		#else
		MyDebug.Log ("serali joinQQGroup:key="+key);
		string[] keyTemp = key.Split('|') ;
		if (keyTemp.Length > 1)
		{
			MyDebug.Log ("serali joinQQGroup:"+keyTemp[1]+",key="+keyTemp[0]);
			MyGameSdk.joinQQGroup(keyTemp[0],keyTemp[1]);
		}else{
			MyGameSdk.joinQQGroup("",key);
		}
		#endif
		//		MyGameSdk.joinQQGroup(num,key);
	}

	//登出接口 
    public void Logout(string customparms)
    {
		MyDebug.Log("Logout");
		//TODO
		MyGameSdk.logout ();
	}
	public string getDeviceID(){
		MyDebug.Log("serali getDeviceID="+MyGameSdk.getDeviceID());
		return MyGameSdk.getDeviceID();
	}
	public string getDeviceIDFV(){
		MyDebug.Log("serali GetDeviceIDFA="+MyGameSdk.getDeviceIDFV());
		return MyGameSdk.getDeviceIDFV();
	}
	
	//退出接口 
	public void exit(){
		MyDebug.Log("exit");
		MyGameSdk.exitSDK ();
	}
	//add by lihui 用来统计盈正热云数据 2017-3-20
	public void setEvent(string eventName)
	{
		MyGameSdk.setEvent (eventName);
	}
	public void getDataExtend(string exd){
		uid = exd;
	}
	
	//用户扩展接口 
	public void setExtData(string type , string roleId, string roleName, int roleLevel, int zoneId, string zoneName, int balance, int vip, string partyName){
		MyDebug.Log("setExtData");
//		JsonData jsonExData = new JsonData(); 
//		jsonExData["roleId"] = roleId; 
//		jsonExData["roleName"] = roleName; 
//		jsonExData["roleLevel"] = roleLevel; 
//		jsonExData["zoneId"] = zoneId; 
//		jsonExData["zoneName"] =  zoneName;
		JsonData json = new JsonData ();
		json ["uid"] = uid;
		json ["roleId"] = roleId;
		json ["roleName"] = roleName;
		json ["zoneId"] = zoneId;
		json ["zoneName"] = zoneName;
		json ["roleLevel"] = roleLevel;
        json["type"] = type;
		string datastr = json.ToJson ();
		MyDebug.Log(datastr);
		MyGameSdk.submitExtendData ("loginGameRole", datastr);
	}

	//释放SDK资源接口 
	
	public void releaseResource() {
	}
	//登出回调 
	public void onLogout(string msg){
		MyDebug.Log("onLogout"+msg);
		//LJSDK.Instance.showAndroidToast(msg);
		_logout_callBack.call();
	}
	//检查登陆，此处是为了模拟用户信息校验过程设置，请游戏方自行上传用户信息与游戏服务器进行数据校验 
	public void checkLogin(string uid,string token,string channelid,string subchannelid,string channeluid,string username,string customparams,string productcode, string and_uuid, string ios_uuid,string idfv){
//        Debug.Log("checkLogin" + uid + token + channelid + channeluid + subchannelid + username + customparams + productcode);
		
		if(_callBack!= null){
//			Debug.Log("checkLogin _callBack");
			_callBack.call(uid, token, channelid, subchannelid, channeluid, username, customparams, productcode, and_uuid,ios_uuid, idfv);
//			Debug.Log("onLoginSuccess token222:"+token+",username="+username+",channelid:"+channelid+",subchannelid:"+subchannelid+",productcode:"+productcode+",channeluid:"+channeluid+",customparams:"+customparams+",uid:"+uid);
		}

	}
	
	public void showAndroidToast(string info)
    {
#if UNITY_EDITOR
#elif UNITY_ANDROID
        using (AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
		{ using( AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity"))
			{
				jo.Call("showToast", info);
			}
		}
#elif UNITY_IPHONE
#endif

    }
	
	
	//可通过该方法获取在后台配置的AndroidManifest meta-data值，方法参数为meta-data的name  
//	public string getManifestData(string name) {
//		//
//	}
	
	//登陆成功回调 
		public void onLoginSuccess(string gameuid,string userName, string gameToken, string extend, string resultCode,string andUuid, string iosUuid,string Idfv){
		Debug.Log("onLoginSuccess");
        string token = gameToken; 
		string username = userName;
		string channelid = GlobalVar.dataEyeChannelID;
        string subchannelid = GlobalVar.subChannelID;
		string exd = extend;
		string channeluid = gameuid;
        string customparams = resultCode;
		string uid = gameuid;
		string and_uuid = andUuid;
		string ios_uuid = iosUuid;
		string idfv = Idfv;
		MyDebug.Log ("serali onLoginSuccess ios_uuid: " + ios_uuid);
//		Debug.Log("onLoginSuccess token:"+token+",username="+username+",channelid:"+channelid+",subchannelid:"+subchannelid+",exd:"+exd+",channeluid:"+channeluid+",customparams:"+customparams+",uid:"+uid);
//		if(json ["username"]!=null){
//			username = (string)json ["username"];
//		}
//		if(json["uid"]!=null){
//			uid = (string)json["uid"];
//		}
//		if(json["channelid"]!=null){
//			channelid = (string)json["channelid"];
//		}
//		if(json["productcode"]!=null){
//			productcode = (string)json["productcode"];
//		}
//		if(json["channeluid"]!=null){
//			channeluid = (string)json["channeluid"]; 
//		}
//		if(json["customparams"]!=null){
//			customparams = (string)json["customparams"];
//		}
		
		//		showAndroidToast(msg+" username:"+username+" uid:"+uid+" channelid:"+channelid+" productcode:"+productcode+" token:"+token+" channeluid:"+channeluid+" customparams:"+customparams);
		checkLogin(uid, token, channelid, subchannelid, channeluid, username, customparams, exd, and_uuid, ios_uuid,idfv);

//		Debug.Log("onLoginSuccess token111:"+token+",username="+username+",channelid:"+channelid+",subchannelid:"+subchannelid+",exd:"+exd+",channeluid:"+channeluid+",customparams:"+customparams+",uid:"+uid);
		
	}
	
	//登陆失败回调 
	public void onLoginFailed(string msg){
		MyDebug.Log("onLoginFailed"+msg);
	//	JsonData json = JsonMapper.ToObject(msg);
	//	string failtips = (string)json ["failtips"];
	//	string customparams = (string)json["customparams"];
        _login_fail_callBack.call();
		//		LJSDK.Instance.showAndroidToast (msg+" failtips:"+failtips+" customparmas:"+customparams);
	}

	//当渠道有sdk退出回调时用sdk回调
	public void onExit_SDK(string msg){
		MyDebug.Log("onExitListeningExit"+msg);
		#if IOS_GENUINE_ANYSDK
		DataEyeTool.stopSession ();
		#endif
		_exit_callBack.call ();
	}

    //当渠道有没有sdk退出时用自身弹出框退出
    public void onExit(string msg){
		#if IOS_GENUINE_ANYSDK
		DataEyeTool.stopSession ();
		#endif
        _exit_popup_callBack.call();
    }
	
	//不定额支付成功回调 
	//该回调仅代表用户已发起支付操作，不代表是否充值成功，具体充值是否到账需以服务器间通知为准；在此回调中游戏方可开始向游戏服务器发起请求，查看订单是否已支付成功，若支付成功则发送道具。 
	public void chargeonSuccess(string msg){
		MyDebug.Log("chargeonSuccess="+msg);
	}
	
	//不定额支付失败回调 
	//该回调代表用户已放弃支付，无需向服务器查询充值状态。 
	public void chargeonFail(string msg){
		MyDebug.Log("chargeonFail="+msg);
	}
	
	
	//定额支付成功回调 
	//该回调仅代表用户已发起支付操作，不代表是否充值成功，具体充值是否到账需以服务器间通知为准；在此回调中游戏方可开始向游戏服务器发起请求，查看订单是否已支付成功，若支付成功则发送道具。 
	public void payonSuccess(string msg){
		MyDebug.Log("payonSuccess="+msg);
		_pay_callBack.call(msg);
	}
	
	//定额支付失败回调 
	//该回调代表用户已放弃支付，无需向服务器查询充值状态。 
	public void payonFail(string msg){
		MyDebug.Log("payonFail="+msg);
		//showAndroidToast (msg);
		_pay_fail_callBack.call(msg);
	}
 	
 	public void FinishDeal(string str)
	{
		#if IOS_GENUINE_SDk
			MyGameSdk.FinishDeal(str);
		#endif
	}
	
	
	void OnGUI(){
		//		if(GUILayout.Button("login",GUILayout.Height(100),GUILayout.Width(200))){
		//			LJSDK.Instance.Login("login");
		//		}
		//
		//		if(GUILayout.Button("charge",GUILayout.Height(100),GUILayout.Width(200))){
		//			LJSDK.Instance.charge("XM_ChargeTest", 10, 10,"game callback information",  "http://callbackurl");
		//		}
		//
		//		if(GUILayout.Button("pay",GUILayout.Height(100),GUILayout.Width(200))){
		//			LJSDK.Instance.pay(100, "zuanshi", 10, "XXX-XXX-XXX-XXX", "http://callbackurl");
		//		}
		//
		//		if(GUILayout.Button("logout",GUILayout.Height(100),GUILayout.Width(200))){
		//			LJSDK.Instance.Logout("logout");
		//		}
		//
		//		if(GUILayout.Button("exit",GUILayout.Height(100),GUILayout.Width(200))){
		//			LJSDK.Instance.exit();
		//		}
	}	

#if IOS_GENUINE_ANYSDK
		void IAPExternalCall(string msg)
		{
			MyDebug.Log("serali IAPExternalCall ： "+ msg);
			Dictionary<string,string> dic = GameUtil.stringToDictionary (msg);
			int code = System.Convert.ToInt32(dic["code"]);
			string result = dic["msg"];
			switch(code)
			{
			case (int)PayResultCode.kPaySuccess://支付成功回调
				MyDebug.Log (" serali IAPExternalCall kPaySuccess : " + msg);
				payonSuccess("");
				break;
			case (int)PayResultCode.kPayFail://支付失败回调
				MyDebug.Log (" serali IAPExternalCall kPayFail : " + msg);
				payonFail("");
				break;
			case (int)PayResultCode.kPayCancel://支付取消回调
				MyDebug.Log (" serali IAPExternalCall kPayCancel : " + msg);
				payonFail("");
				break;
			case (int)PayResultCode.kPayNetworkError://支付超时回调
				MyDebug.Log (" serali IAPExternalCall kPayNetworkError : " + msg);
				payonFail("");
				break;
			case (int)PayResultCode.kPayProductionInforIncomplete://支付信息不完整
				break;
		case (int)PayResultCode.kPayNowPaying:
				MyDebug.Log (" serali IAPExternalCall kPayNowPaying : " + msg);
				GameIAP.getInstance ().resetPayState ();
				payonFail("");
				break;
			default:
				payonFail("");
				break;
			}
		}
		void UserExternalCall(string msg){
			MyDebug.Log (" serali UserExternalCall  : " + msg);
			Dictionary<string,string> dic = GameUtil.stringToDictionary (msg);
			int code = System.Convert.ToInt32(dic["code"]);
			string result = dic ["msg"];
			MyDebug.Log (" serali UserExternalCall  result: " + result);
			switch (code) {
		case (int)UserActionResultCode.kInitSuccess: //初始化成功
				MyDebug.Log (" serali UserExternalCall  kInitSuccess ");
				isInitAnysdk = true;
				onInitFinished ();
				DataEyeTool.startSession ();
				break;
			case (int)UserActionResultCode.kInitFail:			
				break;
			case (int)UserActionResultCode.kLoginSuccess:
				string uid = GameUser.getInstance ().getUserID ();
				MyDebug.Log ("serali uid=" + uid);
				MyConfig.logined = true;
				string user_sdk = result;
				string resultCode = "success";
				onLoginSuccess (uid, "",user_sdk, "", resultCode,"","","");
				MyGameSdk.showFloatButton (100, 20, true);
			break;
			case (int)UserActionResultCode.kLoginCancel:			
				break;
			case (int)UserActionResultCode.kLoginFail:
				onLoginFailed (msg);
				break;
			case (int)UserActionResultCode.kLoginNetworkError:
				break;
			case (int)UserActionResultCode.kLogoutSuccess:
				MyDebug.Log ("serali anysdk logout:"+(int)UserActionResultCode.kLogoutSuccess);
				MyConfig.logined = false;				
				onLogout (msg);
				DataEyeTool.stopSession ();
				MyGameSdk.destroyFloatButton ();
				break;
			case (int)UserActionResultCode.kLogoutFail://登出失败回调
				break;
			case (int)UserActionResultCode.kPlatformEnter://平台中心进入回调
				break;
			case (int)UserActionResultCode.kPlatformBack://平台中心退出回调
				break;
			case (int)UserActionResultCode.kPausePage://暂停界面回调
				break;
		case (int)UserActionResultCode.kExitPage://退出游戏回调
				MyDebug.Log ("serali anysdk exit:"+(int)UserActionResultCode.kExitPage+",msg="+msg);
				if (msg == "onGameExit" || msg == "onNo3rdExiterProvide") {
					onExit_SDK (msg);
				} else {
					onExit (msg);
				}
				MyGameSdk.destroyFloatButton ();
				isInitAnysdk = false;
				break;
			case (int)UserActionResultCode.kGameExitPage:
				onExit(msg);
				break;
			default:
				break;
			}
		}
#endif
}


