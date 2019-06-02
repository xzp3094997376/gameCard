using UnityEngine;
using System.Collections;
using System;
using System.IO;
using System.Collections.Generic;
using SimpleJson;
/***
 * author:zengjiadong
 * 
 * 用于加载管理战斗所需要的资源
 * 
 * */

//资源的类型
public enum AssetType
{
    Model,
    Animation,
    Effect,
    Null,
}

public class AssetDetail
{
    public AssetType type = AssetType.Animation;
    public string name = "";
    //....特殊挂饰所用
    public string bonename;
    public float nScaleValue;
    public Vector3 nPosValue;
    public Vector3 nRotationValue;
}
public class AssetLoad : MonoBehaviour
{
    /// <summary>
    /// 加载完成事件
    /// </summary>
    public delegate void AssetLoadCompleteDelegate();
    // Use this for initialization
    public static AssetLoad Instance = null;
    public Hashtable m_Assets = new Hashtable();
    public static string[] LoadDirs = { "heroprefab", "animation", "effect/prefab", "paths", "flycamera" };
    public List<string> m_AssetsName = new List<string>();
    public List<string> m_AssetsNameDontDestory = new List<string>();
    public int m_AssetCount = 0;
    void Awake()
    {
        Instance = this;
    }
   
    /// <summary>
    /// 加载某种类型的资源，以及资源的名字
    /// </summary>
    /// <param name="type_name"></param>
    /// <param name="?"></param>
    public void LoadAsset(AssetType type, string asset_name, bool dontdestroy = false)
    {
        if (string.IsNullOrEmpty(asset_name))
            return;
        if (dontdestroy)
        {
            if(!m_AssetsNameDontDestory.Contains(asset_name))
            {
                m_AssetsNameDontDestory.Add(asset_name);
            }
        }
        if (m_Assets.ContainsKey(type))
        {
            Hashtable tmpTable = m_Assets[type] as Hashtable;
            if (tmpTable.ContainsKey(asset_name))
                return;
        }
        else
        {
            m_Assets[type] = new Hashtable();
        }

        AssetDetail cur = new AssetDetail();
        cur.type = type;
        cur.name = asset_name;

        string path = UrlManager.ModelPath(asset_name, LoadDirs[(int)type]);
        if (path == "")
        {
            return;
        }

        m_AssetsName.Add(asset_name);
        (m_Assets[type] as Hashtable)[asset_name] = null;
        m_AssetCount++;
        //LoadManager.getInstance().LoadSceneUnity3d(path, cur.name, LoadCompelete, cur, LoadError);
    }
    /// <summary>
    /// 资源加载错误回掉
    /// </summary>
    /// <param name="Error"></param>
    void LoadError(string Error)
    {
        m_AssetCount--;
    }

   
    /// <summary>
    /// 资源加载完成后回掉
    /// </summary>
    /// <param name="load"></param>
    void LoadCompelete(LoadParam load)
    {
        AssetDetail ad = load.param as AssetDetail;
        for (int i = 0; i < m_AssetsName.Count; i++)
            if (m_AssetsName[i] == ad.name)
            {
                m_AssetsName.RemoveAt(i);
                break;
            }

        Hashtable tmp = m_Assets[ad.type] as Hashtable;
        m_AssetCount--;
       
        if (ad.type == AssetType.Effect)
        {
            //缓存特效的整体assetbundle  用到的时候再加载
            GameObject retObject = load.assetbundle.LoadAsset(ad.name, typeof(GameObject)) as GameObject;
            tmp[ad.name] = retObject;
            QualityManager.RecycleAssetBundle(UrlManager.ModelPath(ad.name, LoadDirs[(int)ad.type]));
        }
        else if (ad.type == AssetType.Model)
        {
            // object[] all = load.assetbundle.LoadAll();
            GameObject retObject = load.assetbundle.LoadAsset(ad.name, typeof(GameObject)) as GameObject;
            //if (ad.name == "maozhihualie_t_jiejin_xuqi")
            //{
            //    MyDebug.Log("here");
            //}
            //GameObject gobj = Instantiate(retObject) as GameObject;
            //DestroyObject(gobj, 0.1f);
            tmp[ad.name] = retObject;
            QualityManager.RecycleAssetBundle(UrlManager.ModelPath(ad.name, LoadDirs[(int)ad.type]));
        }
        else if (ad.type == AssetType.Animation)
        {
            GameObject retObject = load.assetbundle.LoadAsset(ad.name, typeof(GameObject)) as GameObject;
            tmp[ad.name] = retObject;
            QualityManager.RecycleAssetBundle(UrlManager.ModelPath(ad.name, LoadDirs[(int)ad.type]));
        }
        else
        {
            tmp[ad.name] = load.assetbundle;

            QualityManager.RecycleAssetBundle(UrlManager.ModelPath(ad.name, LoadDirs[(int)ad.type]), true);

        }
    }

    /// <summary>
    /// 返回动画的片段  
    /// </summary>
    /// <param name="aniName"></param>
    /// <param name="file_name"></param>
    /// <returns></returns>
    public GameObject GetAnimation(string aniName)
    {
        Hashtable hashTables = m_Assets[AssetType.Animation] as Hashtable;

        GameObject tmp = hashTables[aniName] as GameObject;
        return tmp;
    }
    /// <summary>
    /// 获取特效
    /// </summary>
    /// <param name="name">特效名称</param>
    /// <returns>特效返回</returns>
    public GameObject GetEffect(string name)
    {
        Hashtable hashTables = m_Assets[AssetType.Effect] as Hashtable;

        GameObject effectObject = hashTables[name] as GameObject;
        if (effectObject != null)
        {
            ModelShowUtil.CompleteRenderMaterialShader(effectObject);
            for (int i = 0; i < effectObject.transform.childCount; ++i)
                ModelShowUtil.CompleteRenderMaterialShader(effectObject.transform.GetChild(i).gameObject);
        }
        return effectObject;

    }
}
