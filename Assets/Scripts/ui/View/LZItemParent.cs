using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;

/// <summary>
/// 存放item的父类，用于多item的循环
/// </summary>
public class LZItemParent : LZItemCell
{
    public LZScrollView scrollview;
    public GameObject item;
    public UIGrid grid;
    private List<LZItemCell> itemList = new List<LZItemCell>();
    private bool isWaiting = false;
    private bool isInit = false;
    private int currentIndex;
    private LuaTable target;
    private bool isDispose = false; //是否是不显示的
    void Start()
    {
        if (!isInit)
        {
            for (int i = 0; i < scrollview.lineCount; i++)
            {
                GameObject trans = null;
                trans = Instantiate(item, item.transform.position, item.transform.rotation) as GameObject;
                trans.transform.parent = transform;
                trans.transform.localScale = Vector3.one;
                trans.gameObject.SetActive(true);
                trans.name = i.ToString();
                LZItemCell cell = trans.GetComponent<LZItemCell>();
                itemList.Add(cell);
            }
            isInit = true;
        }
        if (isWaiting)
        {
            //赋值
            isWaiting = false;
            Init(currentIndex, target);
        }
        grid.repositionNow = true;
    }

    public override void Init(object obj, SLua.LuaTable table, bool isDispose = false)
    {
        target = table;
        currentIndex = (int)obj;
        if (!isInit)
        {
            isWaiting = true;
            return;
        }
        List<object> dataSource = scrollview.getSourceData;
        int maxCount = dataSource.Count;
        for (int i = 0; i < scrollview.lineCount; i++)
        {
            if ((currentIndex * scrollview.lineCount + i) < maxCount && isDispose == false)
            {
                itemList[i].Init(dataSource[currentIndex * scrollview.lineCount + i], target);
            }
            else
            {
                itemList[i].Dispose();
            }
        }
        grid.repositionNow = true;
    }

    public override void Dispose()
    {
        int count = itemList.Count;
        for (int i = 0; i < count; i++)
        {
            itemList[i].Dispose();
        }
    }
}
