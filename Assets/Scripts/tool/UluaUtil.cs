using UnityEngine;
using System.Collections;
using SLua;
using System;
using System.Reflection;


/// <summary>
/// 一些公共的方法合集
/// </summary>
public class UluaUtil
{

    /// <summary>
    /// 将LuaTable转换成float类型数组
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static float[] transTableToFloatArr(LuaTable tab)
    {
        ArrayList obj = new ArrayList();
        foreach (var objitem in tab)
        {
            obj.Add(float.Parse(objitem.value.ToString()));
        }
        return (float[])obj.ToArray(typeof(float));
    }

    /// <summary>
    /// 将Lua转换成Int类型数组
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static int[] transTableToIntArr(LuaTable tab)
    {
        ArrayList obj = new ArrayList();
        foreach (var objitem in tab)
        {
            obj.Add(Convert.ToInt32(objitem.value.ToString()));
        }
        return (int[])obj.ToArray(typeof(int));
    }

    /// <summary>
    /// 将tab转变成整形变量，使用于只有一个参数的tab
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static int transTableToInt(LuaTable tab)
    {
        foreach (var objitem in tab)
        {
            return Convert.ToInt32(objitem.value.ToString());
        }
        return 0;
    }


    /// <summary>
    /// 将tab转变成float变量，使用于只有一个参数的tab
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static float transTableToFloat(LuaTable tab)
    {
        foreach (var objitem in tab)
        {
            return float.Parse(objitem.value.ToString());
        }
        return 0;
    }

    /// <summary>
    /// 将tab转变成double变量，使用于只有一个参数的tab,其实它传过来的数据本来就是双精度类型
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static double transTableToDouble(LuaTable tab)
    {
        foreach (var objitem in tab)
        {
            return Convert.ToInt64(objitem.value.ToString());
        }
        return 0;
    }

    /// <summary>
    /// 将参数转换成Bool类型
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static bool transTableToBool(LuaTable tab)
    {
        ArrayList obj = new ArrayList();
        foreach (var objitem in tab)
        {
            return objitem.value.ToString() == "true";
        }
        return false;
    }
    /// <summary>
    /// 将table换成Vector3类型
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static Vector3 transTableToVectory3(LuaTable tab)
    {
        float[] temp = transTableToFloatArr(tab);
        Vector3 vec = new Vector3(temp[0], temp[1], temp[2]);
        temp = null;
        return vec;
    }

    /// <summary>
    /// 将table换成Vector2类型
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static Vector2 transTableToVectory2(LuaTable tab)
    {
        float[] temp = transTableToFloatArr(tab);
        Vector2 vec = new Vector2(temp[0], temp[1]);
        temp = null;
        return vec;
    }

    /// <summary>
    /// 将table换成Color类型
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static Color transTableToColor(LuaTable tab)
    {
        float[] temp = transTableToFloatArr(tab);
        Color col = new Color(temp[0], temp[1], temp[2]);
        temp = null;
        return col;
    }

    /// <summary>
    /// 将table换成四元数类型
    /// </summary>
    /// <param name="tab"></param>
    /// <returns></returns>
    public static Quaternion transTableToQuaternion(LuaTable tab)
    {
        float[] temp = transTableToFloatArr(tab);
        Quaternion qua = new Quaternion(temp[0], temp[1], temp[2], temp[3]);
        temp = null;
        return qua;
    }

    /// <summary>
    /// 根据方法参数类型返回对应参数格式object[]
    /// </summary>
    /// <param name="uluaTab">lua参数表</param>
    /// <param name="paraTypes">方法参数属性</param>
    /// <returns></returns>
    public static object[] transTableToObjectList(LuaTable uluaTab, ParameterInfo[] paraTypes)
    {
        ArrayList obj = new ArrayList();
        int j = 0;
        foreach (var objitem in uluaTab)
        {
            switch (paraTypes[j].ParameterType.ToString())
            {
                case "System.String":
                    obj.Add(objitem.value.ToString());
                    break;
                case "System.Int32":
                    obj.Add(Convert.ToInt32(objitem.value));
                    break;
                case "System.Single": //float
                    obj.Add(Convert.ToSingle(objitem.value));
                    break;
                case "System.Boolean":
                    obj.Add((objitem.value.ToString() == "true"));
                    break;
                case "UnityEngine.Vector3":
                    obj.Add(transTableToVectory3(objitem.value as LuaTable));
                    break;
                case "UnityEngine.Vector2":
                    obj.Add(transTableToVectory2(objitem.value as LuaTable));
                    break;
                case "UnityEngine.Quaternion":
                    obj.Add(transTableToQuaternion(objitem.value as LuaTable));
                    break;
                case "UnityEngine.Color": //最后一位透明度，记得不要忘了，默认为1
                    obj.Add(transTableToColor(objitem.value as LuaTable));
                    break;
                case "SLua.LuaFunction":
                    obj.Add(objitem.value as LuaFunction);
                    break;
                default:
                    break;
            }
            j++;
        }
        paraTypes = null;
        uluaTab = null;
        return obj.ToArray();
    }
}
