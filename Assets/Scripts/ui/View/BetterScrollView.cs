/*
 * 描术：
 * 
 * 作者：AnYuanLzh
 * 公司：lexun
 * 时间：2014-xx-xx
 */
using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// 这个类主要做了一件事,就是优化了,NGUI UIScrollView 在数据量很多都时候,
/// 创建过多都GameObject对象,造成资源浪费.
/// </summary>
public class BetterScrollView : MonoBehaviour
{
	public enum ArrangeDirection
	{
		Left_to_Right,
		Right_to_Left,
		Up_to_Down,
		Down_to_Up,
	}
	/// <summary>
	/// items的排列方式
	/// </summary>
	public ArrangeDirection arrangeDirection = ArrangeDirection.Up_to_Down;

	/// <summary>
	/// 列表单项模板
	/// </summary>
	public GameObject itemPrefab;

	/// <summary>
	/// The items list.
	/// </summary>
	public List<BetterItemObject> itemsList;
	/// <summary>
	/// The datas list.
	/// </summary>
	public List<BetterItemData> datasList;

	/// <summary>
	/// 列表脚本
	/// </summary>
	public UIScrollView scrollView;

	public GameObject itemParent;

	/// <summary>
	/// itemsList的第一个元素
	/// </summary>
	BetterItemObject firstItem;
	/// <summary>
	/// itemsList的最后一个元素
	/// </summary>
	BetterItemObject lastItem;


	public delegate void DelegateHandler(BetterItemObject item, BetterItemData data);
	/// <summary>
	/// 响应
	/// </summary>
	public DelegateHandler OnItemInit;

	/// <summary>
	/// 第一item的起始位置
	/// </summary>
	public Vector3 itemStartPos = Vector3.zero;
	/// <summary>
	/// 菜单项间隙
	/// </summary>
	public float gapDis = 0f;

	// 对象池
	// 再次优化，频繁的创建与销毁
	Queue<BetterItemObject> itemLoop = new Queue<BetterItemObject>();

	void Awake()
	{
		if(itemPrefab==null || scrollView==null || itemParent==null)
		{
			MyDebug.LogError("Lzh_LoopScrollView.Awake() 有属性没有在inspector中赋值");
		}

		// 设置scrollview的movement
		if(arrangeDirection == ArrangeDirection.Up_to_Down || 
		   arrangeDirection == ArrangeDirection.Down_to_Up)
		{
			scrollView.movement = UIScrollView.Movement.Vertical;
		}
		else
		{
			scrollView.movement = UIScrollView.Movement.Horizontal;
		}
	}
	
	// Update is called once per frame
	void Update ()
	{
		//if(scrollView.isDragging)
        {
            Validate();
        }
	}

	/// <summary>
	/// 检验items的两端是否要补上或删除
	/// </summary>
	void Validate()
	{
		if( datasList==null || datasList.Count==0)
		{
			return;
		}

        // 如果itemsList还不存在
        if(itemsList==null || itemsList.Count==0)
        {
            itemsList = new List<BetterItemObject>();

			BetterItemObject item = GetItemFromLoop();
            InitItem(item, 0, datasList[0]);
            firstItem = lastItem = item;
            itemsList.Add(item);

			//Validate();
        }

		// 
		bool all_invisible = true;
		foreach(BetterItemObject item in itemsList)
		{
			if(item.widget.isVisible==true)
			{
				all_invisible=false;
			}
		}
		if (all_invisible == true)
				return;

		// 先判断前端是否要增减
		if(firstItem.widget.isVisible)
		{
			// 判断要不要在它的前面补充一个item
			if(firstItem.dataIndex>0)
			{
				BetterItemObject item = GetItemFromLoop();

				// 初化：数据索引、大小、位置、显示
				int index = firstItem.dataIndex-1;
				//InitItem(item, index, datasList[index]);
				AddToFront(firstItem, item, index, datasList[index]);
				firstItem = item;
				itemsList.Insert(0,item);

                //Validate();
			}
		}
		else
		{
			// 判断要不要将它移除
			// 条件：自身是不可见的；且它后一个item也是不可见的（或被被裁剪过半的）.
			// 		这有个隐含条件是itemsList.Count>=2.
			if(itemsList.Count>=2
			   && itemsList[0].widget.isVisible==false
			   && itemsList[1].widget.isVisible==false)
			{
                itemsList.Remove(firstItem);
				PutItemToLoop(firstItem);
                firstItem = itemsList[0];

                //Validate();
			}
		}

		// 再判断后端是否要增减
		if(lastItem.widget.isVisible)
		{
			// 判断要不要在它的后面补充一个item
			if(lastItem.dataIndex < datasList.Count-1)
			{
				BetterItemObject item = GetItemFromLoop();

				// 初化：数据索引、大小、位置、显示
				int index = lastItem.dataIndex+1;
				AddToBack(lastItem, item, index, datasList[index]);
				lastItem = item;
                itemsList.Add(item);

                //Validate();
			}
		}
		else
		{
			// 判断要不要将它移除
			// 条件：自身是不可见的；且它前一个item也是不可见的（或被被裁剪过半的）.
			// 		这有个隐含条件是itemsList.Count>=2.
			if(itemsList.Count>=2
				&& itemsList[itemsList.Count-1].widget.isVisible==false
			   	&& itemsList[itemsList.Count-2].widget.isVisible==false)
			{
				itemsList.Remove(lastItem);
				PutItemToLoop(lastItem);
				lastItem = itemsList[itemsList.Count-1];

                //Validate();
			}
		}



	}

	/// <summary>
	/// Init the specified datas.
	/// </summary>
	/// <param name="datas">Datas.</param>
	public void Init(List<BetterItemData> datas, DelegateHandler onItemInitCallback)
	{
		datasList = datas;
		this.OnItemInit = onItemInitCallback;

		Validate();
	}

    public void Refresh(SLua.LuaTable table, SLua.LuaTable target)
    {
        List<BetterItemData> datas = new List<BetterItemData>();
        foreach (var i in table)
        {
            datas.Add(new BetterItemData(i.value));
        }
        datasList = datas;
        OnItemInit = delegate(BetterItemObject obj, BetterItemData data)
        {
            if (obj.binding)
            {
                obj.binding.CallUpdateWithArgs(data.data,obj.dataIndex,target);
            }
        };
        if (itemsList.Count > 0)
        {
            for (int j = 0; j < itemsList.Count; j++)
            {
                var item = itemsList[j];
                if (item.binding)
                {
                    if (item.dataIndex < datasList.Count)
                    {
                        var data = datasList[item.dataIndex];
                        item.binding.CallUpdateWithArgs(data.data,item.dataIndex,target);
                    }
                    
                }
            }
        }
        Validate();
    }

	/// <summary>
	/// 构造一个 item 对象
	/// </summary>
	/// <returns>The item.</returns>
	BetterItemObject CreateItem()
	{
		GameObject go = NGUITools.AddChild(itemParent,itemPrefab);
        UIWidget widget = go.GetComponent<UIWidget>();
        UluaBinding bind = go.GetComponent<UluaBinding>();
        BetterItemObject item = new BetterItemObject();
        item.widget = widget;
        item.binding = bind;
		go.SetActive(true);
        return item;
	}

	/// <summary>
	/// 用数据列表来初始化scrollview
	/// </summary>
	/// <param name="item">Item.</param>
	/// <param name="indexData">Index data.</param>
	/// <param name="data">Data.</param>
	void InitItem(BetterItemObject item, int dataIndex, BetterItemData data)
	{
		item.dataIndex = dataIndex;
        if(OnItemInit!=null)
        {
            OnItemInit(item, data);
        }
		item.widget.transform.localPosition = itemStartPos;
	}

	/// <summary>
	/// 在itemsList前面补上一个item
	/// </summary>
	void AddToFront(BetterItemObject priorItem, BetterItemObject newItem, int newIndex, BetterItemData newData)
	{
		InitItem (newItem, newIndex, newData);
		// 计算新item的位置
		if(scrollView.movement == UIScrollView.Movement.Vertical)
		{
			float offsetY = priorItem.widget.height*0.5f + gapDis + newItem.widget.height*0.5f;
			if(arrangeDirection == ArrangeDirection.Down_to_Up) offsetY *=-1f;
			newItem.widget.transform.localPosition = priorItem.widget.cachedTransform.localPosition + new Vector3(0f, offsetY, 0f);
		}
		else
		{
			float offsetX = priorItem.widget.width*0.5f + gapDis + newItem.widget.width*0.5f;
			if(arrangeDirection == ArrangeDirection.Right_to_Left) offsetX *=-1f;
			newItem.widget.transform.localPosition = priorItem.widget.cachedTransform.localPosition - new Vector3(offsetX, 0f, 0f);
		}
	}

	/// <summary>
	/// 在itemsList后面补上一个item
	/// </summary>
	void AddToBack(BetterItemObject backItem, BetterItemObject newItem, int newIndex, BetterItemData newData)
	{
		InitItem (newItem, newIndex, newData);
		// 计算新item的位置
		if(scrollView.movement == UIScrollView.Movement.Vertical)
		{
			float offsetY = backItem.widget.height*0.5f + gapDis + newItem.widget.height*0.5f;
			if(arrangeDirection == ArrangeDirection.Down_to_Up) offsetY *=-1f;
			newItem.widget.transform.localPosition = backItem.widget.cachedTransform.localPosition - new Vector3(0f, offsetY, 0f);
		}
		else
		{
			float offsetX = backItem.widget.width*0.5f + gapDis + newItem.widget.width*0.5f;
			if(arrangeDirection == ArrangeDirection.Right_to_Left) offsetX *=-1f;
			newItem.widget.transform.localPosition = backItem.widget.cachedTransform.localPosition + new Vector3(offsetX, 0f, 0f);
		}
	}


	#region 对象池性能相关
	/// <summary>
	/// 从对象池中取行一个item
	/// </summary>
	/// <returns>The item from loop.</returns>
	BetterItemObject GetItemFromLoop()
	{
		BetterItemObject item;
		if(itemLoop.Count<=0)
		{
			item = CreateItem();
		}
		else
		{
			item = itemLoop.Dequeue();
		}
		item.widget.gameObject.SetActive(true);
		return item;
	}
	/// <summary>
	/// 将要移除的item放入对象池中
	/// --这个里我保证这个对象池中存在的对象不超过3个
	/// </summary>
	/// <param name="item">Item.</param>
	void PutItemToLoop(BetterItemObject item)
	{
		if(itemLoop.Count>=3)
		{
			Destroy(item.widget.gameObject);
			return;
		}
		item.dataIndex = -1;
		item.widget.gameObject.SetActive(false);
		itemLoop.Enqueue(item);
	}
	#endregion

}


