using UnityEngine;
using System.Collections;
using SLua;
using System;
using System.Collections.Generic;

[CustomLuaClass]
public class LuaManager
{
    private static LuaManager _luaMrg = null;
    private LuaSvr luaSvr;
    private bool _intied;

    private LuaManager()
    {
        var list = FileUtils.getInstance().getSearchPaths();
        if(list.Count == 0)
        {
            list.Add(Application.streamingAssetsPath);
            FileUtils.getInstance().setSearchPaths(list);
        }

        LuaHelper.Clear();
        LuaState.loaderDelegate = LuaHelper.DoFile; //自定义加载Lua的文件
        luaSvr = new LuaSvr();
    }
    public void start(string main)
    {
        luaSvr.start(main);
    }

    public void init(Action<int> tick, Action complete, bool debug)
    {
        luaSvr.init(tick, () => {
            _intied = true;
            complete.Invoke();
        }, debug);
    }
    /// <summary>
    /// Lua脚本管理单例
    /// </summary>
    /// <returns></returns>
    public static LuaManager getInstance()
    {
        if (_luaMrg == null)
        {
            _luaMrg = new LuaManager();
        }
        return _luaMrg;
    }
    public object DoString(string script)
    {
        return luaSvr.luaState.doString(script);
    }

    public object DoBuffer(byte[] bytes)
    {
        object obj;
        if (luaSvr.luaState.doBuffer(bytes, "temp buffer", out obj))
            return obj;
        return null;
    }

    public object DoFile(string path)
    {
        if (!luaSvr.inited)
        {
            luaSvr.init();
        }
        return luaSvr.luaState.doFile(path);
    }
    /// <summary>
    /// 全局一个LuaState
    /// </summary>
    public static LuaState luaState
    {
        get
        {
            return getInstance().luaSvr.luaState;
        }
    }
    public void Destroy()
    {
        _luaMrg = null;
        luaSvr.luaState.Close();
        luaSvr.luaState = null;
        luaSvr = null;
        var go = GameObject.Find("LuaSvrProxy");
        if (go)
        {
            GameObject.Destroy(go);
        }
    }

    public static void reloadAllScript()
    {
        LuaHelper.Clear();
    }

    public object CallLuaFunction(string fn, params object[] args)
    {
        if (!_intied) return null;
        LuaFunction func = luaSvr.luaState.getFunction(fn);
        if (func != null)
        {
            return func.call(args);
        }
        return null;
    }
}
