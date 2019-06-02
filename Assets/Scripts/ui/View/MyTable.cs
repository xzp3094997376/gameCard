/*************************************************************************************
 * 类 名 称：       MyTable
 * 命名空间：       Assets.Scripts.ui.View
 * 创建时间：       2014/8/30 17:14:34
 * 作    者：       Oliver shen
 * 说    明：       表格组件
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class MyTable : UITable
{
    public UITable mParentTable;
    /// <summary>
    /// 表格总宽
    /// </summary>
    public int width
    {
        get;
        set;
    }
    /// <summary>
    /// 表格总高
    /// </summary>
    public int height
    {
        get;
        set;
    }
    protected override void Start()
    {
        width = 0;
        height = 0;
        base.Start();
        onCustomSort = sortTable;
        if (sorting == Sorting.Alphabetic || sorting == Sorting.None)
            sorting = Sorting.Custom;
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
    /// <summary>
    /// 更新表格宽高
    /// </summary>
    private void setContentSize()
    {
        Bounds b = NGUIMath.CalculateRelativeWidgetBounds(transform, transform);

        width = (int)Mathf.Ceil(b.size.x);
        height = (int)Mathf.Ceil(b.size.y);
    }


    /// <summary>
    /// Positions the grid items, taking their own size into consideration.
    /// </summary>

    protected void RepositionVariableSize(List<Transform> children)
    {
        float xOffset = 0;
        float yOffset = 0;

        int cols = columns > 0 ? children.Count / columns + 1 : 1;
        int rows = columns > 0 ? columns : children.Count;

        Bounds[,] bounds = new Bounds[cols, rows];
        Bounds[] boundsRows = new Bounds[rows];
        Bounds[] boundsCols = new Bounds[cols];

        int x = 0;
        int y = 0;

        for (int i = 0, imax = children.Count; i < imax; ++i)
        {
            Transform t = children[i];
            Bounds b = NGUIMath.CalculateRelativeWidgetBounds(t, !hideInactive);

            Vector3 scale = t.localScale;
            b.min = Vector3.Scale(b.min, scale);
            b.max = Vector3.Scale(b.max, scale);
            bounds[y, x] = b;

            boundsRows[x].Encapsulate(b);
            boundsCols[y].Encapsulate(b);

            if (++x >= columns && columns > 0)
            {
                x = 0;
                ++y;
            }
        }

        x = 0;
        y = 0;

        for (int i = 0, imax = children.Count; i < imax; ++i)
        {
            Transform t = children[i];
            Bounds b = bounds[y, x];
            Bounds br = boundsRows[x];
            Bounds bc = boundsCols[y];

            Vector3 pos = t.localPosition;
            pos.x = xOffset + b.extents.x - b.center.x;
            pos.x += b.min.x - br.min.x + padding.x;

            if (direction == Direction.Down)
            {
                pos.y = -yOffset - b.extents.y - b.center.y;
                pos.y += (b.max.y - b.min.y - bc.max.y + bc.min.y) * 0.5f - padding.y;
            }
            else
            {
                pos.y = yOffset + (b.extents.y - b.center.y);
                pos.y -= (b.max.y - b.min.y - bc.max.y + bc.min.y) * 0.5f - padding.y;
            }

            xOffset += br.max.x - br.min.x + padding.x * 2f;

            t.localPosition = pos;

            if (++x >= columns && columns > 0)
            {
                x = 0;
                ++y;

                xOffset = 0f;
                yOffset += bc.size.y + padding.y * 2f;
            }
        }

        // Apply the origin offset
        if (pivot != UIWidget.Pivot.TopLeft)
        {
            Vector2 po = NGUIMath.GetPivotOffset(pivot);

            float fx, fy;

            Bounds b = NGUIMath.CalculateRelativeWidgetBounds(transform);



            int count = children.Count;
            if (count == 1 && columns > 0)
            {
                float _fx = b.size.x;
                _fx = (_fx + padding.x) * columns;
                fx = Mathf.Lerp(0f, _fx, po.x);
            }
            else
            {
                fx = Mathf.Lerp(0f, b.size.x, po.x);
            }
            fy = Mathf.Lerp(-b.size.y, 0f, po.y);

            for (int i = 0; i < count; ++i)
            {
                Transform t = children[i];
                Vector3 pos = t.localPosition;
                pos.x -= fx;
                pos.y -= fy;
                t.localPosition = pos;
            }
        }
    }


    [ContextMenu("Execute")]
    public override void Reposition()
    {
        if (Application.isPlaying && !mInitDone && NGUITools.GetActive(this)) Init();

        mReposition = false;
        Transform myTrans = transform;
        List<Transform> ch = GetChildList();
        if (ch.Count > 0)
        {
            RepositionVariableSize(ch);
        }
        if (onReposition != null)
            onReposition();

        setContentSize();

    }

    /// <summary>
    /// 向表格里加一个对象
    /// </summary>
    /// <param name="pabs"></param>
    public GameObject AddChild(GameObject pabs)
    {
        GameObject go = NGUITools.AddChild(gameObject, pabs);
        return go;
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
                repositionNow = true;
                rePositionParent();
                yield return new WaitForFixedUpdate();

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
    GameObject _copyObj;
    public void refresh(string path, SLua.LuaTable dataes)
    {
        refresh(path, dataes,null);
    }
    /// <summary>
    /// 协程加载列表，防止卡顿
    /// </summary>
    /// <param name="path"></param>
    /// <param name="dataes"></param>
    /// <param name="target"></param>
    public void refresh(string path, SLua.LuaTable dataes, SLua.LuaTable target)
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
        StartCoroutine(LoadList(path, dataes, target));
    }
}
