/*********************************************************************
* 类 名 称：       ModuleManager
* 命名空间：   
* 创建时间：       2014/7/28 14:20:20
* 作    者：       张晶晶
* 说    明：       模块管理包括此模块名，模块下的所有预设，该模块依赖的图集， 某个预设下的某个子物体依赖的那张图片
* 最后修改时间：   2014/7/28
* 最后修 改 人：   张晶晶
* 曾修改人：
**********************************************************************/

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SimpleJson;
public class ModuleManager  {

    string mName;

   Dictionary<string, GameObject> mPrefabs;

    UIAtlas mAtlas;

   // SpriteManager[] mSpriteManager;

    /// <summary>
    /// 获取设置某个模块预设
    /// </summary>

    public string name
    {
        get
        {
            return this.mName;
        }
        set
        {
            this.mName = value;
        }
    }

    //该模块下的所有预设
    public Dictionary<string, GameObject> prefabs
    {
        get
        {
            return this.mPrefabs;
        }
        set
        {
            this.mPrefabs = value;
        }
    }

  
    //该模块依赖的图集
    public UIAtlas atlas
    {
        get
        {
            return this.mAtlas;
        }
        set
        {
            this.mAtlas = value;
        }
    }

   
}
