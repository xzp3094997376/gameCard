using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class MyGrid : UIGrid
{
    public UITable mParentTable;
    public GameObject _copyObj;
    private int fixedCount;
    protected override void Start()
    {
        onCustomSort = sortTable;
        if (sorting == Sorting.Alphabetic || sorting == Sorting.None)
            sorting = Sorting.Custom;
        base.Start();
    }
    public static int GetNumberInt(string str)
    {
        int result = 0;
        if (str != null && str != string.Empty)
        {
            // 正则表达式剔除非数字字符（不包含小数点.） 
            str = System.Text.RegularExpressions.Regex.Replace(str, @"[^\d]*", "");
            int.TryParse(str, out result);
        }
        return result;
    }

    private int sortTable(Transform x, Transform y)
    {
        return GetNumberInt(x.name).CompareTo(GetNumberInt(y.name));
    }
    public void rePositionParent()
    {
        if (mParentTable)
        {
            mParentTable.repositionNow = true;
        }
    }

    public IEnumerator LoadList(string path, SLua.LuaTable dataes, SLua.LuaTable target = null)
    {
        int num = 0;
        ArrayList list = new ArrayList();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                list.Add(o.value);
            }
        }
        dataes = null;
        num = list.Count;
        var mTrans = transform;
        int childCount = mTrans.childCount;
        int count = Math.Max(num, childCount);
        for (int i = 0; i < count; i++)
        {
            GameObject go = null;
            if (i >= childCount)
            {
                if (_copyObj == null)
                {
                    StopAllCoroutines();
                    yield return null;
                    break;
                }

                go = NGUITools.AddChild(gameObject, _copyObj);
                go.SetActive(true);
                //列表少于需要的数量，加入新的
                var comp = go.GetComponent<UluaBinding>();
                if (comp)
                {
                    comp.CallUpdateWithArgs(new object[] { list[i], i, this, target });
                }
                go.name = "cell" + i;

                AddChild(go.transform);
                if (i != 0 && i % fixedCount == 0)
                {
                    rePositionParent();
                    yield return new WaitForEndOfFrame();
                }
            }
            else
            {
                var t = mTrans.GetChild(i);
                go = t.gameObject;
                if (i < num)
                {
                    go.SetActive(true);
                    go.name = "cell" + i;
                    var comp = go.GetComponent<UluaBinding>();
                    if (comp)
                    {
                        comp.CallUpdateWithArgs(new object[] { list[i], i, this, target });
                        //yield return new WaitForEndOfFrame();
                    }
                }
                else
                {
                    go.SetActive(false);
                }
            }
        }
        target = null;
        repositionNow = true;
        rePositionParent();
    }
    private void _loadList(string path, SLua.LuaTable dataes, SLua.LuaTable target = null)
    {
        int num = 0;
        ArrayList list = new ArrayList();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                list.Add(o.value);
            }
        }
        dataes = null;
        num = list.Count;
        var mTrans = transform;
        int childCount = mTrans.childCount;
        int count = Math.Max(num, childCount);
        for (int i = 0; i < count; i++)
        {
            GameObject go = null;
            if (i >= childCount)
            {
                if (_copyObj == null)
                {
                    break;
                }

                go = NGUITools.AddChild(gameObject, _copyObj);
                go.SetActive(true);
                //列表少于需要的数量，加入新的
                var comp = go.GetComponent<UluaBinding>();
                if (comp)
                {
                    comp.CallUpdateWithArgs(new object[] { list[i], i, this, target });
                }
                go.name = "cell" + i;

                AddChild(go.transform);
            }
            else
            {
                var t = mTrans.GetChild(i);
                go = t.gameObject;
                if (i < num)
                {
                    go.SetActive(true);
                    go.name = "cell" + i;
                    var comp = go.GetComponent<UluaBinding>();
                    if (comp)
                    {
                        comp.CallUpdateWithArgs(new object[] { list[i], i, this, target });
                    }
                }
                else
                {
                    go.SetActive(false);
                }
            }
        }
        target = null;
        repositionNow = true;
        rePositionParent();
    }
    public void refresh(string path, SLua.LuaTable dataes)
    {
        refresh(path, dataes,null);
    }
    public void refresh(string path, SLua.LuaTable dataes, SLua.LuaTable target)
    {
        refresh(path, dataes, target,5);
    }
    public void refresh(string path, SLua.LuaTable dataes, SLua.LuaTable target, int count)
    {
        refresh(path, dataes, target, count,true);
    }
    /// <summary>
    /// 协程加载列表，防止卡顿
    /// </summary>
    /// <param name="path"></param>
    /// <param name="dataes"></param>
    /// <param name="target"></param>
    public void refresh(string path, SLua.LuaTable dataes, SLua.LuaTable target,int count,bool isCoroutine)
    {
        if (_copyObj == null)
        {
            if (transform.childCount > 0)
            {
                _copyObj = transform.GetChild(0).gameObject;
                _copyObj.transform.parent = transform.parent;
                _copyObj.SetActive(false);
            }
            else
            {
                _copyObj = ClientTool.load(path, transform.parent.gameObject);
                _copyObj.SetActive(false);
            }
        }

        if (_copyObj == null) return;
        fixedCount = count;
        StopAllCoroutines();
        if (isCoroutine && gameObject.activeInHierarchy)
            StartCoroutine(LoadList(path, dataes, target));
        else
        {
            _loadList(path, dataes, target);
        }
        
    }  

    public void setParentTable(UITable tb)
    {
        mParentTable = tb;
    }
}
