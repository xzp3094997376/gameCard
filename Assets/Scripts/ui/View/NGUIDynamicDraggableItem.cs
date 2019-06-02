using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <description>
///	AUTO CHANGE YOUR SCROLL VIEW ITEMS AT TABLE
/// YOU NEED:
///	1\BUILD UI - DraggablePanel with table under.
/// 2\BUILD UI - Your item template at table.
/// 3\WRITE - your ui controller(must implement 3 delegate func)
/// 4\WRITE - your datas struct.
/// 5\WRITE - your ui item REFRESH FUNC by data(delegate in controller must be implemented.)
/// 6\CREATE - DynamicDraggableItem.create(...)
///	
///	Chiuan Wei
/// Email:weizhuquan@gmail.com
/// </description>

public class NGUIDynamicDraggableItem {

	public enum Arrangement
	{
		Horizontal,
		Vertical,
	}

	public enum TableType
	{
		UITable,
		UIGrid,
	}

	//private NGUIDynamicDraggableItem(){}

	private Arrangement arrangement = Arrangement.Vertical;
	private TableType tableType = TableType.UITable;
	private UIPanel uipanel = null;
	private List<IDynamicDraggableItem> allItems = null;
	private int safeDataIndex = 1;
	private	int currentMarkIndex = -1;
	private float padding = 0;
	private Vector3 m_SafeLine = Vector3.zero;
	public delegate bool BoolDelegate();
	public delegate int IntDelegate();
    public delegate void RefreshDataDelegate(IDynamicDraggableItem item, int dataIndex);

	//3 delegate callback of your controller.
	public BoolDelegate delegateIsRunning;
	public IntDelegate delegateGetAllDataCount;
	public RefreshDataDelegate delegateRefreshItem;
    
	public static NGUIDynamicDraggableItem create(
		Arrangement pArrangement,
		List<IDynamicDraggableItem> pInstanceItems,
		UIPanel panel,
		BoolDelegate callbackRunningCheck,
		IntDelegate callbackGetDataCount,
		RefreshDataDelegate callBackRefreshItem)
	{
		NGUIDynamicDraggableItem res = new NGUIDynamicDraggableItem();
		res.arrangement = pArrangement;
		res.allItems = pInstanceItems;
		res.delegateIsRunning = callbackRunningCheck;
		res.delegateGetAllDataCount = callbackGetDataCount;
		res.delegateRefreshItem = callBackRefreshItem;

		//get padding at table or ?
		if(pInstanceItems.Count > 0)
		{
			//1 GetItem table or gird padding of each item.
			UITable temp = pInstanceItems[0].IGetTran().parent.GetComponent<UITable>();
			if(temp != null) 
			{
				if(pArrangement == Arrangement.Vertical)
					res.padding = temp.padding.y;
				else res.padding = temp.padding.x;
			}
			else
			{
				UIGrid temp2 = pInstanceItems[0].IGetTran().parent.GetComponent<UIGrid>();
				if(temp2 != null) 
				{
					res.tableType = TableType.UIGrid;
					if(pArrangement == Arrangement.Vertical)
						res.padding = temp2.cellHeight;
					else res.padding = temp2.cellWidth;
				}
			}

			//2 Create the Begin position Mark point.
			//maybe the panel is moving.
			if(panel == null)
			{
                MyDebug.LogError("cant find uipanel of Dynamic item.");
				return res;
			}
			res.uipanel = panel;
			/*
			panel's clipRange.(xy = position,zw = size)
			------------------- TOP
			|				  |
			|				  |
			|				  |
			|				  |
			-------------------
			LEFT

			TOP's worldposition = TransformPoint(panelT.localposition.x + clipRange.x,panelT.localposition.y + clipRange.y + clipRange.w * 0.5f,panelT.localposition.z)
			Left's worldposition = TransformPoint(panelT.localposition.x + clipRange.x - clipRange.z * 0.5f,panelT.localposition.y + clipRange.y,panelT.localposition.z)
			*/
            //#if UNITY_EDITOR
			//instance a Mark Position at Top
            GameObject go = NGUITools.AddChild(panel.parent.gameObject);
			go.transform.position = res.m_SafeLine = res.CountMarkPosition();
            //#endif

		}
		else{
            //MyDebug.LogError("cant running NGUIDynamicDraggableItem,because no pInstanceItems.");
			return res;
		}
		return res;
	}

	private Vector3 CountMarkPosition()
	{
		return arrangement == Arrangement.Vertical ? uipanel.transform.parent.TransformPoint(
					new Vector3(uipanel.transform.localPosition.x + uipanel.baseClipRegion.x,
                        uipanel.transform.localPosition.y + uipanel.baseClipRegion.y + uipanel.baseClipRegion.w * 0.5f,
						uipanel.transform.localPosition.z)):
			uipanel.transform.parent.TransformPoint(
                    new Vector3(uipanel.transform.localPosition.x + uipanel.baseClipRegion.x - uipanel.baseClipRegion.z * 0.5f,
                        uipanel.transform.localPosition.y + uipanel.baseClipRegion.y,
						uipanel.transform.localPosition.z));
	}

	private float CountItemOffset(IDynamicDraggableItem preOne,IDynamicDraggableItem curOne)
	{
		//when root of items is grid
		//the width & height all the same.
		if(tableType == TableType.UIGrid)
		{
			return padding;
		}

		float res = 0;
		Bounds b0 = NGUIMath.CalculateRelativeWidgetBounds(preOne.IGetTran());
		Vector3 scale0 = preOne.IGetTran().localScale;
		//MyDebug.Log(b0.ToString() + "\nscale0 = " + scale0);
		b0.min = Vector3.Scale(b0.min, scale0);
		b0.max = Vector3.Scale(b0.max, scale0);

		Bounds b1 = NGUIMath.CalculateRelativeWidgetBounds(curOne.IGetTran());
		Vector3 scale1 = curOne.IGetTran().localScale;
		//MyDebug.Log(b1.ToString() + "\nscale1 = " + scale1);
		b1.min = Vector3.Scale(b1.min, scale1);
		b1.max = Vector3.Scale(b1.max, scale1);

		//maybe need to check Table setting.
		//here is only Down or up 1 column
		res = arrangement == Arrangement.Vertical ? (b0.max.y - b0.min.y + b1.max.y - b1.min.y) *0.5f + padding * 2:
													(b0.max.x - b0.min.x + b1.max.x - b1.min.x) *0.5f + padding * 2;
		//MyDebug.Log("res = " + res);
		return res;
	}

	private bool CheckIfNewNearestMarkItem(IDynamicDraggableItem pCurrentNearest,IDynamicDraggableItem pNewOne)
	{
		if(arrangement == Arrangement.Vertical)
		{
			return Mathf.Abs(pCurrentNearest.IGetTran().position.y - m_SafeLine.y) 
						> Mathf.Abs(pNewOne.IGetTran().position.y - m_SafeLine.y) ? true : false;
		}
		else
		{
			return Mathf.Abs(pCurrentNearest.IGetTran().position.x - m_SafeLine.x) 
						> Mathf.Abs(pNewOne.IGetTran().position.x - m_SafeLine.x)?true:false;
		}
	}

	public void Running()
	{
        if (allItems.Count == 0) return;
		if(delegateIsRunning != null && delegateIsRunning())
		{
			//find nearest bottom one
			IDynamicDraggableItem bottomOfViewNearest = null;
			int index = 0;
			for(int i =0; i< allItems.Count; i++)
			{
				if(bottomOfViewNearest == null){
					bottomOfViewNearest = allItems[i];
				}
				else
				{
					if(CheckIfNewNearestMarkItem(bottomOfViewNearest,allItems[i]))
					{
						bottomOfViewNearest = allItems[i];
						index = i;
					}
				}
			}

            //MyDebug.Log("nearest bottom item data index = " + bottomOfViewNearest.IGetDataIndex() + "\ncurrentMarkIndex = " + currentMarkIndex);
			RefreshItemsAtIndex(bottomOfViewNearest,index);
		}
	}

	public void RefreshItemsAtIndex(IDynamicDraggableItem currentItem,int index){
		//check how manay item at top.
		int topMoreItemCount = index - safeDataIndex;
		if(topMoreItemCount >= 1)
		{
			//wanna let more top items to bottom
			for(int i = 0; i < topMoreItemCount; i++){
				float y = allItems[allItems.Count -1].IGetTran().localPosition.y;
				int lastDataIndex = allItems[allItems.Count -1].IGetDataIndex();
				if(lastDataIndex < delegateGetAllDataCount())
				{
					//more top to bottom.
					lastDataIndex++;
					//make top one into bottom.
					IDynamicDraggableItem topItem = allItems[0];
					allItems.RemoveAt(0);
					//refresh in new info.

					if(delegateRefreshItem != null) delegateRefreshItem(topItem, lastDataIndex);
					else MyDebug.LogError("error,need link refresh item delegate.");

					float prePos = arrangement == Arrangement.Vertical?allItems[allItems.Count -1].IGetTran().localPosition.y:
																	   allItems[allItems.Count -1].IGetTran().localPosition.x;

					topItem.IGetTran().localPosition = new Vector3(
								arrangement == Arrangement.Vertical ? topItem.IGetTran().localPosition.x:
																	  prePos + CountItemOffset(allItems[allItems.Count -1],topItem),
								arrangement == Arrangement.Vertical ? prePos - CountItemOffset(allItems[allItems.Count -1],topItem):
																	  topItem.IGetTran().localPosition.y,
								topItem.IGetTran().localPosition.z);
					//add into bottom
					allItems.Add(topItem);
					//Debug.Break();
				}
			}
		}
		else if(topMoreItemCount <= -1){
			
			for(int i =0 ; i < Mathf.Abs(topMoreItemCount); i++){
				float y = allItems[0].IGetTran().localPosition.y;
				int topDataIndex = allItems[0].IGetDataIndex();
				if(topDataIndex > 0)
				{
					topDataIndex--;
					IDynamicDraggableItem bottomItem = allItems[allItems.Count -1];
					allItems.RemoveAt(allItems.Count -1);

                    if (delegateRefreshItem != null) delegateRefreshItem(bottomItem, topDataIndex);
					else MyDebug.LogError("error,need link refresh item delegate.");

					float prePos = arrangement == Arrangement.Vertical ? allItems[0].IGetTran().localPosition.y:
																  		 allItems[0].IGetTran().localPosition.x;

					//when offset not caculate before.
					bottomItem.IGetTran().localPosition = new Vector3(
								arrangement == Arrangement.Vertical ? bottomItem.IGetTran().localPosition.x:
																	  prePos - CountItemOffset(allItems[0],bottomItem),
								arrangement == Arrangement.Vertical ? prePos + CountItemOffset(allItems[0],bottomItem):
																	  bottomItem.IGetTran().localPosition.y,
								bottomItem.IGetTran().localPosition.z);
					allItems.Insert(0,bottomItem);
				}
			}
		}
	}


	public void RefreshAll(){
		for(int i=0;i<allItems.Count;i++){
			int curIndex = allItems[i].IGetDataIndex();
			int curAllDataCount = delegateGetAllDataCount();
			if(curIndex <= curAllDataCount){
				if(delegateRefreshItem != null) delegateRefreshItem(allItems[i], curIndex);
			}
			else
			{
				//let this item moveto top
				IDynamicDraggableItem bottomItem = allItems[i];
				allItems.RemoveAt(i);
				int topDataIndex = allItems[0].IGetDataIndex();
				if(topDataIndex > 0)
				{

					topDataIndex--;

					if (delegateRefreshItem != null) delegateRefreshItem(bottomItem, topDataIndex);
						else MyDebug.LogError("error,need link refresh item delegate.");

					float prePos = arrangement == Arrangement.Vertical ? allItems[0].IGetTran().localPosition.y:
																  		 allItems[0].IGetTran().localPosition.x;

					//when offset not caculate before.
					bottomItem.IGetTran().localPosition = new Vector3(
								arrangement == Arrangement.Vertical ? bottomItem.IGetTran().localPosition.x:
																	  prePos - CountItemOffset(allItems[0],bottomItem),
								arrangement == Arrangement.Vertical ? prePos + CountItemOffset(allItems[0],bottomItem):
																	  bottomItem.IGetTran().localPosition.y,
								bottomItem.IGetTran().localPosition.z);
					allItems.Insert(0,bottomItem);
				}
			}
		}
	}
}

public interface IDynamicDraggableItem
{
	int IGetDataIndex();
	Transform IGetTran();
	GameObject IGetGameObject();
}
