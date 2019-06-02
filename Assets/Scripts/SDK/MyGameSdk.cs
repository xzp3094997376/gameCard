using UnityEngine;
using System.Collections;
using System.Collections.Generic;
#if UNITY_IPHONE
using System.Runtime.InteropServices;
#endif
#if IOS_GENUINE_ANYSDK
using game;
#endif

/// <summary>
/// UC游戏SDK调用入口类
/// </summary>
public class MyGameSdk : MonoBehaviour
{
    //#if (UNITY_ANDROID || UNITY_EDITOR )
#if UNITY_IPHONE
     #if IOS_GENUINE_SDk //App Store

        [DllImport("__Internal")]
        private static extern int LsFinishDeal(string tradeid);        

        [DllImport("__Internal")]
        private static extern void LSInitPay();	
		

        public static int FinishDeal(string trade){
            MyDebug.Log ("finish : " + trade);
            return LsFinishDeal (trade);
        }

        public static void initSDK(bool debugMode,
                                   int loglevel,
                                   int cpId,
                                   int gameId,
                                   int serverId,
                                   string serverName,
                                   bool enablePayHistory,
                                   bool enableLogout)
        {
            MyDebug.Log("call initSDK....");
            //LsSetUnityReceiver ("GameManager");  //set the unity message receiver
            ioslogin.ShowLogin ();
            // TODO: API：SDK初始化
            //LsInit(0, "", false);
            MyGameSdk.initPay();
            
        }

        public static void initPay(){
            Debug.Log ("init pay");
            #if UNITY_EDITOR

            #elif UNITY_IOS
                LSInitPay ();
            #endif
        }

         public static void login(bool enableGameAccount, string gameAccountTitle)
        {
           // Debug.Log("MyGameSdk login");
           //ioslogin.ShowLogin ();
           // MyGameSdk.initPay();
        }

        public static int logout()
        {
            ioslogin.Logout ();
            return 1;
        }
	#else
	public static int logout()
	{
	#if IOS_GENUINE_ANYSDK
	MyDebug.Log ("serali anysdk logout:"+GameUser.getInstance ().isFunctionSupported( "logout" ));						
	if( GameUser.getInstance ().isFunctionSupported( "logout" ) ) {
	GameUser.getInstance ().callFuncWithParam( "logout" );
	}
	return 0;
	#else
		return LsLogout(1);
	#endif
	}

	public static void initSDK(bool debugMode,
		int loglevel,
		int cpId,
		int gameId,
		int serverId,
		string serverName,
		bool enablePayHistory,
		bool enableLogout)
	{
		print("call initSDK....");
	#if IOS_GENUINE_ANYSDK
	MyDebug.Log ("serali anysdk initSDK");
	Game.getInstance ().init (MyConfig.anysdk_appkey, MyConfig.anysdk_appsecret, MyConfig.anysdk_privately, MyConfig.anysdk_loginserver);
	#else
		LsSetUnityReceiver ("GameManager");  //set the unity message receiver
		LsInit(0, "", false);
	#endif
	}
	public static void login(bool enableGameAccount, string gameAccountTitle)
	{
	#if IOS_GENUINE_ANYSDK
	if(!GameUser.getInstance().isLogined()){	
	GameUser.getInstance ().login ();
	}
	#else
		LsLogin();
	#endif
	}
        
    #endif

    #region 用C对SDK-API进行封装
        
        [DllImport("__Internal")]
        private static extern void LsSetUnityReceiver(string gbName);
        
        [DllImport("__Internal")]
        private static extern void LsInit(int appId, string appKey, bool isdebug);
        
        [DllImport("__Internal")]
        private static extern void LsLogin();
        
        [DllImport("__Internal")]
        private static extern void LsLoginEx();
        
        [DllImport("__Internal")]
        private static extern void LsShowToolBar(int point);
        
        [DllImport("__Internal")]
        private static extern void LsHideToolBar();
        
        [DllImport("__Internal")]
        private static extern bool LsLogined();
        
        [DllImport("__Internal")]
        private static extern void LsPause();
        
        [DllImport("__Internal")]
        private static extern int LsgetCurrentLoginState();
        
        [DllImport("__Internal")]
        private static extern string LsloginUin();
        
        [DllImport("__Internal")]
        private static extern string LssessionId();
        
        [DllImport("__Internal")]
        private static extern string LsnickName();
        
        [DllImport("__Internal")]
        private static extern int LsLogout(int param);
        
        [DllImport("__Internal")]
private static extern int LSUniPay(string cooOrderSerial, string productId, string productName, float productPrice, int productCount, string payDescription,int iosPay, string notifyUrl);
        
        [DllImport("__Internal")]
        private static extern int LsUniPayAsyn(string cooOrderSerial, string productId, string productName, float productPrice, int productCount, string payDescription);
        
        [DllImport("__Internal")]
        private static extern int LsUniPayForCoin(string cooOrderSerial, int needPayCoins, string payDescription);
		[DllImport("__Internal")]
		private static extern bool LsJoinQQGroup (string num, string key);
		[DllImport("__Internal")]
		private static extern void LSSetEvent(string eventName);
		[DllImport("__Internal")]
		private static extern void LsSendSdkEvent(string eventID, string eventDesc);
		[DllImport("__Internal")]
		private static extern string LsGetDeviceIDFV ();
		[DllImport("__Internal")]
		private static extern string LsGetDeviceID();
		[DllImport("__Internal")]
		private static extern void LsSubmitExtendData(string dataStr);
		[DllImport("__Internal")]
		private static extern string LsGetExd();
        
        #endregion

        /// <summary>
        /// 设置日志级别
        /// </summary>
        /// <param name="logLevel">
        /// 0=错误信息级别，记录错误日志， 
        /// 1=警告信息级别，记录错误和警告日志， 
        /// 2=调试信息级别，记录错误、警告和调试信息，为最详尽的日志级别。 
        /// Constants 中定义了用到的常量。
        /// </param>
        public static void setLogLevel(int logLevel)
        {
            //  callSdkApi("setLogLevel", logLevel);
        }

		public static string getDeviceIDFV(){
			return LsGetDeviceIDFV ();
		}
		public static string getDeviceID(){
			MyDebug.Log ("getDevice");
		#if UNITY_EDITOR
			return "ddd";
		#elif UNITY_IOS
		return LsGetDeviceID ();
		#endif  
		}
		public static void enterUserCenter()
		{
			#if IOS_GENUINE_ANYSDK
			if(GameUser.getInstance().isFunctionSupported("enterPlatform")){
				GameUser.getInstance().callFuncWithParam("enterPlatform");
			}
			#endif
		}
        
        /// <summary>
        /// 设置屏幕方向（0=竖屏，1=横屏），默认为竖屏（0）。
        /// </summary>
        /// <param name="orientation">屏幕方向，0=竖屏，1=横屏，Constants 中定义了用到的常量。</param>
        public static void setOrientation(int orientation)
        {
            //   callSdkApi("setOrientation", orientation);
        }
        
        ///  <summary> 
        /// 设置使用登录界面的类型
        /// </summary>
        /// <param name="loginUISwitch">界面类型，0=DEFAULT，1=USE_WIDGET，2=USE_WIDGET，Constants 中定义了用到的常量。</param>
        public static void setLoginUISwitch(int loginUISwitch)
        {
            //     callSdkApi("setLoginUISwitch", loginUISwitch);
        }
        
        /// <summary>
        /// 设置游戏老账号（游戏自身账号）的验证结果。
        /// 游戏在接收到 CALLBACKTYPE_GameUserAuthentication 消息时，从消息中读取用户名和密码，向游戏服务器发起账号验证（游戏服务器进行账号验证并向 UC 的 SDK 服务器发起账号绑定请求），
        /// 把从游戏服务器返回的验证结果和 sid 通过此方法通知 SDK，从而完成游戏老账号的登录。
        /// </summary>
        /// <param name="loginResultCode">
        /// 登录结果码，参考 UCGameSDKStatusCode ： 
        /// SUCCESS：                        用户验证成功
        /// LOGIN_GAME_USER_AUTH_FAIL：      用户名不存在或密码错误
        /// LOGIN_GAME_USER_NETWORK_FAIL：   网络错误
        /// LOGIN_GAME_USER_OTHER_FAIL：     未知错误
        /// </param>
        /// <param name="sid">从游戏服务器返回的sid</param>
        public static void setGameUserLoginResult(int loginResultCode, string sid)
        {
            // callSdkApi("setGameUserLoginResult", loginResultCode, sid);
        }
        
        /// <summary>
        /// 返回用户登录后的会话标识，此标识会在失效时刷新，游戏在每次需要使用该标识时应从SDK获取
        /// </summary>
        /// <returns>用户登录会话标识</returns>
        public static string getSid()
        {
            log("Unity3D getSid calling...");
            // TODO: API：获取账号主键ID
            print ("serali getsid " + LsloginUin());
            return LsloginUin();
            
        }		
        
        /// <summary>
        /// 返回用户登录后的会话标识，此标识会在失效时刷新，游戏在每次需要使用该标识时应从SDK获取
        /// </summary>
        /// <returns>用户登录会话标识</returns>
        public static string getToken()
        {
            print ("serali gettoken " + LssessionId());
            return LssessionId();
        }
		
		public static string getExd(){
			return LsGetExd();
		}

		
		//add by lihui 2017-3-20 盈正sdk要用了
		public static string getNicename()
		{
			return LsnickName();
		}
		public static void setEvent(string eventName)
		{
			LSSetEvent(eventName);
		}

		public static void setEvent(string eventId, string eventDesc)
		{
			LsSendSdkEvent (eventId, eventDesc);
		}
        
        /// <summary>
        /// 在当前游戏画面（当前的 Activity ）上创建悬浮按钮
        /// </summary>
        public static void createFloatButton()
        {
            //     callSdkApi("createFloatButton");
        }
        
        /// <summary>
        /// 显示悬浮按钮
        /// </summary>
        /// <param name="x">悬浮按钮显示位置的横坐标，单位：%，支持小数。该参数只支持 0 和 100，分别表示在屏幕最左边或最右边显示悬浮按钮。</param>
        /// <param name="y">悬浮按钮显示位置的纵坐标，单位：%，支持小数。例如：80，表示悬浮按钮显示的位置距屏幕顶部的距离为屏幕高度的 80% 。</param>
        /// <param name="visible">true=显示 false=隐藏，隐藏时x,y的值忽略</param>
        public static void showFloatButton(float x, float y, bool visible)
        {
            // TODO: API：显示工具条: point=1,2,3,4,5,6,分别表示：左上、右上、左中、右中、左下、右下 
			#if IOS_GENUINE_ANYSDK
				GameParam param = new GameParam((int)ToolBarPlace.kToolBarBottomLeft);
				if (GameUser.getInstance ().isFunctionSupported ("showToolBar")) {
					GameUser.getInstance ().callFuncWithParam ("showToolBar",param);
				}
			#else
            LsShowToolBar(1);
			#endif
        }
        
        /// <summary>
        /// 销毁当前游戏画面（当前 Activity）悬浮按钮
        /// </summary>
        public static void destroyFloatButton()
        {
            // TODO: API：隐藏工具条
		#if IOS_GENUINE_ANYSDK
			if (GameUser.getInstance ().isFunctionSupported ("hideToolBar")) {
				GameUser.getInstance ().callFuncWithParam ("hideToolBar");
			}	
		#else
            LsHideToolBar();
		#endif
            //   callSdkApi("destroyFloatButton");
        }
        
        /// <summary>
        /// 设置玩家选择的游戏分区及角色信息 
        /// </summary>
        /// <param name="zoneName">玩家实际登录的分区名称</param>
        /// <param name="roleId">角色编号</param>
        /// <param name="roleName">角色名称</param>
        public static void notifyZone(string zoneName, string roleId, string roleName)
        {
            //   callSdkApi("notifyZone", zoneName, roleId, roleName);
        }
        
        /**
         * 
         * @param allowContinuousPay 
         * @param amount 
         * @param serverId 
         * @param roleId 
         * @param roleName 
         * @param grade 
         * @param customInfo 充值自定义信息，此信息作为充值订单的附加信息，充值过程中不作任何处理，仅用于游戏设置自助信息，比如游戏自身产生的订单号、玩家角色、游戏模式等。
         *    如果设置了自定义信息，UC在完成充值后，调用充值结果回调接口向游戏服务器发送充值结果时将会附带此信息，游戏服务器需自行解析自定义信息。
         *    如果不需设置自定义信息，将此参数置为空字符串即可。
         * @return 
         * 
         */
        //
        /// <summary>
        /// 执行充值下单操作，此操作会调出充值界面。 
        /// </summary>
        /// <param name="allowContinuousPay">设置是否允许连接充值，true表示在一次充值完成后在充值界面中可以继续下一笔充值，false表示只能进行一笔充值即返回游戏。</param>
        /// <param name="amount">充值金额。默认为0，如果不设或设为0，充值时用户从充值界面中选择或输入金额；如果设为大于0的值，表示固定充值金额，不允许用户选择或输入其它金额。</param>
        /// <param name="serverId">当前充值的游戏服务器（分区）标识，此标识即UC分配的游戏服务器ID</param>
        /// <param name="roleId">当前充值用户在游戏中的角色标识</param>
        /// <param name="roleName">当前充值用户在游戏中的角色名称</param>
        /// <param name="grade">当前充值用户在游戏中的角色等级</param>
        /// <param name="customInfo">
        /// 充值自定义信息，此信息作为充值订单的附加信息，充值过程中不作任何处理，仅用于游戏设置自助信息，比如游戏自身产生的订单号、玩家角色、游戏模式等。
        /// 如果设置了自定义信息，UC在完成充值后，调用充值结果回调接口向游戏服务器发送充值结果时将会附带此信息，游戏服务器需自行解析自定义信息。
        /// 如果不需设置自定义信息，将此参数置为空字符串即可。
        /// </param> MyGameSdk.pay(true, total, productID, unitName, count, roleId, roleName, serverID, serverName,level, callbackInfo, callBackUrl);
        /// <param name="notifyUrl">支付回调通知URL</parma>
        public static int pay(bool allowContinuousPay,
                              string amount,
                              string productID,
                              string unitName,
                              string count,
                              string roleId,
                              string roleName,
                              string serverID,
                              string serverName,
                              string grade,
                              string customInfo,
                              string notifyUrl,
							  string payType, 
							  string sign)
        {
            // callSdkApi("pay", allowContinuousPay, amount, productID, unitName, count, roleId, roleName, serverID, serverName, grade, customInfo, notifyUrl);
            // TODO: API：同步支付（订单号，道具ID，道具名，价格，数量，分区：不超过20个英文或数字的字符串）
			#if IOS_GENUINE_ANYSDK
				int price = System.Convert.ToInt32 (amount) / 100;
				int rate = TableReader.Instance.TableRowByID("charge_settings", "charge_rate").num("value");
				Dictionary<string,string> mProductionInfo = new Dictionary<string,string>();
				if (price > 648) {
					mProductionInfo ["Product_Id"] = "com.gamensqx.App.108";
					int num = price / 648;
					MyDebug.Log("serali anysdk pay num = " + num);
					mProductionInfo["Product_Count"] = num.ToString();
				} else {
					mProductionInfo["Product_Id"] = "com.gamensqx.App."+productID;
					mProductionInfo["Product_Count"] = "1";
				}			
				mProductionInfo["Product_Name"] = unitName;
				mProductionInfo["Product_Price"] = System.Convert.ToString(price);						
				mProductionInfo["Coin_Name"] = "钻石";
				mProductionInfo["Coin_Rate"] = rate.ToString();
				mProductionInfo["Role_Id"] = roleId;
				mProductionInfo["Role_Name"] = roleName;
				mProductionInfo["Role_Grade"] = grade;			
				mProductionInfo["Server_Id"] = serverID;
				mProductionInfo["Server_Name"] = serverName;
				mProductionInfo["EXT"] = customInfo;
				GameIAP.getInstance().payForProduct(mProductionInfo);//若为单支付，可直接调用
				return 0;
			#else
				return LSUniPay(customInfo, productID, unitName,float.Parse(amount), int.Parse(count), serverID, int.Parse(payType), roleId);
			#endif
        }
		// add by serali 2-10
		public static bool joinQQGroup(string num, string key)
		{
			return LsJoinQQGroup (num, key);
		}
        
        
        /// <summary>
        /// 打开U点充值界面
        /// </summary>
        public static void uPointCharge()
        {
            //callSdkApi("uPointCharge");
        }
        
        /// <summary>
        /// 进入九游社区（个人中心） 
        /// </summary>
            // callSdkApi("enterUserCenter");
        
        /// <summary>
        /// 进入某一特定SDK界面 
        /// </summary>
        /// <param name="business">界面业务参数，用于调用目标业务UI。具体的业务参数请参考SDK开发参考文档。</param>
        public static void enterUI(string business)
        {
            //   callSdkApi("enterUI", business);
        }
        
        /// <summary>
        /// 提交游戏扩展数据，在登录成功以后可以调用。具体的数据种类和数据内容定义，请参考SDK开发参考文档。
        /// </summary>
        /// <param name="dataType">数据种类</param>
        /// <param name="dataStr">数据内容，是一个 JSON 字符串。</param>
        public static void submitExtendData(string dataType, string dataStr)
        {           
			LsSubmitExtendData(dataStr);
			
        }
        
        /// <summary>
        /// 当前登录用户是否UC会员，结果从回调中获取。
        /// </summary>
        public static void isUCVip()
        {
            //   callSdkApi("isUCVip");
        }
        
        /// <summary>
        /// 获取当前登录用户的UC会员信息，包括：状态、有效期、特权等，结果从回调中获取。
        /// </summary>
        public static void getUCVipInfo()
        {
            //    callSdkApi("getUCVipInfo");
        }
        
        /// <summary>
        /// 退出SDK，游戏退出前必须调用此方法，以清理SDK占用的系统资源。如果游戏退出时不调用该方法，可能会引起程序错误。
        /// </summary>
        public static void exitSDK()
        {
			MyDebug.Log ("serali anysdk exitSDK");
	#if IOS_GENUINE_ANYSDK
			if( GameUser.getInstance ().isFunctionSupported( "exit" ) ) {
				GameUser.getInstance ().callFuncWithParam( "exit" );
			}
	#endif
        }
    

        private static void log(string msg)
        {
            //Debug.Log(msg);
            print(msg);
        }
		
 
#else  //安卓 pc
        
       #region 安卓

        private const string SDK_JAVA_CLASS = "cn.gamesdk.unity3d.GameSdk";

        /// <summary>
        /// 设置日志级别
        /// </summary>
        /// <param name="logLevel">
        /// 0=错误信息级别，记录错误日志， 
        /// 1=警告信息级别，记录错误和警告日志， 
        /// 2=调试信息级别，记录错误、警告和调试信息，为最详尽的日志级别。 
        /// Constants 中定义了用到的常量。
        /// </param>
        public static void setLogLevel(int logLevel)
        {
            callSdkApi("setLogLevel", logLevel);
        }

        /// <summary>
        /// 设置屏幕方向（0=竖屏，1=横屏），默认为竖屏（0）。
        /// </summary>
        /// <param name="orientation">屏幕方向，0=竖屏，1=横屏，Constants 中定义了用到的常量。</param>
        public static void setOrientation(int orientation)
        {
            callSdkApi("setOrientation", orientation);
        }

        ///  <summary> 
        /// 设置使用登录界面的类型
        /// </summary>
        /// <param name="loginUISwitch">界面类型，0=DEFAULT，1=USE_WIDGET，2=USE_WIDGET，Constants 中定义了用到的常量。</param>
        public static void setLoginUISwitch(int loginUISwitch)
        {
            callSdkApi("setLoginUISwitch", loginUISwitch);
        }


        /// <summary>
        /// 初始化SDK
        /// </summary>
        /// <param name="debugMode">是否联调模式， false=连接SDK的正式生产环境，true=连接SDK的测试联调环境</param>
        /// <param name="loglevel">
        /// 日志级别：
        /// 0=错误信息级别，记录错误日志，
        /// 1=警告信息级别，记录错误和警告日志， 
        /// 2=调试信息级别，记录错误、警告和调试信息，为最详尽的日志级别 
        /// </param>
        /// <param name="cpId">游戏合作商ID，该ID由UC游戏中心分配，唯一标识一个游戏合作商</param>
        /// <param name="gameId">游戏ID，该ID由UC游戏中心分配，唯一标识一款游戏</param>
        /// <param name="serverId">游戏服务器（游戏分区）标识，由UC游戏中心分配</param>
        /// <param name="serverName">游戏服务器（游戏分区）名称</param>
        /// <param name="enablePayHistory">是否启用支付查询功能</param>
        /// <param name="enableLogout">是否启用用户切换功能</param>
        public static void initSDK(bool debugMode,
                                int loglevel,
                                int cpId,
                                int gameId,
                                int serverId,
                                string serverName,
                                bool enablePayHistory,
                                bool enableLogout)
        {
            print("call initSDK....");
            callSdkApi("initSDK", debugMode,
                loglevel,
                cpId,
                gameId,
                serverId,
                serverName,
                enablePayHistory,
                enableLogout);
        }

        /// <summary>
        /// 调用SDK的用户登录 
        /// 注意：需要支持游戏老账号（游戏自身账号）登录时（enableGameAccount=true），需要在 Android 项目的 Java 代码中编写用户登录验证的逻辑（GameUserLoginOperation 类的 process 方法中）。
        /// </summary>
        /// <param name="enableGameAccount">是否允许使用游戏老账号（游戏自身账号）登录</param>
        /// <param name="gameAccountTitle">
        /// 游戏老账号（游戏自身账号）的账号名称，如“三国号”、“风云号”等。
        /// 如果 enableGameAccount 为false，此参数的值设为空字符串即可。
        /// </param>
        public static void login(bool enableGameAccount, string gameAccountTitle)
        {
            callSdkApi("login", enableGameAccount, gameAccountTitle);
        }

        /// <summary>
        /// 设置游戏老账号（游戏自身账号）的验证结果。
        /// 游戏在接收到 CALLBACKTYPE_GameUserAuthentication 消息时，从消息中读取用户名和密码，向游戏服务器发起账号验证（游戏服务器进行账号验证并向 UC 的 SDK 服务器发起账号绑定请求），
        /// 把从游戏服务器返回的验证结果和 sid 通过此方法通知 SDK，从而完成游戏老账号的登录。
        /// </summary>
        /// <param name="loginResultCode">
        /// 登录结果码，参考 UCGameSDKStatusCode ： 
        /// SUCCESS：                        用户验证成功
        /// LOGIN_GAME_USER_AUTH_FAIL：      用户名不存在或密码错误
        /// LOGIN_GAME_USER_NETWORK_FAIL：   网络错误
        /// LOGIN_GAME_USER_OTHER_FAIL：     未知错误
        /// </param>
        /// <param name="sid">从游戏服务器返回的sid</param>
        public static void setGameUserLoginResult(int loginResultCode, string sid)
        {
            callSdkApi("setGameUserLoginResult", loginResultCode, sid);
        }

        /// <summary>
        /// 返回用户登录后的会话标识，此标识会在失效时刷新，游戏在每次需要使用该标识时应从SDK获取
        /// </summary>
        /// <returns>用户登录会话标识</returns>
        public static string getSid()
        {
            log("Unity3D getSid calling...");

            //using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_CLASS))
            //{
            //    return cls.CallStatic<string>("getSid");
            //}
            return callSdkApi<string>("getSid");

        }
		//add by lihui 得到透传字段
		public static string getExd(){
			return callSdkApi<string>("getExtend");
		}
		public static string getNicename(){
			return null;
		}

        /// <summary>
        /// 返回用户登录后的会话标识，此标识会在失效时刷新，游戏在每次需要使用该标识时应从SDK获取
        /// </summary>
        /// <returns>用户登录会话标识</returns>
        public static string getToken()
        {
            log("Unity3D getToken calling...");

            //using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_CLASS))
            //{
            //    return cls.CallStatic<string>("getToken");
            //}
            return callSdkApi<string>("getToken");
        }

        /// <summary>
        /// 退出当前登录的账号
        /// </summary>
        public static void logout()
        {
            callSdkApi("logout");
        }

        /// <summary>
        /// 在当前游戏画面（当前的 Activity ）上创建悬浮按钮
        /// </summary>
        public static void createFloatButton()
        {
            callSdkApi("createFloatButton");
        }

        /// <summary>
        /// 显示悬浮按钮
        /// </summary>
        /// <param name="x">悬浮按钮显示位置的横坐标，单位：%，支持小数。该参数只支持 0 和 100，分别表示在屏幕最左边或最右边显示悬浮按钮。</param>
        /// <param name="y">悬浮按钮显示位置的纵坐标，单位：%，支持小数。例如：80，表示悬浮按钮显示的位置距屏幕顶部的距离为屏幕高度的 80% 。</param>
        /// <param name="visible">true=显示 false=隐藏，隐藏时x,y的值忽略</param>
        public static void showFloatButton(float x, float y, bool visible)
        {
            callSdkApi("showFloatButton", x, y, visible);
        }

        /// <summary>
        /// 销毁当前游戏画面（当前 Activity）悬浮按钮
        /// </summary>
        public static void destroyFloatButton()
        {
            callSdkApi("destroyFloatButton");
        }

        /// <summary>
        /// 设置玩家选择的游戏分区及角色信息 
        /// </summary>
        /// <param name="zoneName">玩家实际登录的分区名称</param>
        /// <param name="roleId">角色编号</param>
        /// <param name="roleName">角色名称</param>
        public static void notifyZone(string zoneName, string roleId, string roleName)
        {
            callSdkApi("notifyZone", zoneName, roleId, roleName);
        }

        /**
         * 
         * @param allowContinuousPay 
         * @param amount 
         * @param serverId 
         * @param roleId 
         * @param roleName 
         * @param grade 
         * @param customInfo 充值自定义信息，此信息作为充值订单的附加信息，充值过程中不作任何处理，仅用于游戏设置自助信息，比如游戏自身产生的订单号、玩家角色、游戏模式等。
         *    如果设置了自定义信息，UC在完成充值后，调用充值结果回调接口向游戏服务器发送充值结果时将会附带此信息，游戏服务器需自行解析自定义信息。
         *    如果不需设置自定义信息，将此参数置为空字符串即可。
         * @return 
         * 
         */
        //
        /// <summary>
        /// 执行充值下单操作，此操作会调出充值界面。 
        /// </summary>
        /// <param name="allowContinuousPay">设置是否允许连接充值，true表示在一次充值完成后在充值界面中可以继续下一笔充值，false表示只能进行一笔充值即返回游戏。</param>
        /// <param name="amount">充值金额。默认为0，如果不设或设为0，充值时用户从充值界面中选择或输入金额；如果设为大于0的值，表示固定充值金额，不允许用户选择或输入其它金额。</param>
        /// <param name="serverId">当前充值的游戏服务器（分区）标识，此标识即UC分配的游戏服务器ID</param>
        /// <param name="roleId">当前充值用户在游戏中的角色标识</param>
        /// <param name="roleName">当前充值用户在游戏中的角色名称</param>
        /// <param name="grade">当前充值用户在游戏中的角色等级</param>
        /// <param name="customInfo">
        /// 充值自定义信息，此信息作为充值订单的附加信息，充值过程中不作任何处理，仅用于游戏设置自助信息，比如游戏自身产生的订单号、玩家角色、游戏模式等。
        /// 如果设置了自定义信息，UC在完成充值后，调用充值结果回调接口向游戏服务器发送充值结果时将会附带此信息，游戏服务器需自行解析自定义信息。
        /// 如果不需设置自定义信息，将此参数置为空字符串即可。
        /// </param> MyGameSdk.pay(true, total, productID, unitName, count, roleId, roleName, serverID, serverName,level, callbackInfo, callBackUrl);
        /// <param name="notifyUrl">支付回调通知URL</parma>
        public static void pay(bool allowContinuousPay,
                            string amount,
                            string productID,
                            string unitName,
                            string count,
                            string roleId,
                            string roleName,
                            string serverID,
                            string serverName,
                            string grade,
                            string customInfo,
                            string notifyUrl,
							string payType,
                            string sign)
        {
			callSdkApi("pay", allowContinuousPay, amount, productID, unitName, count, roleId, roleName, serverID, serverName, grade, customInfo, notifyUrl, payType, sign);
        }
        /// <summary>
        /// 加QQ群
        /// </summary>
        public static void joinQQGroup(string num, string key)
        {
            callSdkApi<bool>("joinQQGroup",key);
        }
        /// <summary>
        /// 打开U点充值界面
        /// </summary>
        public static void uPointCharge()
        {
            callSdkApi("uPointCharge");
        }

        /// <summary>
        /// 进入九游社区（个人中心） 
        /// </summary>
        public static void enterUserCenter()
        {
            callSdkApi("enterUserCenter");
        }

        /// <summary>
        /// 进入某一特定SDK界面 
        /// </summary>
        /// <param name="business">界面业务参数，用于调用目标业务UI。具体的业务参数请参考SDK开发参考文档。</param>
        public static void enterUI(string business)
        {
            callSdkApi("enterUI", business);
        }

        /// <summary>
        /// 提交游戏扩展数据，在登录成功以后可以调用。具体的数据种类和数据内容定义，请参考SDK开发参考文档。
        /// </summary>
        /// <param name="dataType">数据种类</param>
        /// <param name="dataStr">数据内容，是一个 JSON 字符串。</param>
        public static void submitExtendData(string dataType, string dataStr)
        {
            callSdkApi("submitExtendData", dataType, dataStr);
        }

        /// <summary>
        /// 当前登录用户是否UC会员，结果从回调中获取。
        /// </summary>
        public static void isUCVip()
        {
            callSdkApi("isUCVip");
        }

        /// <summary>
        /// 获取当前登录用户的UC会员信息，包括：状态、有效期、特权等，结果从回调中获取。
        /// </summary>
        public static void getUCVipInfo()
        {
            callSdkApi("getUCVipInfo");
        }

        /// <summary>
        /// 退出SDK，游戏退出前必须调用此方法，以清理SDK占用的系统资源。如果游戏退出时不调用该方法，可能会引起程序错误。
        /// </summary>
        public static void exitSDK()
        {
            callSdkApi("exitSDK");
        }
		//统计热云数据
		public static void setEvent(string eventName){
			callSdkApi ("setEvent", eventName);
		}
		public static string getDeviceID(){
		return callSdkApi<string> ("getDeviceID");
		}
		public static string getDeviceIDFV(){	
			return null;
		}

        private static void callSdkApi(string apiName, params object[] args)
        {
            log("Unity3D " + apiName + " calling...");
            #if UNITY_EDITOR
        #elif UNITY_ANDROID
            using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_CLASS))
            {
                cls.CallStatic(apiName, args);
            }
        #elif UNITY_IPHONE
        #endif
        }

        private static T callSdkApi<T>(string apiName, params object[] args)
        {
        #if UNITY_EDITOR
        #elif UNITY_ANDROID
            using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_CLASS))
            {
                return cls.CallStatic<T>(apiName,args);
            }
        #elif UNITY_IPHONE
        #endif
            return default(T);
        }

        private static void log(string msg)
        {
            Debug.Log(msg);
            //print(msg);
        }

        #endregion
   
#endif

}


