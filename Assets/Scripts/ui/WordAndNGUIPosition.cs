using UnityEngine;
using System.Collections;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class WordAndNGUIPosition : MonoBehaviour
{

    private Vector3 Point = new Vector3(0, 0, 0);
    public Transform trans;
    public Vector3 beginGetPosition
    {
        get
        {
            Point = new Vector3(0, 0, 0);
            getPoint(trans);
            return Point;
        }
    }

    private void getPoint(Transform trans)
    {
        if (trans.parent.name != "center")
        {
            Point = Point + trans.localPosition;
            getPoint(trans.parent);
        }
    }
}
