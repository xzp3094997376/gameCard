/*************************************************************************************
 * 类 名 称：       Tips
 * 命名空间：       Assets.Scripts.ui
 * 创建时间：       2014/9/2 17:19:42
 * 作    者：       Oliver shen
 * 说    明：       Tips提示控件
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;

public class Tips : MonoBehaviour
{
    public enum FixPosition
    {
        Both,
        X,
        Y
    }
    static protected Tips mInstance;
    public float appearSpeed = 10f;
    public UIWidget.Pivot pivot = UIWidget.Pivot.TopLeft;
    private FixPosition fixPos = FixPosition.Both;
    public UILabel text;
    public UISprite background;
    protected Transform mTrans;
    protected float mTarget = 0f;
    protected float mCurrent = 0f;
    UIWidget mWidget;

    static public bool isVisible { get { return (mInstance != null && mInstance.mTarget == 1f); } }

    void Awake() { mInstance = this; }
    void OnDestroy() { mInstance = null; }

    void Start()
    {
        mTrans = transform;
        //mWidgets = GetComponentsInChildren<UIWidget>();
        mWidget = GetComponent<UIWidget>();
        mWidget.alpha = 0;
    }
    void Update()
    {
        if (mCurrent != mTarget)
        {
            mCurrent = Mathf.Lerp(mCurrent, mTarget, RealTime.deltaTime * appearSpeed);
            if (Mathf.Abs(mCurrent - mTarget) < 0.001f) mCurrent = mTarget;
            //SetAlpha(mCurrent * mCurrent);
            mWidget.alpha = mCurrent * mCurrent;
        }
    }


    protected virtual void SetAlpha(float val)
    {
        //for (int i = 0, imax = mWidgets.Length; i < imax; ++i)
        //{
        //    UIWidget w = mWidgets[i];
        //    Color c = w.color;
        //    c.a = val;
        //    w.color = c;
        //}
    }


    /// <summary>
    /// 显示Tip文本
    /// </summary>
    /// <param name="tooltipText">文本内容</param>
    /// <param name="tran">触发Tip的按钮，用于定位</param>
    /// <param name="px">位置修正</param>
    static public void ShowText(string tooltipText, Transform tran, float px = 0)
    {
        if (mInstance != null)
        {
            mInstance.SetText(tooltipText, tran, px);
        }
    }

    /// <summary>
    /// 设置tip的显示也位置
    /// </summary>
    /// <param name="tooltipText"></param>
    /// <param name="tran"></param>
    /// <param name="px"></param>
    private void SetText(string tooltipText, Transform tran, float px = 0, Tips.FixPosition mDir = Tips.FixPosition.X)
    {
        if (string.IsNullOrEmpty(tooltipText)) mTarget = 0;
        else
        {
            mTarget = 1;
            text.text = tooltipText;
            Bounds b = NGUIMath.CalculateRelativeWidgetBounds(tran);
            mTrans.position = tran.position;
            Vector3 pos = mTrans.localPosition;
            fixPos = mDir;
            if (fixPos == FixPosition.X)
            {
                pos.x -= (mWidget.width + b.size.x) / 2 + px;
            }
            else if (fixPos == FixPosition.Y)
            {
                pos.y += (background.height + b.size.y / 2) + px;
            }
            mTrans.localPosition = pos;
        }
        
    }

    public static void ShowText(string tooltipText, Transform tran, float px = 0, Tips.FixPosition mDir = Tips.FixPosition.X)
    {
        if (mInstance != null)
        {
            mInstance.SetText(tooltipText, tran, px,mDir);
        }
    }
}
