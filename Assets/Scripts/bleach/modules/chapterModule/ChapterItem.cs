using SLua;
using UnityEngine;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class ChapterItem : MonoBehaviour
{
    private LuaFunction callBackFun; //供lua回调的方法
    public int IndexMinID = 1; //当前格子最小索引（小节的ID）
    public int IndexMaxID = 2; //当前格子最大索引（小节的ID）
    public int currentChapterIndex = 1; //当前格子处于的章
    public int currentItemIndex = 1;//当前处于第几个格子（1-5）
    public void setCallFun(LuaFunction fun)
    {
        if (fun != null)
        {
            callBackFun = fun;
        }
    }

    public void callOnClick()
    {
        if (callBackFun != null)
        {
            callBackFun.call();
           // callBackFun.Call(index); 可以添加参数
        }
    }
}
