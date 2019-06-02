using UnityEngine;
using System.Collections;
using SLua;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************


/// <summary>
/// 闯关关卡选择赋值
/// </summary>
public class ChapterSelect : MonoBehaviour
{
    UIPopupList mList;
    private string _currentSelectChapter = "";
    private LuaFunction _callFun;
    private bool isSelfSetValue = false;


    void Start()
    {
        mList = GetComponent<UIPopupList>();
        EventDelegate.Add(mList.onChange, OnChange);
    }

    public void SetChapterTitle(LuaTable data, string currentSelect, LuaFunction callFun)
    {
        if (mList == null)
        {
            mList = GetComponent<UIPopupList>();
        }
        _callFun = callFun;
        mList.items.Clear();
        foreach (var value in data)
        {
            mList.items.Add(value.value.ToString());
        }
        mList.value = currentSelect;
    }

    public string currentSelectChapter
    {
        get
        {
            return _currentSelectChapter;
        }
        set
        {
            isSelfSetValue = true;
            mList.value = value;
            _currentSelectChapter = mList.value;
            if (_callFun != null)
            {
                _callFun.call(mList.value);
            }
        }
    }

    void OnChange()
    {
        currentSelectChapter = UIPopupList.current.value;
    }
}
