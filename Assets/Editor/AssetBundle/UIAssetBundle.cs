/*********************************************************************
* 类 名 称：       UIAssetBundle
* 命名空间：       
* 创建时间：       2014/8/6 11:07:10
* 作    者：       张晶晶
* 说    明：       将个模块的ui预设打包成android和ios平台
* 最后修改时间：   2014/10/25
* 最后修 改 人：   张晶晶
* 曾修改人：
**********************************************************************/

using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
using System.IO;

public class UIAssetBundle {

    static string filePath = "Assets/Resources/Prefabs/moduleFabs";
    public static Dictionary<string, GameObject> dic = new Dictionary<string, GameObject>();
    public static BuildAssetBundleOptions options =
            BuildAssetBundleOptions.CollectDependencies |
            BuildAssetBundleOptions.CompleteAssets | BuildAssetBundleOptions.DeterministicAssetBundle;
    static string outfile_Android = "/Users/build/www/Bleach_UI_AssetBundle_Android/";
	static string outfile_IOS = "/Users/build/www/Bleach_UI_AssetBundle_IOS/";
 
    /// <summary>
    /// 打包所有的ui
    /// </summary>
    //[MenuItem("Tools/UIBundle")]
    public static void bundleAllUI()
    {
        GetFile.getFilesByType(filePath, dic, ".prefab");
		bundleOneByPlatform("ab", outfile_Android);
        return;
		bundleOneByPlatform("os", outfile_IOS);
    }

  
    /// <summary>
    ///
    /// </summary>
    public static void bundleOneByPlatform(string type, string outfile)
    {   
        foreach (string p in dic.Keys) {
						string fileName = Path.GetFileName (p);
						fileName = fileName.Replace ("prefab", type);
						string[] dirs = p.Split ('/');
						string dir = dirs [dirs.Length - 2];
						string path = outfile + dir;
						if (!Directory.Exists (path)) {
								Directory.CreateDirectory (path);
						}
						Object obj = AssetDatabase.LoadMainAssetAtPath (p);
						if (type == "ab") {

								BuildPipeline.BuildAssetBundle (obj, null, path + "/" + fileName, options, BuildTarget.Android);
						} else if (type == "os")
								BuildPipeline.BuildAssetBundle (obj, null, path + "/" + fileName, options, BuildTarget.iOS);

				}
        }


}
