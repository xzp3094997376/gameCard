/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       PageViewCtroller
* 机器名称：       SHEN
* 命名空间：       
* 文 件 名：       PageViewCtroller
* 创建时间：       2014/5/24 9:58:21
* 作    者：       Oliver shen
* 说    明：       PageView 显示页码时的控制类
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
/// <summary>
/// PageView 显示页码时的控制类
/// </summary>
public class PageViewCtroller : MonoBehaviour
{
    public GameObject mEnable;
    public GameObject mDisble;
    public int index
    {
        get;
        set;
    }
    public void Show(bool ret)
    {
        mEnable.SetActive(ret);
        mDisble.SetActive(!ret);
    }
    /// <summary>
    /// 通知切换页
    /// </summary>
    public void onClick()
    {
        if (mDisble.activeSelf)
        {
            //Messenger.Broadcast<int>(PageView.MSG_GO_TO_PAGE, index);
        }
    }
}
