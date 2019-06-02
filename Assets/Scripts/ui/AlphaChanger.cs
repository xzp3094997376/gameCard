using UnityEngine;
using System.Collections;

[RequireComponent(typeof(UIWidget))]
public class AlphaChanger : MonoBehaviour
{

    public float mAlpha = 1;
    private float oldAlpha;
    UIWidget mWidget;



    void Start() { 
        mWidget = GetComponent<UIWidget>();
        oldAlpha = mWidget.color.a;
        mAlpha = oldAlpha;
    }

    void LateUpdate() 
    {
        if (mAlpha != oldAlpha)
        {
            oldAlpha = mAlpha;
            mWidget.alpha = oldAlpha;
        }
    }

}