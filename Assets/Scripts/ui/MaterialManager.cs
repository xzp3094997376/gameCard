using UnityEngine;
using System.Collections.Generic;
/// <summary>
/// author:Roy
/// description:
/// This files is using for UISpriteII to manager material.And it is reduce wasting Material.
/// Singleton Object
/// 
/// </summary>
public class MaterialManager 
{
    //private static MaterialManager _ins = null;
    //public static MaterialManager Instance
    //{
    //    get
    //    {
    //        if (_ins == null)
    //        {
    //            _ins = new MaterialManager();
    //        }
    //        return _ins;
    //    }
    //}
    private static Dictionary<string, Material> m_HashMaterial = new Dictionary<string, Material>();


    private MaterialManager(){}
    /// <summary>
    /// get Material Object from manager . reduce waste Material
    /// </summary>
    /// <param name="atlasGID">atlas GID. Such as mAtlas.GetInstanceID()</param>
    /// <param name="shaderName">shader name</param>
    /// <returns> Material Object</returns>
    public static Material GetMaterial(UIAtlas atlas, string shaderName)
    {
        if(atlas==null)
        {
            return null;
        }
        int atlasGID = atlas.GetInstanceID();
        string strKey = atlasGID + shaderName;

        if (m_HashMaterial.ContainsKey(strKey) && m_HashMaterial[strKey] != null)
        {
            return m_HashMaterial[strKey];
        }

        //can not find and create new one.
        Material matBall = new Material(Shader.Find(shaderName));
        
        matBall.SetTexture("_MainTex", atlas.texture);
        if (shaderName.IndexOf("mask_roundness") >= 0)
        {
            //如果缺少贴图自动添加
            matBall.SetTexture("_Mask", Resources.Load<Texture>("meterial/yuanquan"));
        }
        m_HashMaterial[strKey] = matBall;
        return matBall;
    }
    /// <summary>
    ///  set Material Object to manager
    /// </summary>
    /// <param name="atlasGID">atlas GID. Such as mAtlas.GetInstanceID()</param>
    /// <param name="shaderName">shader name</param>
    /// <param name="matBall">Material Object</param>
    public static void SetMaterial(int atlasGID, string shaderName, Material matBall)
    {
        string strKey = atlasGID + shaderName;
        m_HashMaterial[strKey] = matBall;
    }
}
