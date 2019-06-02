using UnityEngine;
using System.Collections;

public class DragHero : UIDragDropItem
{
    public UluaBinding binding;
    protected override void Start()
    {
        base.Start();
        if (binding == null)
        {
            binding = gameObject.GetComponentInParent<UluaBinding>();
        }
    }
    public override void StartDragging()
    {
        if (mTrans == null || mTrans.childCount == 0)
        {
            mDragging = false;
            return;
        }
        NGUITools.AdjustDepth(gameObject,300);
        base.StartDragging();
    }
   
    protected override void OnDragDropRelease(GameObject surface)
    {
        DragHero hero = surface.GetComponent<DragHero>();
        if (hero != null)
        {
            Transform tran = hero.transform;
            Transform t1 = null;
            Transform t2 = null;

            if (tran.childCount == 1)
            {
                t1 = tran.GetChild(0);
            }
            if (mTrans.childCount == 1)
            {
                t2 = mTrans.GetChild(0);
            }
            if (t1)
            {
                t1.parent = mTrans;
                t1.localPosition = Vector3.zero;
                if (binding && hero.binding)
                    binding.CallTargetFunction("updateItem", t1.GetComponent<UluaBinding>());
            }
            if (t2)
            {
                t2.parent = tran;
                t2.localPosition = Vector3.zero;
                if (hero.binding && binding)
                {
                    hero.binding.CallTargetFunction("updateItem", t2.GetComponent<UluaBinding>());
                }
            }
            if (binding && hero.binding)
            {
                binding.CallTargetFunction("changeItem", hero.binding.name, binding.name);
            }
            hero.reset();
            StartCoroutine(resetDepth(hero.gameObject));
            OnDragDropEnd();
            return;
        }
        base.OnDragDropRelease(surface);
    }
    IEnumerator resetDepth(GameObject go)
    {
        yield return new WaitForSeconds(0.1f);
        NGUITools.AdjustDepth(go, -300);
    }
    protected override void OnDragDropEnd()
    {
        base.OnDragDropEnd();
        TweenPosition tween = TweenPosition.Begin(gameObject, 0.1f, Vector3.zero, false);
        tween.onFinished.Clear();
        tween.AddOnFinished(() => {
            reset();
        });
    }
    public void reset()
    {
        if (mButton != null) mButton.isEnabled = true;
        else if (mCollider != null) mCollider.enabled = true;
        else if (mCollider2D != null) mCollider2D.enabled = true;
        mTouch = null;
    }
}
