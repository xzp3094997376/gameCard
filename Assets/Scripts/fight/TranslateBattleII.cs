using UnityEngine;
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
using SLua;
using DataModel;
using Spine;
/***
 *Author: Jiadong Zeng
 *Content: this file using for translate server json object to control fight.
 * 
 *
 ***/
public enum DataType{
    skill = 0,
    endskill = 1,
    attach = 2,
    detach = 3,
    state = 4,
    target = 5,
    val = 6,
    round = 7,
    enter = 8,
    enterT = 9,
    exitT = 10,
    exit = 11,
    end = 12,
    unknow = 99,
};

public enum MagicType
{
    Hp = 43,
    Anger = 23,
};
public class TranslateBattleII : MonoBehaviour {

	// Use this for initialization
    public JsonArray m_FightData = null;
    public int m_FightIndex = 0;

    public List<JsonObject> m_CacheSomeVal = new List<JsonObject>();
    public List<JsonObject> m_CacheSomeSuck = new List<JsonObject>();
    public static TranslateBattleII Inst = null;
    public bool m_IsStop = false;
    TeamManager m_Attcker = null;
    TeamManager m_Defender = null;

    public string m_BeforTalk = "";
    public string m_EndTalk = "";

    LuaTable m_storyTable;
    bool m_isCheckTalk = false;

    public class NodeAseet
    {
        public string before;
        public string after;
    };

    public NodeAseet[] m_Talks = new NodeAseet[3];
    void Awake () {
        Inst = this;
	}

    public void StartFight(JsonArray battleObj, TeamManager atk, TeamManager def)
    {
        m_FightData = battleObj;
        m_FightIndex = 0;
        m_Attcker = atk;
        m_Defender = def;
        m_IsStop = false;
        m_isCheckTalk = false;
        if (!FightManager.Inst.m_IsNewBie)
            CreateAllTalk();
    }

    public HeroCtrl GetTarget(int pos) 
    {
        if (pos < 6)
        {
            return m_Attcker.m_Heros[pos];
        }
        else if (pos >= 6 && pos < 12)
        {
            pos -= 6;
            return m_Defender.m_Heros[pos];
        }
        else if (pos == 12)
        {
            return m_Attcker.m_Heros[6];
        }
        else if (pos == 13)
        {
            return m_Defender.m_Heros[6];
        }
        return null;
    }

    HeroCtrl GetTarget(JsonObject json)
    {
        int pos = json.num("w");
        return GetTarget(pos);
    }
    public void NextStep()
    {
        if (m_IsStop)
        {
            return;
        }
        if (m_FightIndex >= m_FightData.Count )
        {
            CheckFightEnd();
            return;
        }

        JsonObject json = m_FightData[m_FightIndex] as JsonObject;
        DataType type = (DataType)json.num("z");
        if (type == DataType.round && !m_isCheckTalk)
        {
            m_isCheckTalk = true;
            if (json.num("n") == 1)
            {
                CheckFightBegin();
            }
            else
            {
                FightManager.Inst.Next();
            }
            return;
        }

        m_FightIndex ++;
        
        if (type == DataType.enter)
        {
            HeroCtrl selHero2 = GetTarget(json);
            if (selHero2 == null)
            {
                FightManager.Inst.Next();
                return;
            }
            selHero2.ResetLife(json.num("hp"), json.num("anger"));
            if (selHero2.m_TeamID == 6)
            {
                int dictid = json.num("dictid");
                int shenlian = json.num("shenlian");
                selHero2.gameObject.SetActive(false);
                selHero2.SetPetInfo(dictid, shenlian);
            }
            FightManager.Inst.Next();
            return;
        }
        else if (type ==  DataType.round)
        {
            m_isCheckTalk = false;
            if (SimpleUI.Ins != null)
                SimpleUI.Ins.SetRound(json.num("n"));
            if (json.num("n") == 1 )
            {
                SimpleUI.Ins.ShowBattleRun();
                SimpleUI.Ins.SetRound(json.num("n"));
                FightManager.Inst.StartFighting();
                // SimpleUI.Ins.SetBattleCount(TeamMoveMgr.inst.m_MoveIndex + 1, FightLoader.Inst.m_Count);
                // CheckFightBegin();
            }
            else
            {
                FightManager.Inst.Next();
            }
        }
        else if (type == DataType.state)
        {
            HeroCtrl selHero = GetTarget(json);
            if (json.num("i") == 31)
            {
                //吸收
                selHero.PlayWords("T");
            }
            if (json.num("o") == 48)
            {
                if (json.ContainsKey("hp"))
                    json["hp"] = json.num("n");
                else
                    json.Add("hp", json.num("n"));
                selHero.SetJsonValue(json);
                selHero.DropLife();
                Invoke("NextStep", 0.1f);
                return;
            }
            FightManager.Inst.Next();
        }
        else if (type == DataType.target)
        {
            HeroCtrl selHero = GetTarget(json);
            selHero.SetJsonValue(json);
            if (json.num("hp") > 0)
                selHero.addLife();
            else {
                selHero.DropLife();
            }
            Invoke("NextStep", 0.1f);
            return;
        }
        else if (type == DataType.val)
        {
            TranslateVal(json);
            Invoke("NextStep", 0.1f);
            return;
        }
        else if (type ==  DataType.skill)
        {
            HeroCtrl selHero = GetTarget(json);
            m_CacheSomeVal.Clear();
            m_CacheSomeSuck.Clear();
            List<HeroCtrl> heros = new List<HeroCtrl>();
            List<HeroCtrl> heros_heti = new List<HeroCtrl>();
            bool isheti = false;
            for (; m_FightIndex < m_FightData.Count; m_FightIndex++)
            {
                JsonObject tmpObj = m_FightData[m_FightIndex] as JsonObject;

                DataType tmpType = (DataType)(tmpObj.num("z"));
                if (tmpType == DataType.endskill)
                {
                    m_FightIndex++;
                    break;
                }
                    

                if (tmpType == DataType.target)
                {
                    HeroCtrl sel = GetTarget(tmpObj);
                    bool isFind = false;
                    //移除重复英雄
                    for (int k = 0; k < heros.Count && !isFind; k++)
                        if (heros[k].GetInstanceID() == sel.GetInstanceID())
                            isFind = true;
                    if (!isFind)
                    {
                        heros.Add(sel);
                    }
                    sel.SetJsonValue(tmpObj);
                    if (tmpObj.ContainsKey("sx")) 
                    {
                        m_CacheSomeSuck.Add(tmpObj);
                    }
                }
                else if (tmpType == DataType.val)
                {
                    HeroCtrl sel = GetTarget(tmpObj);
                    if (sel != null && sel.GetInstanceID() == selHero.GetInstanceID())
                    {
                        if ((MagicType)tmpObj.num("o") == MagicType.Anger)
                        {
                            if (tmpObj.num("n") < 0)
                            {
                                TranslateVal(tmpObj);
                                continue;
                            }
                        }
                    }
                   
                    m_CacheSomeVal.Add(tmpObj);
                }
                else if (tmpType == DataType.enterT)
                {
                    isheti = true;
                    for (int i = 0; i < 4; i++)
                    {
                        object heti = tmpObj.get<object>("n" + i.ToString());
                        if (heti == null )
                        {
                            break;
                        }
                        int pos = System.Convert.ToInt32(heti);
                        if (pos < 6)
                        {
                            heros_heti.Add(m_Attcker.m_Heros[pos]);
                        }
                        else
                        {
                            heros_heti.Add(m_Defender.m_Heros[pos % 6]);
                        }
                    }
                }
                else
                {
                    m_CacheSomeVal.Add(tmpObj);
                }
            }

            selHero.m_CurSkillID = System.Convert.ToInt32(json["i"]);
            JsonObject table_data = TableReader.Instance.TableRowByID("skill", json["i"]);
            int skill_type = table_data.num("effect");
            if (json.num("c") == 1)
            {
                //播放文字  反击
                selHero.PlayWords("P");
            }
            if (isheti)
            {
                JsonObject table_dataxx = TableReader.Instance.TableRowByID("skilltie", json["i"]);
                JsonArray actions = table_dataxx.get<JsonArray>("action");
                selHero.CastHetiSkill(heros.ToArray(), heros_heti.ToArray(), actions);
            }
            else if (selHero.m_TeamID < 6)
            {
                selHero.CastSkill(heros.ToArray(), null, skill_type);
            }
            else
            {
                selHero.CastSkill_Pet(heros.ToArray(), null, skill_type);
            }
             
        }
        else if (type ==  DataType.attach)
        {
            AttachBuff(json);
            FightManager.Inst.Next();
        }
        else if (type ==  DataType.detach)
        {
            HeroCtrl sel = GetTarget(json);
            sel.m_BuffManager.RemoveBuff(json.num("i"));
            FightManager.Inst.Next();
        }
        else{
            FightManager.Inst.Next();
        }
    }

    private void AttachBuff(JsonObject json)
    {
        HeroCtrl sel = GetTarget(json);
        if (!json.ContainsKey("h") || json.num("h") > 0)
        {
            sel.m_BuffManager.AddBuff(json.num("i"));
        }
        else
        {
            sel.PlayWords("R");
        }
    }
    public void ToEnd()
    {
        m_FightIndex = m_FightData.Count;
        NextStep();
    }
    private void CheckFightBegin()
    {
        if (m_storyTable != null && m_storyTable["before"] != null)
        {
            TranslateScripts.Inst.TranslateString(m_storyTable["before"] as LuaTable);
            return;
        }
        FightManager.Inst.Next();
    }
    public void CheckFightEnd()
    {
        FightManager.Inst.ModifyBlood(false,false);

        bool isWin = FightManager.Inst.m_BattleInfo.get<bool>("win");
        if (m_isCheckTalk  == true && TranslateScripts.Inst.m_IsTalk == true)
        {
            return;
        }
        if (m_storyTable != null && m_storyTable["after"] != null && !m_isCheckTalk && isWin )
        {
            m_isCheckTalk = true;
            TranslateScripts.Inst.TranslateString(m_storyTable["after"] as LuaTable);
            return;
        }
        m_isCheckTalk = false;
        SimpleUI.Ins.CheckGameResult();
    }
    private void CreateAllTalk()
    {
        m_storyTable = null;
        if (GlobalVar.FightData["mdouleName"] as string == "commonChapter")
        {//判断是否第一次打普通关卡 是否需要加载新手
          
           
            int cid = System.Convert.ToInt32(GlobalVar.FightData["chapter_zj"]);
            int xid = System.Convert.ToInt32(GlobalVar.FightData["chapter_xj"]);
            SimpleJson.JsonObject tableData = TableReader.Instance.TableRowByUniqueKey("commonChapter", cid, xid);
            // double val = 0;
            cid = tableData.num("id");
            MStruct mst = MPlayer2.Instance.getStruct("Chapter");
            mst = mst.getStructObject("status");
            double val = mst.getStruct(cid.ToString()).getNumber("star");
            if (val == 0)
            {
                if (tableData.ContainsKey("talk_script"))
                {
                    string storyScript = tableData.str("talk_script");
                    if (!string.IsNullOrEmpty(storyScript))
                    {
                        object objs = LuaManager.getInstance().DoFile("uLuaModule/modules/story_talk/" + storyScript + ".lua");
                        m_storyTable = objs as LuaTable;
                    }
                }
            }
        }
    }
	// Update is called once per frame

    public void OnDropLifeByTarget() 
    {
        if (m_CacheSomeSuck.Count <= 0)
            return;
        JsonObject jsonObj = m_CacheSomeSuck[0];
        if (m_CacheSomeSuck.Count > 1)
        {
            for (int i = 1; i < m_CacheSomeSuck.Count; i++)
            {
                JsonObject tmpObj = m_CacheSomeSuck[i];
                DataType type = (DataType)(tmpObj.num("z"));
                if (type == DataType.target)
                {
                    if (tmpObj.ContainsKey("sx"))
                    {
                        jsonObj["sx"] = jsonObj.num("sx") + tmpObj.num("sx");
                    }
                }
            }
        }
        int pos = jsonObj.num("sw");
        if (pos != null) 
        {
            var t = GetTarget(pos);
            t.SetJsonValue(jsonObj);
            t.addLife();
        }
        m_CacheSomeSuck.Clear();
    }

    public void OnLifeChangingTime()
    {
        if (m_CacheSomeVal.Count <= 0)
            return;

        for (int i = 0; i < m_CacheSomeVal.Count; i++)
        {
            JsonObject tmpObj = m_CacheSomeVal[i];
            DataType type = (DataType)(tmpObj.num("z"));
            if (type == DataType.val)
            {
                TranslateVal(tmpObj);
            }
            else if (type == DataType.attach)
            {
                AttachBuff(tmpObj);
            }
            else if (type == DataType.detach)
            {
                HeroCtrl sel = GetTarget(tmpObj);
                sel.m_BuffManager.RemoveBuff(tmpObj.num("i"));
            }
			else if (type == DataType.state)
			{
				HeroCtrl selHero = GetTarget(tmpObj);
				if (tmpObj.num("i") == 31)
				{
					//吸收
					selHero.PlayWords("T");
				}
				if (tmpObj.num("o") == 43)
				{
					if (tmpObj.ContainsKey("hp")){
						HeroCtrl sel = GetTarget(tmpObj);
						sel.SimpleLifeChange(tmpObj.num("hp"));
					}
					//Invoke("NextStep", 1);
					//return;
				}
				//FightManager.Inst.Next();
			}
			//if (tmpObj.str("n") == "anger")
			//{
			//    tmpTarget.AddAngry(tmpObj.num("anger"));
			//}
			//else
			//{
			//    tmpTarget.ModifyLife(tmpObj.num("v"));
			//}
			
		}
		m_CacheSomeVal.Clear();
    }

    private void TranslateVal(JsonObject tmpObj)
    {
        HeroCtrl tmpTarget = GetTarget(tmpObj);
        if ((MagicType)tmpObj.num("o") == MagicType.Anger)
        {
            tmpTarget.AddAngry(tmpObj.num("n"));
        }
        else if ((MagicType)tmpObj.num("o") == MagicType.Hp)
        {
            tmpTarget.SimpleLifeChange(tmpObj.num("n"));
        }
    }

	void Update () {
	
	}
}
