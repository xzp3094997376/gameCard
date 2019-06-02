using UnityEngine;
using System.Collections;

public class AdjustMsgHeight : MonoBehaviour {

	public CustomLabel trigger;

	private Transform mTrans;

	// Use this for initialization
	void Start () {
		mTrans = transform;
		Bounds bounds = NGUIMath.CalculateRelativeWidgetBounds(mTrans, false);
//		BoxCollider colider = gameObject.AddComponent<BoxCollider>();
//		colider.center = bounds.center;
//		colider.size = bounds.size;
		UIWidget widget = GetComponent<UIWidget>();
		widget.height = Mathf.RoundToInt(bounds.size.y);
		widget.parent.UpdateAnchors();

//		bounds = NGUIMath.CalculateRelativeWidgetBounds(mTrans.parent, false);
//		Debug.Log("resize height..." + bounds.size.y);
	}
}
