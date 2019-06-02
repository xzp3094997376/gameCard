using UnityEngine;
using SLua;
using System;
using System.Reflection;
using System.Collections.Generic;
[CustomLuaClass]
/// <summary>
/// ulua基础方法接口
/// </summary>
public class UluaModuleFuncs
{
    private static UluaModuleFuncs _instance = null;
    public UotherPublicFuncs uOtherFuns;
    public UluaTimer uTimer;
    public List<LuaTable> uCommandList = new List<LuaTable>();
    public bool isHaveTimer = false;
    private int maxCommandNum = 100;//一帧最多执行多少条指令，主要为了防止指令太多，一下子执行造成内存暴涨问题
    private UluaModuleFuncs()
    {
        uOtherFuns = UotherPublicFuncs.Instance;
        uTimer = UluaTimer.Instance;

    }
    public static UluaModuleFuncs Instance
    {
        get
        {
            if (_instance == null)
                _instance = new UluaModuleFuncs();
            return _instance;
        }
    }


    public void times()
    {
        if (uCommandList.Count > 0)
        {
            if (uCommandList.Count >= maxCommandNum)
            {
                int tempNum = maxCommandNum;
                for (int i = 0; i < tempNum; i++)
                {
                    executeInstruct(uCommandList[0]);
                    uCommandList[0] = null;
                    uCommandList.RemoveAt(0);
                }
            }
            else
            {
                int tempNum2 = uCommandList.Count;
                for (int j = 0; j < tempNum2; j++)
                {
                    executeInstruct(uCommandList[0]);
                    uCommandList[0] = null;
                    uCommandList.RemoveAt(0);
                }
            }
        }
        else
        {
            FrameTimerManager.getInstance().remove(times);
            isHaveTimer = false;
        }
    }

    /// <summary>
    /// 批处理命令
    /// </summary>
    /// <param name="actionList"></param>
    public void luaBatchCommands(LuaTable actionList)
    {
        if (!isHaveTimer)
        {
            isHaveTimer = true;
            FrameTimerManager.getInstance().add(1, 0, times);
        }
        foreach (var objitem in actionList)
        {
            uCommandList.Add(objitem.value as LuaTable);
        }
    }

    /// <summary>
    /// 单个命令
    /// </summary>
    /// <param name="dataVO"></param>
    public void luaCommands(LuaTable dataVO)
    {
        if (!isHaveTimer)
        {
            isHaveTimer = true;
            FrameTimerManager.getInstance().add(0, 0, times);
        }
        uCommandList.Add(dataVO);
    }


    public void executeInstruct(LuaTable dataVO)
    {
     //   MyDebug.Log(dataVO["mModuleName"]+"  "+dataVO["mComponetName"]);
        //if (UluaKey.uluaModuleRequireDics.ContainsKey(dataVO["mModuleName"].ToString()))
        //{
        //    if (UluaKey.uluaModuleRequireDics[dataVO["mModuleName"].ToString()].mGoDic.ContainsKey(dataVO["mComponetName"].ToString()))
        //    {
        //        GameObject go = UluaKey.uluaModuleRequireDics[dataVO["mModuleName"].ToString()].mGoDic[dataVO["mComponetName"].ToString()];
        //        Type type = Type.GetType(dataVO["mClassName"].ToString());
        //        if (type == null)  //此处有待优化性能
        //        {
        //            Assembly[] _Assembly = AppDomain.CurrentDomain.GetAssemblies();
        //            for (int i = 0; i != _Assembly.Length; i++)
        //            {
        //                type = _Assembly[i].GetType(dataVO["mClassName"].ToString());
        //                if (type != null) break;
        //            }
        //        }
        //        object comp;
        //        if (type.ToString() == "UnityEngine.GameObject")
        //        {
        //            comp = go;
        //        }
        //        else
        //        {
        //            comp = go.GetComponent(type.ToString()) as object;
        //        }
        //        switch (dataVO["mProType"].ToString())
        //        {
        //            case "MethodInfo": //调用方法
        //                MethodInfo func = type.GetMethod(dataVO["mProName"].ToString());
        //                object[] obj = UluaUtil.transTableToObjectList(dataVO["mArgs"] as LuaTable, func.GetParameters());
        //                func.Invoke(comp, obj);
        //                break;
        //            case "PropertyInfo"://更改某个属性,有get，set的public变量
        //                PropertyInfo pros = type.GetProperty(dataVO["mProName"].ToString());
        //                setPropertyValue(comp, pros, dataVO["mArgs"] as LuaTable);
        //                break;
        //            case "FieldInfo"://没有get，set的public变量
        //                FieldInfo field = type.GetField(dataVO["mProName"].ToString());
        //                setFieldInfoValue(comp, field, dataVO["mArgs"] as LuaTable);
        //                break;
        //            case "PropertyInfoFun": //属性的方法或者属性，可以加点号一直属性下去
        //                getMethodInfoByPro(type, dataVO["mProName"].ToString(), comp, dataVO);
        //                break;
        //            default:
        //                break;
        //        }
        //    }
        //}
    }

    /// <summary>
    /// 根据类型获取最后的方法并执行,最多2层，比如：label.gameObject.setActive()
    /// </summary>
    /// <param name="_type">当前类型</param>
    /// <param name="_str">类型方法字符串 例如：gameObject/SetActive|MethodInfo</param>
    /// <param name="obj">实例</param>
    /// <returns></returns>
    private void getMethodInfoByPro(Type _type, string _str, object obj, LuaTable dataVO)
    {
        string[] s = _str.Split(new char[] { '|' });
        object last_obj = obj;
        string[] pros = s[0].Split(new char[] { '/' });
        PropertyInfo last_Property = _type.GetProperty(pros[0]); //获取第一个的属性的类别
        last_obj = last_Property.GetValue(last_obj, null); //取出第一个属性的实例
        if (pros.Length > 1)
        {
            for (var i = 1; i < pros.Length; i++)
            {
                last_Property = last_Property.PropertyType.GetProperty(pros[i]); //根据名字得到相对应的属性
                last_obj = last_Property.GetValue(last_obj, null); //取出类里面的属性
            }
        }
        string[] last_pro = s[s.Length - 1].Split(new char[] { '|' });
        switch (last_pro[1])
        {
            case "PropertyInfo":
                PropertyInfo pross = last_Property.PropertyType.GetProperty(last_pro[0]);
                setPropertyValue(last_obj, pross, dataVO["mArgs"] as LuaTable);
                break;
            case "FieldInfo":
                FieldInfo field = last_Property.PropertyType.GetField(last_pro[0]);
                setFieldInfoValue(last_obj, field, dataVO["mArgs"] as LuaTable);
                break;
            case "MethodInfo":
                MethodInfo meth = last_Property.PropertyType.GetMethod(last_pro[0]);
                object[] objPro = UluaUtil.transTableToObjectList(dataVO["mArgs"] as LuaTable, meth.GetParameters());
                meth.Invoke(last_obj, objPro);
                break;
            default:
                break;
        }
    }

    /// <summary>
    /// 为属性赋值
    /// </summary>
    /// <param name="comp">组件</param>
    /// <param name="p">属性 字符串 整形，布尔类型等</param>
    /// <param name="objs"></param>
    private void setPropertyValue(object comp, PropertyInfo p, LuaTable objs)
    {
        switch (p.PropertyType.ToString())
        {
            case "System.String":
                p.SetValue(comp, objs[0].ToString(), null);
                break;
            case "System.Int32":
                MyDebug.Log(objs[0]);
                p.SetValue(comp, Convert.ToInt32(objs[0]), null);
                break;
            case "System.Single":
                p.SetValue(comp, float.Parse(objs[0].ToString()), null);
                break;
            case "System.Int64":
                p.SetValue(comp, Convert.ToInt64(objs[0]), null);
                break;
            case "System.Boolean":
                p.SetValue(comp, Convert.ToBoolean(objs[0]), null);
                break;
            case "System.Double":
                p.SetValue(comp, Convert.ToDouble(objs[0]), null);
                break;
            case "UnityEngine.Vector3":
                Vector3 vecObj3 = UluaUtil.transTableToVectory3(objs);
                p.SetValue(comp, vecObj3, null);
                break;
            case "SLua.LuaFunction":
                p.SetValue(comp, (LuaFunction)objs[0], null);
                break;
            default:
                p.SetValue(comp, objs[0], null);
                break;
        }
    }

    /// <summary>
    /// 为没有get，set的public 属性赋值
    /// </summary>
    /// <param name="comp"></param>
    /// <param name="p"></param>
    /// <param name="objs"></param>
    private void setFieldInfoValue(object comp, FieldInfo p, LuaTable objs)
    {
        switch (p.FieldType.ToString())
        {
            case "System.String":
                p.SetValue(comp, objs[0].ToString());
                break;
            case "System.Int32":
                p.SetValue(comp, Convert.ToInt32(objs[0]));
                break;
            case "System.Single":
                p.SetValue(comp, float.Parse(objs[0].ToString()));
                break;
            case "System.Int64":
                p.SetValue(comp, Convert.ToInt64(objs[0]));
                break;
            case "System.Boolean":
                p.SetValue(comp, Convert.ToBoolean(objs[0]));
                break;
            case "System.Double":
                p.SetValue(comp, Convert.ToDouble(objs[0]));
                break;
            case "UnityEngine.Vector3":
                Vector3 vecObj3 = UluaUtil.transTableToVectory3(objs);
                p.SetValue(comp, vecObj3);
                break;
            default:
                p.SetValue(comp, objs[0]);
                break;
        }
    }
}
