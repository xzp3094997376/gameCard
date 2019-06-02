/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       ScrollViewItem
* 机器名称：       SHEN
* 命名空间：       
* 文 件 名：       ScrollViewItem
* 创建时间：       2014/5/23 10:58:21
* 作    者：       Oliver shen
* 说    明：       控制列表项的内容更新。所有用到ScrollView设置的每个列表项模式继承该类
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
/// <summary>
/// 负责更新列表项
/// </summary>
public class ScrollViewItem : MonoBehaviour {
    public float width = 100;
    public float height = 100;
    protected int mIndex = -1;
    public UluaBinding binding;
    public virtual string ClassName
    {
        get { return "ScrollViewItem"; }
    }

    /// <summary>
    /// 更新列表内容
    /// </summary>
    /// <param name="obj"></param>
    public virtual void updateView(object obj,int index,SLua.LuaTable table)
    {
        if (binding != null)
        {
            binding.CallUpdateWithArgs(obj, index, table);
        }
    }

    public void updateSelf() 
    {
        if (binding != null) {
            binding.CallTargetFunction("onUpdate");
        }
    }

    void OnDestroy()
    {
        binding = null;
    }
}
