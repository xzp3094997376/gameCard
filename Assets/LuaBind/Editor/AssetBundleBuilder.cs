using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using LitJson;

public class AssetBundleBuilder : EditorWindow
{
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

    public void RebuildAll()
    {
        FileUtil.DeleteFileOrDirectory(mrg.output);
        BuildAll();
    }
    public void BuildAll()
    {

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
        GUILayout.Space(5);
        EditorTools.DrawSeparator();
        if (EditorTools.DrawHeader("需要打包的文件"))
        {

            EditorTools.BeginContents();
            GUILayout.Space(5);
            for (int i = 0; i < mBundleList.Count; i++)
            {
                if (i % 2 == 0) GUI.backgroundColor = Color.cyan;
                else GUI.backgroundColor = Color.magenta;
                drawLine(mBundleList[i]);
            }
            EditorTools.EndContents();
            GUILayout.Space(5);
            GUI.backgroundColor = Color.yellow;
            EditorTools.BeginContents();
            GUI.backgroundColor = Color.white;
            GUILayout.Space(5);
            EditorGUILayout.BeginHorizontal();
            temp.type = (AssetType)EditorGUILayout.EnumPopup(temp.type);
            GUILayout.Label(temp.path, "HelpBox", GUILayout.Height(16f), GUILayout.Width(250));
            if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
            {
                var path = openFolder();
                temp.path = path;
            }
            GUILayout.Label(temp.root, "HelpBox", GUILayout.Height(16f), GUILayout.Width(250));
            if (GUILayout.Button(browse, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(80f)))
            {
                var path = openFolder();
                if (!string.IsNullOrEmpty(path))
                {
                    temp.root = path;
                    saveSetting();
                }
            }
            if (GUILayout.Button(insertContent, EditorStyles.miniButtonLeft, buttonWidth))
            {
                if (!string.IsNullOrEmpty(temp.path))
                {
                    mBundleList.Add(temp);
                    saveSetting();
                }
            }
            EditorGUILayout.EndHorizontal();
            GUILayout.Space(5);
            EditorTools.EndContents();
            GUI.backgroundColor = Color.white;

            EditorTools.DrawSeparator();
            EditorTools.BeginContents();
            GUILayout.Space(5);
            mrg.output = EditorGUILayout.TextField(new GUIContent("输出"), mrg.output);
            GUILayout.Space(5);
            var buildAll = new GUIContent("打包", "打包资源");


            if (GUILayout.Button(buildAll, EditorStyles.miniButtonLeft, GUILayout.MinWidth(180f)))
            {
                ClearAssetBundlesName();
                BuildAll();
            }
            GUILayout.Space(5);

            var rebuildAll = new GUIContent("重新打包", "打包资源");

            if (GUILayout.Button(rebuildAll, EditorStyles.miniButtonLeft, GUILayout.MinWidth(180f)))
            {
                RebuildAll();
            }
            GUILayout.Space(5);

            EditorTools.EndContents();
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
