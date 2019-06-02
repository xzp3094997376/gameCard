using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using System.Timers;
using System.Collections.Generic;

public class ExportActions : MonoBehaviour
{

    public static string[] mStr = new string[] { "normal", "special", "transform", "super" };
    // Use this for initialization
    void Start()
    {

    }
    [MenuItem("AssetBundle/1、生成动作数据_new")]
    public static void GenActionAsset()
    {
        var path = "Assets/BattleEditor/Actions";
        string[] paths = AssetDatabase.FindAssets("t:Prefab", new string[] { path });
        var len = paths.Length;

        string tmpPath = "Assets/BattleEditor/actions_config/" + "ActionsDefault" + ".asset";
        //FileUtils.getInstance().createDirectory(Application.dataPath + "/actions_config");
        Object o = AssetDatabase.LoadAssetAtPath(tmpPath, typeof(ActionsScriptableData));
        ActionsScriptableData newObj = ScriptableObject.CreateInstance<ActionsScriptableData>();

        if (o)
        {
            AssetDatabase.DeleteAsset(tmpPath);
            o = null;
        }
        List<ActionsData> act = new List<ActionsData>();
        for (int i = 0; i < len; i++)
        {
            var guid = paths[i];
            string p = AssetDatabase.GUIDToAssetPath(guid);
            GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(p);
            var fileName = go.name;
            Actions playerAction = go.GetComponent<Actions>();
            if (playerAction == null)
            {
                continue;
            }

            // 选择的要保存的对象  包含PlayAction动作
            if (playerAction.m_Actions.Length <= 0)
            {
                Debug.Log("empty skill " + fileName);
                continue;
            }
            act.AddRange(playerAction.m_Actions);
        }
        newObj.m_Actions = act.ToArray();
        if (!o)
            AssetDatabase.CreateAsset(newObj, tmpPath);
        AssetDatabase.SaveAssets();
    }

    [MenuItem("AssetBundle/单独打包动作数据_new")]
    public static void BuildActionsAsset()
    {
        SetAssetBundleName("Assets/BattleEditor/actions_config/", "t:Asset", "Assets/BattleEditor", false);
        // Choose the output path according to the build target.
        string outputPath = Path.Combine("AssetBundle", FileUtils.getInstance().getRuntimePlatform());
        if (!Directory.Exists(outputPath))
            Directory.CreateDirectory(outputPath);
        BuildPipeline.BuildAssetBundles(outputPath, BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);

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
}
