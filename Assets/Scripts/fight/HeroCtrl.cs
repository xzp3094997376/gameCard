using UnityEngine;
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
using Spine.Unity;
using DataModel;
public enum AttackType
{
    One,
    Col,
    Row,
    All,
    SelfOne,
    SelfAll,
}

public enum DodgeType
{
    None,
    MoveBack,
    MoveFoward
}
[System.Serializable]

public class HeroCtrl : MonoBehaviour
{
    private SkeletonAnimation m_skAni = null;
    private Animation m_anAni = null;
    public int m_TeamID = 0;
    public int m_HeroID = 0;
    public TeamManager m_MyTeam = null;
    public bool m_MyTurn = false; // 反转
    public Vector3 m_TargetPos = new Vector3();
    public Vector3 m_OriginPos = new Vector3();
    public float m_TargetScale = 0.0f;
    public float m_OriginScale = 0.0f;
    private MoveAction m_MoveAction = null;
    public int m_MAXHP = 18888;
    public int m_HP = 8888;
    public int m_MAXANG = 4;
    public int m_ANG = 2;
    public int m_Damage = 0;
    public LifeBarCtrl m_LifeBar = null;
    public ActionPlayer m_SelfAction = null;

    private DodgeType m_IsDodge = DodgeType.None; // todo:zhangqingbin 需要修改为播动作
    public bool m_isLoadComplete = false;
    public JsonObject m_ValueObj = null;

    public GameObject m_Hero = null;
    public GameObject m_Effect = null;
    public GameObject m_HeroRotation = null;
    public bool isNewHit = false;    //第一次伤害指示  放置  damage/num 变小

    public HUDText m_BloodText = null;
    public bool m_IsMoving = false;
    public HeroBuffMgr m_BuffManager = null;

    public int[] m_SkillAction = new int[3];
    public int[] m_SkillStarupAction = new int[6];

    public HeroCtrl[] m_friend = null;
    public bool m_Poyi = false;

    public bool m_isDie = false;
    public int m_CurSkillID = 0;

    public string m_Petbg = null;
    public string m_Petin = null;
    public GameObject m_PetBgObj = null;
    public int m_PetDictid = 0;
    public int m_PetShenlian = 0;

    public int m_CurrentAttackTimes = 0;
    // Use this for initialization
    void Awake()
    {
        m_HP = m_MAXHP;

        m_OriginPos = this.transform.position;
        m_OriginScale = this.transform.localScale.x;
        m_MoveAction = gameObject.AddComponent<MoveAction>();

        m_BuffManager = gameObject.AddComponent<HeroBuffMgr>();
        m_SelfAction = this.GetComponent<ActionPlayer>();
        if (m_SelfAction == null)
        {
            m_SelfAction = gameObject.AddComponent<ActionPlayer>();
        }
     
    }
    public void InitHeadUIInfo(string name, float scale = 1.0f, bool isBoss = false)
    {
        if (m_LifeBar == null && m_TeamID < 6)
        {
            if (!isBoss)
            {
                GameObject newLifeBar = SimpleUI.Ins.CreateLifeBar();
                if (newLifeBar != null)
                {
                    UIFollowTargetCtrl fo = newLifeBar.GetComponent<UIFollowTargetCtrl>();
                    fo.target = transform;
                    fo.gameCamera = Camera.main.GetComponent<Camera>();
                    fo.uiCamera = GlobalVar.camera;
                    fo.mOffset = new Vector3(0, 2.4f +1.0f * scale, 0);
                }
                m_LifeBar = newLifeBar.GetComponent<LifeBarCtrl>();
                m_LifeBar.SetName(name);
                SetLifeBarVisible(false);
            }
            else
            {
                if (SimpleUI.Ins.m_RunUI == null)
                {
                    SimpleUI.Ins.ShowBattleRun(false);
                }
                m_LifeBar = SimpleUI.Ins.m_RunUI.m_LifeBar;
                m_LifeBar.SetName(name);
                m_LifeBar.gameObject.SetActive(false);
            }
        }

        GameObject uitobj = SimpleUI.Ins.CreateBloodText();

        uitobj.transform.localScale = new Vector3(0.5f, 0.5f, 0.5f);
        m_BloodText = uitobj.GetComponent<HUDText>();
        UIFollowTargetCtrl followCtrl = uitobj.GetComponent<UIFollowTargetCtrl>();
        followCtrl.target = transform;
        followCtrl.gameCamera = Camera.main.GetComponent<Camera>();
        followCtrl.uiCamera = GlobalVar.camera;
        followCtrl.mOffset = new Vector3(0, 2.4f, 0);
    }
    /// <summary>
    /// 原位置初始化一个模型
    /// </summary>
    /// <param name="obj">模型对象</param>
    public void InitHeroModel(string strName, bool isSudden = true)
    {
        string path = "";
#if UNITY_IOS
       path = UrlManager.ModelPath(strName + "_hd", "heroprefab"); 
       strName = strName + "_hd";
#else
        {
            //首先判断是不是已经存在大模型了
            path = UrlManager.ModelPath(strName, "heroprefab");
            if (!LoadManager.getInstance().HadLoadedUrl(path))
            {
                //首先判断是不是已经存在高清模型了
                path = UrlManager.ModelPath(strName + "_hd", "heroprefab");
                if (!LoadManager.getInstance().HadLoadedUrl(path))
                {
                    //如果没有加载大模型，加载小模型
                    path = UrlManager.ModelPath(strName + "_s", "heroprefab");
                    if (path == "")
                    {
                        // 没有小模型，加载标准模型
                        path = UrlManager.ModelPath(strName, "heroprefab");
                    }
                    else
                    {
                        strName = strName + "_s";
                    }
                }
                else
                {
                    strName = strName + "_hd";
                }
            }
            if (path == "")
                return;
        }
#endif
        m_HeroRotation = new GameObject();
        m_HeroRotation.transform.localPosition = this.gameObject.transform.position;
        m_HeroRotation.transform.localScale *= this.gameObject.transform.localScale.x;
        m_HeroRotation.transform.parent = this.gameObject.transform;
        m_HeroRotation.name = "heroRotation";
        if (m_MyTurn)
        {
            m_HeroRotation.transform.localEulerAngles = new Vector3(0, 180, 0);
        }
        LoadManager.getInstance().LoadSceneModel(path, strName, (pram) =>
        {
            GameObject obj = LoadManager.getInstance().GetAnimation("hero");
            GameObject hero_obj = Instantiate(obj) as GameObject;
            hero_obj.transform.parent = m_HeroRotation.transform;
            hero_obj.transform.localPosition = new Vector3(0, 0, 0);
            hero_obj.transform.localScale = new Vector3(1, 1, 1);
            hero_obj.transform.localEulerAngles = new Vector3(0, 0, 0);

            hero_obj.name = "hero";
            m_Hero = hero_obj;

            GameObject skobj = pram.mainGameObject;
            GameObject sk_obj = Instantiate(skobj) as GameObject;

            LoadAssetRef assetRef = sk_obj.AddComponent<LoadAssetRef>();
            assetRef.SetUrl(pram.url);

            sk_obj.transform.parent = hero_obj.transform;
            sk_obj.transform.localPosition = new Vector3(0, 0, 0);
           
            sk_obj.transform.localScale = new Vector3(1, 1, 1);
            sk_obj.transform.localEulerAngles = new Vector3(0, 0, 0);
            sk_obj.name = "skhero";
            m_skAni = sk_obj.GetComponent<SkeletonAnimation>();
            if (m_skAni == null)
            {
                Debug.LogError("hero obj export is error, must have SkeletonAnimation scrip");
                return;
            }
            ModelShowUtil.CompleteRenderMaterialShader(sk_obj);
            m_Poyi = false;
            m_isDie = false;
            SetPySkin(false);
            m_anAni = hero_obj.GetComponent<Animation>();
            if (m_anAni == null)
            {
                Debug.LogError("hero_obj obj export is error, must have Animation scrip");
                return;
            }

            GameObject effect_obj = new GameObject();
            //QualityManager.RecycleAssetBundle(path);
           
            effect_obj.transform.parent = m_HeroRotation.transform;
            effect_obj.transform.localPosition = new Vector3(0, 0, 0);
            effect_obj.transform.localScale = new Vector3(1, 1, 1);
            effect_obj.transform.localEulerAngles = new Vector3(0, 0, 0);
            effect_obj.name = "effect";
            m_Effect = effect_obj;

            GameObject eobj = LoadManager.getInstance().GetEffect("char_shadow1");
            GameObject effectobj = Instantiate(eobj) as GameObject;
            
            effectobj.transform.parent = effect_obj.transform;
            effectobj.transform.localPosition = new Vector3(0, 0, 0);
            effectobj.transform.localScale = new Vector3(1, 1, 1);
            effectobj.transform.localEulerAngles = new Vector3(0, 0, 0);
            m_isLoadComplete = true; 
            
        });
        
        if (m_LifeBar != null)
        {
            UIFollowTargetCtrl fo = m_LifeBar.gameObject.GetComponent<UIFollowTargetCtrl>();
            if (fo != null)
                fo.mOffset = new Vector3(0, 11.0f * m_MyTeam.GetTeamScale(m_TeamID), 0);
        }
    }

    public bool PlayPetIn()
    {
        bool petin = false;
        if (m_Petin != null && m_MyTeam.m_IsAtk)
        {
            GameObject gobj = LoadManager.getInstance().GetEffect(m_Petin);
            GameObject effectObject = Instantiate(gobj) as GameObject;

            effectObject.transform.parent = FightManager.Inst.m_Bg.transform;
            effectObject.transform.localPosition = new Vector3(-2.58f, -1.2f, -2f);
            effectObject.transform.localEulerAngles = Vector3.zero;
            effectObject.transform.localScale = new Vector3(0.75f, 0.75f, 0.75f);
            DestroyObject(effectObject, 1.5f);
            petin = true;
        }
        if (m_Petin != null && !m_MyTeam.m_IsAtk)
        {
            GameObject gobj = LoadManager.getInstance().GetEffect(m_Petin);
            GameObject effectObject = Instantiate(gobj) as GameObject;


            effectObject.transform.parent = FightManager.Inst.m_Bg.transform;
            effectObject.transform.localPosition = new Vector3(2.56f, -1.2f, -2f);
            effectObject.transform.localEulerAngles = new Vector3(0, 180, 0);
            effectObject.transform.localScale = new Vector3(0.75f, 0.75f, 0.75f);
            DestroyObject(effectObject, 1.5f);
            petin = true;
        }
        return petin;
    }
    public bool PlayPetBg()
    {
        bool petin = false;
        if (m_Petbg != null && m_MyTeam.m_IsAtk)
        {
            GameObject gobj = LoadManager.getInstance().GetEffect(m_Petbg);
            if (gobj != null)
            {
                m_PetBgObj = Instantiate(gobj) as GameObject;

                m_PetBgObj.transform.parent = FightManager.Inst.m_Bg.transform;
                m_PetBgObj.transform.localPosition = new Vector3(-2.58f, -1.2f, -2f);
                m_PetBgObj.transform.localEulerAngles = Vector3.zero;
                m_PetBgObj.transform.localScale = new Vector3(0.75f, 0.75f, 0.75f);
                petin = true;
            }
           
        }
        if (m_Petbg != null && !m_MyTeam.m_IsAtk)
        {
            GameObject gobj = LoadManager.getInstance().GetEffect(m_Petbg);
            if (gobj != null)
            {
                m_PetBgObj = Instantiate(gobj) as GameObject;
                m_PetBgObj.transform.parent = FightManager.Inst.m_Bg.transform;
                m_PetBgObj.transform.localPosition = new Vector3(2.56f, -1.2f, -2f);
                m_PetBgObj.transform.localEulerAngles = new Vector3(0, 180, 0);
                m_PetBgObj.transform.localScale = new Vector3(0.75f, 0.75f, 0.75f);
                petin = true;
            }
        }

        SimpleJson.JsonObject tableData = TableReader.Instance.TableRowByUniqueKey("petShenlian", m_PetDictid, m_PetShenlian);
        if (tableData == null)
        {
            return false;
        }
        JsonArray teamMgc = tableData.get<JsonArray>("teamMagic");

        for (int i = 0; i < teamMgc.Count; ++i)
        {
            if (teamMgc[i] != null)
            {
                JsonObject jo = teamMgc[i] as JsonObject;
                int pos = jo.num("position");
                if (m_MyTeam.m_Heros[pos] != null)
                {
                    m_MyTeam.m_Heros[pos].ShowPetMagicAdd(jo.num("magic_effect"), jo.num("magic_arg1"));
                }
            }
        }

        return petin;
    }

    public void ShowPetMagicAdd(int magic_effect, int magic_arg1)
    {
        GameObject eobj = LoadManager.getInstance().GetEffect("pet_tongyong_001");
        GameObject effectobj = Instantiate(eobj) as GameObject;

        effectobj.transform.parent = m_Effect.transform;
        effectobj.transform.localPosition = new Vector3(0, 0, 0);
        effectobj.transform.localScale = new Vector3(1, 1, 1);
        effectobj.transform.localEulerAngles = new Vector3(0, 0, 0);
        GameObject.Destroy(effectobj, 1.5f);

        UluaBinding cbinds = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/PetMagicAdd", m_BloodText.gameObject);
        cbinds.CallUpdateWithArgs(magic_effect, magic_arg1);
    }
    public void ShowPet(bool bshow = true)
    {
        for (int i = 0; i < m_MyTeam.m_Heros.Length; i++)
        {
            if (m_MyTeam.m_Heros[i] != null)
            {
                m_MyTeam.m_Heros[i].SetLifeBarVisible(!bshow);
            }
        }
        //m_PetBgObj.SetActive(!bshow);
        gameObject.SetActive(bshow);

    }
    public void SetPetInfo(int val, int val2)
    {
        m_PetDictid = val;
        m_PetShenlian = val2;
    }

    public void SetPySkin(bool py)
    {
        if (m_skAni == null)
        { return; }
        foreach (var skin in m_skAni.skeleton.Data.Skins)
        {
            if (py)
            {
                if (skin.name == "py")
                {
                    m_skAni.initialSkinName = skin.name;
                    m_skAni.Initialize(true);
                    //m_skAni.skeleton.SetSkin(skin.name);
                    return;
                }
            }

            if (skin.name == "zc")
            {
                m_skAni.initialSkinName = skin.name;
                m_skAni.Initialize(true);
                //m_skAni.skeleton.SetSkin(skin.name);
            }
        }
    }

    public bool WillPoyi()
    {
        if (m_Poyi)
        {
            return false;
        }
        if (m_HP <= 0 )
        {
            return false;
        }
        int poyi_switch = TableReader.Instance.TableRowByID("systemConfig", "poyi_switch").num("value");
        if (poyi_switch <= 0)
        {
            return false;
        }
        int poyi_vip_limit = TableReader.Instance.TableRowByID("systemConfig", "poyi_vip_limit").num("value");
        MStruct mst = MPlayer2.Instance.getStruct("Info");
        int playerLv = mst.getInt("level");
        if (playerLv < poyi_vip_limit)
        {
            return false;
        }
        float poyi_hp_limit = TableReader.Instance.TableRowByID("systemConfig", "poyi_hp_limit").num("value") / 100.0f;
        float pe = ((float)m_HP) / ((float)m_MAXHP);
        if (pe < poyi_hp_limit)
        {
            m_Poyi = true;
            if (m_skAni == null)
            { return false; }
            foreach (var skin in m_skAni.skeleton.Data.Skins)
            {
                if (skin.name == "py")
                {
                    m_skAni.initialSkinName = skin.name;
                    m_skAni.Initialize(true);
                    //m_skAni.skeleton.SetSkin(skin.name);
                    SimpleUI.Ins.ShowPoyi(FightManager.Inst.m_PoyiTime, m_HeroID);
                    Invoke("CallNext", FightManager.Inst.m_PoyiTime);
                    return true;
                }
            }
        }
        return false;
    }
    public void ResetLife(int hp = 0, int angry = 0)
    {
        m_HP = hp;
        m_ANG = angry;

        if (m_LifeBar != null)
        {
            m_LifeBar.InitState((1.0f * m_HP) / m_MAXHP, (1.0f * m_ANG) / m_MAXANG);

        }
    }

    public void PlayAnimation(string name, bool loop = false, bool btrup = false)
    {
        if (m_Hero == null)
        {
            return;
        }
        if (m_skAni != null && m_skAni.state != null && m_skAni.state.FindAnimation(name))
        {
            m_skAni.state.SetAnimation(0, name, loop);
            m_anAni.Stop();
            return;
        }
        
        if (m_anAni != null && m_anAni.GetClip(name) != null)
        {
            if (btrup)
            {
                foreach (AnimationState state in m_anAni)
                {
                    state.time = 0.0f;
                }
            }
            m_anAni.Play(name);
            if (loop)
            {
                m_anAni.wrapMode = WrapMode.Loop;
            }
            else
            {
                m_anAni.wrapMode = WrapMode.Once;
            }
        }
        else if(m_anAni != null)
        {
            m_anAni.Play("idle");
            if (loop)
            {
                m_anAni.wrapMode = WrapMode.Loop;
            }
            else
            {
                m_anAni.wrapMode = WrapMode.Once;
            }
        }
    }

    void Update()
    {
        if (!m_isLoadComplete)
        {
            return;
        }
        if (m_skAni != null && m_skAni.state != null)
        if (m_isLoadComplete 
            && (m_skAni != null && m_skAni.state != null &&!m_skAni.state.IsPlaying) 
            && (m_anAni != null &&!m_anAni.isPlaying) 
            && m_HP > 0)
        {
            if (m_IsMoving)
                PlayAnimation("run", true);
            else
                PlayAnimation("idle", true);
        }
        if ((m_skAni != null && m_skAni.state != null && !m_skAni.state.IsPlaying) && (m_anAni != null && !m_anAni.isPlaying) && m_HP <= 0)
        {
            PlayAnimation("idle", true);
        }
    }
    public void SetJsonValue(JsonObject val)
    {
        if (isNewHit)
        {
            val["hp"] = val.num("hp") + m_ValueObj.num("hp");
        }

        m_ValueObj = val;
        isNewHit = true;

    }
    void OnDestroy()
    {
        if (m_BloodText)
        {
            DestroyObject(m_BloodText.gameObject);
        }
        if (m_LifeBar && !m_LifeBar.m_IsBoss)
        {
            DestroyObject(m_LifeBar.gameObject);
        }
    }


    public void PlayWords(string str)
    {
        m_BloodText.Add(str, Color.black, 0.1f);
    }
    /// <summary>
    /// 设置一个英雄成为boss
    /// </summary>
    public void SetHeroToBeBoss()
    {
        SetLifeBarVisible(false);
        DestroyObject(m_LifeBar);
        if (SimpleUI.Ins.m_RunUI == null)
        {
            SimpleUI.Ins.ShowBattleRun(false);
        }
        m_LifeBar = SimpleUI.Ins.m_RunUI.m_LifeBar;
        m_LifeBar.gameObject.SetActive(true);
    }
    public void SetLifeBarVisible(bool b)
    {
        if (m_LifeBar == null)
        {
            return;
        }
       
        if (m_LifeBar != null)
            m_LifeBar.gameObject.SetActive(b);
        //当前模型如果隐形的话 自己也隐形
        if (gameObject.activeSelf == false)
            m_LifeBar.gameObject.SetActive(false);
    }
    public void InitUseActions(int heroId)
    {
        JsonObject mon = TableReader.Instance.TableRowByID("avter", heroId);
        if (mon == null)
        {
            return;
        }
        int action = mon.num("action_atk");
        m_SkillAction[0] = action;
        m_SelfAction.AddAction(action);
        FightManager.Inst.LoadActionNeedAssets(action);
        action = mon.num("action_skill1");
        m_SkillAction[1] = action;
        m_SelfAction.AddAction(action);
        FightManager.Inst.LoadActionNeedAssets(action);
        action = mon.num("action_skill2");
        m_SkillAction[2] = action;
        m_SelfAction.AddAction(action);
        FightManager.Inst.LoadActionNeedAssets(action);

        JsonArray skillarray = mon.get<JsonArray>("xp_skill");
        if (skillarray != null)
        {
            for (int i = 0; i < skillarray.Count; ++i)
            {
                int skill_id = System.Convert.ToInt32(skillarray[i]);
                InitSkillAction(skill_id);
            }
        }
    }

    public void InitUseActionsE(int heroId)
    {
        JsonObject mon = TableReader.Instance.TableRowByID("petavter", heroId);
        if (mon == null)
        {
            return;
        }
        int action = mon.num("action_atk");
        m_SkillAction[0] = action;
        m_SelfAction.AddAction(action);
        FightManager.Inst.LoadActionNeedAssets(action);
        
        JsonArray Actionarray = mon.get<JsonArray>("action_starup_skill");
        if (Actionarray != null)
        {
            for (int i = 0; i < Actionarray.Count; ++i)
            {
                int action_id = System.Convert.ToInt32(Actionarray[i]);
                m_SkillStarupAction[i] = action_id;
                m_SelfAction.AddAction(action_id);
                FightManager.Inst.LoadActionNeedAssets(action_id);
            }
        }

        m_Petbg = mon.str("pet_bg");
        //特效
        LoadManager.getInstance().LoadSceneEffect(m_Petbg, LoadComplete);
        m_Petin = mon.str("pet_in");
        //特效
        LoadManager.getInstance().LoadSceneEffect(m_Petin, LoadComplete);
        LoadManager.getInstance().LoadSceneEffect("pet_tongyong_001", LoadComplete);
        
    }
    public void LoadComplete(LoadParam load)
    {

    }
    public void InitSkillAction(int skill_id)
    {
        JsonObject skill_js = TableReader.Instance.TableRowByID("skilltie", skill_id);
        if (skill_js == null)
        {
            return;
        }
        JsonArray skill_action = skill_js.get<JsonArray>("action");
        if (skill_action == null)
        {
            return;
        }
        for (int i = 0; i < skill_action.Count; ++i)
        {
            int action = System.Convert.ToInt32(skill_action[i]);
            m_SelfAction.AddAction(action);
            FightManager.Inst.LoadActionNeedAssets(action);
        }
    }
    void CallNext()
    {
        FightManager.Inst.Next();
    }

    /// <summary>
    /// 查找技能
    /// </summary>
    /// <param name="?"></param>
    /// <returns></returns>
    public Vector3 GetSkillPosition(TeamSelectType tm)
    {
        return m_MyTeam.GetTeamPosition(tm, m_TeamID);
    }
    public void FowardTo(Vector3 pos, float LastTime, float modeSize = -1.0f)
    {
        m_TargetPos = pos;
        transform.position = m_OriginPos;
        float aniLength = LastTime;
        m_MoveAction.MoveTo(m_TargetPos, aniLength);

        if (modeSize > 0)
        {
            m_TargetScale = modeSize;
            transform.localScale = new Vector3(m_OriginScale, m_OriginScale, m_OriginScale);
            m_MoveAction.ScaleTo(m_TargetScale, aniLength);
        }
    }
    public void CastSkill(HeroCtrl[] enemy, HeroCtrl[] friend, int skill_type)
    {
        if (skill_type > 3)
        {
            FightManager.Inst.Next();
            return;
        }
        int actionid = m_SkillAction[skill_type - 1];
       
        m_SelfAction.StartAction(actionid, enemy, -1);
        for (int i = 0; friend != null && i < friend.Length; i++)
        {

        }
    }
    public void CastSkill_Pet(HeroCtrl[] enemy, HeroCtrl[] friend, int skill_type)
    {
        if (skill_type != 1 && skill_type < 100)
        {
            FightManager.Inst.Next();
            return;
        }
        else if (skill_type == 1)
        {
            ShowPet(true);
            int actionidx = m_SkillAction[skill_type - 1];

            m_SelfAction.StartAction(actionidx, enemy, -1);
           
            return;
        }
        ShowPet(true);
        int actionid = m_SkillStarupAction[skill_type - 100];

        m_SelfAction.StartAction(actionid, enemy, -1);
      
    }
    public void CastHetiSkill(HeroCtrl[] enemy, HeroCtrl[] friend, JsonArray actions)
    {
        m_friend = friend;
        int actionid = System.Convert.ToInt32(actions[0]);
        m_SelfAction.StartAction(actionid, enemy, 0);
        int pos = 0;
        
        for (int i = 0; friend != null && i < friend.Length; i++)
        {
            HeroCtrl fri = friend[i];
            int friActionid = 91002;
            for (int j = i + 1; j >= 0; j--)
            {
                if (actions.Count >= i + 1 && actions[j] != null)
                {
                    friActionid = System.Convert.ToInt32(actions[j]);
                    break;
                }
            }
            fri.m_SelfAction.AddAction(friActionid);
            pos += 1;
            fri.m_SelfAction.StartAction(friActionid, null, pos);
        }
    }
    public void BackTo(float LastTime = 0)
    {
        float aniLength = LastTime;
        //if (m_Ani.GetClip("move_back") != null) todo:zhangqingbin 可以播放动作
        //    aniLength = m_Ani.GetClip("move_back").length;

        if (LastTime >= 0)
            aniLength = LastTime;
        m_MoveAction.MoveTo(m_OriginPos, aniLength);
        m_MoveAction.ScaleTo(m_OriginScale, aniLength);
        //if (aniLength > 0)
        //{
        //    LoopAnimation(aniLength);
        //}
        //PlayAnimation("move_back", PlayMode.StopAll);
    }

    public void DodgeBackTo(float LastTime = 0)
    {

        float aniLength = LastTime;
        //if (m_Ani.GetClip("move_out") != null)
        //    aniLength = m_Ani.GetClip("move_out").length;

        if (LastTime >= 0)
        {
            aniLength = LastTime;
            LoopAnimation(aniLength);
        }
        m_MoveAction.MoveTo(m_OriginPos, aniLength);
        //PlayAnimation("move_out", PlayMode.StopAll);
    }
    public void Dodge(float LastTime = 0.25f)
    {
        if (m_IsDodge != 0)
            return;
        m_IsDodge = DodgeType.MoveBack; ;
        float aniLength = LastTime;
        //if (m_Ani.GetClip("move_back") != null)
        //    aniLength = m_Ani.GetClip("move_back").length;

        if (LastTime >= 0)
            aniLength = LastTime;
        transform.Translate(-0.6f, 0, -0.75f);
        Vector3 targetPos = new Vector3();
        targetPos = transform.position;
        transform.position = targetPos;
        m_MoveAction.MoveTo(targetPos, aniLength);
        if (aniLength > 0)
        {
            LoopAnimation(aniLength);
        }
        //PlayAnimation("move_back", PlayMode.StopAll);
    }
    public void LoopAnimation(float len)
    {
        if (len <= 0)
            return;
        //m_Ani.wrapMode = WrapMode.Loop;
        Invoke("EndLoop", len);
    }

    void EndLoop()
    {
        //m_Ani.wrapMode = WrapMode.Once;
        //if (m_Ani.IsPlaying("move_back") || m_Ani.IsPlaying("move_out"))
        //    PlayAnimation("standfight", PlayMode.StopAll);
        if (m_IsDodge == DodgeType.MoveBack)
        {
            m_IsDodge = DodgeType.MoveFoward;
            this.DodgeBackTo(0.1f);
        }
        else if (m_IsDodge == DodgeType.MoveFoward)
        {
            m_IsDodge = DodgeType.None;
        }
    }
    void cancelHit()
    {
        //ResetShaderHit(0);
    }
    public void ResetShaderHit(float rate)
    {
        Transform t = m_Hero.transform;
        if (!t)
            return;

        //细化边框
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            if (t0.GetComponent<Renderer>() != null && t0.GetComponent<Renderer>().material != null)
            {
                if (!string.IsNullOrEmpty(t0.GetComponent<Renderer>().material.shader.name))
                {
                    //float vvv = t0.renderer.material.GetFloat("_Outline");
                    t0.GetComponent<Renderer>().material.SetFloat("_RimIntensity", rate);
                }
            }
        }
    }
    /// <summary>
    /// 设置shdaer的颜色
    /// </summary>
    /// <param name="rate"></param>
    /// <param name="faceColor"></param>
    /// <param name="rimColor"></param>
    public void SetShaderColorAndRim(float rate, Color faceColor, Color rimColor)
    {
        Transform t = m_Hero.transform;
        if (!t)
            return;

        //细化边框
        for (int i = 0; i < t.childCount; i++)
        {
            Transform t0 = t.GetChild(i);
            if (t0.GetComponent<Renderer>() != null && t0.GetComponent<Renderer>().material != null)
            {
                if (!string.IsNullOrEmpty(t0.GetComponent<Renderer>().material.shader.name))
                {
                    //float vvv = t0.renderer.material.GetFloat("_Outline");
                    t0.GetComponent<Renderer>().material.SetFloat("_RimIntensity", rate);
                    t0.GetComponent<Renderer>().material.SetColor("_Color", faceColor);
                    t0.GetComponent<Renderer>().material.SetColor("_RimColor", rimColor);
                }
            }
        }
    }
    void PlayBlock()
    {
        int num = m_ValueObj.num("hp");
        //ResetShaderHit(1);
        Invoke("cancelHit", 0.25f);
        num = (int)Mathf.Floor(num * 1.0f / FightManager.Inst.m_AttackTimes);
        if (m_ValueObj.num("c") != 0)
        {
            PlayCritNum(num);
        }
        else
        {
            PlayWords(num.ToString());
        }
    }

    void OnEnable()
    {
        if (m_LifeBar)
            m_LifeBar.gameObject.SetActive(true);
    }
    void OnDisable()
    {
        if (m_LifeBar)
            m_LifeBar.gameObject.SetActive(false);
    }
    public void DisappearHero()
    {
        GameObject obj = LoadManager.getInstance().GetEffect("siwang");
        GameObject gobj = Instantiate(obj, transform.position, transform.rotation) as GameObject;
        ModelShowUtil.resetShader(gobj.transform);
        DestroyObject(gobj, 2);
        m_MoveAction.Disappear(0);

    }
    public bool DropLife(int num = 0, string strPlayAni = "hurt1")
    {
        m_CurrentAttackTimes++;
        bool needBreakAction = false;
        num = -num;
        if (m_ValueObj != null)
        {
            //MyDebug.Log(m_ValueObj);//提前打印
            if (m_ValueObj.num("hp") > 0)
            {
                addLife();
                return needBreakAction;
            }
            int hit = 1;//默认1,普通命中，
            if (m_ValueObj.ContainsKey("h"))
            {
                hit = m_ValueObj.num("h");
            }
            if (hit == 0)
            {
                Dodge();
                PlayWords("S");
                return needBreakAction;
            }
            else if (hit < 0)
            {
                PlayWords("R");
               return needBreakAction;
            }
            num = m_ValueObj.num("hp");

            if (FightManager.Inst.m_AttackTimes > 1)
            {

                num = (int)Mathf.Floor(num * 1.0f / FightManager.Inst.m_AttackTimes);

                if (isNewHit)
                {

                    num += num % FightManager.Inst.m_AttackTimes;
                }
            }
            
            if (m_ValueObj.num("b") != 0)
            {
                PlayWords("O" + num.ToString());
            }
            else if (m_ValueObj.num("c") != 0)
            {
                PlayWords("Q" + GetCritNumString(num));
            }
            else if (m_ValueObj.num("fa") != 0) 
            {
                PlayWords("Y" + GetCritNumString(num));
            }
            else
            {
                Invoke("cancelHit", 0.25f);
                if (num != 0)
                    PlayWords(num.ToString());
            }
            //if (m_ValueObj.ContainsKey("sx"))
            //{
            //    var taget = TranslateBattleII.Inst.GetTarget(m_ValueObj.num("sw"));
            //    if (taget != null)
            //    {
            //        taget.SetJsonValue(m_ValueObj);
            //        taget.addLife();
            //    }
            //}
            isNewHit = false;

            m_HP += num;
            //m_HP = 200;
            if (SimpleUI.Ins.m_RunUI != null)
                SimpleUI.Ins.m_RunUI.AddHurtNum(-num);
         
            if (m_ValueObj.num("d") != 0 && m_CurrentAttackTimes >= FightManager.Inst.m_AttackTimes && !m_isDie)
            {
                if (m_HP > 0)
                {
                    PlayWords((-m_HP).ToString());
                }
                m_isDie = true;
                m_HP = 0;
                needBreakAction = true;
                SetLifeBarVisible(false);
                Invoke("DisappearHero", 0.5f);
                PlayAnimation("dead");
            }
            else
            {
                PlayAnimation(strPlayAni , false, true);
            }
            
            if (m_LifeBar != null)
                m_LifeBar.SetLife((1.0f * m_HP) / m_MAXHP);

            return needBreakAction;
            // this.AddAngry(m_ValueObj.num("anger_v_with_target"));
        }
        else if (m_Damage > 0)
        {
            num = -m_Damage;
            if (FightManager.Inst.m_AttackTimes > 1)
            {
                num = num / FightManager.Inst.m_AttackTimes;
            }
            PlayWords(num.ToString());
        }
        else {
            float cur_rd = Random.value;
            if (cur_rd < 0.2f)
            {
                float rd = Random.value;
                if (rd < 0.3f)
                {
                    PlayWords("D");
                }
                else if (rd < 0.6f)
                {
                    PlayWords("B");
                }
                else
                {
                    PlayWords("I");
                }
                return needBreakAction;
            }
            else if (cur_rd < 0.4f)
            {
                num *= 2;
                PlayCritNum(num);

            }
            else PlayWords(num.ToString());
        }

        m_HP += num;
        if (SimpleUI.Ins.m_RunUI != null)
            SimpleUI.Ins.m_RunUI.AddHurtNum(-num);
        if (m_HP <= 0 && m_CurrentAttackTimes >= FightManager.Inst.m_AttackTimes && !m_isDie)
        {
            m_isDie = true;
            m_HP = 0;
            needBreakAction = true;
            SetLifeBarVisible(false);
            Invoke("DisappearHero", 0.5f);
        }
        else
        {
            PlayAnimation(strPlayAni, false, true);
        }
        if (m_LifeBar != null)
            m_LifeBar.SetLife((1.0f * m_HP) / m_MAXHP);

        return needBreakAction;
    }
    private string GetCritNumString(int num)
    {
        string str = num.ToString();
        for (int i = 0; i < 10; i++)
        {
            string tmp = "" + System.Convert.ToChar(98 + i);
            str = str.Replace(i.ToString(), tmp);
        }
        str = str.Replace("-", "a");
        return str;
    }
    private void PlayCritNum(int num)
    {

        string str = num.ToString();
        for (int i = 0; i < 10; i++)
        {
            string tmp = "" + System.Convert.ToChar(98 + i);
            str = str.Replace(i.ToString(), tmp);
        }
        str = str.Replace("-", "a");
        PlayWords(str);
    }
    private void PlayAddNum(string str)
    {
        for (int i = 0; i < 10; i++)
        {
            string tmp = "" + System.Convert.ToChar(108 + i);
            str = str.Replace(i.ToString(), tmp);
        }

        PlayWords(str);
    }
    private void PlayAddCritNum(string str)
    {
        for (int i = 0; i < 10; i++)
        {
            string tmp = "" + System.Convert.ToChar(66 + i);
            str = str.Replace(i.ToString(), tmp);
        }
        str = str.Replace("+", "A");
        PlayWords(str);
    }
    public void addLife(int num = 0, bool bPlaySound = true)
    {
        if (m_Damage > 0)
        {
            num = m_Damage;
            PlayAddNum("+" + num.ToString());
            if (FightManager.Inst.m_AttackTimes > 1)
            {
                num = num / FightManager.Inst.m_AttackTimes;
            }
            m_HP += num;
            m_HP = Mathf.Min(m_HP, m_MAXHP);
            if (m_LifeBar != null)
                m_LifeBar.SetLife((1.0f * m_HP) / m_MAXHP);
            return;
        }
        else if (m_ValueObj != null)
        {
            if (!m_ValueObj.ContainsKey("sx"))
            {
                num = m_ValueObj.num("hp");
            }
            else 
            {
                num = m_ValueObj.num("sx");
            }
        }
        if (num < 0)
        {
            DropLife();
            return;
        }
        if (!m_ValueObj.ContainsKey("sx") && FightManager.Inst.m_AttackTimes > 1)
        {
            num = (int)Mathf.Floor(num * 1.0f / FightManager.Inst.m_AttackTimes);

            if (isNewHit)
            {
                isNewHit = false;
                num += num % FightManager.Inst.m_AttackTimes;
            }
        }
        if (m_ValueObj.ContainsKey("crit"))
        {
            PlayAddCritNum("+" + num.ToString());
        }
        else if (m_ValueObj.ContainsKey("sx")) 
        {
            PlayAddNum("X+" + num.ToString());
        }
        else
        {
            PlayAddNum("+" + num.ToString());
        }
        isNewHit = false;
        m_HP += num;
        m_HP = Mathf.Min(m_HP, m_MAXHP);
        if (m_LifeBar != null)
            m_LifeBar.SetLife((1.0f * m_HP) / m_MAXHP);
    }

    public Transform FindPart(string sthName, Transform t)
    {

        Transform tran = t.Find(sthName);
        if (tran != null)
            return tran;

        for (int i = 0; i < t.childCount; i++)
        {
            tran = FindPart(sthName, t.GetChild(i));
            if (tran != null)
                return tran;
        }
        return null;
    }

    public void ModifyLife(int v)
    {
        m_HP = Mathf.Min(m_MAXHP, m_HP + v);
        if (m_LifeBar != null)
        {
            m_LifeBar.SetLife((1.0f * m_HP) / m_MAXHP);
        }
    }
    public void AddAngry(int v)
    {
        m_ANG = m_ANG + v;
        if (m_LifeBar != null)
        {
            m_LifeBar.SetFuel((1.0f * m_ANG) / m_MAXANG);
        }
    }
    public void SimpleLifeChange(int life)
    {
        if (life < 0)
        {
            PlayWords(life.ToString());
        }
        else
        {
            PlayAddNum("+" + life.ToString());
        }

        ModifyLife(life);
    }
}
