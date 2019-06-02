using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.XCodeEditor;
using System.Xml;
#endif
using System.IO;

public static class XCodePostProcess
{
    #if UNITY_EDITOR
    [PostProcessBuild (100)]
    public static void OnPostProcessBuild (BuildTarget target, string pathToBuiltProject)
    {
		if (target != BuildTarget.iOS) {
            Debug.LogWarning ("Target is not iPhone. XCodePostProcess will not run");
            return;
        }


        // Create a new project object from build target
        XCProject project = new XCProject (pathToBuiltProject);

        // Find and run through all projmods files to patch the project.
        // Please pay attention that ALL projmods files in your project folder will be excuted!
        //在这里面把frameworks添加在你的xcode工程里面
        string[] files = Directory.GetFiles (Application.dataPath, "*.projmods", SearchOption.AllDirectories);
        foreach (string file in files) {
			if(isApplyMod(file)){
				project.ApplyMod( file );
			}	
        }


        //设置签名的证书， 第二个参数 你可以设置成你的证书
		project.overwriteBuildSetting ("CODE_SIGN_IDENTITY", "xxxxxx", "Release");
        project.overwriteBuildSetting ("CODE_SIGN_IDENTITY", "xxxxxx", "Debug");


     	//得到xcode工程的路径
        string path = Path.GetFullPath (pathToBuiltProject);
		// 编辑plist 文件
        EditorPlist(path);

        //编辑代码文件
        EditorCode(path);

        // Finally save the xcode project
        project.Save ();




    }

   private static void EditorPlist(string filePath)
    {
     
        ChangePlist list =new ChangePlist(filePath);
        string bundle = "com.yusong.momo";

        string shareSDKListInfo = @"
        <key>LSApplicationQueriesSchemes</key>
		<array>
			<string>instagram</string>
			<string>pinit</string>
			<string>pocket-oauth-v1</string>
			<string>fbauth2</string>
			<string>rm226427com.mob.demoShareSDK</string>
			<string>renren</string>
			<string>renreniphone</string>
			<string>renrenios</string>
			<string>renrenapi</string>
			<string>mqzone</string>
			<string>mqq</string>
			<string>mqqapi</string>
			<string>wtloginmqq2</string>
			<string>mqqopensdkapiV3</string>
			<string>mqqopensdkapiV2</string>
			<string>mqqOpensdkSSoLogin</string>
			<string>mqzoneopensdkapiV2</string>
			<string>mqzoneopensdkapi19</string>
			<string>mqzoneopensdkapi</string>
			<string>mqzoneopensdk</string>
			<string>alipayshare</string>
			<string>alipay</string>
			<string>yixinopenapi</string>
			<string>yixin</string>
			<string>wechat</string>
			<string>weixin</string>
			<string>tencentweiboSdkv2</string>
			<string>TencentWeibo</string>
			<string>weibosdk2.5</string>
			<string>weibosdk</string>
			<string>sinaweibohdsso</string>
			<string>sinaweibosso</string>
			<string>com.google.gppconsent.2.4.1</string>
			<string>com.google.gppconsent.2.4.0</string>
			<string>com.google.gppconsent.2.3.0</string>
			<string>com.google.gppconsent.2.2.0</string>
			<string>com.google.gppconsent</string>
			<string>hasgplus4</string>
			<string>googlechrome-x-callback</string>
			<string>googlechrome</string>
			<string>storylink</string>
			<string>alipayshare</string>
			<string>mqqwpa</string>
			<string>line</string>
			<string>whatsapp</string>
			<string>kakaolink</string>
		</array>

		";

		string netForIpote = @"
		<key>NSAppTransportSecurity</key>
		<dict>
			<key>NSAllowsArbitraryLoads</key>
			<true/>
		</dict>";

		string jpushPlistInfor = @"
		<key>UIBackgroundModes</key>
		<array>
			<string>remote-notification</string>
		</array>";

		string shareSDKNeedChanged = @"
		<key>CFBundleURLTypes</key>
		<array>
			<dict>
				<key>CFBundleTypeRole</key>
				<string>Editor</string>
				<key>CFBundleURLSchemes</key>
				<array>
					<string>wxb03a5770123ecc30</string>
				</array>
			</dict>
			<dict>
				<key>CFBundleTypeRole</key>
				<string>Editor</string>
				<key>CFBundleURLSchemes</key>
				<array>
					<string>wb63990981</string>
				</array>
			</dict>
			<dict>
				<key>CFBundleTypeRole</key>
				<string>Editor</string>
				<key>CFBundleURLSchemes</key>
				<array>
					<string>yx33398dbe98f246e19dcf4ff2bcd7f603</string>
				</array>
			</dict>
		</array>";
        
        //在plist里面增加一行
        list.AddKey(shareSDKListInfo);
        list.AddKey(netForIpote);
        list.AddKey(jpushPlistInfor);
        list.AddKey(shareSDKNeedChanged);
        //在plist里面替换一行
         //list.ReplaceKey("<string>com.yusong.${PRODUCT_NAME}</string>","<string>"+bundle+"</string>");
        //保存
        list.Save();

    }

    private static void EditorCode(string filePath)
    {
		//读取UnityAppController.mm文件
        XClass UnityAppController = new XClass(filePath + "/Classes/UnityAppController.mm");

        //在指定代码后面增加一行代码
        //UnityAppController.WriteBelow("#include \"PluginBase/AppDelegateListener.h\"","");

        //在指定代码中替换一行
       // UnityAppController.Replace("AppController_SendNotificationWithArg(kUnityOnOpenURL, notifData);\n	return YES;","AppController_SendNotificationWithArg(kUnityOnOpenURL, notifData);\n	return false;");

        //在指定代码后面增加一行
        //UnityAppController.WriteBelow("UnityCleanup();\n}","- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url\r{\r    return false;\r}");


    }

    #endif
	public static void Log(string message)
	{
		UnityEngine.Debug.Log("PostProcess: "+message);
	}
	private static bool isApplyMod(string file)
	{
		bool ret = true;
		string[] str = file.Split('/');
		Debug.Log(str);
		Debug.Log(str [str.Length - 1]);
		switch (str [str.Length - 1]) 
		{
			case "IosGenuineSdk.projmods":
				#if IOS_GENUINE_SDk
				return true;
				#endif
				return false;
			break;
		}
		return ret;
	}
}
