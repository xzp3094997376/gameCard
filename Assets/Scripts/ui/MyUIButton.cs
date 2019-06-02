using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class MyUIButton : UIButton
{
    private UISprite mSprite;
    private string mNormalSprite = "";
    void Start()
    {
        mSprite = GetComponent<UISprite>();
        if (mSprite)
        {
            mNormalSprite = mSprite.spriteName;
        }
    }
    public override void SetState(State state, bool immediate)
    {
        if (mSprite == null)
        {
            return;            
        }
        if (mSprite != null)
        {
            switch (state)
            {
                case State.Normal: SetSprite(mNormalSprite); break;
                case State.Hover: SetSprite(string.IsNullOrEmpty(hoverSprite) ? mNormalSprite : hoverSprite); break;
                case State.Pressed: SetSprite(pressedSprite); break;
                case State.Disabled: SetSprite(disabledSprite); break;
            }
        }
        
    }

    public override bool isEnabled
    {
        get
        {
            return base.isEnabled;
        }
        set
        {
            base.isEnabled = value;
        }
    }
    protected override void OnDragOver()
    {
        if (UICamera.currentTouch == null)
            return;
        if (isEnabled && (dragHighlight || UICamera.currentTouch.pressed == gameObject))
            base.OnDragOver();
    }

    /// <summary>
    /// Drag out state logic is a bit different for the button.
    /// </summary>

    protected override void OnDragOut()
    {
        if (UICamera.currentTouch == null)
            return;
        if (isEnabled && (dragHighlight || UICamera.currentTouch.pressed == gameObject))
            base.OnDragOut();
    }
}
