using UnityEngine;
using System.Collections;
using SLua;
using System;
using System.Collections.Generic;

//超链接点击事件
public class RichTextClick : MonoBehaviour
{
    public string[] currentParams;
    public string luaScriptPath = "uLuaModule/uLuaFramework/logic/uRichTextEvent.lua";
    public LuaTable target;
    public int paramsNum;
    private const string CREATE = "create";
    private const string ON_HYPERLINK = "onHyperlink";
    Action luaOnUpdate = null;
    void Start()
    {
        Init();
    }

    public void Init()
    {
        if (Application.isPlaying)
        {
            if (string.IsNullOrEmpty(luaScriptPath)) return;
            var o = LuaManager.getInstance().DoFile(luaScriptPath);
            if (o == null) return;
            LuaTable table = o as LuaTable;
            if (table == null)
            {
                MyDebug.LogError("lua 文件：" + luaScriptPath + " 没有返回值");
                return;
            }
            if (table != null)
            {
                var fn = LuaHelper.getTableFunction(table, CREATE);
                object self;
                if (fn != null)
                {
                    self = fn.call(table, this);
                    if (self != null)
                    {
                        target = self as LuaTable;
                        if (target != null)
                        {
                            target["binding"] = this;
                        }
                    }
                }
                else
                {
                    MyDebug.LogError("lua 文件：" + luaScriptPath + " 没有定义create方法");
                }
            }
        }
    }

    void OnClick()
    {
        paramsNum = currentParams.Length;
        if (target != null)
        {
            CallLuaFunction(target, ON_HYPERLINK, currentParams);
        }
        else
        {
            luaOnUpdate = () =>
            {
                CallLuaFunction(target, ON_HYPERLINK, currentParams);
            };
        }
    }

    public object CallLuaFunction(LuaTable luaTable, string functionName, params object[] args)
    {
        if (luaTable == null) return null;
        object[] newArgs = new object[args.Length + 1];
        newArgs[0] = luaTable;
        Array.Copy(args, 0, newArgs, 1, args.Length);
        object val = null;
        var fn = LuaHelper.getTableFunction(luaTable, functionName);
        if (fn != null)
        {
            var vals = fn.call(newArgs, null);
            if (vals != null) val = vals;
        }
        return val;
    }
}
