using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************


/// <summary>
/// 非create类，是绑定在预设的button类
/// </summary>
public class CustomButton : MonoBehaviour
{

    public UISprite mBg;
    public UILabel mLabel;
    public BoxCollider boxCollider;
    private int mDepth = 1;//默认为1
    private UIEventListener mListener;
    public UIEventListener.VoidDelegate onClick;
    private bool mEnable = true;
    private string mLabtext = "";//按钮文本内容
    public bool isClickSound = true; //是否点击按钮有声音
    private bool isChange;
    private int w = 1;
    private int h = 1;

    void Start()
    {
        mListener = UIEventListener.Get(gameObject);
        mListener.onClick += onClick;
        Depth = mDepth;
    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~set代码区~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /// <summary>
    /// 按钮文本内容
    /// </summary>
    public string btnText
    {
        get
        {
            if (mLabel != null) return "";
            return mLabel.text;
        }
        set
        {
            if (mLabel != null) return;
            mLabtext = value;
            isChange = true;
        }
    }

    /// <summary>
    /// 设置按钮皮肤
    /// </summary>
    /// <param name="spriteName"></param>
    public void setBtnBG(string spriteName)
    {
        if (mBg)
            mBg.spriteName = spriteName;
    }

    /// <summary>
    /// 设置按钮是否可用
    /// </summary>
    public bool enable
    {
        get { return mEnable; }
        set
        {
            if (mEnable == value)
                return;
            mEnable = value;
            changeProperty();
        }
    }

    /// <summary>
    /// 设置按钮深度
    /// </summary>
    /// <param name="d"></param>


    public int Depth
    {
        get { return mDepth; }
        set
        {
            mDepth = value;
            if (mBg)
                mBg.depth = mDepth;
            if (mLabel != null)
                mLabel.depth = mDepth + 1;
        }
    }

    /// <summary>
    /// 播放按钮点击音效
    /// </summary>
    public void showClickSound()
    {

    }

    /// <summary>
    /// 设置按钮位置
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    /// <param name="z"></param>
    public void setLocation(int x, int y, int z = 0)
    {
        gameObject.transform.localPosition = new Vector3(x, y, z);
    }

    public void setSize(int w, int h)
    {
        this.w = w;
        this.h = h;
        changeProperty();
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~其他函数代码~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public int width
    {
        get
        {
            return w;
        }

    }
    public int height
    {
        get
        {
            return h;
        }
    }

    private void changeProperty()
    {
        isChange = false;
        if (mLabel != null)
        {
            mLabel.text = mLabtext;
            mLabel.transform.localPosition = new Vector3(0, -2, -0.1f);//注意!
        }
        if (mBg)
        {
            mBg.transform.localScale = new Vector3(1f, 1f, 1f);
            mBg.MakePixelPerfect();
            mBg.SetDimensions(w, h);
        }
        boxCollider.enabled = mEnable;
        boxCollider.center = new Vector3(0f, 0f, 0);
        boxCollider.size = new Vector3(w, h, 1);
    }
}
