using UnityEngine;
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
using System;
using SLua;


namespace DataModel {
	public class MStruct {
      
		internal MStruct(MRoot root, JsonObject attributes = null) {
            initWithAttribute(attributes);
            if (root == null)
                m_root = this as MRoot;
            else
                m_root = root;
        }
        protected MRoot m_root = null;
		protected JsonObject m_data = new JsonObject();

		protected JsonObject m_attributes = null;
        protected Dictionary<string,string> m_shortToLong = new Dictionary<string,string>();
		internal void initWithAttribute(JsonObject attrs) {
            if (attrs != null)
            {
                m_shortToLong = new Dictionary<string, string>();//清空
                m_attributes = attrs;
                var keys = new string[m_attributes.Count];
                m_attributes.Keys.CopyTo(keys,0);
                for (var i = 0; i < keys.Length; i++) {
                    var key = keys[i];
                        var attr = m_attributes[key] as JsonObject;
                        if (attr == null)//把简写的结构变回正常结构。sp:"Number" =>  sp:{"type":"Number"}
                        {
                            attr = new JsonObject();
                            attr.Add("type", m_attributes[key] as string);
                            m_attributes[key] = attr;
                            m_shortToLong.Add(key, key);//默认是长短一样。
                        }
                        else if (attr.ContainsKey("shortKey"))
                        {
                            if (!m_shortToLong.ContainsKey(attr.get<string>("shortKey")))
                            { 
                                m_shortToLong.Add(attr.get<string>("shortKey"), key);   
                            }
                        }
                        else
                        {
                            m_shortToLong.Add(key, key);//默认是长短一样。
                        }
                    }
            }
		}
        protected bool updateByAttributeKey(string key, object obj)
        {
            if (m_attributes != null && m_attributes.ContainsKey(key))
            {
                if (obj as string == "---")
                {
                    //m_struct.Remove(key);
                    m_data.Remove(key);
                    return true;
                }

                var attr = m_attributes[key] as JsonObject;
                var type = attr["type"] as string;//取得类型
                switch (type)
                {
                    case "Struct" :
                        if (!m_data.ContainsKey(key))
                        {
                            m_data.Add(key, new MStruct(m_root,attr["attributes"] as JsonObject));
                        }
                        (m_data[key] as MStruct).update(obj as JsonObject);
                        break;
                    case "StructObject":
                        if (!m_data.ContainsKey(key))
                        {
                            object attribute = null,item = null;
                            attr.TryGetValue("attributes", out attribute);
                            attr.TryGetValue("item", out item);
                            m_data.Add(key, new MStructObject(m_root, attribute as JsonObject, item));
                        }
                        (m_data[key] as MStructObject).update(obj as JsonObject);
                        break;
                    case "Object":
                        //if (!m_data.ContainsKey(key))
                        //{
                        //    LuaTable tb = TTLuaMain.Instance.luaState.NewTable();
                        //    m_data.Add(key, tb);
                        //}
                        //m_data[key] = null;
                        //LuaTable newTb = TTLuaMain.Instance.luaState.NewTable();
                        //JsonObject jo = obj as JsonObject;
                        //foreach (var j in jo)
                        //{
                        //    newTb[j.Key] = j.Value;
                        //}
                        //m_data[key] = newTb;
                        //break;
                    case "Array":
                    case "Number":
                    case "Boolean":
                    case "String":
                    case "StringEnum":
                    case "Timestamp":
                        if (m_data.ContainsKey(key))
                        {
                            m_data[key] = obj;
                        }
                        else
                        {
                            m_data.Add(key, obj);
                        }
                        break;
                    default:
                        return false;
                }
                return true;
            }
            return false;
        }
        protected string getLongKey(string key)
        {
            string longKey = null;
            if (m_shortToLong.ContainsKey(key))
            {
                longKey = m_shortToLong[key];
            }
            else
            {
                longKey = key;
            }
            return longKey;
        }
		public virtual void update(JsonObject oUpdate) {
            if (oUpdate == null)
                return;

            m_table = null;
            foreach (var item in oUpdate) {
                var key = getLongKey(item.Key);
                if (updateByAttributeKey(key as string, item.Value))
                {//尝试识别稳定属性。即非structobject类型的信息。
                    //多余信息暂时没有需要额外处理。直接忽略这些内容。
                    markChange(key);
                }
            }
            
		}
		public virtual ICollection<string> Keys 
		{
			get 
			{
				return m_attributes.Keys;
			}
		}

        public virtual IEnumerator<KeyValuePair<string,object>> GetEnumerator()
        {
            return m_attributes.GetEnumerator();
        }

        protected LuaTable m_table = null;
        protected int m_tableCount = 0;
        public int getCount()
        {
            return m_tableCount;
        }
        public LuaTable getLuaTable()
        {
            if (m_table == null)
            {
                m_table = new LuaTable(LuaManager.luaState);
                m_tableCount = 0;
                foreach (var item in this)
                {
                    m_table[item.Key] = item.Value;
                    m_tableCount++;
                }
            }
            return m_table;
        }
		public MStruct getStruct (string str)
		{
			return this [str] as MStruct;
		}
		public MStructObject getStructObject (string str)
		{
			return this [str] as MStructObject;
		}
        //MPlayer2.Instance.Characters["XD4rf33F"].level
		public object this[string key] {
			get 
			{
                //if (m_struct.ContainsKey(key))
                //    return m_struct[key];
               // MyDebug.Log (key);
                if (m_attributes != null && m_attributes.ContainsKey(key))
                {
                   // MyDebug.Log (key);
                    var attr = m_attributes[key] as JsonObject;
                    if (attr == null)//把简写的结构变回正常结构。sp:"Number" =>  sp:{"type":"Number"}
                    {
                        attr = new JsonObject();
                        attr.Add("type", m_attributes[key] as string);
                        m_attributes[key] = attr;
                    }
                    string type = attr["type"] as string;
                    switch (type)
                    {
                        case "Struct" :
                            if (!m_data.ContainsKey(key))
                                m_data.Add(key, new MStruct(m_root, attr.ContainsKey("attributes") ? (attr["attributes"] as JsonObject) : null));
                            return m_data[key];
                        case "StructObject":
                            if (!m_data.ContainsKey(key))
                                m_data.Add(key, new MStructObject(m_root, attr.ContainsKey("attributes") ? (attr["attributes"] as JsonObject) : null, attr["item"]));
                            return m_data[key];
                        case "Object": 
                            {
                                if (m_data.ContainsKey(key))
                                    return m_data[key] as JsonObject;
                                return new JsonObject();
                            }
                        case "Array": 
                            {
                                if (m_data.ContainsKey(key))
                                    return m_data[key] as JsonArray;
                                return new JsonArray();
                            }
                        case "Number":
                            return getNumber(key);
                        case "Boolean": 
                            return getBoolean(key);
                        case "String": 
                            return getString(key);
                        case "Timestamp":
                            return getTimestamp(key);
                        case "StringEnum":
                            return getStringEnum(key);
                        default: break;
                    }
                }
                else if (m_data.ContainsKey(key))
                {
                    return m_data[key];
                }
                return getDefaultItem(key);
			}
		}
        public virtual object getDefaultItem(string key)
        {
            return null;
        }
		public string getString(string key) {
			if (m_data.ContainsKey(key)) 
				return m_data[key] as string;
			if (m_attributes!=null &&m_attributes.ContainsKey(key)) 
				return "";//default value
            MyDebug.Log (key + " is not define");
			throw new Exception();
		}
		public double getNumber(string key) {
			if (m_data.ContainsKey(key)) 
				return Convert.ToDouble(m_data[key]);
			if (m_attributes!=null &&m_attributes.ContainsKey(key)) 
				return 0f;//default value
            MyDebug.Log (key + " is not define");
			throw new Exception();
		}
        public long getLong(string key)
        {
            try
            {
                if (m_data.ContainsKey(key))
                    return Convert.ToInt64(m_data[key]);
                if (m_attributes != null && m_attributes.ContainsKey(key))
                    return 0L;//default value
            }
            catch (Exception)
            {
                throw new Exception();
            }
            return 0;
        }
        public long getTimestamp(string key)
        {//case "Timestamp":
            var time = getLong(key);
            //时间修正
            if (time>0)
                return Network.Instance.serverToClientTime(time);
            return 0L;
        }
		public int getInt(string key) {
			if (m_data.ContainsKey(key)) 
				return Convert.ToInt32(m_data[key]);
			if (m_attributes!=null &&m_attributes.ContainsKey(key)) 
				return 0;//default value
            MyDebug.Log (key + " is not define");
			throw new Exception();
		}
		public bool getBoolean(string key) {
			if (m_data.ContainsKey(key)) 
				return Convert.ToBoolean(m_data[key]);
			if (m_attributes!=null &&m_attributes.ContainsKey(key)) 
				return false;//default value
            MyDebug.Log (key + " is not define");
			throw new Exception();
        }
        public string getStringEnum(string key)
        {
            var index = getInt(key);
            var attr = m_attributes.get<JsonObject>(key);
            if (attr != null && attr.ContainsKey("enum"))
            {
                var enums = attr.get<JsonArray>("enum");
                if (enums != null && enums.Count > index)
                {
                    return enums[index] as string;
                }
            }
            MyDebug.Log(index.ToString() + " is not in enum ");
            throw new Exception();
        }
        #region
        //建立监听机制。方便后续界面开发。里面金钱变化。。例如商店刷新。
        //关键点，如何用lua插入和移除监听器。
        private Dictionary<string, Dictionary<string, LuaFunction>> m_listenersByAttr = new Dictionary<string, Dictionary<string, LuaFunction>>();


        public virtual void addListener(string key, string attr, LuaFunction luaFn)
        {
            if (!m_listenersByAttr.ContainsKey(attr))
            {
                m_listenersByAttr.Add(attr, new Dictionary<string, LuaFunction>());
            }
            var dict = m_listenersByAttr[attr];
            if (!dict.ContainsKey(key))
            {
                dict.Add(key, luaFn);
            }
            else
            {
                dict[key] = luaFn;
            }
            m_root.addListener(key, this, attr);
        } 
        internal void removeListener(string key, string attr )//禁止lua访问
        {
            if (!m_listenersByAttr.ContainsKey(attr))
            {
                return;
            }
            var dict = m_listenersByAttr[attr];
            if (!dict.ContainsKey(key))
            {
                return;
            }
            dict.Remove(key);
        }

        private HashSet<string> m_changes = new HashSet<string>();
        protected void markChange(string attr) {
            if (!m_changes.Contains(attr)) {
                m_changes.Add(attr);
            }
        }
       
        protected void fireChanges(HashSet<string> alreadyFire)
        {
            foreach (var attr in m_changes)
            {
                var a_struct = getStruct(attr);
                if (a_struct != null)
                {
                    a_struct.fireChanges(alreadyFire);
                    //continue;
                }
                
                if (!m_listenersByAttr.ContainsKey(attr))
                {
                    continue;
                }
                
                var dict = m_listenersByAttr[attr];
                string[] keys = new string[dict.Count];
                dict.Keys.CopyTo(keys, 0);
                for (var i = 0; i < keys.Length; i++)
                {
                    var key = keys[i];
                    try
                    {
                        if (dict.ContainsKey(key) && !alreadyFire.Contains(key))
                        {
                            (dict[key] as LuaFunction).call(key, attr, this[attr]);
                            alreadyFire.Add(key);
                        }
                    }
                    catch (Exception e)
                    {

                    }
                }
            }
            m_changes.Clear();
        }
        public void clear()
        {
            m_changes.Clear();
            string[] keys = new string[m_data.Count];
            m_data.Keys.CopyTo(keys, 0);
            for (var i = 0; i < keys.Length; i++)
            {
                MStruct ms = m_data[keys[i]] as MStruct;
                MStructObject mso = m_data[keys[i]] as MStructObject;
                if (ms != null && mso == null)
                {//attributes
                    ms.clear();
                }
                else
                {//其他删除
                    if (mso != null)
                    {
                        mso.clear();
                    }
                    m_data.Remove(keys[i]);
                }
            }
        }

        #endregion

    }
}
