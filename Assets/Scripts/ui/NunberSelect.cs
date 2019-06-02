using UnityEngine;
using System.Collections;
using SLua;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

/// <summary>
/// 数量选择类
/// </summary>
public class NunberSelect : MonoBehaviour
{
    public UIButton addBtn;
    public UIButton subBtn;
    public UIButton add_ten;
    public UIButton sub_ten;

    public UILabel txtNumLab;
    public LuaFunction callBackFun;
    public LuaTable mTarget;
    private int currentSelectNum = 1;
    private int maxNum = 1; //传过来的最大值
    private string funType = "";
    private bool isPress = false;

    void Awake()
    {
        UIEventListener.Get(addBtn.gameObject).onPress = onPressAdd;
        UIEventListener.Get(subBtn.gameObject).onPress = onPressSub;
        if (add_ten != null)
        {
            UIEventListener.Get(add_ten.gameObject).onPress = onPressAdd;
        }
        if (sub_ten != null)
        {
            UIEventListener.Get(sub_ten.gameObject).onPress = onPressSub;
        }
    }

    private float _longClickDuration = 1.1f;
    float _lastPress = -1f;

    private void onPressSub(GameObject go, bool state)
    {
        if (state)
        {
            isPress = true;
            if (go.name == "btn_sub1")
                funType = "Sub";
            else
                funType = "Sub_10";
            _lastPress = Time.realtimeSinceStartup;
        }
        else
        {
            isPress = false;
            _lastPress = -1;
            funType = "";
        }
    }

    private void onPressAdd(GameObject go, bool state)
    {
        if (state)
        {
            isPress = true;
            _lastPress = Time.realtimeSinceStartup;
            if (go.name == "btn_add1")
                funType = "Add";
            else
                funType = "Add_10";
        }
        else
        {
            isPress = false;
            _lastPress = -1;
            funType = "";
        }
    }


    void Update()
    {
        if (isPress)
        {
            if (Time.realtimeSinceStartup - _lastPress > _longClickDuration)
            {
                if (funType == "Add")
                {
                    onAddOne();
                }
                else if (funType== "Add_10")
                {
                    onAddTen();
                }
                else if (funType == "Sub")
                {
                    onSubOne();
                }
                else if (funType == "Sub_10")
                {
                    onSubTen();
                }
            }
        }
    }

    public int selectNum
    {
        get
        {
            return currentSelectNum;
        }
        set
        {
            currentSelectNum = value;
            txtNumLab.text = currentSelectNum + "";
            if (callBackFun != null)
            {
                callBackFun.call(mTarget);
            }
        }
    }

    public void maxNumValue(int max)
    {
        maxNum = max;
    }


    public void setCallFun(LuaFunction _fun, LuaTable _target)
    {
        if (_fun != null)
        {
            mTarget = _target;
            callBackFun = _fun;
        }
    }


    /// <summary>
    /// 增加到目前的最大值
    /// </summary>
    /// <param name="go"></param>
    public void onAddMax()
    {
        if (selectNum != maxNum)
            selectNum = maxNum;
    }

    public void onAddOne()
    {
        if (selectNum < maxNum)
        {
            selectNum = currentSelectNum + 1;
        }
    }

    public void onAddTen()
    {
        if (selectNum < maxNum)
        {
            selectNum = currentSelectNum + 10;
            if (selectNum > maxNum)
            {
                selectNum = maxNum;
            }
        }
    }

    public void onSubMax()
    {
        if (selectNum != 1)
            selectNum = 1;
    }

    public void onSubOne()
    {
        if (selectNum > 1)
        {
            selectNum = currentSelectNum - 1;
        }
    }

    public void onSubTen()
    {
        if (selectNum > 1)
        {
            selectNum = currentSelectNum - 10;
            if (selectNum < 1)
            {
                selectNum = 1;
            }
        }
    }

    void OnDestroy()
    {
        maxNum = 1;
        mTarget = null;
        callBackFun = null;
    }
}
