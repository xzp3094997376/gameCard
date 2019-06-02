using SimpleJson;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;


/// <summary>
/// json解析
/// </summary>
//[CustomLuaClass]
public class Table
{

    private Dictionary<string, int> m_uniqueKeyCols = new Dictionary<string, int>();
    private int m_nUniqueKeuCount = 0;
    private Dictionary<string, JsonObject> m_uniqueKeyIndex = new Dictionary<string, JsonObject>();
    private Dictionary<string, Dictionary<string, JsonObject>> m_uniqueIndex = new Dictionary<string, Dictionary<string, JsonObject>>();
    private JsonObject m_tableData = null;
    private JsonObject m_tableTags = null;
    public int rowCount = 0;
    public Table(JsonObject joTableData)
    {
        m_tableData = joTableData;
        m_tableName = joTableData["enName"] as string;
        //if (m_tableName == "GMconfig")
        //{
        //    MyDebug.Log(joTableData);
        //}
        //buildIndex
        JsonObject oTableTags = joTableData["tags"] as JsonObject;
        m_tableTags = oTableTags;
        JsonArray aUniqueCols = new JsonArray(); //唯一列
        JsonArray aUniqueKeyCols = new JsonArray();
        foreach (var tag in oTableTags)
        {
            string sColName = tag.Key;
            JsonObject oColTag = tag.Value as JsonObject;
            if (oColTag.ContainsKey("unique"))
            {
                aUniqueCols.Add(sColName);
                m_uniqueIndex.Add(sColName, new Dictionary<string, JsonObject>());
            }
            else if (oColTag.ContainsKey("uniqueKey"))
            {
                aUniqueKeyCols.Add(sColName);
            }
        }
        m_nUniqueKeuCount = aUniqueKeyCols.Count;
        for (int i = 0; i < m_nUniqueKeuCount; i++)
        {
            m_uniqueKeyCols.Add(aUniqueKeyCols[i] as string, i);
        }

        JsonArray aRows = joTableData["rows"] as JsonArray;
        rowCount = aRows.Count;
        for (int i = 0; i < aRows.Count; i++)
        {
            JsonObject oRow = aRows[i] as JsonObject;
            foreach (string sColName in aUniqueCols)
            {
                if (oRow.ContainsKey(sColName) && !(oRow[sColName].ToString()).Equals(""))
                {
                    m_uniqueIndex[sColName].Add(oRow[sColName].ToString(), oRow);
                }
            }
            if (oRow.ContainsKey("$key") && !(oRow["$key"] as string).Equals(""))
            {
                m_uniqueKeyIndex.Add(oRow["$key"] as string, oRow);
            }
        }
    }
    private JsonObject getOtherTableValue(string table, string colSrc, object value) {
        return TableReader.Instance.TableRowByUnique(table, colSrc, value);
    }
    private JsonObject lazyLoad(JsonObject joRow)
    {
        if (joRow == null)
            return joRow;

        //判断是否需要lazyLoad
        if (!joRow.ContainsKey("lazy_load"))
            return joRow;
        object obj;
        bool bsuccess = SimpleJson.SimpleJson.TryDeserializeObject(joRow.str("lazy_load"), out obj);
        if (!bsuccess || obj == null)
        {
            joRow.Remove("lazy_load");
            return joRow;
        }
        JsonObject jo = obj as JsonObject;
           
        //还原回去。
        joRow.Remove("lazy_load");
        foreach (var item in jo)
        {
            joRow.Add(item.Key,item.Value);
        }
        //检查关联信息？
        var tableReader = TableReader.Instance;
       
        JsonObject oTableTags = m_tableData["tags"] as JsonObject;
		JsonArray aRows = m_tableData["rows"] as JsonArray;
		foreach (var item in m_tableTags)
		{
			string sColName = "$" + item.Key;
			JsonObject oTag = item.Value as JsonObject;
            if (!oTag.ContainsKey("unlink") && oTag.ContainsKey("linkCell") && (oTag["linkCell"] as JsonObject)["type"].Equals("linkCell"))
            {
                JsonObject oLinkCell = oTag["linkCell"] as JsonObject;
                string table = oLinkCell["table"] as string;
                string colSrc = oLinkCell["colSrc"] as string;
                bool multiCell = oTag.ContainsKey("multiCell");
                string multiKey = null;
                if (multiCell)
                    multiKey = oTag["multiCell"] as String;
                bool array = oTag.ContainsKey("array");
                var oRow = joRow;
                if (multiCell && multiKey == null)
                {
                    if (!oRow.ContainsKey(sColName))
                        continue;
                    if (array)
                    {
                        JsonArray vCell = oRow[sColName] as JsonArray;
                        JsonArray vNewCell = new JsonArray();
                        oRow.Add(sColName.Replace("$", "_"), vNewCell);
                        if (vCell == null) continue;
                        for (int i = 0; i < vCell.Count; i++)
                        {
                            JsonArray vSubCell = vCell[i] as JsonArray;
                            JsonArray vNewSubCell = new JsonArray();
                            vNewCell.Add(vNewSubCell);

                            if (vSubCell == null)
                            {
                                vNewSubCell.Add(null);
                                continue;
                            }
                            for (int j = 0; j < vSubCell.Count; j++)
                            {
                                vNewSubCell.Add(getOtherTableValue(table, colSrc, vSubCell[j]));
                                //vSubCell[j] = fOtherTableRow(table, colSrc, vSubCell[j]);
                            }
                        }
                    }
                    else
                    {
                        JsonArray vCell = oRow[sColName] as JsonArray;
                        JsonArray vNewCell = new JsonArray();
                        oRow.Add(sColName.Replace("$", "_"), vNewCell);
                        for (var i = 0; i < vCell.Count; i++)
                        {
                            vNewCell.Add(getOtherTableValue(table, colSrc, vCell[i]));
                            //vCell[i] = fOtherTableRow(table, colSrc, vCell[i]);
                        }
                    }
                }
                else if (!multiCell)
                {
                    if (!oRow.ContainsKey(sColName))
                        continue;
                    if (array)
                    {
                        JsonArray vCell = oRow[sColName] as JsonArray;
                        JsonArray vNewCell = new JsonArray();
                        oRow.Add(sColName.Replace("$", "_"), vNewCell);
                        if (vCell == null) continue;
                        for (int i = 0; i < vCell.Count; i++)
                        {
                            vNewCell.Add(getOtherTableValue(table, colSrc, vCell[i]));
                            //vCell[i] = fOtherTableRow(table, colSrc, vCell[i]);
                        }
                    }
                    else
                    {
                        if (oRow.ContainsKey(sColName))
                            oRow[sColName.Replace("$", "_")] = getOtherTableValue(table, colSrc, oRow[sColName]);
                    }
                }
                else
                {
                    JsonArray vCell = oRow[multiKey] as JsonArray;
                    if (vCell == null) continue;
                    string sRealColName = "$" + sColName.Substring(multiKey.Length + 2);//多了$和_
                    //MyDebug.Log(sRealColName);
                    for (var i = vCell.Count - 1; i >= 0; i--)
                    {
                        JsonObject oCell = vCell[i] as JsonObject;
                        if (oCell == null) continue;
                        if (array)
                        {
                            JsonArray vSubCell = oCell[sRealColName] as JsonArray;
                            JsonArray vNewSubCell = new JsonArray();
                            oCell.Add(sRealColName.Replace("$", "_"), vNewSubCell);
                            if (vSubCell == null) continue;
                            for (var j = 0; j < vSubCell.Count; j++)
                            {
                                vNewSubCell.Add(getOtherTableValue(table, colSrc, vSubCell[j]));
                                //vSubCell[j] = fOtherTableRow(table, colSrc, vSubCell[j]);
                            }
                        }
                        else
                        {
                            if (oCell.ContainsKey(sRealColName))
                                oCell[sRealColName.Replace("$", "_")] = getOtherTableValue(table, colSrc, oCell[sRealColName]);
                        }
                    }
                }
            }
		}

        return joRow;
    }
    public JsonObject RowByUnique(string sColName, object sValue)
    {
        Dictionary<string, JsonObject> index = null;
        if (m_uniqueIndex.TryGetValue(sColName, out index))
        {
            JsonObject jo = null;
            if (index.TryGetValue(sValue.ToString(), out jo))
            {
                return lazyLoad(jo);
            } 
        }
        return null;
    }
    public JsonObject RowByID(object sValue)
    {
        return RowByUnique("id", sValue);
    }
    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="sDstColName"></param>
    /// <param name="sColName"></param>
    /// <param name="sValue"></param>
    /// <returns>需要注意，获取失败返回的是默认值，例如int的0</returns>
    public T ValueByUniqueT<T>(string sDstColName, string sColName, object sValue)
    {
        JsonObject jo = RowByUnique(sColName, sValue);
        if (jo == null) return default(T);
        if (jo.ContainsKey(sDstColName))
        {
            var val = jo[sDstColName];
			if (val is T)
			{
				return (T)val;
			}
			else if (typeof(T) == typeof(int) && val is Int64) 
			{
				object temp = Convert.ToInt32(val);
				return (T)temp;
			}
        }
        return default(T);
    }
    public object ValueByUnique(string sDstColName, string sColName, object sValue)
    {
        return ValueByUniqueT<object>(sDstColName, sColName, sValue);
    }
    public JsonObject RowByUniqueKey(params object[] values)
    {
        string key = null;
        if (values.Length == m_nUniqueKeuCount)
        {
            //部分object为int，部分string，采用toString统一处理
            StringBuilder sb = new StringBuilder(values[0].ToString(), 20);//
            for (int i = 1; i < values.Length; i++)
            {
                sb.Append("||");
                sb.Append(values[i].ToString());
            }
            key = sb.ToString();
        }
        else if (values.Length == m_nUniqueKeuCount * 2)//输入方式："name","狐疑","diffcult","困难"
        {
            string[] aKeys = new string[values.Length];
            for (int i = 0; i < values.Length; i += 2)
            {
                int nIndex = 0;
                if (!m_uniqueKeyCols.TryGetValue(values[i] as string, out nIndex))
                {
                    return null;//不存在的列。
                }
                aKeys[nIndex] = values[i + 1].ToString();
            }
            key = String.Join("||", aKeys);
        }
        else if (values.Length == 1 && values[0] is JsonObject)
        {
            JsonObject joArg = values[0] as JsonObject;
            string[] aKeys = new string[values.Length];
            foreach (var item in m_uniqueKeyCols)
            {
                if (!joArg.ContainsKey(item.Key))
                    return null;
                aKeys[item.Value] = joArg[item.Key].ToString();
            }
            key = String.Join("||", aKeys);
        }
        else
        {
            return null;
        }
        //MyDebug.Log("key::::::" + key);
        //foreach (string k in m_uniqueKeyIndex.Keys)
        //{
        //    MyDebug.Log("key::::::" + k);
        //}
        JsonObject jo = null;
        m_uniqueKeyIndex.TryGetValue(key, out jo);
        return lazyLoad(jo);
    }
    public void ForEach(Func<int, JsonObject, bool> fCallback)
    {
        JsonArray aRows = m_tableData["rows"] as JsonArray;
        int nCount = aRows.Count;
        for (int i = 0; i < nCount; i++)
        {
            try
            {
                if (fCallback(i, lazyLoad(aRows[i] as JsonObject)))
                {
                    break;
                }
            }
            catch (Exception e)
            {
              

            }
           
        }
    }

    public int returnTableLength()
    {
        JsonArray aRows = m_tableData["rows"] as JsonArray;
        if (aRows != null)
            return aRows.Count;
        else
            return 0;
    }
    internal void LinkCell(Func<string, string, object, JsonObject> fOtherTableRow)
    {
		JsonObject oTableTags = m_tableData["tags"] as JsonObject;
		JsonArray aRows = m_tableData["rows"] as JsonArray;
		foreach (var item in oTableTags)
		{
			string sColName = "$" + item.Key;
			JsonObject oTag = item.Value as JsonObject;
			if (!oTag.ContainsKey("unlink") && oTag.ContainsKey("linkCell") && (oTag["linkCell"] as JsonObject)["type"].Equals("linkCell"))
			{
				JsonObject oLinkCell = oTag["linkCell"] as JsonObject;
				string table = oLinkCell["table"] as string;
				string colSrc = oLinkCell["colSrc"] as string;
				bool multiCell = oTag.ContainsKey("multiCell");
				string multiKey = null;
				if (multiCell)
					multiKey = oTag["multiCell"] as String;
				bool array = oTag.ContainsKey("array");
				
				ForEach((nIndex, oRow) =>
				        {
					if (multiCell && multiKey == null) {
						if (!oRow.ContainsKey(sColName))
							return true;
						if (array) {
							JsonArray vCell = oRow[sColName] as JsonArray;
                            JsonArray vNewCell = new JsonArray();
                            oRow.Add(sColName.Replace("$", "_"), vNewCell );
							if (vCell == null) return true;
                            for (int i = 0; i < vCell.Count; i++)
                            {
								JsonArray vSubCell = vCell[i] as JsonArray;
                                JsonArray vNewSubCell = new JsonArray();
                                vNewCell.Add(vNewSubCell);

                                if (vSubCell == null)
                                {
                                    vNewSubCell.Add(null);
                                    continue;
                                }
                                for (int j = 0; j < vSubCell.Count; j++)
                                {
                                    vNewSubCell.Add(fOtherTableRow(table, colSrc, vSubCell[j]));
									//vSubCell[j] = fOtherTableRow(table, colSrc, vSubCell[j]);
								}
							}
						} else {
							JsonArray vCell = oRow[sColName] as JsonArray;
                            JsonArray vNewCell = new JsonArray();
                            oRow.Add(sColName.Replace("$", "_"), vNewCell);
                            for (var i = 0; i < vCell.Count; i++)
                            {
                                vNewCell.Add(fOtherTableRow(table, colSrc, vCell[i]));
								//vCell[i] = fOtherTableRow(table, colSrc, vCell[i]);
							}
						}
					}
					else if (!multiCell){
						if (!oRow.ContainsKey(sColName))
							return true;
						if (array) {
							JsonArray vCell = oRow[sColName] as JsonArray;
                            JsonArray vNewCell = new JsonArray();
                            oRow.Add(sColName.Replace("$", "_"), vNewCell);
							if (vCell == null) return true;
                            for (int i = 0; i < vCell.Count; i++)
                            {
                                vNewCell.Add(fOtherTableRow(table, colSrc, vCell[i]));
								//vCell[i] = fOtherTableRow(table, colSrc, vCell[i]);
							}
						} else {
							if (oRow.ContainsKey(sColName))
								oRow[sColName.Replace("$","_")] = fOtherTableRow(table, colSrc, oRow[sColName]);
						}
					}
					else {
						JsonArray vCell = oRow[multiKey] as JsonArray;
						if (vCell == null) return true;
                        string sRealColName = "$" + sColName.Substring(multiKey.Length + 2);//多了$和_
                        //MyDebug.Log(sRealColName);
						for (var i = vCell.Count - 1; i >= 0; i--) {
							JsonObject oCell = vCell[i] as JsonObject;
							if (oCell == null) continue;
							if (array) {
                                JsonArray vSubCell = oCell[sRealColName] as JsonArray;
                                JsonArray vNewSubCell = new JsonArray();
                                oCell.Add(sRealColName.Replace("$", "_"), vNewSubCell);
								if (vSubCell == null) continue;
                                for (var j = 0; j < vSubCell.Count; j++)
                                {
                                    vNewSubCell.Add(fOtherTableRow(table, colSrc, vSubCell[j]));
                                    //vSubCell[j] = fOtherTableRow(table, colSrc, vSubCell[j]);
								}
							} else {
                                if (oCell.ContainsKey(sRealColName))
                                    oCell[sRealColName.Replace("$", "_")] = fOtherTableRow(table, colSrc, oCell[sRealColName]);
							}
						}
					}
					
					return false;//遍历全部
				});
			}
		}
    }
    private string m_tableName = "";
    public string TableName
    {
        get
        {
            return m_tableName;
        }
    }
}
