using UnityEngine;
using SimpleJson;
using System.Collections;

public enum GuideStop
{
    Start,
    Round,
    WinEnd,
    LoseEnd
};
public class SimpleUI : MonoBehaviour {

	// Use this for initialization
    public static SimpleUI Ins = null;
    public GameObject ui;
    public RunUI m_RunUI = null;
    public bool isEnd = false;
    public int m_SpeedLevel = 0;
    public UluaBinding cbinds = null;
    public TranslateScripts ctran = null;
    public bool CisNewBie = false;
    
    private bool isWin = true;

    private UluaBinding battle_poyi = null;
    private UluaBinding battle_heti = null;
    private UluaBinding battel_win = null;
    private UluaBinding battle_run = null;
    void Awake () {
        //ui = GlobalVar.battle;
        //ui = NGUITools.AddChild(GlobalVar.center);
        //ui.name = "blood_words";
        Ins = this;
        //UIMrg.Ins.replaceObjectToModule("blood_words", ui);
        //battle_player_in = ClientTool.load("Prefabs/moduleFabs/battleModule/battle_player_in", ui);
    }
    public void InitState()
    {
        ui = NGUITools.AddChild(GlobalVar.center);
        ui.name = "blood_words";
        if (FightManager.Inst.m_IsCGBattle)
        {
            UIMrg.Ins.pushObjectWithName("blood_words", ui);
        }
        else
            UIMrg.Ins.replaceObjectToModule("blood_words", ui);
        ui.AddComponent<FightUIState>();
        //battle_player_in = ClientTool.load("Prefabs/moduleFabs/battleModule/battle_player_in", ui);
        battle_poyi = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_poyi1", ui, false);
        battle_poyi.gameObject.SetActive(false);
        battle_heti = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_heti2", ui, false);
        battle_heti.gameObject.SetActive(false);
        battel_win = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_win_new1", ui, false);
        battel_win.gameObject.SetActive(false);
    }
    void OnDestroy()
    {
        Ins = null; 
    }
    public void CheckGameResult()
    {
        TranslateBattleII.Inst.m_IsStop = true;
        bool isWin = FightManager.Inst.m_BattleInfo.get<bool>("win");
        this.isWin = isWin;
        if (isWin)
        {
            HeroCtrl[] heros = FightManager.Inst.m_Defender.m_Heros;
            for (int i = 0; i < 6; i++)
                if (heros[i] != null && heros[i].gameObject.activeSelf)
                {
                    heros[i].DisappearHero();
                }
        }
        else
        {
            HeroCtrl[] heros = FightManager.Inst.m_Attacker.m_Heros;
            for(int i=0; i<6; i++)
                if (heros[i] != null && heros[i].gameObject.activeSelf)
                {
                    heros[i].DisappearHero();
                }
        }
        ShowBattleEnd(isWin);
    }
    public void disposeFun()
    {
        Ins = null;
        DestroyObject(this.gameObject);
    }
    public void ShowSkillName(string type, float lasttime, HeroCtrl target)
    {
        if (target.m_LifeBar == null)
            return;
        UluaBinding battle = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_"+ type, target.m_LifeBar.gameObject);
        Vector3 pos = new Vector3(0, 36f, 0);
        battle.transform.localPosition = pos;

        battle.CallUpdateWithArgs(target.m_CurSkillID);
        if (lasttime >= 0)
        {
            DestroyObject(battle.gameObject, lasttime);
        }
    }
    public void ShowHeti2(float lasttime, HeroCtrl traget)
    {
        battle_heti.gameObject.SetActive(true);
        //Animator ani = battle_heti.gameObject.GetComponent<Animator>();
        int[] friendID = new int[6] { 0, 0, 0, 0, 0, 0 };
        friendID[0] = traget.m_HeroID;
        for (int i = 0; traget.m_friend != null && i < traget.m_friend.Length; i++)
        {
            friendID[i + 1] = traget.m_friend[i].m_HeroID;
        }
        battle_heti.CallUpdateWithArgs(friendID[0], friendID[1], friendID[2], friendID[3], friendID[4]);
        if (lasttime >= 0)
        {
            Invoke("HideHeti2", lasttime);
        }

    }
    public void HideHeti2()
    {
        battle_heti.gameObject.SetActive(false);
    }
    public void ShowHeti(string type, float lasttime, HeroCtrl traget)
    {
        if (type == "heti2")
        {
            ShowHeti2(lasttime, traget);
            return;
        }
        UluaBinding battle_heti = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_" + type, ui, false);

        int[] friendID = new int[6] { 0, 0, 0, 0, 0, 0};
        friendID[0] = traget.m_HeroID;
        for (int i = 0; traget.m_friend != null && i < traget.m_friend.Length; i++)
        {
            friendID[i + 1] = traget.m_friend[i].m_HeroID;
        }
        battle_heti.CallUpdateWithArgs(friendID[0], friendID[1], friendID[2], friendID[3], friendID[4]);
        if (lasttime >= 0)
        {
            DestroyObject(battle_heti.gameObject, lasttime);
        }
    }

    public void ShowPoyi(float lasttime, int heroid)
    {
        battle_poyi.gameObject.SetActive(true);

        battle_poyi.CallUpdateWithArgs(heroid);
        if (lasttime >= 0)
        {
            Invoke("HidePoyi", lasttime);
        }
    }

    public void HidePoyi()
    {
        battle_poyi.gameObject.SetActive(false);
    }

    public void ShowHeti3(int type, float lasttime)
    {
        GameObject battle_heti = ClientTool.load("Prefabs/moduleFabs/battleModule/battle_heti3", ui);
        if (lasttime >= 0)
        {
            DestroyObject(battle_heti, lasttime);
        }
    }
    public void ShowHeti4(int type, float lasttime)
    {
       

    }
    public void ShowBattleEnd(bool isWin, bool isNewbie = false, TranslateScripts tran = null){
        //GameObject gobj = null;
        //UIMrg.Ins.pop();
        if (m_RunUI != null)
            GameObject.Destroy(m_RunUI.gameObject);

        FightManager.Inst.ModifyBlood(false, false);
        //isWin = false;
        //改成正常速度
        EffectManager.Instance.ModifySpeed(1);
        
        if (isWin)
        {
            cbinds = battel_win;

        }
        else
        {
            cbinds = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_lose_new", ui);
        }
        cbinds.gameObject.SetActive(false);
        CisNewBie = isNewbie;
        ctran = tran;
        Invoke("LaterShowEnd", 0.5f);
    }
    void LaterShowEnd()
    {
        if (isWin)
        {
            IsPlayGuide(GuideStop.WinEnd, 30);
        }
        else
        {
            IsPlayGuide(GuideStop.LoseEnd, 30);
        }
        cbinds.gameObject.SetActive(true);
        cbinds.CallUpdateWithArgs(FightManager.Inst.m_Data, GlobalVar.FightData, CisNewBie, ctran);
    }

    public void ShowBattleRun(bool isShow = true)
    {
        if (m_RunUI != null)
            return;
        GameObject obj = null;
        battle_run = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/battleModule/battle_run_new", ui);
        obj = battle_run.gameObject;
        obj.SetActive(false);
        m_RunUI = obj.GetComponent<RunUI>();
        if (isShow == false)
        {
            obj.SetActive(true);
            //m_RunUI.m_TxtRound.gameObject.SetActive(false);
        }
        if (FightManager.Inst.m_IsReplay)
        {
            Invoke("LaterCall", 3f);
        }
        //UIMrg.Ins.replaceObject(obj);
    }
    public void CallBattleRunUpdate()
    {
        if (battle_run != null)
        {
            battle_run.CallUpdateWithArgs(GlobalVar.FightData, FightManager.Inst.m_IsCGBattle);
        }
        else
        {
            ShowBattleRun(false);
            battle_run.CallUpdateWithArgs(GlobalVar.FightData, FightManager.Inst.m_IsCGBattle);
        }
    }

    private void LaterCall()
    {
        if(m_RunUI != null)
             m_RunUI.ModifyClickBtn(true);
    }
    public GameObject CreateLifeBar()
    {
        GameObject obj = ClientTool.load("Prefabs/moduleFabs/battleModule/life_bar", ui);

        return obj;
    }
    public GameObject CreateBloodText()
    {
        GameObject obj = ClientTool.load("Prefabs/moduleFabs/battleModule/blood_words", ui);

        return obj;
    }

    public void CreatePetInUI(bool isatk, bool isDef)
    {
        GameObject obj = ClientTool.load("Prefabs/moduleFabs/battleModule/PetIn_UI", ui);
        Petin_UI uitemp = obj.GetComponent<Petin_UI>();
        if (isatk)
            uitemp.SetAtk();
        if (isDef)
            uitemp.SetDef();
        GameObject.Destroy(obj, 1.5f);
    }
    public void ModifyVisable(bool needShow)
    {
        if(m_RunUI != null)
            m_RunUI.gameObject.SetActive(needShow);
    }
    public void ShowBattleStart() {
        //ShowBattleEnd(false);
        //ShowBattleEnd(false);
        
        GameObject gobj = ClientTool.load("effect_new/prefab/kaishizhandou", ui);
        //gobj.transform.parent = GlobalVar.center.transform.parent;
        gobj.transform.localPosition = new Vector3();
        DestroyObject(gobj, 2.0f);
        AudioManagerFight.Inst.Play("se_battle_start");
        if (m_RunUI)
        {
            m_RunUI.gameObject.SetActive(true);
            UluaBinding binding =  m_RunUI.gameObject.GetComponent<UluaBinding>();
            binding.CallUpdateWithArgs(GlobalVar.FightData, FightManager.Inst.m_IsNewBie);
        }
    }

    public void ShowWhiteScreen(float time)
    {
        GameObject obj = GameObject.Find("GameManager/Camera/mainUI/center");
        GameObject effctName = ClientTool.load("effect/fight/qiechangtexiao", obj);
        GameObject.Destroy(effctName, time);
    }

    private IEnumerator BattlePlayerInFalse(float time)
    {
        yield return new WaitForSeconds(time);
        //battle_player_in.SetActive(false);
    }

    public void ShowBattleRound(int cur, int total)
    {
        //ShowBattleEnd(false);
        //ShowBattleEnd(false);

        GameObject gobj = ClientTool.load("Prefabs/moduleFabs/battleModule/battle_round", ui);
        SetStage setter = gobj.GetComponent<SetStage>();
        setter.SetRounds(cur ,total);
        DestroyObject(gobj, 1.33f);
    }
    public bool IsPlayGuide(GuideStop guideStop, int m_RoundIdx)
    {
        bool ret = (bool)LuaManager.getInstance().CallLuaFunction("GuideMrg.IsPlayGuide",(int)guideStop,m_RoundIdx);
        
        return ret;
    }

    public void SetRound(int round = 1)
    {
        if(m_RunUI != null)
			m_RunUI.SetRound(Localization.Get("LocalKey_851") + ((round) + "/30"));
    }
    public void SetBattleCount(int c, int total)
    {
        if(m_RunUI != null)
            m_RunUI.UpdateBattleCount(c, total);
        
    }
}
