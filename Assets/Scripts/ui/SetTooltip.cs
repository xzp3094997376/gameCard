/*************************************************************************************
 * 类 名 称：       SetUIToolTip
 * 命名空间：       Assets.Scripts.ui
 * 创建时间：       2014/9/2 10:52:19
 * 作    者：       Oliver shen
 * 说    明：       
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using SLua;
using System;

[CustomLuaClass]
public class SetTooltip : MonoBehaviour
{
    public float fixPosition = 0;
    public Tips.FixPosition mDir = Tips.FixPosition.X;
    /// <summary>
    /// 显示tips的事件
    /// </summary>
    public Func<string> onTooltip;

    /// <summary>
    /// 初始化，给lua绑定onTooltip方法，获得lua里的文本
    /// </summary>
    void Start()
    {
        if (onTooltip == null)
        {
            UluaBinding binding = NGUITools.FindInParents<UluaBinding>(gameObject);
            if (binding)
            {
                var vars = binding.mVariables;
                for (int i = 0, max = vars.Length; i < max; i++)
                {
                    var lua = vars[i];
                    if (lua.gameObject == gameObject)
                    {
                        onTooltip = () =>
                        {
                            string str = "";
                            object text = UluaBinding.CallLuaFunction(binding.target, UluaBinding.ON_TOOLTIP, lua.name);
                            if (text != null) str = text.ToString();
                            return str;                            
                        };
                        break;
                    }
                }
            }
        }
    }
    public void show(string text)
    {
        Tips.ShowText(text, transform, fixPosition, mDir);
    }
    void OnDestroy()
    {
        onTooltip = null;
    }
    /// <summary>
    /// 按下触发tip事件
    /// </summary>
    /// <param name="press"></param>
    void OnPress(bool press)
    {
        
        if (press && onTooltip != null)
        {
            string text = onTooltip();
            Tips.ShowText(text, transform, fixPosition, mDir);
            return;
        }
        Tips.ShowText(null, transform, fixPosition, mDir);
    }
}
