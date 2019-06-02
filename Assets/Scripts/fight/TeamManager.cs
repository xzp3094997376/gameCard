using UnityEngine;
using System.Collections;
using SimpleJson;
using System;

/// <summary>
/// 队伍可以选择的目标类型
/// </summary>
/// 

public enum TeamSelectType
{
    Self,
    Row,//行
    Col,//列
    All,//全部
}
public class TeamManager : MonoBehaviour
{
    static int MaxTeamSize = 7;
    public HeroCtrl[] m_Heros = new HeroCtrl[MaxTeamSize];
    //public Vector2 m_SpaceSize = new Vector2(1.2f, 1.2f);

    public bool m_IsAtk = true; //进攻方
    private float m_change = 1;
    public string[] m_RandomHeroList = null;
    public JsonArray m_TeamData = null;
    private int m_LoadCount = 0;

    public bool m_RandomHero = true;
    
    void Awake()
    {
    }
    public Vector3[] new_Array
    {
        get
        {
            if (m_IsAtk)
            {
                return ConstData.FightAtkPosition;
            }
            else
            {
                return ConstData.FightDefPosition;

            }
        }
    }

    public Vector3[] new_ArrayE
    {
        get
        {
            if (m_IsAtk)
            {
                return ConstData.FightAtkPositionE;
            }
            else
            {
                return ConstData.FightDefPositionE;

            }
        }
    }

    public Vector3 GetTeamPosition(TeamSelectType sel, int team_id = 0)
    {
        Vector3 ret = new Vector3();
        switch(sel)
        {
            case TeamSelectType.All:
                ret = new_ArrayE[1]; // 全体攻击在2号位
                break;
            case TeamSelectType.Col:
                ret = new_Array[team_id % 3];
                break;
            case TeamSelectType.Row:
                if (team_id < 3) //前排
                    ret = new_ArrayE[1];
                else
                    ret = new_ArrayE[4];

                break;
            default:
                ret = new_ArrayE[team_id];
                break;
        }
       
        return ret;
    }

    public float GetTeamScale( int team_id = 0)
    {
        if (m_IsAtk)
        {
            return ConstData.FightAtkScale[team_id];
        }
        else
        {
            return ConstData.FightDefScale[team_id];

        }
    }

    public bool WillPoyi()
    {
        for(int i = 0; i < m_Heros.Length; ++i)
        {
            if (m_Heros[i] != null)
            {
                if (m_Heros[i].WillPoyi())
                {
                    return true;
                }
            }
        }
        return false;
    }

    public void LoadSingleHeros(int hero_id, int i, int max_hp, int hp, int angry, bool isSudden = false, bool isBoss = false, float modelSize = 1, string name = "", int star = 1)
    {
        if (m_Heros[i] != null)
            return;

        JsonObject mon = null;
        if (i < 6)
        {
            mon = TableReader.Instance.TableRowByID("avter", hero_id);
        }
        else
        {
            mon = TableReader.Instance.TableRowByID("petavter", hero_id);
        }
        

        string model_name = mon.str("model");

        GameObject obj = new GameObject();
        if (obj == null)
        {
            return;
        }
        float modelSizeE = modelSize * GetTeamScale(i);
        int turn = 0;//mon.num("turn");
        m_Heros[i] = CreateHeroObject(obj, i, model_name, modelSizeE, turn);
        //m_Heros[i].SetModelData(mon);
        m_Heros[i].m_TeamID = i;
        m_Heros[i].m_HeroID = hero_id;
        if (i < 6)
        {
            m_Heros[i].InitUseActions(hero_id);
        }
        else
        {
            m_Heros[i].InitUseActionsE(hero_id);
        }
        
        if (name == "")
        {
            JsonObject monc = TableReader.Instance.TableRowByID("char", hero_id);
            name = monc.str("show_name");
        }
        string col = GetStarColor(star);
        name = col + name;
        m_Heros[i].InitHeadUIInfo(name, modelSize, isBoss);
        m_Heros[i].InitHeroModel(model_name, isSudden);
        m_Heros[i].m_MAXHP = max_hp;
        m_Heros[i].m_MAXANG = 100;
        m_Heros[i].ResetLife(hp, angry);

        
        if (m_Heros[i].m_LifeBar != null)
            m_Heros[i].SetLifeBarVisible(true);
       
        //如果是地方血条变红色
        if (m_IsAtk)
            return;
        if (m_Heros[i].m_LifeBar != null)
        {
            UISprite life_tran = m_Heros[i].m_LifeBar.m_Life.gameObject.GetComponent<UISprite>();
            life_tran.spriteName = "Zhandou_wenzi_xuetiao_2";
        }
        if (i == 6)
        {
            m_Heros[i].gameObject.SetActive(false);
        }
    }
    public string GetStarColor(int star_lev)
    {
        if (star_lev == 1)
        {
            return "[ffffff]";
        }
        else if (star_lev == 2)
        {
            return "[24fc24]";
        }
        else if (star_lev == 3)
        {
            return "[12bfff]";
        }
        else if (star_lev == 4)
        {
            return "[ff3ffd]";
        }
        else if (star_lev == 5)
        {
            return "[ffbb29]";
        }
        else if (star_lev == 6)
        {
            return "[ff2626]";
        }
        return "[ffffff]";
    }
    public void LoadSingleHeroByJson(JsonObject cjso, int i)
    {
        int hero_id = cjso.num("id");
        if (m_Heros[i] != null && hero_id == m_Heros[i].m_HeroID)
        {
            return;
        }

        JsonObject mon = null;
        if (i < 6)
        {
            mon = TableReader.Instance.TableRowByID("avter", hero_id);
        }
        else
        {
            mon = TableReader.Instance.TableRowByID("petavter", hero_id);
        }

        string model_name = mon.str("model");
        GameObject obj = new GameObject();
        if (obj == null)
        {
            return;
        }
        float model_size = cjso.num("big") / 1000.0f * GetTeamScale(i);
        int turn = 0;// mon.num("turn");
        m_Heros[i] = CreateHeroObject(obj, i, model_name, model_size, turn);
      
        m_Heros[i].m_HeroID = hero_id;
        m_Heros[i].m_TeamID = i;
        if (i < 6)
        {
            m_Heros[i].InitUseActions(hero_id);
        }
        else
        {
            m_Heros[i].InitUseActionsE(hero_id);
        }
        string name = cjso.str("name");
        if (string.IsNullOrEmpty(name))
        {
            JsonObject monc = TableReader.Instance.TableRowByID("char", hero_id);
            name = monc.str("show_name");
        }
        string col = GetStarColor(cjso.num("star"));
        name = col + name;
        bool isBoss = false;
        if (mon.ContainsKey("big_model") && mon.str("big_model") != "" && mon.num("big_model") != 0)
        {
            isBoss = true;
        }
        m_Heros[i].InitHeadUIInfo(name, cjso.num("big") / 1000.0f, isBoss);
        m_Heros[i].InitHeroModel(model_name);
        
        m_Heros[i].m_MAXHP = cjso.num("maxHp");
        m_Heros[i].m_MAXANG = 100;
        m_Heros[i].ResetLife(cjso.num("hp"), cjso.num("anger"));
        //如果是地方血条变红色
        if (m_IsAtk)
            return;
        if (m_Heros[i].m_LifeBar != null)
        {
            UISprite life_tran = m_Heros[i].m_LifeBar.m_Life.gameObject.GetComponent<UISprite>();
            life_tran.spriteName = "Zhandou_wenzi_xuetiao_2";
        }
        if (i == 6)
        {
            m_Heros[i].gameObject.SetActive(false);
        }
    }

    public void RectShow(bool show)
    {
        return;
    }

    public HeroCtrl CreateHeroObject(GameObject obj, int pos, string name, float modelSize = 1, int turn = 0)
    {
        return CreateSingleHero(obj, new_Array[pos].x, new_Array[pos].y, new_Array[pos].z, name, modelSize, turn);
    }
    HeroCtrl CreateSingleHero(GameObject obj, float x, float y, float z, string str,float modelSize = 1, int turn = 0)
    {
        Transform transform = this.transform;
        Vector3 tmp = transform.position;
        tmp.x += x;
        tmp.y += y;
        tmp.z += z;

        obj.transform.position = tmp;
        
      
        obj.transform.localScale = new Vector3(modelSize, modelSize, modelSize);
        obj.name = str;
        obj.transform.parent = this.transform;

        HeroCtrl hc = obj.GetComponent<HeroCtrl>();
        if (hc == null)
        {
            hc = obj.AddComponent<HeroCtrl>() as HeroCtrl;
        }
        if ((turn == 1 && m_IsAtk) || (turn == 0 && !m_IsAtk))
        {
            hc.m_MyTurn = true;
        }
        hc.m_MyTeam = this;
        return hc;
    }
}

