using UnityEngine;
using System.Collections;

public class InputControll : MonoBehaviour
{
    public UIInput input;
    public UIButton bt;
    private bool isPress = false;
    private int time = 0;
    public void OnChange()
    {
        if (input.value == "")
        {
            bt.isEnabled = false;
        }
        else
        {
            bt.isEnabled = true;
        }
    }

    protected virtual void OnPress(bool isPressed)
    {
        if (isPressed)
        {
            isPress = isPressed;
            time = 0;
        }
    }
    public void Update()
    {
        //if (isPress)
        //{
        //    time += 1;
        //    if (time >= 30)
        //    {
        //        //获取输入值
        //        input.value = "anc";
        //        isPress = false;
        //        time = 0;

        //    }
        //}
    }
}
