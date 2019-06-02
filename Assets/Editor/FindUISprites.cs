using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEditor;
using UnityEngine;
using System.IO;


public class FindUISprites : MonoBehaviour 
{
    [MenuItem("Tools/查找丢失图集的UISprite")]
    private static void OnSearch() 
    {
        //确保鼠标右键选择的是一个Prefab
        //if (Selection.gameObjects.Length != 1)
        //{
        //    return;
        //}

        _CheckMissSprite();
    }

    public static void _CheckMissSprite()
    {
        var select = Selection.activeObject;
        var path = AssetDatabase.GetAssetPath(select);

        List<string> files = GetObjectNameToArray(path);

        for (int i = 0; i < files.Count; i++ )
        {
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(files[i]);
            // 获取所有的UISprite
            UISprite[] sprites = obj.GetComponentsInChildren<UISprite>(true);

            for (int j = 0; j < sprites.Length; j++)
            {
                if (sprites[j].GetAtlasSprite() == null)
                {
                    string pPath = GetGameObjectPath(sprites[j].gameObject);
                    if (sprites[j].atlas != null)
                    {
                        string name = "";
                        name = sprites[j].atlas == null ? "" : sprites[j].atlas.name;
                        Debug.Log("图集 :  " + name + "     缺失    " + sprites[j].spriteName + "   路径: " + pPath + sprites[j].gameObject.name);
                    }
                    else 
                    {
                        SpriteHelper sh = sprites[j].gameObject.GetComponent<SpriteHelper>();
                        if (sh == null)
                        {
                            Debug.Log("丢失图集    路径: " + pPath);
                        }
                    }
                }
            }
        }
    }

    [MenuItem("Tools/修改所有Prefab里的UILabel")]
    private static void OnSearchPrefab()
    {
        SearchPrefabs();
    }

    public static void SearchPrefabs()
    {
        var select = Selection.activeObject;
        var path = AssetDatabase.GetAssetPath(select);

        List<string> files = GetObjectNameToArray(path);

        var fs = GetPrefabInFiles(files);
        dealWithUILabel(fs);
    }


    public static void dealWithUILabel(List<string> fs)
    {
        foreach (string s in fs) 
        {
            UnityEngine.Object loadObject = AssetDatabase.LoadMainAssetAtPath(s);
            if (loadObject == null) 
            {
                continue;
            }
            GameObject preObj = loadObject as GameObject;

            UILabel[] labs = preObj.GetComponentsInChildren<UILabel>(true);
            if (labs != null) 
            {
                foreach (UILabel label in labs) 
                {
                    if (label.bitmapFont != null && label.bitmapFont.name == "MyDanicFont") 
                    {
                        if (label.effectStyle != UILabel.Effect.Outline8) 
                        {
                            // 改变
                            label.effectStyle = UILabel.Effect.Outline8;
                            label.fontStyle = FontStyle.Normal;
                        }

                        if (label.fontStyle != FontStyle.Normal) {
                            label.fontStyle = FontStyle.Normal;
                        }
                    }
                }
                EditorUtility.SetDirty(preObj);
            }
        }
        AssetDatabase.SaveAssets();
    }
    static List<string> GetPrefabInFiles(List<string> files)
    {
        List<string> fs = new List<string>();
        Debug.LogError("搜索开始");
        foreach (string file in files)
        {

            string loadfile = file;

            //UnityEngine.Object loadObject = AssetDatabase.LoadMainAssetAtPath(loadfile);
            //
            //if (loadObject == null)
            //{
            //
            //    Debug.LogError("load asset file error:" + loadfile);
            //
            //    return null;
            //
            //}

            if (file.EndsWith(".prefab"))
            {
                //此处有点问题：就是我不实例化物体对象就获取不到子物体的Renderer组件

                //有大神知道原因请赐教，感激不尽!!!!!!!

                fs.Add(file);

                //GameObject.DestroyImmediate(preObj);

            }
        }

        Debug.LogError("搜索结束: " + fs.Count);
        return fs;
    }


    public static string GetGameObjectPath(GameObject obj)
    {
        string path = "/" + obj.name;
        while (obj.transform.parent != null)
        {
            obj = obj.transform.parent.gameObject;
            path = "/" + obj.name + path;
        }
        return path;
    }

    /// <summary>
    /// 根据指定的 Assets下的文件路径 返回这个路径下的所有文件名//
    /// </summary>
    /// <returns>文件名数组</returns>
    /// <param name="path">Assets下“一"级路径</param>
    /// <param name="pattern">筛选文件后缀名的条件.</param>
    /// <typeparam name="T">函数模板的类型名t</typeparam>
    public static List<string> GetObjectNameToArray(string path)
    {  
        string objPath = path;//Application.dataPath + "/" + path;
        string[] directoryEntries;
        List<string> files = new List<string>();
        try
        {
            //返回指定的目录中文件和子目录的名称的数组或空数组
            directoryEntries = Directory.GetDirectories(objPath);

            for (int i = 0; i < directoryEntries.Length; i++)
            {
                string p = directoryEntries[i];

                if (Directory.Exists(p))
                {
                    string[] subFils = Directory.GetFileSystemEntries(p);
                    foreach (string s in subFils)
                    {
                        if (s.EndsWith(".prefab"))
                        {
                            if (!files.Contains(s))
                            {
                                files.Add(s);
                            }
                        }
                    }
                }
                else
                {
                    if (p.EndsWith(".prefab"))
                    {
                        if (!files.Contains(p))
                        {
                            files.Add(p);
                        }
                    }
                }
            }

            return files;
        }
        catch (System.IO.DirectoryNotFoundException)
        {
            Debug.Log("The path encapsulated in the " + objPath + "Directory object does not exist.");
        }
        return null;
    }
}



public class ScanMaterials : EditorWindow
{

    [MenuItem("Tools/ScanMaterials")]

    public static void Scan()
    {

        var select = Selection.activeObject;
        var path = AssetDatabase.GetAssetPath(select);

        List<string> files = GetObjectNameToArray(path);
        GetPrefab(files);

    }

    /// <summary>
    /// 根据指定的 Assets下的文件路径 返回这个路径下的所有文件名//
    /// </summary>
    /// <returns>文件名数组</returns>
    /// <param name="path">Assets下“一"级路径</param>
    /// <param name="pattern">筛选文件后缀名的条件.</param>
    /// <typeparam name="T">函数模板的类型名t</typeparam>
    public static List<string> GetObjectNameToArray(string path)
    {
        string objPath = path;//Application.dataPath + "/" + path;
        List<string> directoryEntries = new List<string>();
        List<string> files = new List<string>();
        try
        {
            //返回指定的目录中文件和子目录的名称的数组或空数组
            
            var ds = Directory.GetDirectories(objPath);
            var fs = Directory.GetFiles(objPath);
            directoryEntries.AddRange(ds);
            directoryEntries.AddRange(fs);

            for (int i = 0; i < directoryEntries.Count; i++)
            {
                string p = directoryEntries[i];

                if (Directory.Exists(p))
                {
                    string[] subFils = Directory.GetFileSystemEntries(p);
                    foreach (string s in subFils)
                    {
                        if (s.EndsWith(".prefab") || s.EndsWith(".mat"))
                        {
                            if (!files.Contains(s))
                            {
                                files.Add(s);
                            }
                        }
                    }
                }
                else
                {
                    if (p.EndsWith(".prefab") || p.EndsWith(".mat"))
                    {
                        if (!files.Contains(p))
                        {
                            files.Add(p);
                        }
                    }
                }
            }

            return files;
        }
        catch (System.IO.DirectoryNotFoundException)
        {
            Debug.Log("The path encapsulated in the " + objPath + "Directory object does not exist.");
        }
        return null;
    }

    public static string GetGameObjectPath(GameObject obj)
    {
        string path = "/" + obj.name;
        while (obj.transform.parent != null)
        {
            obj = obj.transform.parent.gameObject;
            path = "/" + obj.name + path;
        }
        return path;
    }

    static void GetPrefab(List<string> files)
    {
        StringBuilder sb = new StringBuilder();
        int count = 0;
        Debug.LogError("搜索开始");
        foreach (string file in files)
        {

            string loadfile = file;

            UnityEngine.Object loadObject = AssetDatabase.LoadMainAssetAtPath(loadfile);

            if (loadObject == null)
            {

                Debug.LogError("load asset file error:" + loadfile);

                return;

            }

            if (file.EndsWith(".prefab"))
            {
                GameObject preObj = loadObject as GameObject;

                //此处有点问题：就是我不实例化物体对象就获取不到子物体的Renderer组件

                //有大神知道原因请赐教，感激不尽!!!!!!!

                GameObject obj = Instantiate(preObj) as GameObject;

                Renderer[] renderers = obj.GetComponentsInChildren<Renderer>(true);

                for (int i = 0; i < renderers.Length; i++)
                {

                    Renderer render = renderers[i];

                    Judge(render.sharedMaterials, render.gameObject, preObj, loadfile, ref sb, ref count);

                }
                GameObject.DestroyImmediate(obj);

            }
            else if (file.EndsWith(".mat")) 
            {
                Material go = loadObject as Material;
                if (go.mainTexture == null) 
                {

                    string str = " mainTexture is none";
                    StringBuilder sb1 = new StringBuilder();
                    sb1.Append(" ");

                    sb1.Append(" ");

                    sb1.Append(go.name);

                    sb1.Append(" ");

                    sb1.Append(str);
                    count++;
                    Debug.LogError(sb1.ToString());
                }
                
            }
        }
        Debug.LogError(sb.ToString());
        Debug.LogError("搜索结束: " + count);
    }

    static void Judge(Material[] materials, GameObject obj, GameObject parentObj, string path, ref StringBuilder sb, ref int count)
    {
        for (int y = 0; y < materials.Length; y++)
        {

            Material material = materials[y];

            if (null == material)
            {

                string str = " Material is none";

                sb.Append(" ");

                sb.Append(parentObj.name);

                sb.Append(" " + obj.name);

                sb.Append(" ");

                sb.Append(str);
                sb.Append("\n");
                count++;
            }

            else
            {

                if (material.mainTexture == null)
                {

                    string str = " mainTexture is none";

                    sb.Append(" ");

                    sb.Append(parentObj.name);

                    sb.Append(" " + obj.name);

                    sb.Append(" ");

                    sb.Append(material.name);

                    sb.Append(" ");

                    sb.Append(str);
                    sb.Append("\n");
                    count++;
                }

            }

        }
    }

}

