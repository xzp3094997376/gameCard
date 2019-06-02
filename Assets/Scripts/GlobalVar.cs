using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************


/// <summary>
///全局变量
/// </summary>
public class GlobalVar
{

    public static string currentScene = "";//当前玩家所处于的场景
    public static GameObject UI;//整个UI界面
    public static UIRoot Root;
    public static Camera camera;
    public static UIPanel RootPanel;
    public static ApiLoading loading;
    public static FightManager fightmgr;
    public static GameObject center;
    public static GameObject undestroy;
    public static GameObject notice;
    public static GameObject battle;
    public static SLua.LuaTable FightData; //进入战斗数据  表示是什么战斗，哪一关，哪一章等等
    public static GameObject MainUI;
    public static Dictionary<string, UIAtlas> altasDic = new Dictionary<string, UIAtlas>();

    //----------------------一些公共变量--------------------------
    public static string gameName = "";
    public static bool isLJSDK = true; //是否使用凌镜SDK
    public static string updateURL = ""; //游戏自动更新url
    public static string mainVersion = "0";//当前版本号
    public static string sdkPlatform;    //sdk平台
	public static string language;    //语言类型
    public static bool isPush = false;   //是否开启推送
	public static string iosLoginUrl=""; //苹果登录URL add by serali 2017-2-15
	public static bool isChgeAcc = false; //苹果是否开启切换账号功能

    public static bool isNeedUpdate = false;
    public static string dataEyeChannelID = "";
    public static string dataEyeAppID = "";
    public static string subChannelID = "";
	public static bool iosVerfy = false;//标识是否走我们自己的服务器验签
	public static bool isChannel = false;//是否选择渠道
	public static string  channelName ="";//渠道名
}
