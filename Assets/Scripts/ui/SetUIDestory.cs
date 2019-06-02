using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

//关闭界面，适用于弹出框之类的
public class SetUIDestory : MonoBehaviour
{
    public string currentModuleName = ""; //该弹出预设所属的模块
    public GameObject thisGo = null; //该预设

    public void onNormalClose()
    {
        GameObject.Destroy(gameObject);
    }

    public void onDestroyClick()
    {
        //if (UluaKey.uluaModuleRequireDics.ContainsKey(currentModuleName + "/" + thisGo.name))
        //{
        //    UluaKey.uluaModuleRequireDics.Remove(currentModuleName + "/" + thisGo.name);
        //}
        //if (UluaKey.uluaModuleRequireDics[currentModuleName].mGoDic.ContainsKey(thisGo.name)) //存在这个
        //{
        //    GameObject.Destroy(UluaKey.uluaModuleRequireDics[currentModuleName].mGoDic[thisGo.name]);
        //}
    }
}
