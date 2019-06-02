using UnityEngine;
using System.Collections;

#if IOS_GENUINE_SDk

public class ioslogin : MonoBehaviour {

	public Rect m_margin;
	public string m_URL = "https://120.92.132.88:8443/admin/platform/goLogin.do?deviceId=deviceId000";
	public UniWebView _webView;

	#region
	//login info

	public static string m_token = "";
	public static string m_uid = "";
	public static string m_JSNeedLoadBefore = "";
	private static bool isLogin = true;

	//show the login window 
	public static void ShowLogin(){
		Debug.Log ("show ShowLogin head");
		string weuid = PlayerPrefs.GetString("weuid");
		string wetoken = PlayerPrefs.GetString("wetoken");
		Debug.Log(weuid);
		Debug.Log(wetoken);
		//string weuid = "111111";
		//string wetoken = "111111";
		if (string.IsNullOrEmpty (weuid)) {
			var webview = new GameObject ();
			webview.AddComponent<ioslogin> ();
			Debug.Log ("show login");
		} else 
		{
			Debug.Log ("show login else");
			MySdk.Instance.onInitFinished();
			MySdk.Instance.onLoginSuccess(weuid, "",wetoken, "","","","","");
		}

	}
	/// <summary>
	/// check is login
	/// </summary>
	/// <value><c>true</c> if is login; otherwise, <c>false</c>.</value>
	public static bool IsLogin{
		get{
			return isLogin;
		}
	}
	/// <summary>
	/// Logout this instance.
	/// </summary>
	public static void Logout(){
		PlayerPrefs.SetString("weuid", "");
		PlayerPrefs.SetString("wetoken", "");
		MySdk.Instance.onLogout (" ios sdk");
		isLogin = false;
	}

	#endregion
	// Use this for initialization
	void Start () {
		_webView = gameObject.AddComponent<UniWebView>();
		_webView.OnReceivedMessage += OnReceivedMessage;
		_webView.OnLoadComplete += OnLoadComplete;
		_webView.OnWebViewShouldClose += OnWebViewShouldClose;
		_webView.OnEvalJavaScriptFinished += OnEvalJavaScriptFinished;
		
		_webView.InsetsForScreenOreitation += InsetsForScreenOreitation;
		MyDebug.Log ("ios loginurl=" + GlobalVar.iosLoginUrl);
		m_URL = GlobalVar.iosLoginUrl;
		_webView.url = m_URL;
		
		//You can read a local html file, by putting the file into /Assets/StreamingAssets folder
		//And use the url like these
		//If you are using "Split Application Binary" for Android, see the FAQ section of manual for more.
		/*
			#if UNITY_EDITOR
			_webView.url = Application.streamingAssetsPath + "/index.html";
			#elif UNITY_IOS
			_webView.url = Application.streamingAssetsPath + "/index.html";
			#elif UNITY_ANDROID
			_webView.url = "file:///android_asset/index.html";
			#endif
			*/
		
		// You can set the spinner visibility and text of the webview.
		// This line can change the text of spinner to "Wait..." (default is  "Loading...")
		//_webView.SetSpinnerLabelText("Wait...");
		// This line will tell UniWebView to not show the spinner as well as the text when loading.
		//_webView.SetShowSpinnerWhenLoading(false);
		
		//4.Now, you can load the webview and waiting for OnLoadComplete event now.
		_webView.SetTransparentBackground(true);
		_webView.Load();
	}

	//5. When the webView complete loading the url sucessfully, you can show it.
	//   You can also set the autoShowWhenLoadComplete of UniWebView to show it automatically when it loads finished.
	void OnLoadComplete(UniWebView webView, bool success, string errorMessage) {

		Debug.Log ("Load result:" + success);
		if (success) {
			webView.Show();		
			MyDebug.Log("init sdk complete....");
			MySdk.Instance.onInitFinished();
			string strDeviceID = MyGameSdk.getDeviceID();
			webView.EvaluatingJavaScript("var deviceid =" + strDeviceID+";");
		} else {
			MyDebug.Log("Something wrong in webview loading: " + errorMessage);
			//
			_webView.url = m_URL;
			_webView.Load();
		}
	}
	
	//6. The webview can talk to Unity by a url with scheme of "uniwebview". See the webpage for more
	//   Every time a url with this scheme clicked, OnReceivedMessage of webview event get raised.
	void OnReceivedMessage(UniWebView webView, UniWebViewMessage message) {
		Debug.Log(message.rawMessage);
		//7. You can get the information out from the url path and query in the UniWebViewMessage
		//For example, a url of "uniwebview://move?direction=up&distance=1" in the web page will 
		//be parsed to a UniWebViewMessage object with:
		//				message.scheme => "uniwebview"
		//              message.path => "move"
		//              message.args["direction"] => "up"
		//              message.args["distance"] => "1"
		// "uniwebview" scheme is sending message to Unity by default.
		// If you want to use your customized url schemes and make them sending message to UniWebView,
		// use webView.AddUrlScheme("your_scheme") and webView.RemoveUrlScheme("your_scheme")
		Debug.Log (message.path);
		if (string.Equals(message.path,"complete")) {
			PlayerPrefs.SetString("weuid", message.args["uid"]);
			PlayerPrefs.SetString("wetoken", message.args["token"]);
			if (GlobalVar.isChgeAcc) 
			{
			PlayerPrefs.SetString("uid", message.args["name"]);
			}
			Destroy(_webView);
			MySdk.Instance.onLoginSuccess(message.args["uid"], "",message.args["token"], "","","","","");
//			GameObject nobj = new GameObject();
//			MyGameSdk gamesdk = nobj.AddComponent<MyGameSdk>();
//			gamesdk.
			//MyGameSdk.login(true, "lala");

		} 
	}

	//9. By using EvaluatingJavaScript method, you can talk to webview from Unity.
	//It can evel a javascript or run a js method in the web page.
	//(In the demo, it will be called when the cube hits the sphere)
	public void ShowAlertInWebview(float time, bool first) {

		if (first) {
			//Eval the js and wait for the OnEvalJavaScriptFinished event to be raised.
			//The sample(float time) is written in the js in webpage, in which we pop 
			//up an alert and return a demo string.
			//When the js excute finished, OnEvalJavaScriptFinished will be raised.
			_webView.EvaluatingJavaScript("sample(" + time +")");
		}
	}
	
	//In this demo, we set the text to the return value from js.
	void OnEvalJavaScriptFinished(UniWebView webView, string result) {
		Debug.Log("js result: " + result);
		//tipTextMesh.text = "<color=#000000>" + result + "</color>";
	}
	
	//10. If the user close the webview by tap back button (Android) or toolbar Done button (iOS), 
	//    we should set your reference to null to release it. 
	//    Then we can return true here to tell the webview to dismiss.
	bool OnWebViewShouldClose(UniWebView webView) {
		if (webView == _webView) {
			_webView = null;
			return true;
		}
		return false;
	}
	
	// This method will be called when the screen orientation changed. Here we returned UniWebViewEdgeInsets(5,5,bottomInset,5)
	// for both situation. Although they seem to be the same, screenHeight was changed, leading a difference between the result.
	// eg. on iPhone 5, bottomInset is 284 (568 * 0.5) in portrait mode while it is 160 (320 * 0.5) in landscape.
	UniWebViewEdgeInsets InsetsForScreenOreitation(UniWebView webView, UniWebViewOrientation orientation) {
		//int bottomInset = (int)(UniWebViewHelper.screenHeight * 0.5f);
		
		if (orientation == UniWebViewOrientation.Portrait) {
			return new UniWebViewEdgeInsets(0,0,0,0);
		} else {
			return new UniWebViewEdgeInsets(0,0,0,0);
		}
	}
	// Update is called once per frame
	void Update () {
	
	}
}
#endif