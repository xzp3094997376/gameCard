using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SampleDynamicDragPanel : MonoBehaviour
{
    List<object> m_Data = new List<object>();
    List<IDynamicDraggableItem> m_InstanceItems = new List<IDynamicDraggableItem>();

    public UITable table;
    public UIScrollView dragPanel;
    public GameObject templateItem;
    private NGUIDynamicDraggableItem dynamicLogic;
    private bool mStarted = false;
    private bool _needInited = false;
    private int _initCount = 0;
    SLua.LuaTable _traget = null;
    private bool _inited = false;
    private List<Transform> mTableChild = new List<Transform>();
    // Use this for initialization
    void Start()
    {
        //1 you need datas.
        //here we create some datas.
        //for (int i = 0; i < 1000; i++)
        //{
        //    m_Data.Add("hello chiuan's " + i);
        //}

        //2 you need ui items.
        //create limit instances item at table.
        //how many item? just base on your draggable panel clipRange. 
        //for (int i = 0; i < m_Data.Count; i++)
        //{
        //    if (i > 10) break;//we wont instance too many.
        //    CreateItem(m_Data[i], i);
        //}
        //after instance items,need make sure this draggable panel items position are corrected.

        //3 Create dynamic logic.

        mStarted = true;
        if (_needInited)
        {
            //StartCoroutine(InitWithLIst(m_Data, _initCount));
            InitWithLIst(m_Data, _initCount);
        }
    }

    public void InitWithLIst(List<object> list, int initCount = 8)
    {
        if (mTableChild.Count == 0)
        {
            for (int j = 0; j < table.transform.childCount; j++)
            {
                mTableChild.Add(table.transform.GetChild(j));
            }
        }
        for (int i = 0; i < initCount && i < m_Data.Count; i++)
        {
            CreateItem(m_Data[i], i);
            table.repositionNow = true;
            //if ((i + 1) % (initCount / 2) == 0)
            //{
            //    yield return new WaitForEndOfFrame();
            //}
        }
        //yield return null;
        if (dynamicLogic == null)
            dynamicLogic = NGUIDynamicDraggableItem.create(
                NGUIDynamicDraggableItem.Arrangement.Vertical,
                m_InstanceItems,
                dragPanel.panel,
                delegateCheckDraggingRunning,
                GetDataCount,
                delegateRefreshItem);
        _inited = true;
        table.repositionNow = true;
        StartCoroutine(wait());
    }

    private IEnumerator wait()
    {
        yield return null;
        table.repositionNow = true;
    }
    public void Init(SLua.LuaTable data, int initCount = 8, SLua.LuaTable traget = null)
    {
        _traget = traget;
        m_Data.Clear();
        foreach (var i in data)
        {
            m_Data.Add(i.value);
        }
        _initCount = initCount;

        if (!mStarted)
        {
            _needInited = true;
            return;
        }
        if (_inited)
        {
            dynamicLogic.RefreshAll();
            //StartCoroutine(wait());
        }
        else
        {
            //StartCoroutine(InitWithLIst(m_Data, initCount));
            InitWithLIst(m_Data, _initCount);
        }
    }
    // Update is called once per frame
    void Update()
    {
        if (dynamicLogic != null) dynamicLogic.Running();
    }
    void CreateItem(object data, int pDataIndex)
    {
        GameObject go = null;

        if (pDataIndex < mTableChild.Count)
        {
            go = mTableChild[pDataIndex].gameObject;
        }
        else
        {
            go = Instantiate(templateItem) as GameObject;
            go.transform.parent = table.transform;
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
        }
        go.SetActive(true);
        SampleDynamicDragItem item = go.GetComponent<SampleDynamicDragItem>();
        //add into instance list.
        m_InstanceItems.Add(item);
        item.Refresh(data, pDataIndex, _traget);
        go.name = pDataIndex + "";

    }

    /*THOSE 3 DELEGATE FUNC MUST NEED.*/

    //dynamic logic need stop auto when this return false.
    bool delegateCheckDraggingRunning()
    {
        return dragPanel.gameObject.activeSelf;
    }

    //get all data length.
    int GetDataCount()
    {
        return m_Data.Count - 1;
    }

    //NOTE: THIS IS IMPORTANT
    //THIS CALLBACK TELL U WHITCH UI ITEM WILL NEED REFRESH
    //SO U CAN WRITE YOUR REFRESH UI ITEM BY DATA LOGIC HERE.
    void delegateRefreshItem(IDynamicDraggableItem pItem, int dataIndex)
    {
        SampleDynamicDragItem item = (SampleDynamicDragItem)pItem;
        item.Refresh(m_Data[dataIndex], dataIndex, _traget);
    }



}
