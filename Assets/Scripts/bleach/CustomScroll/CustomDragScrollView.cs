
using UnityEngine;
using System.Collections;


public class CustomDragScrollView : MonoBehaviour
{

	public CustomScrollView scrollView;

    [HideInInspector]
    [SerializeField]
    CustomScrollView draggablePanel;

	Transform mTrans;
    CustomScrollView mScroll;
	bool mAutoFind = false;


	void OnEnable ()
	{
		mTrans = transform;

        if (scrollView == null && draggablePanel != null)
		{
			scrollView = draggablePanel;
			draggablePanel = null;
		}
		FindScrollView();
	}

	void FindScrollView ()
	{

        CustomScrollView sv = NGUITools.FindInParents<CustomScrollView>(mTrans);

		if (scrollView == null)
		{
			scrollView = sv;
			mAutoFind = true;
		}
		else if (scrollView == sv)
		{
			mAutoFind = true;
		}
		mScroll = scrollView;
	}


	void Start () { FindScrollView(); }


	void OnPress (bool pressed)
	{
		if (mAutoFind && mScroll != scrollView)
		{
			mScroll = scrollView;
			mAutoFind = false;
		}

		if (scrollView && enabled && NGUITools.GetActive(gameObject))
		{
			scrollView.Press(pressed);
			
			if (!pressed && mAutoFind)
			{
                scrollView = NGUITools.FindInParents<CustomScrollView>(mTrans);
				mScroll = scrollView;
			}
		}
	}


	void OnDrag (Vector2 delta)
	{
		if (scrollView && NGUITools.GetActive(this))
			scrollView.Drag();
	}

	void OnScroll (float delta)
	{
		if (scrollView && NGUITools.GetActive(this))
			scrollView.Scroll(delta);
	}
}
