using UnityEngine;
using System.IO;
using System;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************
/***
 * 
 * 文件修改！将文件加载机制 修改成先加载persistentDataPath目录下面 
 * 如果没有再加载其它目录
 * 
 ***/
//加载地址
#if UNITY_EDITOR
public class Table_PathSetting
{
    private static Table_PathSetting _setting;
    public string configPath = "";
    static public string path
    {
        get
        {
            if (_setting == null)
            {
                _setting = new Table_PathSetting();
                _setting.configPath = FileUtils.getInstance().getString("editor_config/path_setting.txt");
            }
            return _setting.configPath;
        }
    }
}
#endif

public class UrlManager
{

    private static string pf
    {
        get
        {
            var pf = FileUtils.getInstance().getRuntimePlatform();
            return pf;
        }
    }
    //服务器资源总路径
    public static string serverResourcesPath
    {
        get
        {
            return "http://" + Network.SERVER_IP + ":7912/bleachResources";
        }
    }

    //路径
    public static string GetPath(string path)
    {
        string url = path;
        if (Application.platform == RuntimePlatform.IPhonePlayer || Application.platform == RuntimePlatform.OSXEditor)
        {
            url = "file://" + path;
        }
        return url;
    }

    /// <summary>
    /// 获取资源目录  用于www的资源加载
    /// </summary>
    /// <param name="name">文件名字</param>
    /// <param name="type">类型 默认角色</param>
    /// <returns></returns>
    public static string ModelPath(string name, string type = "roles")
    {
        string strPath = "ArtResources/" + pf + "/" + type + "/" + name.ToLower();

        //#if UNITY_IOS
        //            strPath += type + "/" + name + ".os";
        //#else
        //            strPath += type + "/" + name + ".ab";
        //#endif
        var path = FileUtils.getInstance().getFullPath(strPath);
        return (path);
    }

    public static string AssetBuildPath(string name, string type = "roles")
    {
        string strPath = "AssetBundle/" + pf + "/" + type + "/" + name.ToLower();

        //#if UNITY_IOS
        //            strPath += type + "/" + name + ".os";
        //#else
        //            strPath += type + "/" + name + ".ab";
        //#endif
        var path = FileUtils.getInstance().getFullPath(strPath);
        return (path);
    }
    static string formatUrl(string urlstr)
    {
        if (string.IsNullOrEmpty(urlstr)) return "";
        Uri url = new Uri(urlstr);

        return url.AbsoluteUri;
    }

    static bool isAbsoluteUrl(string url)
    {
        Uri result;
        return Uri.TryCreate(url, System.UriKind.Absolute, out result);
    }

    /// <summary>
    /// 获取场景路径 只能用于www加载
    /// </summary>
    /// <param name="fileName">场景名字</param>
    /// <returns></returns>
    public static string GetScenePath(string fileName)
    {
        string strPath = "ArtResources/" + pf + "/";

#if UNITY_IOS
            strPath += fileName + ".unityOs";
#else
        strPath += fileName + ".unityAb";
#endif
        var path = FileUtils.getInstance().getFullPath(strPath);
        return (path);
    }

    //获取音乐文件地址
    public static string GetAudioPath(string _path)
    {
        string strPath = "ArtResources/" + pf + "/" + _path.ToLower();

        //#if UNITY_IOS
        //            strPath += _path + ".os";
        //#else
        //        strPath += _path + ".ab";
        //#endif
        var path = FileUtils.getInstance().getFullPath(strPath);

        return (path);
    }

    //config位置
    public static string GetConfigPath(string path)
    {
#if UNITY_EDITOR
        if (!Directory.Exists(Table_PathSetting.path))
        {
            if (UnityEditor.EditorUtility.DisplayDialog("提示", "找不到配置表格，请在菜单Setting->配置文件更改->浏览(表格目录) 配置", "确定"))
            {
            }
            throw new Exception("未配置表格目录");
        }
        return Table_PathSetting.path + "/" + path;
#else
        return FileUtils.getInstance().getFullPath("configs/" + path);
#endif
    }



    /// <summary>
    /// 加载的图片的位置
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static string GetImagesPath(string path)
    {
        //if(path.IndexOf(".png") == -1 && path.IndexOf(".jpg") == -1)
        //{
        //    //Debug.Log("图片文件没有后缀 -> " + path);
        //}
        //return FileUtils.getInstance().getFullPath("images/" + path);
        if (string.IsNullOrEmpty(path) || Path.GetFileNameWithoutExtension(path) == "") return "";
        return "images/" + path;
    }
    /// <summary>
    /// lua加载路径  意味着lua 安卓的lua必须放在persistent目录
    /// </summary>
    /// <param name="path">路径</param>
    /// <returns></returns>
    public static string GetLuaPath(string path)
    {
        if (!path.EndsWith(".lua")) path += ".lua";
        return FileUtils.getInstance().getFullPath(path);
    }
}
