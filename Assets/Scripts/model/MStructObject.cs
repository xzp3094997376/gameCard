using UnityEngine;
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
namespace DataModel 
{
	public class MStructObject : MStruct {
        internal MStructObject(MRoot root, JsonObject attributes = null, object item = null)
            : base(root,attributes)
        {
            initWithItem(item);
        }
        protected JsonObject m_item = null;

        private string m_item_type = "";
       
        internal void initWithItem(object item) {
            if (item != null) {
                if (item as JsonObject != null)
                {
                    m_item = item as JsonObject;
                }
                else
                {
                    m_item = new JsonObject();
                    m_item.Add("type", item as string);
                }
                m_item_type = m_item["type"] as string;
            }
        }


        protected Dictionary<string, object> m_items = new Dictionary<string, object>();

        public bool existsKey(string key)
        {
            return m_items.ContainsKey(key);
        }
		public override ICollection<string> Keys 
		{
			get 
			{
                return m_items.Keys;
			}
		}
        public ICollection<string> AttributeKeys
        {
            get
            {
                return m_attributes.Keys;
            }
        }

        public override IEnumerator<KeyValuePair<string, object>> GetEnumerator()
        {
            return m_items.GetEnumerator();
        }
        public override object getDefaultItem(string key)
        {
            object ret = null;
            switch (m_item_type)
            {
                case "Struct":
                    ret = new MStruct(m_root, m_item.ContainsKey("attributes") ? (m_item["attributes"] as JsonObject) : null);
                    break;
                case "StructObject":
                    ret = new MStructObject(m_root, m_item.ContainsKey("attributes") ? (m_item["attributes"] as JsonObject) : null, m_item["item"]);
                    break;
                case "Object":
                    ret = new JsonObject();
                    break;
                case "Array":
                    ret = new JsonArray();
                    break;
                case "Number":
                    ret = 0f;
                    break;
                case "Boolean":
                    ret = false;
                    break;
                case "String":
                    ret = "";
                    break;
                case "Timestamp":
                    ret = 0;
                    break;
                case "StringEnum":
                    ret = "";
                    break;
                default: break;
            }
            return ret;
        }

        protected bool updateByItemKey(string key, object obj)
        {
            if (obj as string == "---")
            {
                m_items.Remove(key);
                m_data.Remove(key);
                return true;
            }

            switch (m_item_type)
            {
                case "Struct":
                    if (!m_items.ContainsKey(key))
                    {
                        m_items.Add(key, new MStruct(m_root, m_item["attributes"] as JsonObject));
                        m_data.Add(key, m_items[key]);
                    }
                    (m_items[key] as MStruct).update(obj as JsonObject);
                    break;
                case "StructObject":
                    if (!m_items.ContainsKey(key))
                    {
                        object attribute = null, item = null;
                        m_item.TryGetValue("attributes", out attribute);
                        m_item.TryGetValue("item", out item);
                        m_items.Add(key, new MStructObject(m_root, attribute as JsonObject, item));
                        m_data.Add(key, m_items[key]);
                    }
                    (m_items[key] as MStructObject).update(obj as JsonObject);
                    break;
                case "Object":
                    //if (!m_data.ContainsKey(key))
                    //    {
                    //        LuaInterface.LuaTable tb = TTLuaMain.Instance.luaState.NewTable();
                    //        m_data.Add(key, tb);
                    //        m_items.Add(key, tb);

                    //    }
                    //    m_data[key] = null;
                    //    m_items[key] = null;
                    //    LuaInterface.LuaTable newTb = TTLuaMain.Instance.luaState.NewTable();
                    //    JsonObject jo = obj as JsonObject;
                    //    foreach (var j in jo)
                    //    {
                    //        newTb[j.Key] = j.Value;
                    //    }
                    //    m_data[key] = newTb;
                    //    m_items[key] = newTb;

                    //    break;
                case "Array":
                case "Number":
                case "Boolean":
                case "String":
                case "Timestamp":
                case "StringEnum":
                    if (m_items.ContainsKey(key))
                    {
                        m_items[key] = obj;
                        m_data[key] = obj;
                    }
                    else
                    {
                        m_items.Add(key, obj);
                        m_data.Add(key, obj);
                    }
                    break;
                default:
                    return false;
            }
            return true;
        }
      
		public override void update(JsonObject oUpdate)
		{
            if (oUpdate == null)
                return;

            m_table = null;

            foreach (var item in oUpdate)
            {
                var key = getLongKey(item.Key);
                if (updateByAttributeKey(key as string, item.Value))
                {
                    markChange(key);
                    continue;
                }
                updateByItemKey(key, item.Value);
                markChange(key);
            }
		}
	}
}