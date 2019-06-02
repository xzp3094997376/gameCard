using UnityEngine;
using System.Collections;

public class SampleDynamicDragItem : MonoBehaviour,IDynamicDraggableItem {
    public UluaBinding binding;
    private int m_DataIndex = 0;
    
	void Start () {
	}
	

	public void Refresh(object data,int pDataIndex,object traget = null)
	{
		//RECORD THE DATA INDEX OF THIS ITEM.
		m_DataIndex = pDataIndex;
		//REFRESH UI BASE ON DATA.
        if (binding)
        {
            binding.CallUpdateWithArgs(data, m_DataIndex, traget);
        }
	}

	public int IGetDataIndex()
	{
		return m_DataIndex;
	}
	public Transform IGetTran()
	{
		return transform;
	}
	public GameObject IGetGameObject()
	{
		return gameObject;
	}
}
