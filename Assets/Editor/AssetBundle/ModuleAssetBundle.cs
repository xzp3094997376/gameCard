/*********************************************************************
* 类 名 称：       TestDependice 
* 命名空间：       
* 创建时间：       2014/8/6 11:07:10
* 作    者：       张晶晶
* 说    明：       将模块资源包打包并注入公共资源依赖
* 最后修改时间：   2014/8/7
* 最后修 改 人：   张晶晶
* 曾修改人：
**********************************************************************/


using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;
using SimpleJson;
using System.Collections.Generic;


public class ModuleAssetBundle : MonoBehaviour {

    static string publicPath = "Assets/Resources/AllAtlas/PublicAtlas";  //公共图集预设
    static string publicPfbPath = "Assets/Resources/Prefabs/publicPrefabs";  //公共预设
    static string fontPath = "Assets/Resources/font";
    static string outPath = "Assets/StreamingAssets/bleachModule/";
 
  
    static JsonObject modules;
	static Dictionary<string, List<Object>> dependModule = new Dictionary<string, List<Object>>();

    /// <summary>
    /// 将公共图集注入每个模块进行资源打包.ab
    /// </summary>

    [MenuItem("Tools/模块资源打包")]
    public static void createAssetBundle_Android()
    {
        dependModule.Clear();

        //构建资源包时选择资源包中文件的依赖 加入未压缩的assetbundle
        var options =
            BuildAssetBundleOptions.CollectDependencies |BuildAssetBundleOptions.UncompressedAssetBundle|
            BuildAssetBundleOptions.CompleteAssets | BuildAssetBundleOptions.DeterministicAssetBundle;

        //从配置文件中读取相关信息
        modules = ModuleXml.createConfigurationString();
        JsonArray moduleArray = modules["modules"] as JsonArray;
		int moduleNum = 0;
        foreach (JsonObject moduleWithNum in moduleArray)
        {
			JsonObject module = moduleWithNum["module"+moduleNum] as JsonObject;
			moduleNum ++;
            JsonArray prefabs = module["prefabs"] as JsonArray;
            List<Object> objs = new List<Object>();
            foreach (JsonObject prefab in prefabs)
            {
                string url = prefab["url"].ToString();
         //       MyDebug.Log("prefab: " + prefab + "  url: " + url);
                Object pObj = AssetDatabase.LoadMainAssetAtPath(url);
		//		MyDebug.Log("pObj" + pObj.name);
                objs.Add(pObj);
            }

            JsonArray atlas = module["atlas"] as JsonArray;

            string moduleName = module["name"].ToString();

       //     if (atlas.Contains("public"))
       //     {
				dependModule.Add(moduleName, objs);
               
       //     }
      //      else
      //      {
      //          buildObjectsDepend_Android(objs.ToArray(), outPath, moduleName, options);
                //buildObjectsDepend_IOS(objs.ToArray(), outPath, moduleName, options); 
    //        }
        }

        publicDependToAndroid(); 
       // publicDependToIOS();

    }

    /// <summary>
    /// 将公共图片和字体注入预设依赖,面向android平台
    /// </summary>
    public static void publicDependToAndroid()
    {
        var options =
            BuildAssetBundleOptions.CollectDependencies | BuildAssetBundleOptions.UncompressedAssetBundle |
            BuildAssetBundleOptions.CompleteAssets | BuildAssetBundleOptions.DeterministicAssetBundle;
        //注入公共资源
        BuildPipeline.PushAssetDependencies();

        List<Object> publicAtlas = GetAllPfb(publicPath);
        List<Object> fonts = GetAllPfb(fontPath);
        List<Object> publicPfb = GetAllPfb(publicPfbPath);
        BuildPipeline.BuildAssetBundle(null, publicAtlas.ToArray(), outPath + "PublicAtlas.ab", options, BuildTarget.Android);  //公共图集
        BuildPipeline.BuildAssetBundle(null, fonts.ToArray(), outPath + "font.ab", options, BuildTarget.Android);
        BuildPipeline.BuildAssetBundle(null, publicPfb.ToArray(), outPath + "publicPrefabs.ab", options, BuildTarget.Android);  //公共预设

        foreach (string moduleName in dependModule.Keys)
        {
            //将上述资源压入依赖到下面资源
            BuildPipeline.PushAssetDependencies();
            buildObjectsDepend_Android(dependModule[moduleName].ToArray(), outPath, moduleName, options);
            BuildPipeline.PopAssetDependencies();

        }
        BuildPipeline.PopAssetDependencies();
        AssetDatabase.Refresh();
    }


    public static List<Object> GetAllPublicPfb()
    {

        List<Object> objs = new List<Object>();
        //加入到公共预设图集
   //    Object publicObj =  AssetDatabase.LoadMainAssetAtPath(publicPath);
   //    objs.Add(publicObj);
        Dictionary<string, GameObject> publicPfbDic = new Dictionary<string,GameObject>();
        GetFile.getFilesByType(publicPath, publicPfbDic, "prefab"); 
        foreach (string p in publicPfbDic.Keys)
        {
       
            Object pObj = AssetDatabase.LoadMainAssetAtPath(p);
            objs.Add(pObj);
        }
        return objs;
    }

    public static List<Object> GetAllPfb(string path)
    {

        List<Object> objs = new List<Object>();   
        Dictionary<string, GameObject> publicPfbDic = new Dictionary<string, GameObject>();
        GetFile.getFilesByType(path, publicPfbDic, "prefab");
        foreach (string p in publicPfbDic.Keys)
        {
        
            Object pObj = AssetDatabase.LoadMainAssetAtPath(p);
            objs.Add(pObj);
        }
        return objs;
    }
    /// <summary>
    /// 将公共图片和字体注入预设依赖，面向ios平台
    /// </summary>
    public static void publicDependToIOS()
    {
        var options =
            BuildAssetBundleOptions.CollectDependencies | BuildAssetBundleOptions.UncompressedAssetBundle |
            BuildAssetBundleOptions.CompleteAssets | BuildAssetBundleOptions.DeterministicAssetBundle;
        //注入公共资源
        BuildPipeline.PushAssetDependencies();
        List<Object> publics = GetAllPublicPfb();
        BuildPipeline.BuildAssetBundle(null, publics.ToArray(),outPath + "public.os", options, BuildTarget.iOS);
        BuildPipeline.BuildAssetBundle(AssetDatabase.LoadMainAssetAtPath(fontPath), null, outPath + "font.os", options, BuildTarget.iOS);

        foreach (string moduleName in dependModule.Keys)
        {
            //将上述资源压入依赖到下面资源
            BuildPipeline.PushAssetDependencies();
            buildObjectsDepend_IOS(dependModule[moduleName].ToArray(), outPath, moduleName, options);
            BuildPipeline.PopAssetDependencies();
        }
        BuildPipeline.PopAssetDependencies();
        AssetDatabase.Refresh();
    }


    /// <summary>
    /// 将多个预设打包成面向Android平台的资源包
    /// </summary>
    public static void buildObjectsDepend_Android(Object[] SelectedAsset, string outfile, string name, BuildAssetBundleOptions options)
    {
        string targetAndroid;
        //确定打包后文件的名字
        if (name == null)
        {
            targetAndroid = outfile + "unknow.ab";
        }
        else
        {
            targetAndroid = outfile + name + ".ab";
        }

        BuildPipeline.BuildAssetBundle(null, SelectedAsset, targetAndroid, options, BuildTarget.Android);
    }


    /// <summary>
    /// 将多个预设打包成面向IOS平台的资源包
    /// </summary>
    public static void buildObjectsDepend_IOS(Object[] SelectedAsset, string outfile, string name, BuildAssetBundleOptions options)
    {
        string targetIOS;
        //确定打包后文件的名字
        if (name == null)
        {
            targetIOS = outfile + "unknow.os";
        }
        else
        {
            targetIOS = outfile + name + ".os";
        }

        BuildPipeline.BuildAssetBundle(null, SelectedAsset, targetIOS, options, BuildTarget.iOS);
    }
}
