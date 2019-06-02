using UnityEngine;
using System.Collections.Generic;
using System;
using SLua;


/// <summary>
/// 滑动方向，Horizontal左右方向滑动  Vertical 上下方向滑动
/// </summary>
public enum LZMovement
{
    Horizontal,
    Vertical,
}

public class LZScrollView : MonoBehaviour
{
    public Transform standardTrans;//计算坐标的标准，一般是scrollview的父类
    public GameObject itemCell;
    public Transform movePanel;
    public int lineCount = 1; // scroll 每行或者每列的个数
    public Vector2 itemWidthandheight = new Vector2(100, 100); //itemCell的高度和宽度
    public LZMovement movement = LZMovement.Vertical;
    public Dictionary<int, GameObject> itemDic = new Dictionary<int, GameObject>(); //itemCell 以及对应的索引

    private int moveSpeed = 5;//翻页的速度
    private Vector3 _targetPos;
    private int dataHangNum = 0;//真实数据的行数或者列数
    private int createHangCount = 1;// 实际生成的行数或者列数

    private int currentMinVernier = 0; //当前最小值游标
    private int currentMaxVernier = 0;//当前最大值游标

    private int topStandardValue = 0; //最顶端的标准以及最左边的标准
    private int bottleStandardValue = 0; //最下面的标准以及最右边的标准

    private Vector3 standardPos = Vector3.one;
    private List<object> _listData = new List<object>();//赋值的数据
    private bool _isPlaying = false;
    private bool _isPress = false;
    private bool _isOverRange = false;
    private bool isInit = false;
    private UIPanel panel; //为了获取Panel的高度
    private LuaTable _traget;
    private Vector3 initialPosition; // 移动的最初始位置
    public bool isPlaying
    {
        get
        {
            return _isPlaying;
        }
        set
        {
            _isPlaying = value;
        }
    }
    public bool isPress
    {
        get
        {
            return _isPress;
        }
        set
        {
            _isPress = value;
        }
    }
    public Vector3 targetPos
    {
        get
        {
            return _targetPos;
        }
        set
        {
            _targetPos = value;
        }
    }
    public bool isOverRange
    {
        get
        {
            return _isOverRange;
        }
        set
        {
            _isOverRange = value;
        }
    }
    public int getMinVernier
    {
        get
        {
            return currentMinVernier;
        }
    }
    public int getMaxVernier
    {
        get
        {
            return currentMaxVernier;
        }
    }
    public int getTopStandardValue
    {
        get
        {
            return topStandardValue;
        }
    }
    public int getBottleStandardValue
    {
        get
        {
            return bottleStandardValue;
        }
    }
    public List<object> getSourceData
    {
        get
        {
            return _listData;
        }
    }

    void Start()
    {
    }

    /// <summary>
    /// 赋值数据
    /// </summary>
    public void refresh(LuaTable dataes, LuaTable traget)  //重新刷新数据
    {
        if (dataes == null)
        {
            _traget = null;
            return;
        }

        _traget = null;
        _traget = traget;
        List<object> list = new List<object>();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                list.Add(o.value);
            }
        }
        clearList(_listData);
        _listData = list;
        dataes = null;
        list = null;
        if (_listData.Count == 0)
        {
            disPoseItemCell();
            return;
        }
        dataHangNum = _listData.Count % lineCount == 0 ? _listData.Count / lineCount : (_listData.Count / lineCount + 1);
        if (isInit)
        {
            resetVernier(_listData.Count);
            for (int i = currentMinVernier; i <= currentMaxVernier; i++)
            {
                LZItemCell cell;
                cell = itemDic[i].GetComponent<LZItemCell>();
                if (lineCount > 1)
                {
                    cell = itemDic[i].GetComponent<LZItemParent>();
                }
                if (i < dataHangNum)
                {
                    cell.gameObject.SetActive(true);//隐藏起来，并不删除
                    cell.Init(i, _traget);
                }
                else
                {
                    cell.Dispose();
                }
                cell = null;
            }
            adjustingLocation();
        }
        else
        {
            initialPosition = movePanel.localPosition;
            initAllNeedCell();
            isInit = true;
        }
    }

    /// <summary>
    /// 重设游标
    /// </summary>
    private void resetVernier(int newDataLength)
    {
        if (dataHangNum >= currentMaxVernier)
        {
            return;
        }
        int newMaxVernier = dataHangNum - 1;
        int newMinVernier = dataHangNum - createHangCount;
        if (newMinVernier <= 0)
        {
            newMinVernier = 0;
            newMaxVernier = createHangCount - 1;
        }
        List<GameObject> goList = new List<GameObject>();
        for (int i = currentMinVernier; i <= currentMaxVernier; i++)
        {
            goList.Add(itemDic[i]);
            itemDic.Remove(i);
        }
        int k = 0;
        for (int j = newMinVernier; j <= newMaxVernier; j++)
        {
            itemDic[j] = goList[k];
            k = k + 1;
        }
        goList = null;
        currentMinVernier = newMinVernier;
        currentMaxVernier = newMaxVernier;
    }


    private void disPoseItemCell()
    {
        foreach (int key in itemDic.Keys)
        {
            LZItemCell cell = itemDic[key].transform.GetComponent<LZItemCell>();
            if (cell != null)
            {
                cell.Dispose();
            }
        }
    }

    private void clearList(List<object> list)
    {
        int count = 0;
        for (int i = 0; i < count; i++)
        {
            list[i] = null;
        }
        list = null;
    }


    private void initAllNeedCell()
    {
        currentMinVernier = 0;
        panel = gameObject.GetComponent<UIPanel>();
        if (panel == null)
        {
            Debug.LogError("没有UIpanel用于裁剪可显示区域");
            return;
        }
        if (movement == LZMovement.Vertical)
        {
            topStandardValue = Convert.ToInt32(GetStandardPosition(itemCell.transform).y);
            bottleStandardValue = topStandardValue - Convert.ToInt32(panel.height);
            currentMaxVernier = Convert.ToInt32(panel.height) / Convert.ToInt32(itemWidthandheight.y) + 1;
        }
        else
        {
            topStandardValue = Convert.ToInt32(GetStandardPosition(itemCell.transform).x);
            bottleStandardValue = topStandardValue + Convert.ToInt32(panel.width);
            currentMaxVernier = Convert.ToInt32(panel.width) / Convert.ToInt32(itemWidthandheight.x) + 1;
        }
        createHangCount = currentMaxVernier + 1;
        for (int i = 0; i <= currentMaxVernier; i++)
        {
            GameObject trans = null;
            trans = Instantiate(itemCell, itemCell.transform.position, itemCell.transform.rotation) as GameObject;
            trans.transform.parent = movePanel;
            trans.transform.localScale = Vector3.one;
            trans.gameObject.SetActive(true);
            trans.name = i.ToString();
            LZItemParent cell = trans.GetComponent<LZItemParent>();
            if (movement == LZMovement.Vertical)
                trans.transform.localPosition = new Vector3(trans.transform.localPosition.x, -i * (itemWidthandheight.y), 0);
            else
                trans.transform.localPosition = new Vector3(i * (itemWidthandheight.x), trans.transform.localPosition.y, 0);
            if (i < dataHangNum)
            {
                cell.Init(i, _traget);
            }
            else
            {
                cell.Init(i, _traget, true);
            }
            itemDic[i] = trans;
        }
    }


    void Update()
    {
        if (isPlaying)
        {
            float dis = Vector3.Distance(movePanel.localPosition, targetPos);
            if (dis <= 0)
            {
                movePanel.localPosition = targetPos;
                MoveFinished();
            }
            else
            {
                movePanel.localPosition = Vector3.MoveTowards(movePanel.localPosition, targetPos, Time.deltaTime * 500 * moveSpeed);
            }
        }
    }
    public void MoveFinished()
    {
        isPlaying = false;
    }

    /// <summary>
    /// 往上滚动，表示增加页数
    /// </summary>
    public void plusItem()
    {
        if ((currentMaxVernier + 1) >= dataHangNum)
        {
            isOverRange = true;
            return;
        }
        isOverRange = false;
        GameObject go = itemDic[currentMinVernier];
        LZItemCell cell = go.GetComponent<LZItemCell>();  //这一步可以优化
        cell.Dispose();
        itemDic[currentMinVernier] = null;
        itemDic.Remove(currentMinVernier);
        if (movement == LZMovement.Vertical)
        {
            go.transform.localPosition = itemDic[currentMaxVernier].transform.localPosition - new Vector3(0, itemWidthandheight.y, 0);
        }
        else
        {
            go.transform.localPosition = itemDic[currentMaxVernier].transform.localPosition + new Vector3(itemWidthandheight.x, 0, 0);
        }
        currentMinVernier = currentMinVernier + 1;
        currentMaxVernier = currentMaxVernier + 1;
        cell.gameObject.SetActive(true);
        cell.Init(currentMaxVernier, _traget);
        go.name = currentMaxVernier.ToString();
        itemDic[currentMaxVernier] = go;
    }

    /// <summary>
    /// 往下滚动，表示减小页数
    /// </summary>
    public void minuItem()
    {
        if (currentMinVernier <= 0)
        {
            isOverRange = true;
            return;
        }
        isOverRange = false;
        GameObject go = itemDic[currentMaxVernier];
        LZItemCell cell = go.GetComponent<LZItemCell>();  //这一步可以优化
        cell.Dispose();
        itemDic[currentMaxVernier] = null;
        itemDic.Remove(currentMaxVernier);
        if (movement == LZMovement.Vertical)
            go.transform.localPosition = itemDic[currentMinVernier].transform.localPosition + new Vector3(0, itemWidthandheight.y, 0);
        else
            go.transform.localPosition = itemDic[currentMinVernier].transform.localPosition - new Vector3(itemWidthandheight.x, 0, 0);
        currentMinVernier = currentMinVernier - 1;
        currentMaxVernier = currentMaxVernier - 1;
        cell.gameObject.SetActive(true);
        cell.Init(currentMinVernier, _traget);
        go.name = currentMinVernier.ToString();
        itemDic[currentMinVernier] = go;
    }

    /// <summary>
    /// 跳转到指定页面，直接赋值  只支持单行单列的滚动条
    /// </summary>
    /// <param name="selectPage"></param>
    public void assignPage(int selectPage)
    {
        int count = itemDic.Keys.Count; //字典的数量
        int tempValue = 0;
        //1 跳转的数字比当前最小的索引还小
        if ((selectPage - count) <= 0)
        {
            for (int k = 0; k < count / 2; k++)  //选中的那个尽量在中间
            {
                if ((selectPage - k) >= 0)
                {
                    tempValue = selectPage - k;
                }
            }
            resetItemDic(tempValue);
            return;
        }
        //2 跳转的数字在后面
        if ((selectPage + count) >= (_listData.Count - 1))
        {
            tempValue = selectPage - count / 2;
            for (int k = 0; k < count; k++)
            {
                if ((tempValue + count) > dataHangNum)
                {
                    tempValue = tempValue - 1;
                }
                else
                {
                    resetItemDic(tempValue);
                    return;
                }
            }
        }
        //3 直接减一半就好
        tempValue = selectPage - count / 2;
        resetItemDic(tempValue);
    }

    /// <summary>
    /// 本方法有待优化
    /// </summary>
    /// <param name="startCount"></param>
    private void resetItemDic(int startCount)
    {
        int count = itemDic.Keys.Count;
        int index = 0;
        List<LZItemCell> listGo = new List<LZItemCell>();
        for (int i = currentMinVernier; i <= currentMaxVernier; i++)
        {
            LZItemCell cell = itemDic[i].GetComponent<LZItemCell>();
            listGo.Add(cell);
            itemDic.Remove(i);
        }
        for (int j = startCount; j < (count + startCount); j++)
        {
            itemDic[j] = listGo[index].gameObject;
            listGo[index].gameObject.SetActive(true);
            listGo[index].Init(j, _traget);
            itemDic[j].name = j.ToString();
            index++;
        }
        currentMinVernier = startCount;
        currentMaxVernier = count + startCount - 1;
        listGo = null;
        if (currentMaxVernier >=count)
        {
            if (movement == LZMovement.Vertical)
            {
                movePanel.localPosition = movePanel.localPosition + new Vector3(0, itemWidthandheight.y * count / 2, 0);
            }
            else
            {
                movePanel.localPosition = movePanel.localPosition - new Vector3(itemWidthandheight.x * count / 2, 0, 0);
            }
        }
        if (currentMinVernier <= count / 2)
        {
            if (movement == LZMovement.Vertical)
            {
                movePanel.localPosition = movePanel.localPosition - new Vector3(0, itemWidthandheight.y * count / 2, 0);
            }
            else
            {
                movePanel.localPosition = movePanel.localPosition + new Vector3(itemWidthandheight.x * count / 2, 0, 0);
            }
        }
        adjustingLocation();
    }

    public Vector3 GetStandardPosition(Transform trans)
    {
        standardPos = Vector3.zero;
        getPoint(trans);
        return standardPos;
    }

    private void getPoint(Transform trans)
    {
        if (trans.parent != standardTrans)
        {
            standardPos = standardPos + trans.localPosition;
            getPoint(trans.parent);
        }
    }

    public void adjustingLocation()
    {
        int firstY = 0;
        int lastY = 0;
        int trueHangCount = 0;
        Vector3 v3 = movePanel.localPosition;
        bool tempBol = false;
        for (int i = createHangCount; i > createHangCount / 2; i--) //获取一个界面真实能显示的格子行数
        {
            if (movement == LZMovement.Vertical)
            {
                if (i * itemWidthandheight.y >= Convert.ToInt32(panel.height))
                {
                    trueHangCount = i;
                }
            }
            else
            {
                if (i * itemWidthandheight.x >= Convert.ToInt32(panel.width))
                {
                    trueHangCount = i;
                }
            }
        }
        if (movement == LZMovement.Vertical)
        {
            firstY = Convert.ToInt32(GetStandardPosition(itemDic[getMinVernier].transform).y);
            //这个地方情况比较复杂
            //1.不满全屏的情况，不关怎么样都以最上为单位
            if (dataHangNum < trueHangCount)
            {
                if (firstY > getTopStandardValue)
                    targetPos = v3 + new Vector3(0, -Math.Abs(firstY - getTopStandardValue), 0);
                else
                    targetPos = v3 + new Vector3(0, Math.Abs(firstY - getTopStandardValue), 0);
                tempBol = true;
            }
            else
            {
                if ((dataHangNum - 1) < currentMaxVernier) //如果
                    lastY = Convert.ToInt32(GetStandardPosition(itemDic[dataHangNum - 1].transform).y - itemWidthandheight.y);
                else
                    lastY = Convert.ToInt32(GetStandardPosition(itemDic[getMaxVernier].transform).y - itemWidthandheight.y);
                //2,大于全屏的数量,先按最下面的取值，然后判断最上面是否超标
                if (lastY >= getBottleStandardValue)
                {
                    targetPos = v3 - new Vector3(0, Math.Abs(lastY - getBottleStandardValue), 0);
                    tempBol = true;
                }
                if (firstY < getTopStandardValue)
                {
                    targetPos = v3 + new Vector3(0, Math.Abs(firstY - getTopStandardValue), 0);
                    tempBol = true;
                }
            }
        }
        else
        {
            //横向移动的时候
            firstY = Convert.ToInt32(GetStandardPosition(itemDic[getMinVernier].transform).x);
            if (dataHangNum < trueHangCount)
            {
                if (firstY < getTopStandardValue)
                    targetPos = v3 + new Vector3(Math.Abs(firstY - getTopStandardValue), 0, 0);
                else
                    targetPos = v3 - new Vector3(Math.Abs(firstY - getTopStandardValue), 0, 0);
                tempBol = true;
            }
            else
            {
                if ((dataHangNum - 1) < currentMaxVernier) //如果
                    lastY = Convert.ToInt32(GetStandardPosition(itemDic[dataHangNum - 1].transform).x + itemWidthandheight.x);
                else
                    lastY = Convert.ToInt32(GetStandardPosition(itemDic[getMaxVernier].transform).x + itemWidthandheight.x);
                if (lastY < getBottleStandardValue)
                {
                    targetPos = v3 + new Vector3(Math.Abs(lastY - getBottleStandardValue), 0, 0);
                    tempBol = true;
                }
                if (firstY > getTopStandardValue)
                {
                    targetPos = v3 - new Vector3(Math.Abs(firstY - getTopStandardValue), 0, 0);
                    tempBol = true;
                }
            }
        }
        if (tempBol)
        {
            tempBol = false;
            isPlaying = true;
        }
    }
}
