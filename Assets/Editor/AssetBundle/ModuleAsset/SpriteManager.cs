/*********************************************************************
* 类 名 称：       SpriteManager
* 命名空间：   
* 创建时间：       2014/7/28 14:20:20
* 作    者：       张晶晶
* 说    明：       精灵图片管理设置某物体上附着的图集预设及其中的精灵
* 最后修改时间：   2014/7/28
* 最后修 改 人：   张晶晶
* 曾修改人：
**********************************************************************/
using UnityEngine;
using System.Collections;

public class SpriteManager  {

    string mModuleName;

    string mPrefabsName;

    public GameObject mPrefab;
    
    private GameObject mAttachedGameObject;

    private UIAtlas mUIAtlas;

    private string mSpriteName;

    /// <summary>
    /// 通过传来的参数构造实例化
    /// </summary>


	public SpriteManager(string moduleName, string prefab, GameObject attachGameobject, UIAtlas atlas, string sprite){
     //   this.mPrefabsName = prefabName;
        this.mModuleName = moduleName;
		this.mPrefabsName = prefab;
        this.mAttachedGameObject = attachGameobject;
		this.mUIAtlas = atlas;
		this.mSpriteName = sprite;
	}

    //该物体所在的模块
    public string moduleName
    {
        get
        {
            return this.mModuleName;
        }
        set
        {
            this.mModuleName = value;
        }
    }

    //物体所在的预设名
    public string prefabName
    {
        get
        {
            return this.mPrefabsName;
        }
        set
        {
            this.mPrefabsName= value;
        }
    }
    /// <summary>
    /// 获取设置某个模块预设
    /// </summary>

    public GameObject ModulePrefab
    {
        get
        {
            return this.mPrefab;
        }
        set
        {
            this.mPrefab = value;
        }
    }


    /// <summary>
    /// 获取该图集图片附着在那个物体上
    /// </summary>

    public GameObject AttachedGameObject
    {
        get
        {
            return this.mAttachedGameObject;
        }
        set
        {
            this.mAttachedGameObject = value;
        }
    }

    /// <summary>
    /// 获取是那个图集
    /// </summary>

    public UIAtlas m_UIAtlas
    {
        get
        {
            return this.mUIAtlas;
        }
        set
        {
            this.mUIAtlas = value;
        }
    }

    /// <summary>
    /// 获取是那个图集
    /// </summary>

    public string m_SpriteName
    {
        get
        {
            return this.mSpriteName;
        }
        set
        {
            this.mSpriteName = value;
        }
    }

}
