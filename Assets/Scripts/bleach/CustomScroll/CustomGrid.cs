using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;

public class CustomGrid : UIWidgetContainer
{
    public GameObject Item;
    public CustomScrollView mDrag;
    public int m_cellHeight = 60;
    public int m_cellWidth = 700;
    private float m_height;
    private int m_maxLine;
    private customItemCell[] m_cellList;

    private float lastY = -1;
    private ArrayList m_listData;  //数据源
    private Vector3 defaultVec;
    private LuaTable _traget;
    private bool isInitOver = false;

    void Awake()
    {
        defaultVec = new Vector3(0, m_cellHeight, 0);
        m_height = mDrag.panel.height;
        m_maxLine = Mathf.CeilToInt(m_height / m_cellHeight);
        //m_maxLine =10;
        m_cellList = new customItemCell[m_maxLine];
    }

    public void refresh(LuaTable dataes, LuaTable traget = null)
    {
        if (dataes == null)
        {
            _traget = null;
            return;
        }
        _traget = null;
        _traget = traget;
        if (m_listData != null)
        {
            int maxCount = m_listData.Count - 1;
            for (int i = 0; i < maxCount; i++)
            {
                m_listData[i] = null;
            }
            m_listData.Clear();
            m_listData = null;
        }
        m_listData = new ArrayList();
        if (dataes != null)
        {
            foreach (var o in dataes)
            {
                m_listData.Add(o.value);
            }
        }
        dataes = null;
        Validate();
        UpdateBounds(m_listData.Count);
        if (m_cellList[0]==null)
        {
            CreateItem();
        }
    }

    void Update()
    {
        if (mDrag.transform.localPosition.y != lastY)
        {
            Validate();
            lastY = mDrag.transform.localPosition.y;
        }
    }

    private void UpdateBounds(int count)
    {
        Vector3 vMin = new Vector3();
        vMin.x = -transform.localPosition.x;
        vMin.y = transform.localPosition.y - count * m_cellHeight;
        vMin.z = transform.localPosition.z;
        Bounds b = new Bounds(vMin, Vector3.one);
        b.Encapsulate(transform.localPosition);

        mDrag.bounds = b;
        mDrag.UpdateScrollbars(true);
        mDrag.RestrictWithinBounds(true);
    }


    private void Validate()
    {
        if (!isInitOver)
            return;
        Vector3 position = mDrag.panel.transform.localPosition;
        float _ver = Mathf.Max(position.y, 0);
        int startIndex = Mathf.FloorToInt(_ver / m_cellHeight);
        int endIndex = Mathf.Min(m_listData.Count, startIndex + m_maxLine);
        customItemCell cell;
        int index = 0;
        for (int i = startIndex; i < startIndex + m_maxLine; i++)
        {
            cell = m_cellList[index];

            if (i < endIndex)
            {
                cell.updateView(m_listData[i], _traget);
                cell.transform.localPosition = new Vector3(0, i * -m_cellHeight, 0);
                cell.gameObject.SetActive(true);
            }
            else
            {
                cell.transform.localPosition = defaultVec;
            }
            index++;
        }
    }

    /// <summary>
    /// 创建预设
    /// </summary>
    private void CreateItem()
    {
        for (int i = 0; i < m_maxLine; i++)
        {
            GameObject go;
            go = Instantiate(Item) as GameObject;
            go.transform.parent = transform;
            go.transform.localScale = Vector3.one;
            go.SetActive(false);
            customItemCell item = go.GetComponent<customItemCell>();
            m_cellList[i] = item;
        }
        isInitOver = true;
        Validate();
        UpdateBounds(m_listData.Count);
    }
}