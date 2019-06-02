using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

//目前只有星星显示或者隐藏的功能，之后可能要提供动画效果
public class StarPrefabs : MonoBehaviour
{

    public List<UISprite> uCommandList = new List<UISprite>(); //存放当前格子的星星

    //设置星星显示的数量
    public void setStar(int starValue)
    {
        int starNum = uCommandList.Count;
        for (int i = 0; i < starNum; i++)
        {
            uCommandList[i].gameObject.SetActive(true);
            if (i < starValue)
            {
                uCommandList[i].spriteName = "xingxing_1";
            }
            else
            {
                uCommandList[i].spriteName = "xingxing_2";
            }
        }
    }

    public void setLight(int lightnum,int total)
    {
        int lightNum = uCommandList.Count;
        for (int i = 0; i < lightNum; i++)
        {
            if (uCommandList[i].atlas == null)
            {
                uCommandList[i].atlas = getAltasByName();
            }
            if (i>=total)
            {
                uCommandList[i].gameObject.SetActive(false);
            }
            else
            {
                uCommandList[i].gameObject.SetActive(true);
                if (i < lightnum)
                {
                    uCommandList[i].spriteName = "guanqiaL";
                }
                else
                {
                    uCommandList[i].spriteName = "guanqiaG";
                }
            }
        }
    }

    private UIAtlas getAltasByName()
    {
        if (GlobalVar.altasDic.ContainsKey("newchapterModule_altas"))
        {
            return GlobalVar.altasDic["newchapterModule_altas"];
        }
        else
        {
            var  go = ClientTool.Pureload("AllAtlas/ModuleAtlas/newchapterModule_altas");
            UIAtlas altas = go.GetComponent<UIAtlas>();
            if (altas != null)
            {
                GlobalVar.altasDic["newchapterModule_altas"] = altas;
                return GlobalVar.altasDic["newchapterModule_altas"];
            }
        }
        return null;
    }
}
