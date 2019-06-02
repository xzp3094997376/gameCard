
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
namespace DataModel
{
    public class MRoot : MStruct
    {
        public MRoot(string attr):base(null)//not allow create.
        {
            init(attr);
        }
        public static MRoot create(string attributes)
        {
            return new MRoot(attributes);
        }
       
        public override void update(JsonObject oUpdate)
        {
            base.update(oUpdate);
            HashSet<string> alreadyFire = new HashSet<string>();
            fireChanges(alreadyFire);
        }

        private Dictionary<string, Dictionary<string, MStruct>> m_listenersByKey = new Dictionary<string, Dictionary<string, MStruct>>();
        public void addListener(string key, MStruct aStruct, string attr)
        {
            if (!m_listenersByKey.ContainsKey(key))
            {
                m_listenersByKey.Add(key, new Dictionary<string, MStruct>());
            }
            var dict = m_listenersByKey[key];
            if (!dict.ContainsKey(attr))
            {
                dict.Add(attr, aStruct);
            }
        }
        public override void addListener(string key, string attr, SLua.LuaFunction luaFn)
        {
            base.addListener(key, attr, luaFn);
        }
        public void removeListener(string key)
        {
            if (!m_listenersByKey.ContainsKey(key))
            {
                return;
            }
            var dict = m_listenersByKey[key];
            foreach (var item in dict)
            {
                item.Value.removeListener(key, item.Key);
            }
            m_listenersByKey.Remove(key);
        }

        private void init(string attr)
        {
           // string attr = @"{""playerId"":""String"",""Info"":{""type"":""Struct"",""attributes"":{""sex"":""Number"",""nickname"":""String"",""level"":""Number"",""vip"":""Number""}},""Resource"":{""type"":""Struct"",""attributes"":{""exp"":""Number"",""level"":""Number"",""skill_point"":""Number"",""max_skill_point"":""Number"",""vip_exp"":""Number"",""vip"":""Number"",""money"":""Number"",""gold"":""Number"",""bp"":""Number"",""max_bp"":""Number"",""soul"":""Number"",""max_slot"":""Number"",""popularity"":""Number"",""credit"":""Number"",""honor"":""Number"",""donate"":""Number""}},""Team"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""chars"":""Array""}}},""Chapter"":{""type"":""Struct"",""attributes"":{""lastChapter"":""Number"",""lastSection"":""Number"",""status"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""star"":""Number"",""reset"":""Number"",""fight"":""Number""}}}}},""NBChapter"":{""type"":""Struct"",""attributes"":{""lastChapter"":""Number"",""lastSection"":""Number"",""status"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""star"":""Number"",""reset"":""Number"",""fight"":""Number""}}}}},""UnionChapter"":{""type"":""Struct"",""attributes"":{""lastChapter"":""Number"",""lastSection"":""Number"",""status"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""star"":""Number"",""reset"":""Number"",""fight"":""Number""}}}}},""VSBattle"":{""type"":""Struct"",""attributes"":{""now_rank"":""Number"",""best_rank"":""Number"",""has_fight"":""Number"",""max_fight"":""Number"",""rdm_hash"":""Array"",""refresh_ct"":""Number"",""next_record_pos"":""Number"",""record"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""rank_num"":""Number"",""enemyId"":""String"",""battleId"":""Number""}}}}},""Chars"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""level"":""Number"",""star"":""Number"",""stage"":""Number"",""power"":""Number"",""max_hp"":""Number"",""phy_atk"":""Number"",""mag_atk"":""Number"",""phy_def"":""Number"",""mag_def"":""Number"",""block_p"":""Number"",""block_r"":""Number"",""block_imm_p"":""Number"",""dodge_p"":""Number"",""hit_p"":""Number"",""crit_p"":""Number"",""crit_r"":""Number"",""crit_imm_p"":""Number"",""heal_p"":""Number"",""heal_bonus_p"":""Number"",""hp_factor"":""Number"",""phy_atk_factor"":""Number"",""mag_atk_factor"":""Number"",""phy_def_factor"":""Number"",""mag_def_factor"":""Number"",""xp_skill_level"":""Number"",""guanghuan_level"":""Number"",""transform"":{""attributes"":{""level"":""Number""},""type"":""StructObject"",""item"":{""type"":""Number""}},""attach"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""magic_type"":""String"",""magic_arg"":""Number"",""lock"":""Boolean""}}},""attachTemp"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""magic_type"":""String"",""magic_arg"":""Number""}}},""equip"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""level"":""Number"",""id"":""Number"",""exp"":""Number""}}},""skill"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""level"":""Number""}}}}}},""ItemBagIndex"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""count"":""Number"",""full"":{""type"":""Array"",""categorys"":[]},""avaliable"":{""type"":""Array"",""categorys"":[]},""max_stack"":{""type"":""Number"",""categorys"":[]}}}},""ItemBag"":{""type"":""StructObject"",""attributes"":{""max"":""Number"",""count"":""Number"",""empty"":{""type"":""Array"",""categorys"":[]}},""item"":{""type"":""Struct"",""attributes"":{""count"":""Number"",""id"":""Number"",""type"":""Number"",""position"":""Number"",""time"":""Number""}}},""CharPieceBagIndex"":{""type"":""StructObject"",""item"":{""type"":""Struct"",""attributes"":{""count"":""Number"",""full"":{""type"":""Array"",""categorys"":[]},""avaliable"":{""type"":""Array"",""categorys"":[]},""max_stack"":{""type"":""Number"",""categorys"":[]}}}},""CharPieceBag"":
            object obj;
            SimpleJson.SimpleJson.TryDeserializeObject(attr, out obj);
            this.initWithAttribute(obj as JsonObject);
           
        }
    }
}
