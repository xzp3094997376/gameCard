using System.Collections.Generic;
using System.IO;
using SLua;
using System;
using System.Text;
[CustomLuaClass]
public static class LuaHelper
{
    static Dictionary<string, byte[]> mCacheLuaFile = new Dictionary<string, byte[]>();

    /// <summary>
    /// 清除脚本文件缓存
    /// </summary>
    public static void Clear()
    {
        if (mCacheLuaFile != null)
            mCacheLuaFile.Clear();
    }
    
    /// <summary>
    /// 读lua脚本文件
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    public static byte[] DoFile(string filePath)
    {
        try
        {
            if (!filePath.EndsWith(".lua")) filePath += ".lua";

#if UNITY_EDITOR
            string path = FileUtils.getInstance().getFullPath(filePath);
            if (!FileUtils.getInstance().isFileExist(path)) return null;
            string str = FileUtils.getInstance().getString(path);
            return Encoding.UTF8.GetBytes(str);

#else
            if (mCacheLuaFile.ContainsKey(filePath))
            {
                return mCacheLuaFile[filePath];
            }
            string path = FileUtils.getInstance().getFullPath(filePath);
            if (!FileUtils.getInstance().isFileExist(path)) return null;

            byte[] data = FileUtils.getInstance().getBytes(path);
            data = ConfigManager.ecodeLuaFile(data);
            mCacheLuaFile.Add(filePath, data);
            return data;
#endif
        }
        catch (IOException e)
        {
            MyDebug.LogError("读取" + filePath + "失败！");
        }
        return null;
    }

    /// <summary>
    /// 获得luaTable中的方法
    /// </summary>
    /// <param name="luaTable"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    public static LuaFunction getTableFunction(LuaTable luaTable, string name)
    {
        object funcObj = luaTable[name];
        if (funcObj is LuaFunction)
            return (LuaFunction)funcObj;
        else
            return null;
    }

    public static object CallLuaFunction(LuaTable luaTable, string functionName, params object[] args)
    {
        if (luaTable == null) return null;
        object val = null;
        var fn = getTableFunction(luaTable, functionName);
        if (fn != null)
        {
            object[] newArgs = new object[args.Length + 1];
            newArgs[0] = luaTable;
            Array.Copy(args, 0, newArgs, 1, args.Length);
            try
            {
                val = fn.call(newArgs);
            }
            catch (System.Exception error)
            {
                UnityEngine.Debug.Log(error);
            }
        }
        return val;
    }
    /// <summary>
    /// 从可写目录读文件
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static string readFile(string path)
    {
        string str = "";
        if (File.Exists(path))
        {
            str = File.ReadAllText(path, Encoding.UTF8);
        }
        return str;
    }

    /// <summary>
    /// 往可写目录写文件
    /// </summary>
    /// <param name="path"></param>
    /// <param name="stream"></param>
    public static void writeFile(string path, object stream)
    {
        try
        {
            byte[] data = null;
            //获得字节数组
            if (stream.GetType() == typeof(string))
            {
                data = new UTF8Encoding().GetBytes(stream.ToString());
            }
            else if (stream.GetType() == typeof(byte[]))
            {
                data = (byte[])stream;
            }
            if (data != null)
            {
                //开始写入
                FileUtils.getInstance().writeFile(path, data);
            }

            //清空缓冲区、关闭流
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    /// <summary>
    /// 删除文件
    /// </summary>
    /// <param name="path"></param>
    public static void deleteFile(string path)
    {
        if (File.Exists(path))
        {
            File.Delete(path);
        }
    }
}
