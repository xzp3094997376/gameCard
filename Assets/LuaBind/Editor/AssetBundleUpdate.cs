using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using LitJson;
using ICSharpCode.SharpZipLib.Zip;
using LuaBind;

public class AssetBundleUpdate : EditorWindow
{
    public const string rootPath = "Assets/UI";
    private string mInput;
    private string mOutput;
    private string mVersion;

    enum AssetType
    {
        Prefab,
        Texture,
        Shader,
        Material,
        Font,
        Scene,
        AudioClip,
        AnimationClip,
        AudioMixer,
        Asset
    }

    class AssetBuildMrg
    {
        public List<AssetItem> list = new List<AssetItem>();
        public string output = "AssetBundle";
        public string oldOutput = "OldAssetBundle";
    }

    class AssetItem
    {
        public string path;
        public AssetType type = AssetType.Prefab;
        public string root;
    }

    private static GUIContent
        insertContent = new GUIContent("+", "添加变量"),
        browse = new GUIContent("浏览", "浏览文件夹"),
        deleteContent = new GUIContent("-", "删除变量");
    private static GUILayoutOption buttonWidth = GUILayout.MaxWidth(20f);
    private AssetBuildMrg mrg = new AssetBuildMrg();
    private List<AssetItem> mBundleList = new List<AssetItem>();
    private AssetItem temp = new AssetItem();
    private string bundleListPath
    {
        get
        {
            return "editor_config/bundle_list.json";
        }
    }
    [MenuItem("AssetBundle/2、Open")]
    public static void Open()
    {
        GetWindow<AssetBundleBuilder>();
    }

    public void UpdatePackage() 
    {
        string oldOut = Path.Combine(mrg.oldOutput, FileUtils.getInstance().getRuntimePlatform());
        Debug.LogError("老的输出目录: " + oldOut);
        if (!Directory.Exists(oldOut))
            Directory.CreateDirectory(oldOut);

        string path = oldOut + "/" + FileUtils.getInstance().getRuntimePlatform();
        //if (string.IsNullOrEmpty(path)) return null;
        byte[] bytes = FileUtils.getInstance().getBytes(path);
        AssetBundle ab = null;
        if (bytes != null && bytes.Length > 0)
        {
            ab = AssetBundle.LoadFromMemory(bytes);
        }
        if (ab != null) {
            AssetBundleManifest old = ab.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
            ab.Unload(false);

            string[] olds = old.GetAllAssetBundles();
            foreach (string o in olds)
            {
                Debug.Log("old name = " + o);
                //Debug.Log("hash = " + old.);
            }
        }
    }

    //清除已经打包的资源 AssetBundleNames
    private static void ClearAssetBundlesName()
    {
        int length = AssetDatabase.GetAllAssetBundleNames().Length;
        Debug.Log(length);
        string[] oldAssetBundleNames = new string[length];
        for (int i = 0; i < length; i++)
        {
            oldAssetBundleNames[i] = AssetDatabase.GetAllAssetBundleNames()[i];
        }

        for (int j = 0; j < oldAssetBundleNames.Length; j++)
        {
            AssetDatabase.RemoveAssetBundleName(oldAssetBundleNames[j], true);
        }
    }

    public void RebuildAll()
    {
        FileUtil.DeleteFileOrDirectory(mrg.output);
        BuildAll();
    }

    private bool isBuildAsset() 
    {
        bool isbuild = false;
        FileUtils utils = FileUtils.getInstance();
        utils.ForEachDirectory(mInput, "*.prefab", (path) =>
        {
            isbuild = true;
        });
        utils.ForEachDirectory(mInput, "*.png", (path) =>
        {
            isbuild = true;
        });
        utils.ForEachDirectory(mInput, "*.jpg", (path) =>
        {
            isbuild = true;
        });
        return isbuild;
    }
    public void BuildAll()
    {
        if (isBuildAsset() == false) return;

        ClearAssetBundlesName();
        for (int i = 0; i < mBundleList.Count; i++)
        {
            var item = mBundleList[i];
            if (item != null && !string.IsNullOrEmpty(item.path))
            {
                SetAssetBundleName(item.path, "t:" + item.type.ToString(), item.root, false);
            }
        }


        // Choose the output path according to the build target.
        string outputPath = Path.Combine(mrg.output, FileUtils.getInstance().getRuntimePlatform());
        if (!Directory.Exists(outputPath))
            Directory.CreateDirectory(outputPath);
         BuildPipeline.BuildAssetBundles(outputPath, BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);
        //string[] all = am.GetAllAssetBundles();
        //foreach (string name in all)
        //{
        //    Debug.Log("name = " + name);
        //}
    }
    /*
    [MenuItem("AssetBundle/清除目录AssetBundle打包标记")]
    public static void ClearAssetBundleName()
    {
        if (Selection.assetGUIDs.Length == 0)
        {
            EditorUtility.DisplayDialog("tips","请选择一个或多个目录","OK");
            return;
        }
        for(int i = 0; i < Selection.assetGUIDs.Length; i++)
        {
            var guid = Selection.assetGUIDs[i];
            string path = AssetDatabase.GUIDToAssetPath(guid);
            FileUtils.getInstance().ForEachDirectory(path, (p) =>
            {
                p = p.Substring(p.IndexOf("/Assets/") + 1);
                AssetImporter im = AssetImporter.GetAtPath(p);
                if(im)
                    im.assetBundleName = "";
            });
        }
        
    }*/

    public static void SetAssetBundleName(string path, string type, string root, bool isClear)
    {
        string[] paths = AssetDatabase.FindAssets(type, new string[] { path });
        var len = paths.Length;
        for (int i = 0; i < len; i++)
        {
            var guid = paths[i];
            string p = AssetDatabase.GUIDToAssetPath(guid);
            AssetImporter im = AssetImporter.GetAtPath(p);
            if (isClear)
            {
                p = "";
            }
            else
            {
                if (string.IsNullOrEmpty(root)) path = "Assets";
                else path = root;
                p = p.Replace(path + "/", "");
                p = Path.GetDirectoryName(p) + "/" + Path.GetFileNameWithoutExtension(p);
            }
            im.assetBundleName = p;
            EditorUtility.DisplayProgressBar(type, path, (float)i / len);
        }
        if (len == 0)
        {
            string[] _paths = Directory.GetFiles(path, type.Replace("t:", "*."), SearchOption.AllDirectories);
            len = _paths.Length;
            for (int i = 0; i < len; i++)
            {
                string p = FileUtils.getLinuxPath(_paths[i]);
                p = p.Replace(Application.dataPath + "/", "Assets");
                AssetImporter im = AssetImporter.GetAtPath(p);
                if (isClear)
                {
                    p = "";
                }
                else
                {
                    if (string.IsNullOrEmpty(root)) path = "Assets";
                    else path = root;
                    p = p.Replace(path + "/", "");
                    p = Path.GetDirectoryName(p) + "/" + Path.GetFileNameWithoutExtension(p);
                }
                im.assetBundleName = p;
                EditorUtility.DisplayProgressBar(type, path, (float)i / len);
            }
        }
        EditorUtility.ClearProgressBar();
    }
    string openFolder()
    {
        var path = EditorUtility.OpenFolderPanel("选择目录", Application.dataPath, "");
        if (!string.IsNullOrEmpty(path))
        {
            path = FileUtils.getLinuxPath(path);
            if (path.IndexOf(Application.dataPath + "/") == -1)
            {
                EditorUtility.DisplayDialog("tips", "请选择Assets下的目录", "OK");
                return "";
            }
            path = path.Replace(Application.dataPath + "/", "Assets/");
        }
        return path;
    }

    void OnGUI()
    {
        //ayout.Space(5);
        //orTools.DrawSeparator();
        //EditorTools.DrawHeader("需要打包的文件"))
        //
        //
        //EditorTools.BeginContents();
        //GUILayout.Space(5);
        //for (int i = 0; i < mBundleList.Count; i++)
        //{
        //    if (i % 2 == 0) GUI.backgroundColor = Color.cyan;
        //    else GUI.backgroundColor = Color.magenta;
        //    drawLine(mBundleList[i]);
        //}
        //EditorTools.EndContents();
        //GUILayout.Space(5);
        //GUI.backgroundColor = Color.yellow;
        //EditorTools.BeginContents();
        //GUI.backgroundColor = Color.white;
        //GUILayout.Space(5);
        //EditorGUILayout.BeginHorizontal();
        //temp.type = (AssetType)EditorGUILayout.EnumPopup(temp.type);
        //GUILayout.Label(temp.path, "HelpBox", GUILayout.Height(16f), GUILayout.Width(250));
        //if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
        //{
        //    var path = openFolder();
        //    temp.path = path;
        //}
        //GUILayout.Label(temp.root, "HelpBox", GUILayout.Height(16f), GUILayout.Width(250));
        //if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
        //{
        //    var path = openFolder();
        //    if (!string.IsNullOrEmpty(path))
        //    {
        //        temp.root = path;
        //        saveSetting();
        //    }
        //}
        //if (GUILayout.Button(insertContent, EditorStyles.miniButtonLeft, buttonWidth))
        //{
        //    if (!string.IsNullOrEmpty(temp.path))
        //    {
        //        mBundleList.Add(temp);
        //        saveSetting();
        //    }
        //}
        //EditorGUILayout.EndHorizontal();
        //GUILayout.Space(5);
        //EditorTools.EndContents();
        //GUI.backgroundColor = Color.white;
        //
        //EditorTools.DrawSeparator();
        //EditorTools.BeginContents();
        //GUILayout.Space(5);
        //mrg.output = EditorGUILayout.TextField(new GUIContent("输出"), mrg.output);
        //GUILayout.Space(5);
        //var buildAll = new GUIContent("打包", "打包资源");
        //
        //
        //if (GUILayout.Button(buildAll, EditorStyles.miniButtonLeft, GUILayout.MinWidth(180f)))
        //{
        //    BuildAll();
        //}
        //GUILayout.Space(5);

            //var rebuildAll = new GUIContent("重新打包", "打包资源");
            //
            //if (GUILayout.Button(rebuildAll, EditorStyles.miniButtonLeft, GUILayout.MinWidth(180f)))
            //{
            //    RebuildAll();
            //}
            //GUILayout.Space(5);
            //
            //var update = new GUIContent("更新", "更新资源");
            //
            //if (GUILayout.Button(update, EditorStyles.miniButtonLeft, GUILayout.MinWidth(180f)))
            //{
            //    UpdatePackage();
            //}
            //GUILayout.Space(5);

            //EditorTools.EndContents();
        //}

          GUILayout.BeginHorizontal();
          GUILayout.Label("更新资源目录", GUILayout.Width(146), GUILayout.Height(18f));
          GUILayout.Label(mInput, "HelpBox", GUILayout.Height(18f));
          if (GUILayout.Button("浏览"))
          {
              string path = EditorUtility.OpenFolderPanel("更新文件目录", mInput, "Assets");
              if (!string.IsNullOrEmpty(path))
              {
                  mInput = path;
              }

          }
          GUILayout.EndHorizontal();

          GUILayout.BeginHorizontal();
          GUILayout.Label("Output", GUILayout.Width(146), GUILayout.Height(18f));
          GUILayout.Label(mOutput, "HelpBox", GUILayout.Height(18f));
          if (GUILayout.Button("浏览"))
          {
              string path = EditorUtility.OpenFolderPanel("Output", mOutput, "Assets");
              if (!string.IsNullOrEmpty(path))
              {
                  mOutput = path;
              }

          }
          GUILayout.EndHorizontal();

          GUILayout.BeginHorizontal();
          GUILayout.Label("版本号", GUILayout.Width(146), GUILayout.Height(18f));
          mVersion = EditorGUILayout.TextField(mVersion, GUILayout.Height(18f));
          GUILayout.EndHorizontal();

          if (GUILayout.Button("打包"))
          {
              BuildAll();
              BuildPrefab();
              BuildLua();
              Copy();
              Zip();
          }

          //if (GUILayout.Button("打包lua"))
          //{
          //    BuildLua();
          //}

    }

    private void BuildPrefab()
    {
        FileUtils utils = FileUtils.getInstance();
        List<string> bundleFull = new List<string>();
        List<string> moveList = new List<string>();
        //utils.ForEachDirectory(mInput, "*.prefab", (path) =>
        //{
        //    path = FileUtils.getLinuxPath(path);
        //    if (path.IndexOf("/Assets/UI/") > -1)
        //    {
        //        var url = path.Substring(path.IndexOf("/Assets/UI/") + 11);
        //        url = Path.GetDirectoryName(url) + "/" + Path.GetFileNameWithoutExtension(url);
        //        moveList.Add(url);
        //        bundleFull.Add(url);
        //    }
        //});
        //utils.ForEachDirectory(mInput + "/Assets/images/", "*.*", (path) =>
        //{
        //    if (!path.EndsWith(".meta"))
        //    {
        //        path = FileUtils.getLinuxPath(path);
        //        if (path.IndexOf("/Assets/images/") > -1)
        //        {
        //            var url = path.Substring(path.IndexOf("/Assets/") + 8);
        //            url = Path.GetDirectoryName(url) + "/" + Path.GetFileNameWithoutExtension(url);
        //            moveList.Add(url);
        //            bundleFull.Add(url);
        //        }
        //    }
        //});
        bool copySys = false;
        for (int i = 0; i < mBundleList.Count; i++)
        {
            var item = mBundleList[i];
            if (item != null && !string.IsNullOrEmpty(item.path))
            {
                item.path = "/trunk/" + item.path;
                if (item.root == null || item.root.Equals("")) item.root = "Assets";
                if (item.type != AssetType.Texture)
                {
                    utils.ForEachDirectory(mInput + item.path, "*.*", (path) =>
                    {
                        if (!path.EndsWith(".meta"))
                        {
                            path = FileUtils.getLinuxPath(path);
                            if (path.IndexOf(item.root) > -1)
                            {
                                var url = path.Substring(path.IndexOf(item.root) + item.root.Length + 1);
                                url = Path.GetDirectoryName(url) + "/" + Path.GetFileNameWithoutExtension(url);
                                moveList.Add(url);
                                bundleFull.Add(url);
                                copySys = true;
                            }
                        }
                    });
                }
                else 
                {
                    utils.ForEachDirectory(mInput + item.path, "*.*", (path) =>
                    {
                        if (!path.EndsWith(".meta"))
                        {
                            path = FileUtils.getLinuxPath(path);
                            if (path.IndexOf(item.root) > -1)
                            {
                                var url = path.Substring(path.IndexOf("/Assets/") + 8);
                                url = Path.GetDirectoryName(url) + "/" + Path.GetFileNameWithoutExtension(url);
                                moveList.Add(url);
                                bundleFull.Add(url);
                            }
                        }
                    });
                }
                //SetAssetBundleName(item.path, "t:" + item.type.ToString(), item.root, false);
            }
        }

        var pf = FileUtils.getInstance().getRuntimePlatform();
        var outPut = mOutput + "/" + pf + "/" + mVersion;

        for (int i = 0; i < moveList.Count; i++)
        {
            var path = Application.dataPath + "/../AssetBundle/" + utils.getRuntimePlatform() + "/" + moveList[i];
            if (utils.isFileExist(path))
            {
                var p = outPut + "/AssetBundle/" + utils.getRuntimePlatform() + "/" + moveList[i].ToLower();
                if (!Directory.Exists(Path.GetDirectoryName(p)))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(p));
                }
                File.Copy(path, p, true);
            }
        }
        //if (copySys)
        //{
            var sysPath = Application.dataPath + "/../AssetBundle/" + utils.getRuntimePlatform() + "/" + utils.getRuntimePlatform();
            var mPath = Application.dataPath + "/../AssetBundle/" + utils.getRuntimePlatform() + "/" + utils.getRuntimePlatform() + ".manifest";
            
            if (utils.isFileExist(sysPath))
            {
                var p = outPut + "/AssetBundle/" + utils.getRuntimePlatform() + "/" + utils.getRuntimePlatform();
                if (!Directory.Exists(Path.GetDirectoryName(p)))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(p));
                }
                File.Copy(sysPath, p, true);
                var m = mInput  + "/" + utils.getRuntimePlatform() + ".manifest";
                File.Copy(mPath, m, true);
                var sb = mInput + "/" + utils.getRuntimePlatform();
                File.Copy(sysPath, sb, true);
            }
        //}
    }

    private void BuildLua()
    {
        FileUtils utils = FileUtils.getInstance();
        var pf = FileUtils.getInstance().getRuntimePlatform();
        var outPut = mOutput + "/" + pf + "/" + mVersion;
        utils.ForEachDirectory(mInput, "*.lua", (path) =>
        {
            path = FileUtils.getLinuxPath(path);
            if (path.IndexOf("/Assets/StreamingAssets/uLuaModule/") > -1)
            {
                var p = outPut + "/" + path.Substring(path.IndexOf("/StreamingAssets/") + 17);
                if (!Directory.Exists(Path.GetDirectoryName(p)))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(p));
                }
                File.Copy(path, p, true);
            }

        });
        BuildWindow.zipLua(outPut + "/uLuaModule");
        EditorUtility.ClearProgressBar();
    }

    private void Copy()
    {
        var pf = FileUtils.getInstance().getRuntimePlatform();
        var outPut = mOutput + "/" + pf + "/" + mVersion;
        CopyDirectory(mInput + "/trunk/ArtResources/" + pf, outPut + "/ArtResources/" + pf);

        CopyDirectory(mInput + "/client_table", outPut + "/configs");
        //CopyDirectory(mInput + "/Assets/images", outPut + "/images");
        var f = mInput + "Assets/StreamingAssets/shareSDKConfig.json";
        outPut = mOutput + "/" + pf;
        if (File.Exists(f))
            File.Copy(f, outPut + "/shareSDKConfig.json", true);
        f = mInput + "Assets/StreamingAssets/BindUnityList.txt";
        if (File.Exists(f))
            File.Copy(f, outPut + "/BindUnityList.txt", true);
        f = mInput + "/trunk/Assets/StreamingAssets/Localization.csv";
        if (File.Exists(f))
        {
            string path = mOutput + "/" + pf + "/" + mVersion + "/lan/";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            File.Copy(f, path + "Localization.csv", true);
        }
    }

    void Zip()
    {
        FastZip fast = new FastZip();
        var pf = FileUtils.getInstance().getRuntimePlatform();
        var zipPath = mOutput + "/" + mVersion + ".zip";
        fast.CreateZip(zipPath, mOutput + "/" + pf, true, "");

        FileUtils.getInstance().removeDirectory(mOutput + "/" + pf + "/" + mVersion);
        File.Move(zipPath, mOutput + "/" + pf + "/" + Path.GetFileName(zipPath));
    }

    public static void CopyDirectory(string sourcePath, string destinationPath)
    {
        if (!Directory.Exists(sourcePath)) return;
        DirectoryInfo info = new DirectoryInfo(sourcePath);
        FileUtils.getInstance().createDirectory(destinationPath);
        foreach (FileSystemInfo fsi in info.GetFileSystemInfos())
        {
            string destName = Path.Combine(destinationPath, fsi.Name);
            if (fsi is System.IO.FileInfo)
            {
                if (fsi.FullName.IndexOf(".meta") > -1) continue;
                File.Copy(fsi.FullName, destName, true);
            }
            else
            {
                FileUtils.getInstance().createDirectory(destName);
                CopyDirectory(fsi.FullName, destName);
            }
        }
    }
    private void drawLine(AssetItem dictionary)
    {

        EditorGUILayout.BeginHorizontal();
        var tp = dictionary.type;
        dictionary.type = (AssetType)EditorGUILayout.EnumPopup(dictionary.type);
        if (tp != dictionary.type)
        {
            saveSetting();
        }
        GUILayout.Label(dictionary.path, "HelpBox", GUILayout.Height(16f), GUILayout.Width(250));
        if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
        {
            var path = openFolder();
            if (!string.IsNullOrEmpty(temp.path))
            {
                dictionary.path = path;
                saveSetting();
            }
        }

        GUILayout.Label(dictionary.root, "HelpBox", GUILayout.Height(16f), GUILayout.Width(250));
        if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
        {
            var path = openFolder();
            if (!string.IsNullOrEmpty(path))
            {
                dictionary.root = path;
                saveSetting();
            }
        }

        if (GUILayout.Button(deleteContent, EditorStyles.miniButtonLeft, buttonWidth))
        {
            mBundleList.Remove(dictionary);
            if (!string.IsNullOrEmpty(dictionary.path))
                SetAssetBundleName(dictionary.path, "t:" + dictionary.type.ToString(), dictionary.root, true);
            saveSetting();
        }
        EditorGUILayout.EndHorizontal();
        GUILayout.Space(5);
    }

    void OnFocus()
    {
        readSetting();
    }
    static public T loadObjectFromJsonFile<T>(string path)
    {
        string str = FileUtils.getInstance().getString(path);
        if (string.IsNullOrEmpty(str))
        {
            return default(T);
        }

        T data = JsonMapper.ToObject<T>(str);
        if (data == null)
        {
            Debug.LogError("Cannot read data from " + path);
        }

        return data;
    }
    private void readSetting()
    {
        var json = loadObjectFromJsonFile<AssetBuildMrg>(bundleListPath);
        if (json != null)
        {
            mrg = json;
            mBundleList = json.list;
        }
    }

    void OnLostFocus()
    {
        //saveSetting();
    }
    static public void saveObjectToJsonFile<T>(T data, string path)
    {
        string jsonStr = JsonFormatter.PrettyPrint(JsonMapper.ToJson(data));

        FileUtils.getInstance().writeFileWithCode(path, jsonStr, null);
    }
    private void saveSetting()
    {
        mrg.list = mBundleList;
        saveObjectToJsonFile(mrg, bundleListPath);
    }

    void OnHierarchyChange()
    {
    }

    void OnProjectChange()
    {
    }

    void OnInspectorUpdate()
    {
        this.Repaint();
    }

    void OnSelectionChange()
    {

    }

    void OnDestroy()
    {
    }
}
