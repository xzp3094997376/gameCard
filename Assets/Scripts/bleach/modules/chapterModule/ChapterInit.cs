using UnityEngine;
using System.Collections;
using SLua;
using System;
using System.Reflection;

public class ChapterInit : MonoBehaviour
{
    public DragPageComponent dragPage;
    private int maxPage = 3;
    private int currPage = 1;
    public LuaFunction callBackFun;
    public LuaFunction errorMessage;
    public LuaTable mTarget;
    private bool isCreate = false;
    private int realMaxPage = 1;


    /// <summary>
    /// 设置最大值和当前值
    /// </summary>
    /// <param name="_currPage"></param>
    /// <param name="_maxPage"></param>
    public void setInit(string _currPage, string _maxPage, bool islast)
    {
        if (!isCreate)
        {
            dragPage.initTransInfo = SetInit;
            dragPage.changeTransInfo = ChangeTransInfo;
            dragPage.errorCallback = showError;
            isCreate = true;
        }
        currPage = Convert.ToInt32(_currPage);
        maxPage = Convert.ToInt32(_maxPage);
        realMaxPage = Convert.ToInt32(_maxPage);
        if (maxPage < 3)
        {
            maxPage = 3;
        }
        if (!islast)
        {
            realMaxPage = realMaxPage - 1;
        }
        dragPage.SetInit(currPage, maxPage, realMaxPage);
    }


    /// <summary>
    /// 设置移动后的回调函数
    /// </summary>
    /// <param name="_fun"></param>
    /// <param name="_target"></param>
    public void setCallFun(LuaFunction _fun, LuaTable _target)
    {
        if (_fun != null)
        {
            mTarget = _target;
            callBackFun = _fun;
        }
    }

    /// <summary>
    /// 设置错误显示的回调函数
    /// </summary>
    /// <param name="_fun"></param>
    /// <param name="_target"></param>
    public void setCallBackMessage(LuaFunction _fun, LuaTable _target)
    {
        if (_fun != null)
        {
            mTarget = _target;
            errorMessage = _fun;
        }
    }


    void SetInit(GameObject[] goes, int page)
    {
        for (int i = 0; i < goes.Length; i++)
        {
            int tempPage = 1;
            switch (i)
            {
                case 0:
                    tempPage = page - 1;
                    if (tempPage < 1)
                    {
                        tempPage = maxPage;
                    }
                    break;
                case 1:
                    tempPage = page;
                    break;
                case 2:
                    tempPage = page + 1;
                    if (tempPage > maxPage)
                    {
                        tempPage = 1;
                    }
                    break;
            }
            ChangeTransInfo(goes[i], tempPage, false);
        }
    }

    /// <summary>
    /// 回调方法
    /// </summary>
    /// <param name="go"></param>
    /// <param name="page"></param>
    void ChangeTransInfo(GameObject go, int page, bool bol)
    {
        callBackFun.call(mTarget, go, page, bol);
    }


    void showError(bool rightOrleft)
    {
        if (errorMessage != null)
        {
            errorMessage.call(mTarget, rightOrleft);
        }
    }
    void OnDestroy()
    {
        errorMessage = null;
        callBackFun = null;
        mTarget = null;
        dragPage.onDispose();
        dragPage = null;
        isCreate = false;
    }
}
