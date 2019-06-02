/*************************************************************************************
 * 类 名 称：       LuaVariable
 * 命名空间：       Assets.uCsharpFramework
 * 创建时间：       2014/8/30 23:17:14
 * 作    者：       Oliver shen
 * 说    明：       
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System;

[System.Serializable]
/// <summary>
/// Lua变量
/// </summary>
public class LuaVariable
{
    private GameObject _go;
    private MonoBehaviour comp;
    public string name;
    public UnityEngine.Object variable;
    public string type;
    UITexture mTexture;
    public UnityEngine.Object val
    {
        get
        {
            if (isGameObject)
            {
                return gameObject;
            }
            else
            {
                if (gameObject)
                {
                    return gameObject.GetComponent(type);
                }
                return null;
            }
        }
    }
    public LuaVariable()
    {
    }
    public bool isGameObject
    {
        get
        {
            return type == "GameObject";
        }
    }
    public GameObject gameObject
    {
        get
        {
            //if (_go == null && variable != null)
            //{
            //    if (isGameObject) _go = variable as GameObject;
            //    else
            //    {
            //        if (variable.GetType() == typeof(GameObject))
            //        {
            //            _go = (GameObject)variable;
            //            variable = _go.GetComponent(type);
            //            return _go;
            //        }
            //        _go = (variable as MonoBehaviour).gameObject;
            //    }
            //}
            //return _go;
            if (_go) return _go;
            if (isGameObject) _go = variable as GameObject;
            else
            {
                if (variable == null) return null;
                if (variable.GetType() == typeof(GameObject))
                {
                    _go = (GameObject)variable;
                    return _go;
                }
                try
                {
                    var v = ((MonoBehaviour)variable);
                    if (v)
                        _go = v.gameObject;
                }
                catch (Exception e)
                {
                    Debug.LogError(e.ToString());
                }
                //variable = _go;
            }
            return _go;
        }
    }

    /// <summary>
    /// 显示gameObject
    /// </summary>
    public void Show()
    {
        if (gameObject != null) gameObject.SetActive(true);
    }
    /// <summary>
    /// 隐藏gameObject
    /// </summary>
    public void Hide()
    {
        if (gameObject != null) gameObject.SetActive(false);
    }
    /// <summary>
    /// 设置文本
    /// </summary>
    /// <param name="text"></param>
    public void SetText(string text)
    {
        if (isGameObject)
        {
            if (gameObject != null)
            {
                UILabel lab = gameObject.GetComponent<UILabel>();
                lab.text = text;
            }
        }
        else
        {
            if (variable is UILabel) { ((UILabel)variable).text = text; }
            else
            {
                if (gameObject != null)
                {
                    UILabel lab = gameObject.GetComponent<UILabel>();
                    lab.text = text;
                }
            }
        }
    }

    public void Play(string aniName)
    {
        Play(aniName, null);
    }
    public void Play(string clipName, EventDelegate.Callback cb)
    {
        GameObject go = gameObject;
        Animation ani = go.GetComponent<Animation>();
        ActiveAnimation activeAni = null;
        if (ani != null)
        {
            activeAni = ActiveAnimation.Play(ani, clipName, AnimationOrTween.Direction.Forward);
        }
        else
        {
            Animator animator = go.GetComponent<Animator>();
            if (animator == null) return;
            activeAni = ActiveAnimation.Play(animator, clipName, AnimationOrTween.Direction.Forward, AnimationOrTween.EnableCondition.DoNothing, AnimationOrTween.DisableCondition.DoNotDisable);
        }
        if (activeAni != null)
        {
            if (cb != null)
            {
                activeAni.onFinished.Clear();
                EventDelegate.Add(activeAni.onFinished, cb, true);
            }
        }
    }
    
    public void ChangeColor(string color,int index = 0)
    {
        UIWidget widget = gameObject.GetComponent<UIWidget>();
        if (widget)
        {
            widget.color = NGUIText.ParseColor(color, index);
        }
    }

    internal void ChangeColor(Color color)
    {
        UIWidget widget = gameObject.GetComponent<UIWidget>();
        if (widget)
        {
            widget.color = color;
        }
    }
    
    internal void Dispose()
    {
        //if (type == "UISprite")
        //{
        //    UISprite sp = (UISprite)variable;
        //    sp.atlas = null;
        //}
        comp = null;
        variable = null;
        if (mTexture)
        {
            mTexture.mainTexture = null;
        }
        mTexture = null;
    }

}
[Serializable]
public class LuaKeyValue
{
    public string Key = "keyName";
    public string Str = "";
    public int Int = 0;
    public float Float = 0;
    public ValTypes type = ValTypes.Int;
    public enum ValTypes
    {
        Int,
        Float,
        String
    }
    public LuaKeyValue()
    {

    }
    public object value
    {
        get
        {
            if (type == ValTypes.Int)
                return Int;
            else if (type == ValTypes.Float)
            {
                return Float;
            }
            else if (type == ValTypes.String)
            {
                return Str;
            }
            return null;
        }
    }

}