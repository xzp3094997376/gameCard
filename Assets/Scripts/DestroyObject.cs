using UnityEngine;
using System.Collections;

public class DestroyObject : MonoBehaviour
{
    public bool isClick;
    public bool isPopWindow;
    private System.Action callBack = null;
    void OnClick()
    {
        if (isClick == true)
        {
            Destroy(gameObject.transform.parent.gameObject);
            if (callBack != null)
            {
                callBack();
                callBack = null;
            }
        }
        if (isPopWindow)
        {
            UIMrg.Ins.popWindow();
            if (callBack != null)
            {
                callBack();
                callBack = null;
            }
        }
    }
    public void setCallBack(System.Action cb)
    {
        callBack = cb;
    }
}
