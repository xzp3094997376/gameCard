/*********************************************************************
* 类 名 称：       DownModuleAsset
* 命名空间：       
* 创建时间：       2014/7/24 9:40:21
* 作    者：       张晶晶
* 说    明：       下载模块预设，作为测试
* 最后修改时间：   2014/7/26 
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/

using UnityEngine;
using System.Collections;




public class DownModuleAsset : MonoBehaviour {


    public static AssetBundle bundle = null;

    public static bool isDownModule1 = false;

	bool isStart = false;

    void Update()
    {
        //当主预设需要的图集加载完毕执行主预设的加载
		if (DownPublicAsset.isDownFinish && !isStart) {
			StartCoroutine (Down ());
			isStart = true;
		}
        //FrameTimerManager.frameHandle(); //启动定时器     
    }


    /// <summary>
    /// 采用协同下载资源包并实例化
    /// </summary>
    /// <returns></returns>
	IEnumerator Down()
	{
        MyDebug.Log("applicate data" + Application.dataPath);
       // string selfPath = "file:///" + Application.dataPath + "/BundleAsset/sea.web";  
            //从服务器端下载
            string mainPath = "file:///" + Application.dataPath + "/BundleAsset/m1.web";
            WWW asset = new WWW(mainPath);
            yield return asset;
            MyDebug.Log("mainPath " + mainPath);
            bundle = asset.assetBundle;
            Instantiate(bundle.LoadAsset("m1_ng"));
            isDownModule1 = true;   //设定主预设下载完毕
            yield return new WaitForSeconds(1);
	}

}
