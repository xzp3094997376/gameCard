/*********************************************************************
* 类 名 称：       DownPublicAsset
* 命名空间：       
* 创建时间：       2014/7/24 9:40:21
* 作    者：       张晶晶
* 说    明：       下载公共图集预设
* 最后修改时间：   2014/7/26 
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/


using UnityEngine;
using System.Collections;



public class DownPublicAsset : MonoBehaviour {
    
	// Use this for initialization
    public static bool isDownFinish = false;
    void Awake () {
	  StartCoroutine(DownAsset());
	}

    /// <summary>
    /// 下载公用图集预设并设置是否下载完毕
    /// </summary>
    /// <returns></returns>

    IEnumerator DownAsset(){
		string sharePath = "file:///" + Application.dataPath + "/BundleAsset/sea.web";
        WWW shareasset = new WWW(sharePath);
        yield return shareasset;
        AssetBundle sharebundle = shareasset.assetBundle;
        MyDebug.Log("sharePath " + sharePath);
        sharebundle.LoadAllAssets();
        isDownFinish = true;
        yield return new WaitForSeconds(1);
    }
   
}
