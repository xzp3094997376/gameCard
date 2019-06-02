/*********************************************************************
* 类 名 称：       SysCheckState
* 命名空间：       
* 创建时间：       2014/11/3 10:35:20
* 作    者：       张晶晶
* 说    明：       获取系统设置中的各种设置开关状态
* 最后修改时间：   2014/11/3
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
public class SysCheckState{

  // public static string stateFile = "";

    public static string content  ="";
    public static string fileName="";


    public static string getSysState(){

        
        return content;
    }

    public static void setSysState(string str)
    {

    }
}
