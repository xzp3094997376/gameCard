using System;
using System.Collections;
using System.IO;

//*********************************************
//**author:ChelseaLing                       **
//**copyright:乐云工作室                     **
//*********************************************

public class MsgUtil
{
    private static Hashtable msg_function = new Hashtable();
    public delegate void funcDelegate(object bc);
    public static void addEventListener(string msg_type, funcDelegate func)
    {
        if (msg_function.ContainsKey(msg_type) == true)
        {
            ((ArrayList)msg_function[msg_type]).Add(func);
        }
        else
        {
            ArrayList funcArr = new ArrayList();
            funcArr.Add(func);
            msg_function.Add(msg_type, funcArr);
        }
    }

    public static void removeEventListener(string msg_type)
    {
        msg_function.Remove(msg_type);
    }

    public static void callFunc(string msg_type, object bc)
    {
        ArrayList tempList = (ArrayList)msg_function[msg_type];
        if (tempList == null)
        {
            return;
        }
        foreach (object obj in tempList)
        {
            if (obj == null)
            {
                continue;
            }
            ((funcDelegate)obj)(bc);
        }
    }
}
