using SimpleJson;
using System;
using System.Collections.Generic;

//[CustomLuaClass]
public class TableReader
{
    private static TableReader _instance = null;
    private Dictionary<string, string> mTableJson = new Dictionary<string, string>();
    public static TableReader Instance//单例对象。
    {
        get
        {
            if (_instance == null)
            {
                _instance = new TableReader();
            }
            return _instance;
        }
    }
    public static void Destroy()
    {
        if (_instance != null)
        {
            if (_instance.m_Tables != null)
            {
                List<string> keys = new List<string>(_instance.m_Tables.Keys);
                for (int i = 0; i < keys.Count; i++)
                {
                    _instance.m_Tables[keys[i]] = null;
                }
                _instance.m_Tables.Clear();
            }
            _instance.mTableJson.Clear();
        }
       
    }
   
    timeCounter tc;
    /**
     * 加载json表格，多个表格如何一次导入
     * 每个字符串就是一个json内容，不需要文件名等其他信息。json内容自包含完整信息
     * 
     **/
    public void Load(string[] aJsons, string[] filenames)
    {
        ConfigManager.getInstance().onLoadComplete();
    }
    private Dictionary<string, Table> m_Tables = new Dictionary<string, Table>();
    private Table m_anyEmptyTable;
    private TableReader()
    {
        JsonObject jo = new JsonObject();
        jo.Add("enName", "EmtpyTable");
        jo.Add("rows", new JsonArray());
        jo.Add("tags", new JsonObject());
        m_anyEmptyTable = new Table(jo);
    }
    private Table tryLoadTable(string sTableName)
    {
        if (!mTableJson.ContainsKey(sTableName))
        {
            byte[] tempByte = FileUtils.getInstance().getBytes(UrlManager.GetConfigPath(sTableName + ".data"));
            if (tempByte == null || tempByte.Length == 0) return null;
            string json = ConfigManager.moduleOpen(tempByte);
            mTableJson.Add(sTableName,json);
            //MyDebug.LogWarning("load table ------> " + sTableName);
        };
        object obj;
        string m_json = mTableJson[sTableName];
        if (m_json[0] != '{')
        {
            m_json = m_json.Substring(1);
        }
        //float time = Time.realtimeSinceStartup;
        if (SimpleJson.SimpleJson.TryDeserializeObject(m_json, out obj))
        {
            mTableJson[sTableName] = null;
            mTableJson.Remove(sTableName);
            if (obj.GetType().ToString().Equals("SimpleJson.JsonObject"))
            {
                Table tb = new Table(obj as JsonObject);
                return tb;
            }
            else
            {
                MyDebug.Log("json内容出错，请检查：");
            }
        }
        else
        {
            MyDebug.Log("json解析失败，请检查：");
        }
        return null;
    }
    public Table GetTable(string sTableName)
    {
        Table table;//防止出错。默认返回一个空数据Table。
        if (m_Tables.TryGetValue(sTableName, out table))
        {
            return table;
        }
        table = tryLoadTable(sTableName);
        if (table != null)
        {
            m_Tables.Add(sTableName,table);
            return table;
        }
        return m_anyEmptyTable;
    }

    public void LoadTable(string sTableName)
    {
        if (sTableName == null && sTableName == "")
            return;
        if (m_Tables.ContainsKey(sTableName))
        {
            return;
        }
        Table table = tryLoadTable(sTableName);
        if (table != null)
        {
            m_Tables.Add(sTableName, table);
            GC.Collect();
            return;
        }
        return;
    }

    public JsonObject TableRowByUnique(string sTableName, string sColName, object sValue)
    {
        Table table = GetTable(sTableName);
        var tempObj = table.RowByUnique(sColName, sValue);
        //NGUIDebug.Clear();

        if (tempObj==null)
        {
        //    MyDebug.Log("配置表出错，表名：" + sTableName + "索引条件：" + sColName + "索引值：" + sValue);
        }
        return tempObj;
    }
    public JsonObject TableRowByID(string sTableName, object sValue)
    {
        Table table = GetTable(sTableName);
        var tempObj = table.RowByID(sValue);
        //NGUIDebug.Clear();

        if (tempObj == null)
        {
         //   MyDebug.Log("配置表出错，表名：" + sTableName + "索引值：" + sValue);
        }
        return tempObj;
    }
    public JsonObject TableRowByUniqueKey(string sTableName, params object[] values)
    {
        Table table = GetTable(sTableName);
        return table.RowByUniqueKey(values);
    }
    public T TableValueByUniqueT<T>(string sTableName, string sDstColName, string sColName, object sValue)
    {
        Table table = GetTable(sTableName);
        return table.ValueByUniqueT<T>(sDstColName, sColName, sValue);
    }
    public object TableValueByUnique(string sTableName, string sDstColName, string sColName, object sValue)
    {
        return TableValueByUniqueT<object>(sTableName, sDstColName, sColName, sValue);
    }

    public void ForEachTable(string sTableName, Func<int, JsonObject, bool> fCallback)
    {
        Table table = GetTable(sTableName);
        table.ForEach(fCallback);
    }

    public int getTableLengthByTableName(string  sTableName)
    {
        Table table = GetTable(sTableName);
        return table.returnTableLength();
    }
    public void ForEachLuaTable(string sTableName, Func<int, JsonObject, bool> fCallback)
    {
        ForEachTable(sTableName, fCallback);
    }

    public int getTableRowCount(string sTableName)
    {
        Table table = GetTable(sTableName);
        return table.rowCount;
    }
}
