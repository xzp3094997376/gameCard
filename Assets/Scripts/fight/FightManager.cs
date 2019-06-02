using UnityEngine;
using System.Collections;
using SimpleJson;
using System.Collections.Generic;
using System;
using SLua;
public class FightManager : MonoBehaviour
{
    public static FightManager Inst = null;
    public GameObject m_Bg = null;
    // 服务器下发的战斗数据
    public SimpleJson.JsonObject m_Data = null;
    public SimpleJson.JsonObject m_BattleInfo = null;
    public JsonArray m_Battles = null;
    public int m_Count = 1;
    public JsonArray m_BattleData = null;

    // 敌方和我方的战队的管理
    public TeamManager m_Attacker = null;
    public TeamManager m_Defender = null;
    private int m_AttackIdx = 0;
    private int m_DefendIdx = 0;
    private int m_RoundIdx = 0;    
    public HeroCtrl m_Hero = null;
    public HeroCtrl[] m_Targets = null;
    
    // 播放相关
    public int m_AttackTimes = 1;
    public bool m_IsNewBie = false;
    public bool m_IsBattleEditor = false;
    public bool m_IsShowBlood = false;
    public bool m_IsCGBattle = false;
    public bool m_IsReplay = false;

    public float m_PoyiTime = 3.4f;

    public UluaBinding m_BG = null;
    public bool m_bLoading = false;
    private bool m_isEnableAll = true;
    int progress = 0;
    private SimpleJson.JsonObject m_battle_data;
    private string m_scenename;
    void Awake()
    {      
        Inst = this;
        if (!m_IsBattleEditor)
        {
            InitFighting();
        }
       
    }
    void Start()
    {
        if (m_IsBattleEditor)
        {
            InitFighting();
        }
    }
    void InitFighting()
    {
        gameObject.AddComponent<AudioManagerFight>();
        gameObject.AddComponent<EffectManager>();
        gameObject.AddComponent<SimpleUI>();
        gameObject.AddComponent<TranslateBattleII>();
        LoadCommonEffect();
    }
    public void LoadCommonEffect()
    {
        LoadManager.getInstance().LoadSceneEffect("siwang", LoadComplete, null, true);
        LoadManager.getInstance().LoadSceneEffect("Run", LoadComplete, null, true);
        LoadManager.getInstance().LoadSceneEffect("char_shadow1", LoadComplete, null, true);
        LoadManager.getInstance().LoadSceneAnimation("hero", LoadComplete, null, true);
    }
    public void LoadComplete(LoadParam load)
    {

    }
    public void show()
    {
        this.gameObject.SetActive(true);
    }

    public void hide()
    {
        this.gameObject.SetActive(false);
    }

    public void ModifyBlood(bool show, bool needLater = true)
    {
        m_IsShowBlood = show;
        for (int i = 0; i < m_Attacker.m_Heros.Length; i++)
        {
            if (m_Attacker.m_Heros[i] != null)
            {
                m_Attacker.m_Heros[i].SetLifeBarVisible(show);
            }
        }
        for (int i = 0; i < m_Defender.m_Heros.Length; i++)
        {
            if (m_Defender.m_Heros[i] != null)
            {
                m_Defender.m_Heros[i].SetLifeBarVisible(show);
            }
        }
        if (needLater)
            LaterNext(0);
    }

    public void LaterNext(float nv)
    {
        Invoke("Next", nv);
    }
    public void SpellSkills(bool isSelf, int idx, int action_type, List<int> arr, List<int> hurts, int skillid)
    {
        if (m_IsShowBlood == false)
            ModifyBlood(true, false);
        if (isSelf)
        {
            m_Hero = m_Attacker.m_Heros[idx];
            m_Hero.m_CurSkillID = skillid;
            List <HeroCtrl> heros = new List<HeroCtrl>();
            for (int i = 0; i < arr.Count; i++)
            {
                heros.Add(m_Defender.m_Heros[arr[i]]);
                m_Defender.m_Heros[arr[i]].m_Damage = hurts[i];
            }
            
            m_Attacker.m_Heros[idx].CastSkill(heros.ToArray(), null, action_type);
        }
        else
        {
            List<HeroCtrl> heros = new List<HeroCtrl>();
            m_Hero = m_Defender.m_Heros[idx];
            m_Hero.m_CurSkillID = skillid;
            for (int i = 0; i < arr.Count; i++)
                {
                    heros.Add(m_Attacker.m_Heros[arr[i]]);
                    m_Attacker.m_Heros[arr[i]].m_Damage = hurts[i];
                }
            m_Defender.m_Heros[idx].CastSkill(heros.ToArray(), null, action_type);
        }

    }
    public void SpellHetiSkills(bool isSelf, int idx, int idxfriend, int skillid, List<int> arr, List<int> hurts)
    {
        if (m_IsShowBlood == false)
            ModifyBlood(true, false);
        HeroCtrl heroCur = null;
        HeroCtrl[] enemy = new HeroCtrl[arr.Count];
        HeroCtrl[] friend = new HeroCtrl[1] ;
        if (isSelf)
        {
            heroCur = m_Attacker.m_Heros[idx];
            heroCur.m_CurSkillID = skillid;
            friend[0] = m_Attacker.m_Heros[idxfriend];

            for (int i = 0; i < arr.Count; i++)
            {
                enemy[i] = m_Defender.m_Heros[arr[i]];
                m_Defender.m_Heros[arr[i]].m_Damage = hurts[i];
            }
        }
        else
        {
            heroCur = m_Defender.m_Heros[idx];
            heroCur.m_CurSkillID = skillid;
            friend[0] = m_Defender.m_Heros[idxfriend];

            for (int i = 0; i < arr.Count; i++)
            {
                enemy[i] = m_Attacker.m_Heros[arr[i]];
                m_Attacker.m_Heros[arr[i]].m_Damage = hurts[i];
            }

        }
        heroCur.InitSkillAction(skillid);
        JsonObject table_dataxx = TableReader.Instance.TableRowByID("skilltie", skillid);
        JsonArray actions = table_dataxx.get<JsonArray>("action");
        heroCur.CastHetiSkill(enemy, friend, actions);
    }
    void SetBack()
    {
        ModelShowUtil.resSetLayer(m_Hero.transform, 0);
    }
    void SpeedDown()
    {
        EffectManager.Instance.SpeedScale(0.1f, 1.0f);
    }

    void SpeedUp()
    {
        EffectManager.Instance.SpeedScale(2.0f, 0.5f);
    }

    //查找目标

    public void Next()
    {
        if (m_Attacker != null)
        {
            if (m_Attacker.WillPoyi())
            {
                return;
            }
        }
        if (m_Defender != null)
        {
            if (m_Defender.WillPoyi())
            {
                return;
            }
        }
        if (m_IsNewBie)
        {
            TranslateScripts.Inst.CallNextStep();
            return;
        }
        if (m_IsBattleEditor)
        {
            BattleEditor.Inst.Next();
            return;
        }
        TranslateBattleII.Inst.NextStep();
        return;
    }

    HeroCtrl[] SelectTarget(HeroCtrl[] ctrls, AttackType type)
    {
        ArrayList lives = new ArrayList();
        for (int i = 0; i < ctrls.Length; i++)
        {
            if (ctrls[i] != null && ctrls[i].m_HP > 0)
                lives.Add(ctrls[i]);
        }
        if (type == AttackType.One)
        {
            int rd = ((int)(UnityEngine.Random.value * lives.Count)) % lives.Count;
            HeroCtrl[] arr = new HeroCtrl[1];
            arr[0] = (HeroCtrl)lives[rd];
            return arr;
        }
        if (type == AttackType.Col)
        {
            int rd = ((int)(UnityEngine.Random.value * lives.Count)) % lives.Count;
            HeroCtrl[] arr = new HeroCtrl[2];
            HeroCtrl hc = (HeroCtrl)lives[rd];
            int sz = hc.m_TeamID % 3;
            arr[0] = ctrls[sz];
            arr[1] = ctrls[sz + 3];
            return arr;
        }
        if (type == AttackType.All)
        {
            HeroCtrl[] arr = new HeroCtrl[6];

            arr[0] = ctrls[1];
            arr[1] = ctrls[0];

            for (int i = 2; i < 6; i++)
            {
                arr[i] = ctrls[i];
            }
            return arr;
        }

        if (type == AttackType.Row)
        {
            int rd = ((int)(UnityEngine.Random.value * lives.Count)) % lives.Count;
            HeroCtrl[] arr = new HeroCtrl[3];
            HeroCtrl hc = (HeroCtrl)lives[rd];
            int startId = 3 * ((int)(hc.m_TeamID / 3));
            arr[0] = ctrls[1 + startId];
            arr[1] = ctrls[0 + startId];
            arr[2] = ctrls[2 + startId];
            return arr;
        }

        return null;
    }
    public void ExitFighting()
    {
        //this.gameObject.SetActive(false);
        if (SceneLoad.Inst != null)
            SceneLoad.Inst.DestroyScene();
        for (int i = 0; i < m_Attacker.m_Heros.Length; i++)
            if (m_Attacker.m_Heros[i] != null)
            {
                GameObject.DestroyObject(m_Attacker.m_Heros[i].gameObject);
                m_Attacker.m_Heros[i] = null;
            }

        for (int i = 0; i < m_Defender.m_Heros.Length; i++)
            if (m_Defender.m_Heros[i] != null)
            {
                GameObject.DestroyObject(m_Defender.m_Heros[i].gameObject);
                m_Attacker.m_Heros[i] = null;
            }
        LoadManager.getInstance().removeEffectResource();
        if (QualityManager.IsLow())
            LoadManager.getInstance().RemoveUnusedModel(true);
        else
            LoadManager.getInstance().RemoveUnusedModel(false);
    }
    public void InitFight()
    {
        SimpleUI.Ins.InitState();
        m_AttackIdx = m_DefendIdx = 0;
        // .AutoSetCamera(1);
        //Invoke("CreateEnd", 1.5f);

    }
    public void StartFighting()
    {
        if (SimpleUI.Ins.IsPlayGuide(GuideStop.Start, 0))
        {
            return;
        }
        TextureCache.getInstance().removeUnusedTextures();
        SimpleUI.Ins.ShowBattleStart();
        
        Invoke("EndStartFighting", 2.0f);
    }
    public void EndStartFighting()
    {
        ModifyBlood(true, false);
        EnableAll(true);
        m_isEnableAll = true;

        bool petinatk = false;
        bool petindef = false;
        if (m_Attacker.m_Heros[6] != null)
        {
            petinatk = m_Attacker.m_Heros[6].PlayPetIn();
        }
        if (m_Defender.m_Heros[6] != null)
        {
            petindef = m_Defender.m_Heros[6].PlayPetIn();
        }

        if (petinatk || petindef)
        {
            SimpleUI.Ins.CreatePetInUI(petinatk, petindef);
            Invoke("NextPetBg", 1.4f);
        }
        else
            Invoke("Next", 0.2f);
    }
    public void NextPetBg()
    {
        if (m_Attacker.m_Heros[6] != null)
        {
            m_Attacker.m_Heros[6].PlayPetBg();
        }
        if (m_Defender.m_Heros[6] != null && m_Defender.m_Heros[6].m_Petin != null)
        {
            m_Defender.m_Heros[6].PlayPetBg();
        }
        Invoke("Next", 1.5f);
    }
    public void CreateEffect(LuaTable curTable, out float time, out GameObject effectObject)
    {
        string name = curTable[2] as string;
        time = System.Convert.ToSingle(curTable[3]);
        GameObject gobj = LoadManager.getInstance().GetEffect(name);
        effectObject = Instantiate(gobj) as GameObject;
       
        int curTableCount = curTable.length();

        if (curTableCount >= 4 && curTable[4] as string != "")
        {
            string follow = curTable[4] as string;
            GameObject fobj = GameObject.Find(follow);
            if (fobj != null)
            {
                effectObject.transform.parent = fobj.transform;
                effectObject.transform.localPosition = Vector3.zero;
                effectObject.transform.localEulerAngles = Vector3.zero;
                effectObject.transform.localScale = Vector3.one;
                if(fobj.layer == 8)
                {
                    NGUITools.SetLayer(effectObject, fobj.layer);
                }
            }

        }
        //GameObject sceneObject = GameObject.Find("scene");

        if (curTableCount >= 5)
        {
            effectObject.transform.position = new Vector3(System.Convert.ToSingle(curTable[5]), System.Convert.ToSingle(curTable[6]), System.Convert.ToSingle(curTable[7]));
        }
        if (curTableCount >= 8)
        {
            effectObject.transform.eulerAngles = new Vector3(System.Convert.ToSingle(curTable[8]), System.Convert.ToSingle(curTable[9]), System.Convert.ToSingle(curTable[10]));
        }
       // MyDebug.Log(gobj.transform.position.ToString() + time);

        DestroyObject(effectObject, time);
    }
    public void PlayAnimation(bool isTrue, int idx, string ani)
    {
        if (isTrue)
        {
            m_Attacker.m_Heros[idx].PlayAnimation(ani);
        }
        else
        {
            m_Defender.m_Heros[idx].PlayAnimation(ani);
        }
        //SimpleUI.Ins.ShowBattleRun();
        TranslateScripts.Inst.CallNextStep();

    }
    public void AddBuff(bool isTrue, int idx, int bid)
    {
        if (isTrue)
        {
            m_Attacker.m_Heros[idx].m_BuffManager.AddBuff(bid);
        }
        else
        {
            m_Defender.m_Heros[idx].m_BuffManager.AddBuff(bid);
        }
        Invoke("Next", 0.5f);

    }
    public void RemoveBuff(bool isTrue, int idx, int bid)
    {
        if (isTrue)
        {
            m_Attacker.m_Heros[idx].m_BuffManager.RemoveBuff(bid);
        }
        else
        {
            m_Defender.m_Heros[idx].m_BuffManager.RemoveBuff(bid);
        }
        Invoke("Next", 0.5f);

    }
    public void SetHeroPosition(bool isTrue, int idx, float x, float y, float z)
    {
        if (isTrue)
        {
            m_Attacker.m_Heros[idx].transform.position = new Vector3(x, y, z);
        }
        else
        {
            m_Defender.m_Heros[idx].transform.position = new Vector3(x, y, z);
        }
        //SimpleUI.Ins.ShowBattleRun();
        TranslateScripts.Inst.CallNextStep();

    }
    public void SetHeroRotation(bool isTrue, int idx, float x, float y, float z)
    {
        if (isTrue)
        {
            m_Attacker.m_Heros[idx].transform.eulerAngles = new Vector3(x, y, z);
        }
        else
        {
            m_Defender.m_Heros[idx].transform.eulerAngles = new Vector3(x, y, z);
        }
        TranslateScripts.Inst.CallNextStep();

    }
    public void HideHero(bool isTrue, int idx)
    {
        if (isTrue)
        {
            m_Attacker.m_Heros[idx].DisappearHero();
        }
        else
        {
            m_Defender.m_Heros[idx].DisappearHero();
        }
        //SimpleUI.Ins.ShowBattleRun();
        Invoke("Next", 0.5f);

    }
    public void InitBattleInfo(SimpleJson.JsonObject battle_data, string scenename)
    {
        MusicManager.stopAllMusic();
        if (QualityManager.IsLow())
            LoadManager.getInstance().RemoveUnusedModel(true);
        else
            LoadManager.getInstance().RemoveUnusedModel(true);
        ClientTool.release();
        m_BG = ClientTool.loadAndGetLuaBinding("Prefabs/publicPrefabs/LoadingPrefabs", ApiLoading.getInstance().gameObject);
        m_bLoading = true;
        FightManager.Inst.InitFight();
        ClientTool.showFighting();
        //StartAni.Inst.Begin();
        SimpleUI.Ins.ShowBattleRun(false);
        m_battle_data = battle_data;
        m_scenename = scenename;
    }

    void LoadBattleAssets(JsonArray battle_data)
    {
        if (battle_data == null)
        {
            return;
        }
        for (int i = 0; i < battle_data.Count; i++)
        {
            JsonObject cjso = battle_data[i] as JsonObject;
            DataType type = (DataType)cjso.num("z");
            if (type == DataType.enter)
            {
               
                int pos = cjso.num("w");
                if (pos < 6)
                {
                    m_Attacker.LoadSingleHeroByJson(cjso, pos);
                }
                else if (pos >= 6 && pos < 12)
                {
                    m_Defender.LoadSingleHeroByJson(cjso, pos - 6);
                }
                else if (pos == 12)
                {
                    m_Attacker.LoadSingleHeroByJson(cjso, 6);
                }
                else if (pos == 13)
                {
                    m_Defender.LoadSingleHeroByJson(cjso, 6);
                }
            }
        }
    }

    void CreateBattleHero(JsonArray battle_data, AssetLoad ld)
    {
        if (battle_data == null)
        {
            return;
        }
        for (int i = 0; i < battle_data.Count; i++)
        {
            JsonObject cjso = battle_data[i] as JsonObject;
            DataType type = (DataType)cjso.num("z");
            if (type == DataType.enter)
            {

                int pos = cjso.num("w");
                if (pos < 6)
                {
                    m_Attacker.LoadSingleHeroByJson(cjso, pos);
                }
                else
                {
                    m_Defender.LoadSingleHeroByJson(cjso, pos - 6);
                }
            }
        }

    }



    public void LoadActionNeedAssets(int nActionid)
    {
        if (nActionid <= 0)
        {
            return;
        }
        ActionsData dat = ActionMgr.Ins.GetAction(nActionid);
        if (dat == null)
        {
            return;
        }

        if (dat != null && dat.m_Data != null)
        {
            foreach (BaseAction ba in dat.m_Data)
            {
                // 预加载特效
                if (ba.m_ActionType == ActionTypeEnum.PlayEffect && ba.m_StrValue != "")
                {
                    LoadManager.getInstance().LoadSceneEffect(ba.m_StrValue, LoadComplete);
                }
            }
        }
    }
    public void StartFight()
    {
        TranslateBattleII.Inst.StartFight(m_BattleData, m_Attacker, m_Defender);
        FightManager.Inst.Next();
    }

    public void Forward(bool isAtt, int nPos, float x, float y, float z)
    {
        if (isAtt)
        {
            m_Attacker.m_Heros[nPos].FowardTo(new Vector3(x,y,z),0);
        }
        else
        {
            m_Defender.m_Heros[nPos].FowardTo(new Vector3(x, y, z), 0);
            
        }
        Invoke("Next", 0);
    }

    public void BackTo(bool isAtt, int nPos)
    {
        if (isAtt)
        {
            m_Attacker.m_Heros[nPos].BackTo(0);
        }
        else
        {
            m_Defender.m_Heros[nPos].BackTo(0);

        }
        Invoke("Next", 0);
    }
    public void LoadSingleHero(bool isAtt, int heroid, int nPos, int nMax_hp, int nHP, int nAngry, bool isSudden = false, bool isBoss=false,float size=1, string name = "", int star = 1)
    {
        if (isAtt)
        {
            m_Attacker.LoadSingleHeros(heroid, nPos, nMax_hp, nHP, nAngry, isSudden, isBoss, size, name, star);
        }
        else
        {

            m_Defender.LoadSingleHeros(heroid, nPos, nMax_hp, nHP, nAngry, isSudden, isBoss, size, name, star);
        }

        TranslateScripts.Inst.CallNextStep();
    }
    public void RemoveChar(bool isAtt, int nPos)
    {
        if (isAtt)
        {
            if (m_Attacker.m_Heros[nPos] != null)
            {
                DestroyObject(m_Attacker.m_Heros[nPos].gameObject);
                m_Attacker.m_Heros[nPos] = null;
            }
        }
        else
        {

            if (m_Defender.m_Heros[nPos] != null)
            {
                DestroyObject(m_Defender.m_Heros[nPos].gameObject);
                m_Defender.m_Heros[nPos] = null;
            }
        }
        Invoke("Next", 0);
    }
    // Update is called once per frame
    void FixedUpdate()
    {
        if (m_bLoading)
        {
            if (progress == 2)
            {
                SceneLoad.Inst.LoadScene(m_scenename);
                if (m_battle_data != null && m_battle_data.ContainsKey("battle3"))
                {
                    JsonArray BattleArr = null;

                    m_BattleInfo = m_battle_data["battle3"] as JsonObject;
                    BattleArr = m_BattleInfo["battle"] as JsonArray;
                    m_Battles = BattleArr;

                    m_Count = BattleArr.Count;
                    m_BattleData = BattleArr[0] as JsonArray;
                }
               
                LoadBattleAssets(m_BattleData);
               
            }
            if (progress == 20) // 0-30只会执行一次
            {
                AudioManagerFight af = gameObject.GetComponent<AudioManagerFight>();
                if (af != null) af.PlayMusic();
            }
            if (progress < 30)
            {
                progress = progress + 2;
            }
            else if (progress <= 100 - LoadManager.getInstance().getunCompleteLoadCount() * 3)
            {
                progress = progress + 3;
            }
            
            if (progress > 100)
                progress = 100;
            if (progress == 100 && LoadManager.getInstance().getunCompleteLoadCount() == 0)
            {
                EnableAll(true);
                EnablePet(false);
                SimpleUI.Ins.CallBattleRunUpdate();
                FightManager.Inst.m_Bg.SetActive(true);
                m_bLoading = false;
                progress = 0;
                if (m_BG)
                {
                    DestroyObject(m_BG.gameObject);
                    m_BG = null;
                }
                
                StartFight();
            }

            if (m_BG)
            {
                m_BG.CallUpdateWithArgs(progress);
            }
        }
       
    }
    public void EnablePet(bool enable)
    {
        if (m_Attacker.m_Heros[6] != null)
        {
            m_Attacker.m_Heros[6].gameObject.SetActive(enable);
        }
        if (m_Defender.m_Heros[6] != null)
        {
            m_Defender.m_Heros[6].gameObject.SetActive(enable);
        }

    }
    public void EnableAll(bool enable)
    {
        if (enable == m_isEnableAll) return;
        else m_isEnableAll = !m_isEnableAll;

        for (int i = 0; i < m_Attacker.m_Heros.Length; i++)
        {
            if (m_Attacker.m_Heros[i] == null )
            {
                continue;
            }
            if (m_Attacker.m_Heros[i].m_HeroRotation != null)
            {
                m_Attacker.m_Heros[i].m_HeroRotation.SetActive(enable);
            }
            if (m_Attacker.m_Heros[i].m_Hero != null)
            {
                m_Attacker.m_Heros[i].m_Hero.SetActive(enable);
            }
            if (m_Attacker.m_Heros[i].m_Effect != null)
            {
                m_Attacker.m_Heros[i].m_Effect.SetActive(enable);
            }
            m_Attacker.m_Heros[i].SetLifeBarVisible(enable);
        }
        for (int i = 0; i < m_Defender.m_Heros.Length; i++)
        {
            if (m_Defender.m_Heros[i] == null)
            {
                continue;
            }
            if (m_Defender.m_Heros[i].m_HeroRotation != null)
            {
                m_Defender.m_Heros[i].m_HeroRotation.SetActive(enable);
            }
            if (m_Defender.m_Heros[i].m_Hero != null)
            {
                m_Defender.m_Heros[i].m_Hero.SetActive(enable);
            }
            if (m_Defender.m_Heros[i].m_Effect != null)
            { 
                m_Defender.m_Heros[i].m_Effect.SetActive(enable);
            }
            m_Defender.m_Heros[i].SetLifeBarVisible(enable);
        }
        SimpleUI.Ins.ModifyVisable(enable);
        FightManager.Inst.m_Bg.SetActive(enable);
    }

    public void EnableFriend(HeroCtrl target, bool enable)
    {
        target.m_Hero.SetActive(enable);
        if (target.m_friend == null)
        {
            return;
        }
        for (int j = 0; j < target.m_friend.Length; j++)
        {
            if (target.m_friend[j] != null)
            {
                target.m_friend[j].m_Hero.SetActive(enable);
            }
        }
    }

    public void EnableHetiEnemy(HeroCtrl[] target, bool enable)
    {
        for (int j = 0; j < target.Length; j++)
        {
            if (target[j] != null)
            {
                target[j].m_Hero.SetActive(enable);
            }
        }
    }
    public void EnableOne(HeroCtrl ctrl)
    {
        //if (m_IsShowBlood) 
            ctrl.gameObject.SetActive(true);
    }
    public void FightEnd()
    {
        for (int i = 0; i < m_Defender.m_Heros.Length; i++)
        {
            if (m_Defender.m_Heros[i] != null)
                DestroyObject(m_Defender.m_Heros[i].gameObject);
        }
        for (int i = 0; i < m_Attacker.m_Heros.Length; i++)
        if (m_Attacker.m_Heros[i] != null){
            if (m_Attacker.m_Heros[i].m_HP <= 0)
            {
                DestroyObject(m_Attacker.m_Heros[i].gameObject);
                m_Attacker.m_Heros[i] = null;
            }

            if(m_Attacker.m_Heros[i] != null)
            {
                m_Attacker.m_Heros[i].m_BuffManager.ClearAllBuff() ;
            }
        }
        SceneLoad.Inst.DestroyScene();
    }
}
