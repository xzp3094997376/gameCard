using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

//设置panel层数，需要添加面板的地方，请挂这个脚本
public class setUIPanel : MonoBehaviour
{
    public UIPanel targetPanel;
    public int index = 2;
    public bool isAddDepth = true;
    void Start()
    {
        UIPanel tempPanel = targetPanel == null ? targetPanel = gameObject.GetComponent<UIPanel>() : targetPanel;
        if (tempPanel == null)
        {
            tempPanel = gameObject.AddComponent<UIPanel>();

        }
        tempPanel.depth = UIModule.panelDepth + index;
    }

}
