using UnityEngine;
using System.Collections;

public class GoodsManager : MonoBehaviour {
	public bool isClick;

	void OnClick()
	{
		if (isClick == true) 
		{
			Destroy(gameObject.transform.parent.gameObject);
		}
	}
}
