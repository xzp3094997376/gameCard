using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class SetChildVisible : MonoBehaviour
{
    public Transform fatherTrans;
    private List<GameObject> childrenGo = new List<GameObject>();
    void Start()
    {
    }

    /// <summary>
    /// 更新
    /// </summary>
    public void updateList()
    {
        childrenGo.Clear();
        for (int i = 0; i < fatherTrans.childCount; i++)
        {
            Transform t0 = fatherTrans.GetChild(i);
            childrenGo.Add(t0.gameObject);
        }
    }

    public void showORhide(int needShowIndex)
    {
        updateList();
        int num = childrenGo.Count;
        for (int i = 0; i < num; i++)
        {
            if (i == needShowIndex - 1)
            {
                childrenGo[i].SetActive(true);
            }
            else
            {
                childrenGo[i].SetActive(false);
            }
        }
    }

    /// <summary>
    /// 显示全部
    /// </summary>
    public void showAll()
    {
        updateList();
        int num = childrenGo.Count;
        for (int i = 0; i < num; i++)
        {
            childrenGo[i].SetActive(true);
        }
    }
}
