/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       Page
* 机器名称：       SHEN
* 命名空间：       
* 文 件 名：       Page
* 创建时间：       2014/5/23 12:58:21
* 作    者：       Oliver shen
* 说    明：       PageView中的每一页的实现需要继承该类
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;
/// <summary>
/// PageView中用到的Page
/// </summary>
public class Page : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
    /// <summary>
    /// 更新本页内容
    /// </summary>
    public virtual void onUpdate(){

    }
}
