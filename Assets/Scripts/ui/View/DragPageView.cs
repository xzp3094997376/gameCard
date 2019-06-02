using UnityEngine;
using System.Collections;

public class DragPageView : MonoBehaviour
{

    /// <summary>
    /// Reference to the scroll view that will be dragged by the script.
    /// </summary>

    public PageView scrollView;

    // Legacy functionality, kept for backwards compatibility. Use 'scrollView' instead.
    [HideInInspector]
    [SerializeField]
    PageView draggablePanel;

    Transform mTrans;
    PageView mScroll;
    bool mAutoFind = false;
    bool mStarted = false;

    /// <summary>
    /// Automatically find the scroll view if possible.
    /// </summary>

    void OnEnable()
    {
        mTrans = transform;

        // Auto-upgrade
        if (scrollView == null && draggablePanel != null)
        {
            scrollView = draggablePanel;
            draggablePanel = null;
        }

        if (mStarted && (mAutoFind || mScroll == null))
            FindScrollView();
    }

    /// <summary>
    /// Find the scroll view.
    /// </summary>

    void Start()
    {
        mStarted = true;
        FindScrollView();
    }

    /// <summary>
    /// Find the scroll view to work with.
    /// </summary>

    void FindScrollView()
    {
        // If the scroll view is on a parent, don't try to remember it (as we want it to be dynamic in case of re-parenting)
        PageView sv = NGUITools.FindInParents<PageView>(mTrans);

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

    /// <summary>
    /// Create a plane on which we will be performing the dragging.
    /// </summary>

    void OnPress(bool pressed)
    {
        // If the scroll view has been set manually, don't try to find it again
        if (mAutoFind && mScroll != scrollView)
        {
            mScroll = scrollView;
            mAutoFind = false;
        }

        if (scrollView && enabled && NGUITools.GetActive(gameObject))
        {
            scrollView.PressCollider(gameObject, pressed);

            if (!pressed && mAutoFind)
            {
                scrollView = NGUITools.FindInParents<PageView>(mTrans);
                mScroll = scrollView;
            }
        }
    }

    /// <summary>
    /// Drag the object along the plane.
    /// </summary>

    void OnDrag(Vector2 delta)
    {
        if (scrollView && NGUITools.GetActive(this))
            scrollView.DragPanel(gameObject, delta);
    }
}
