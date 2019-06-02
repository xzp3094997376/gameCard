using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using SLua;
[CustomLuaClass]
public class Phalanx : MonoBehaviour
{
    public int maxItemCount = 16;
    public int maxRows = 4;
    public int maxColumns = 4;
    public bool isRowFirst = true;
    public bool customLocation = false;

    public GameObject template;
    private List<GameObject> _items = new List<GameObject>();
    public List<GameObject> items { get { return _items; } }
	public GameObject Get(int index)
	{
		return _items.Count > index ? _items[index] : null;
	}

	public T Get<T>(int index) where T : Component
	{
		GameObject go = Get(index);
		return go != null ? go.GetComponent<T>() : null;
	}

    public Vector2 spacing = new Vector2(100, 100);

    void Awake()
    {
        if (template != null)
        {
            template.SetActive(false);
        }
        if (items.Count == 0)
        {
            CreateComponent();            
        }
    }

    public void Reset(int maxRows, int maxColumns, int maxItemCount)
    {
        this.maxRows = maxRows;
        this.maxColumns = maxColumns;
        this.maxItemCount = maxItemCount;
        _RefreshComponent();
    }

	public void RefreshComponent()
	{
        _RefreshComponent();
	}

    private void _RefreshComponent()
    {
        int max = Mathf.Min(maxColumns * maxRows, maxItemCount);
        int i = 0;
        if (_items.Count > max)
        {
            for (i = _items.Count - 1; i >= max; i--)
            {
                GameObject.Destroy(_items[i]);
                _items.RemoveAt(i);
            }
        }
        else if (_items.Count < max)
        {
            if (isRowFirst)
            {
                int beginRow = items.Count / maxColumns;
                int beginColumn = items.Count % maxColumns;
                CreateComponent(beginRow, beginColumn);
            }
            else
            {
                int beginColumn = items.Count / maxRows;
                int beginRow = items.Count % maxRows;
                CreateComponent(beginRow, beginColumn);
            }            
        }
    }

	private void CreateComponent(int beginRow = 0, int beginColumn = 0)
	{
		if (template != null)
		{
            if (isRowFirst) _CreateRowFirst(beginRow, beginColumn);
            else _CreateColumnFirst(beginRow, beginColumn);
		}
	}

    private void _CreateColumnFirst(int beginRow, int beginColumn)
    {
        bool brFlag = false;
        for (int x = beginColumn; x < maxColumns; x++)
        {
            int y = beginRow;
            if (x > beginColumn) y = 0;
            for (; y < maxRows; y++)
            {
                GameObject go = NGUITools.AddChild(gameObject, template);
                go.name = go.name + "_" + y + "_" + x;
                go.SetActive(true);
                Transform t = go.transform;
                if (customLocation) t.localPosition = new Vector3(template.transform.localPosition.x + x * spacing.x, template.transform.localPosition.y - y * spacing.y, 0f);
                _items.Add(go);

                if (y + x * maxRows + 1 >= maxItemCount)
                {
                    brFlag = true;
                    break;
                }
            }
            if (brFlag) break;
        }
    }

    private void _CreateRowFirst(int beginRow = 0, int beginColumn = 0)
    {
        bool brFlag = false;
        for (int y = beginRow; y < maxRows; y++)
        {
            int x = beginColumn;
            if (y > beginRow) x = 0;
            for (; x < maxColumns; x++)
            {
                GameObject go = NGUITools.AddChild(gameObject, template);
                go.name = go.name + "_" + y + "_" + x;
                go.SetActive(true);
                Transform t = go.transform;
                if (customLocation) t.localPosition = new Vector3(template.transform.localPosition.x + x * spacing.x, template.transform.localPosition.y - y * spacing.y, 0f);
                _items.Add(go);

                if (y * maxColumns + x + 1 >= maxItemCount)
                {
                    brFlag = true;
                    break;
                }
            }
            if (brFlag) break;
        }
    }
}
