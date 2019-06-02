/*********************************************************************
* 类 名 称：       GetGameObject
* 命名空间：       
* 创建时间：       2014/7/23 9:40:21
* 作    者：       张晶晶
* 说    明：       实例化模块预设中的一个物体
* 最后修改时间：   2014/7/26 
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/
using UnityEngine;
using System.Collections;




public class GetGameObject : MonoBehaviour
{
    bool isInstantiate = false;  //约束只是先一次实例化

    void Start()
    {
        StartCoroutine(show());
    }
    ////下载并实例化一个模块中的一个预设
    //// Update is called once per frame
    //void Update()
    //{
    //    //当该模块下载完毕执行一次实例化
    //    if (DownModuleAsset.isDownModule1 && DownModuleAsset.bundle != null && !isInstantiate)
    //    {
    //        Instantiate(DownModuleAsset.bundle.Load("m2_ng"));
    //        isInstantiate = true;
    //    }
    //}

    public IEnumerator show()
    {
        string mainPath = "file:///" + Application.dataPath + "/ExportModule";
        WWW asset = new WWW(mainPath+"/public.ab");
        yield return asset;
   
        AssetBundle public_bundle = asset.assetBundle;
        public_bundle.LoadAllAssets();
 //       public_bundle = asset.assetBundle;
        yield return new WaitForSeconds(1);

        string fontPath = "file:///" + Application.dataPath + "/ExportModule";
        WWW asset_font = new WWW(fontPath + "/font.ab");
        yield return asset_font;
        AssetBundle font_bundle = asset_font.assetBundle;
        font_bundle.LoadAllAssets();
  //      public_bundle = asset_font.assetBundle;
        yield return new WaitForSeconds(1);

        WWW module_1 = new WWW(mainPath + "/Module_1.ab");
        yield return asset;
      
        AssetBundle module1_bundle = module_1.assetBundle;
    
        yield return new WaitForSeconds(1);
        Instantiate(module1_bundle.LoadAsset("m1"));
        Instantiate(module1_bundle.LoadAsset("m11"));
       // isDownModule1 = true;   //设定主预设下载完毕
        yield return new WaitForSeconds(1);

        WWW module_2 = new WWW(mainPath + "/Module_2.ab");
        yield return asset;
       
        AssetBundle module2_bundle = module_2.assetBundle;
      
        Instantiate(module2_bundle.LoadAsset("m2_ng"));
        yield return new WaitForSeconds(1);

        WWW module_3 = new WWW(mainPath + "/Module_3.ab");
        yield return asset;
        
        AssetBundle module3_bundle = module_3.assetBundle;
      
        Instantiate(module3_bundle.LoadAsset("m3_ng"));
        yield return new WaitForSeconds(1);

    }
}

