/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       ScrollView
* 机器名称：       SHEN
* 命名空间：       
* 文 件 名：       ScrollView
* 创建时间：       2014/5/23 9:58:21
* 作    者：       Oliver shen
* 说    明：       拖动列表控制类
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
/// <summary>
/// 拖动列表控制类
/// 支持循环滚动，方向调整等
/// </summary>
public class ScrollView : MonoBehaviour
{
    public UIScrollView mScrollView;
    public GameObject Content;
    public UluaBinding luaBinding;
    public bool resetContent = true;

    /// <summary>
    /// 是否列表项居中
    /// </summary>
    public bool isCenterChild = false;
    /// <summary>
    /// 是否点击列表项，项居中
    /// </summary>
    public bool isCenterOnClick = false;
    /// <summary>
    /// 间隔
    /// </summary>
    public float spacing = 10f;
    /// <summary>
    /// 列表项总数
    /// </summary>
    public int itemCount = 0;

    /// <summary>
    /// 列表项预设，预需要脚本 ScrollViewItem的类或派生类
    /// </summary>
    public GameObject viewItem;

    /// <summary>
    /// 每页显示多少个item
    /// </summary>
    private int pageCount = 0;
    /// <summary>
    /// 列表项控制类
    /// </summary>
    private ScrollViewItem viewItemClass;

    private List<ScrollViewItem> localList = new List<ScrollViewItem>();

    private UIGrid grid;
    private int loadedCount = 0;
    private bool needUpdate = false;
    private UIPanel mScrollPanel;
    private UIWrapContent mUIWrapContent;

    /// <summary>
    /// 左边缘控件
    /// </summary>
    private UIWidget mLeft;
    /// <summary>
    /// 右边缘控件
    /// </summary>
    private UIWidget mRight;
    private bool isStart = false;
    private bool _needRefresh = false;
    private bool isAdd;
    private bool isTop;
    private LuaTable _traget;
    private bool mFrist = true;
    private int _gotoindex;
    /// <summary>
    /// 数据源
    /// </summary>
    public IList DataSource
    {
        get;
        set;
    }

    // Use this for initialization
    void Awake()
    {
        DataSource = new List<object>();
        if (viewItem.transform.parent != null)
        {
            viewItem.SetActive(false);
            viewItem.transform.parent = transform;
        }

        mScrollView.onDragFinished += onDragFinished;
    }


    public void ResetPosition()
    {
        if (mScrollView)
        {
            mScrollView.ResetPosition();
        }
    }
    /// <summary>
    /// 开始运行
    /// </summary>
    void Start()
    {
        //init ScorllView
        if (mScrollView == null)
        {
            mScrollView = GetComponentInChildren<UIScrollView>();
            if (GetComponent<UIDragScrollView>() == null)
            {
                UIDragScrollView ds = gameObject.AddComponent<UIDragScrollView>();
                ds.scrollView = mScrollView;
            }
        }

        if (mScrollView == null)
        {
            MyDebug.LogError("can't find ScrollView GameObject!");
            return;
        }
        #region 初始化边缘
        mLeft = NGUITools.AddChild<UIWidget>(mScrollView.gameObject);
        mLeft.width = 2;
        mLeft.height = 2;
        mRight = NGUITools.AddChild<UIWidget>(mScrollView.gameObject);
        mRight.width = 2;
        mRight.height = 2;
        #endregion
        mScrollPanel = mScrollView.gameObject.GetComponent<UIPanel>();
        if (Content == null)
            Content = mScrollView.GetComponentInChildren<UIWrapContent>().gameObject;

        if (Content == null) return;
        UICenterOnChild sp = Content.GetComponent<UICenterOnChild>();
        if (isCenterChild)
        {
            if (!sp)
            {
                sp = Content.AddComponent<UICenterOnChild>();
                sp.springStrength = 8;
            }
        }
        else
        {
            Destroy(sp);
        }
        #region 循环与重用cell
        // BMK 检测与加入循环组件
        mUIWrapContent = Content.GetComponent<UIWrapContent>();
        if (!mUIWrapContent)
        {
            mUIWrapContent = Content.AddComponent<UIWrapContent>();
            mUIWrapContent.cullContent = true;
        }
        mUIWrapContent.onInitializeItem = onInitializeItem;

        #endregion

        // 表格
        grid = Content.GetComponent<UIGrid>();
        if (!grid)
        {
            grid = Content.AddComponent<UIGrid>();
        }
        grid.hideInactive = true;
        grid.keepWithinPanel = false;
        if (resetContent) { 
            grid.transform.localPosition = Vector3.zero;
        }
        //初始化表格参数
        if (viewItem)
        {
            viewItemClass = viewItem.GetComponent<ScrollViewItem>();//每个cell都要继承这个类
            if (viewItemClass == null)
            {
                ClientTool.LogError("the item no script extand ScrollViewItem");
                return;
            }
            grid.cellWidth = viewItemClass.width + spacing;
            grid.cellHeight = viewItemClass.height + spacing;

            Vector2 size = mScrollPanel.GetViewSize();
            float width = size.x;
            float height = size.y;

            if (mScrollView.movement == UIScrollView.Movement.Horizontal)//横
            {
                grid.arrangement = UIGrid.Arrangement.Horizontal;
                pageCount = (int)(width / grid.cellWidth) + 2;
                mUIWrapContent.itemSize = (int)grid.cellWidth;

            }
            else if (mScrollView.movement == UIScrollView.Movement.Vertical)//竖
            {
                grid.arrangement = UIGrid.Arrangement.Vertical;
                pageCount = (int)(height / grid.cellHeight) + 2;
                mUIWrapContent.itemSize = (int)grid.cellHeight;
            }
        }
        isStart = true;
        if (_needRefresh)
        {
            updateScrollView(DataSource, isAdd, isTop);
            _needRefresh = false;
        }
    }

    /// <summary>
    /// 更新每个格子，用于循环动态更新内容。。重要提升性能
    /// </summary>
    /// <param name="go"></param>
    /// <param name="wrapIndex"></param>
    /// <param name="realIndex">索引</param>
    private void onInitializeItem(GameObject go, int wrapIndex, int realIndex)
    {
        int index = Mathf.Abs(realIndex);
        if (index < DataSource.Count)
            go.GetComponent<ScrollViewItem>().updateView(DataSource[index], index, _traget);
    }
    /// <summary>
    /// 列表项点击居中事件检测
    /// </summary>
    private void toggleCenterOnClick()
    {
        Transform trans = Content.transform;

        for (int i = 0; i < trans.childCount; i++)
        {
            GameObject go = trans.GetChild(i).gameObject;
            UICenterOnClick click = go.GetComponent<UICenterOnClick>();
            if (!isCenterOnClick)
            {
                if (click)
                    Destroy(click);
            }
            else
            {
                if (!click)
                    go.AddComponent<UICenterOnClick>();
            }

        }
    }
    

    #region 判断是否拖到底
    private float getScrollViewOffset(float contentMin, float contentMax, float contentSize, float viewSize, bool inverted)
    {
        float value = 0;
        float contentPadding;

        if (viewSize < contentSize)
        {
            contentMin = Mathf.Clamp01(contentMin / contentSize);
            contentMax = Mathf.Clamp01(contentMax / contentSize);

            contentPadding = contentMin + contentMax;
            value = inverted ? ((contentPadding > 0.001f) ? 1f - contentMin / contentPadding : 0f) :
                ((contentPadding > 0.001f) ? contentMin / contentPadding : 1f);
        }
        else
        {
            contentMin = Mathf.Clamp01(-contentMin / contentSize);
            contentMax = Mathf.Clamp01(-contentMax / contentSize);

            contentPadding = contentMin + contentMax;
            value = inverted ? ((contentPadding > 0.001f) ? 1f - contentMin / contentPadding : 0f) :
                ((contentPadding > 0.001f) ? contentMin / contentPadding : 1f);

        }
        return value;
    }
    private float getCurValue()
    {
        float value = 0;
        Bounds b = mScrollView.bounds;
        Vector2 bmin = b.min;
        Vector2 bmax = b.max;
        if (mScrollView.movement == UIScrollView.Movement.Horizontal && bmax.x > bmin.x)
        {
            Vector4 clip = mScrollPanel.finalClipRegion;
            int intViewSize = Mathf.RoundToInt(clip.z);
            if ((intViewSize & 1) != 0) intViewSize -= 1;
            float halfViewSize = intViewSize * 0.5f;
            halfViewSize = Mathf.Round(halfViewSize);

            if (mScrollPanel.clipping == UIDrawCall.Clipping.SoftClip)
                halfViewSize -= mScrollPanel.clipSoftness.x;

            float contentSize = bmax.x - bmin.x;
            float viewSize = halfViewSize * 2f;
            float contentMin = bmin.x;
            float contentMax = bmax.x;
            float viewMin = clip.x - halfViewSize;
            float viewMax = clip.x + halfViewSize;

            contentMin = viewMin - contentMin;
            contentMax = contentMax - viewMax;

            value = getScrollViewOffset(contentMin, contentMax, contentSize, viewSize, false);
        }

        if (mScrollView.movement == UIScrollView.Movement.Vertical && bmax.y > bmin.y)
        {
            Vector4 clip = mScrollPanel.finalClipRegion;
            int intViewSize = Mathf.RoundToInt(clip.w);
            if ((intViewSize & 1) != 0) intViewSize -= 1;
            float halfViewSize = intViewSize * 0.5f;
            halfViewSize = Mathf.Round(halfViewSize);

            if (mScrollPanel.clipping == UIDrawCall.Clipping.SoftClip)
                halfViewSize -= mScrollPanel.clipSoftness.y;

            float contentSize = bmax.y - bmin.y;
            float viewSize = halfViewSize * 2f;
            float contentMin = bmin.y;
            float contentMax = bmax.y;
            float viewMin = clip.y - halfViewSize;
            float viewMax = clip.y + halfViewSize;

            contentMin = viewMin - contentMin;
            contentMax = contentMax - viewMax;

            value = getScrollViewOffset(contentMin, contentMax, contentSize, viewSize, true);
        }
        return value;
    }
    #endregion

    private void onDragFinished()
    {
        if (!enabled)
        {
            return;
        }

        float num = getCurValue();

        //MyDebug.Log("00000000000");
        if (num >= 0.999f)
        {
            Debug.Log("1111111111111");
            if (luaBinding != null)
            {
                //print("---------------");
                luaBinding.CallTargetFunction("AddNewPage", new object[1]);
            }
        }
        else if (num <= 0.001f)
        {
            Debug.Log("2222222");
            if (luaBinding != null)
            {
                //print("---------------");
                luaBinding.CallTargetFunction("AddNewPageUp", new object[1]);
            }
        }
    }

    public void updateLocal() 
    {
        if (localList != null && localList.Count > 0) {
            for (int i = 0; i < localList.Count; i++) 
            {
                localList[i].updateSelf();
            }
        }
    }

    /// <summary>
    /// 拖动结束事件
    /// </summary>
    private void onStoppedMoving()
    {
        if (enabled)
        {
            onFinish();
        }
    }
    /// <summary>
    /// 拖动结束
    /// </summary>
    void onFinish()
    {
        float num = getCurValue();
        if (num >= 0.9f && !needUpdate)
        {
            needUpdate = true;
        }
        else
        {
            needUpdate = false;
        }
    }
    /// <summary>
    /// 列表总数
    /// </summary>
    public int ItemCount
    {
        get { return itemCount; }
        set { itemCount = value; }
    }
    /// <summary>
    ///  清空列表
    /// </summary>
    public void clearItems()
    {
        bool isClear = false;
        MyDebug.Log(itemCount);
        List<GameObject> listgo = new List<GameObject>();
        for (int i = 0; i < Content.transform.childCount; i++)
        {
            GameObject go = Content.transform.GetChild(i).gameObject;
            go.transform.localPosition = Vector3.zero;
            if (i < itemCount)
            {
                go.SetActive(false);
            }
            else
            {
                listgo.Add(go);
                isClear = true;
            }
        }
        for (int j = 0; j < listgo.Count; j++)
        {
            GameObject go2 = listgo[j];
            go2.transform.parent = null;
            Destroy(go2);
        }
        listgo.Clear();

        if (isClear && mUIWrapContent != null)
        {
            mUIWrapContent.clearList();
        }
        
        loadedCount = 0;
    }
    /// <summary>
    /// 删除一项
    /// </summary>
    /// <param name="index"></param>
    public void Remove(int index)
    {
        if (grid)
        {
            //Destroy(grid.GetChild(index));
        }
        else
        {

        }
    }
    /// <summary>
    /// 加一个ViewItem
    /// </summary>
    /// <param name="fn"></param>
    /// <param name="data"></param>
    public GameObject Add(object data, int index)
    {
        if (!viewItem) return null;
        if (loadedCount >= pageCount) return null;
        GameObject go = null;
        int childCount = Content.transform.childCount;
        if (childCount > index)
        {
            var tran = Content.transform.GetChild(index);
            go = tran.gameObject;
            go.SetActive(true);
        }
        else
        {
            go = NGUITools.AddChild(Content, viewItem);
            go.SetActive(true);
        }
        go.name = index.ToString();
        ScrollViewItem sc = go.GetComponent<ScrollViewItem>();
        if (!sc)
        {
            UICenterOnClick uc = go.GetComponent<UICenterOnClick>();
            if (isCenterOnClick)
            {
                if (uc == null)
                    go.AddComponent<UICenterOnClick>();
            }
            else if (uc)
                Destroy(uc);

            //if (!mUIWrapContent.enabled || index > pageCount - 3)
            {
                //更新格子。。。
                sc = go.AddComponent<ScrollViewItem>();
                sc.updateView(data, index, _traget);
                localList.Add(sc);
            }

        }
        else
        {
            //if (!mUIWrapContent.enabled || index > pageCount - 3)
            //更新格子。。。
            sc.updateView(data, index, _traget);
            localList.Add(sc);
        }
        loadedCount++;

        return go;
    }

    public void goToIndex(int index)
    {
        Vector2 pv = NGUIMath.GetPivotOffset(mScrollView.contentPivot);

        float val = 0;
        if (itemCount > 0)
        {
            val = (float)index / (float)itemCount;
            var mPanel = mScrollPanel;
            Bounds b = mScrollView.bounds;
            Vector2 bmin = b.min;
            Vector2 bmax = b.max;
            Vector4 clip = mPanel.finalClipRegion;
            mUIWrapContent.enabled = false;
            if (mScrollView.movement == UIScrollView.Movement.Horizontal)
            {
                int intViewSize = Mathf.RoundToInt(clip.z);
                if ((intViewSize & 1) != 0) intViewSize -= 1;
                float halfViewSize = intViewSize * 0.5f;
                halfViewSize = Mathf.Round(halfViewSize);
                if (mPanel.clipping == UIDrawCall.Clipping.SoftClip)
                    halfViewSize -= mPanel.clipSoftness.x;

                float contentSize = bmax.x - bmin.x;
                float viewSize = halfViewSize * 2f;
                float contentMin = bmin.x;
                float contentMax = bmax.x;
                float viewMin = clip.x - halfViewSize;
                float viewMax = clip.x + halfViewSize;

                contentMin = viewMin - contentMin;
                contentMax = contentMax - viewMax;
                float contentPadding;

                if (viewSize < contentSize)
                {
                    contentMin = Mathf.Clamp01(contentMin / contentSize);
                    contentMax = Mathf.Clamp01(contentMax / contentSize);

                    contentPadding = contentMin + contentMax;
                    if (contentPadding > 0.001f)
                    {
                        val = val / contentPadding;
                    }
                    else
                    {
                        val = 0;
                    }
                }
                else
                {
                    contentMin = Mathf.Clamp01(-contentMin / contentSize);
                    contentMax = Mathf.Clamp01(-contentMax / contentSize);

                    contentPadding = contentMin + contentMax;
                    if (contentPadding > 0.001f)
                    {
                        val = val / contentPadding;
                    }
                    else
                    {
                        val = 0;
                    }
                }
                val = Mathf.Min(1, val);
                mScrollView.SetDragAmount(val, 1 - pv.y, false);
                mScrollView.SetDragAmount(val, 1 - pv.y, true);

            }
            else if (mScrollView.movement == UIScrollView.Movement.Vertical)
            {
                int intViewSize = Mathf.RoundToInt(clip.w);
                if ((intViewSize & 1) != 0) intViewSize -= 1;
                float halfViewSize = intViewSize * 0.5f;
                halfViewSize = Mathf.Round(halfViewSize);
                if (mPanel.clipping == UIDrawCall.Clipping.SoftClip)
                    halfViewSize -= mPanel.clipSoftness.y;

                float contentSize = bmax.y - bmin.y;
                float viewSize = halfViewSize * 2f;
                float contentMin = bmin.y;
                float contentMax = bmax.y;
                float viewMin = clip.y - halfViewSize;
                float viewMax = clip.y + halfViewSize;

                contentMin = viewMin - contentMin;
                contentMax = contentMax - viewMax;
                float contentPadding;

                if (viewSize < contentSize)
                {
                    contentMin = Mathf.Clamp01(contentMin / contentSize);
                    contentMax = Mathf.Clamp01(contentMax / contentSize);

                    contentPadding = contentMin + contentMax;
                    if (contentPadding > 0.001f)
                    {
                        val = val / contentPadding;
                    }
                    else
                    {
                        val = 0;
                    }
                }
                else
                {
                    contentMin = Mathf.Clamp01(-contentMin / contentSize);
                    contentMax = Mathf.Clamp01(-contentMax / contentSize);

                    contentPadding = contentMin + contentMax;
                    if (contentPadding > 0.001f)
                    {
                        val = val / contentPadding;
                    }
                    else
                    {
                        val = 0;
                    }
                }
                val = Mathf.Min(1, val);
                mScrollView.SetDragAmount(pv.x, val, false);
                mScrollView.SetDragAmount(pv.x, val, true);
            }

        }

        mUIWrapContent.enabled = true;
        SortAlphabetically();
    }

    /// <summary>
    /// 按数据填充列表
    /// </summary>
    /// <param name="list"></param>
    /// <param name="add">为true时追加</param>
    public void updateScrollView(IList list, bool add, bool top = false)
    {
        if (list == null) return;
        if (add)
        {
            itemCount += list.Count;
            for (int i = 0; i < list.Count; i++)
            {
                DataSource.Add(list[i]);
            }
            top = false;
            add = false;
        }
        else
        {
            itemCount = list.Count;
            clearItems();
            DataSource = list;
            if (itemCount == 0)
            {
                
                if (mUIWrapContent)
                {
                    mLeft.transform.localPosition = Vector3.zero;
                    mRight.transform.localPosition = Vector3.zero;
                    mUIWrapContent.enabled = false;
                }

                return;
            }
        }
        if (mUIWrapContent)
        {
            mUIWrapContent.enabled = true;
        }
        isAdd = add;
        isTop = top;
        if (!isStart)
        {
            _needRefresh = true;
            return;
        }
        mLeft.transform.position = Vector3.zero;
        mRight.transform.position = Vector3.zero;
        if (itemCount > 0 && viewItem)
        {
            localList.Clear();
            for (int i = 0; i < itemCount; i++)
            {
                if (!Add(list[i], i)) break;
            }
        }
        if (mUIWrapContent.enabled || true)
        {
            mUIWrapContent.clearList();
            if (mScrollView.movement == UIScrollView.Movement.Horizontal)
            {
                mUIWrapContent.minIndex = 0;
                mUIWrapContent.maxIndex = itemCount - 1;
                //加入一个控制，定好scrollview的滚动范围
                float lx = 0;
                float rx = 0;
                if (itemCount > 0)
                {
                    //Transform t = grid.GetChild(0);
                    //lx = t.localPosition.x - grid.cellWidth / 2;
                    lx =  - grid.cellWidth / 2;
                    rx = lx + grid.cellWidth * itemCount;
                }
                mLeft.transform.localPosition = new Vector3(lx, 0, 0);
                mRight.transform.localPosition = new Vector3(rx, 0, 0);
            }
            else
            {
                mUIWrapContent.minIndex = -itemCount + 1;
                mUIWrapContent.maxIndex = 0;
                //加入一个控制，定好scrollview的滚动范围
                float ly = 0;
                float ry = 0;
                if (itemCount > 0)
                {
                    ly = grid.cellHeight / 2;
                    ry = ly - grid.cellHeight * itemCount;
                }
                mLeft.transform.localPosition = new Vector3(0, ly, 0);
                mRight.transform.localPosition = new Vector3(0, ry, 0);
            }
           
            float val = getCurValue();
            int index = (int)(val * itemCount);
           
            if (top || itemCount < pageCount)
            {
                grid.Reposition();
                mScrollView.ResetPosition();
                if (_gotoindex >= 0)
                {
                    goToIndex(_gotoindex);
                }
            }
            else
            {
                grid.Reposition();
                if (mFrist && !isTop)
                {
                    mFrist = false;
                    mScrollView.ResetPosition();
                    if (_gotoindex >= 0)
                    {
                        goToIndex(_gotoindex);
                    }
                }
                else
                {
                    if (_gotoindex >= 0)
                    {
                        goToIndex(_gotoindex);
                    }
                    else
                    {
                        SortAlphabetically();
                    }
                }
            }
        }
        else
        {
            mLeft.transform.localPosition = Vector3.zero;
            mRight.transform.localPosition = Vector3.zero;
            if (mFrist && !isTop)
            {
                mFrist = false;
                grid.repositionNow = true;
                mScrollView.ResetPosition();
            }
        }
        //修改
        if (!mFrist)
            mScrollView.Scroll(0.02f);
    }

    void  RefreshPos(UIGrid grid) 
    {
        grid.Reposition();
    }

    void  SortAlphabetically()
    {
        float x = 0;
        float y = 0;
        if (mScrollView.movement == UIScrollView.Movement.Horizontal)
        {
            x = 0.002f;
        }
        else
        {
            y = 0.002f;
        }
        mScrollPanel.clipOffset = new Vector2(mScrollPanel.clipOffset.x + x, mScrollPanel.clipOffset.y + y);
       
        mUIWrapContent.WrapContent();
    }
    /// <summary>
    /// 按数据填充列表
    /// </summary>
    /// <param name="list"></param>
    public void updateScrollView(IList list)
    {
        updateScrollView(list, false);
    }
    public void refresh(LuaTable dataes)
    {
        refresh(dataes, null);
    }
    public void refresh(LuaTable dataes, LuaTable traget)
    {
        refresh(dataes, traget, true);
    }
    public void refresh(LuaTable dataes, LuaTable traget, bool top)
    {
        refresh(dataes, traget, true, 0);
    }

    /// <summary>
    /// 刷新列表
    /// </summary>
    /// <param name="dataes">数据表</param>
    /// <param name="top">是否跳到列表顶部</param>
    public void refresh(LuaTable dataes, LuaTable traget, bool top, int gotoindex)
    {
        if (dataes == null)
        {
            _traget = null;
            return;
        }
        _gotoindex = gotoindex;
        _traget = null;
        _traget = traget;
        ArrayList list = new ArrayList();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                list.Add(o.value);
            }
        }
        dataes = null;
        updateScrollView(list, false, top);
    }

    void OnDestroy()
    {
        if (DataSource != null)
        {
            ClientTool.freeList(DataSource);
            DataSource.Clear();
        }
        viewItem = null;
    }
}
