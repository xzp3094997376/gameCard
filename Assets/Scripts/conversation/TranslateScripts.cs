using UnityEngine;
using System.Collections;
using SLua;
using System.Collections.Generic;
using SimpleJson;
using DataModel;
//using SceneEditor;

[CustomLuaClass]
public class TranslateScripts
{
    private static TranslateScripts _ins = null;
    private int m_Step = 0;
    private LuaTable m_Tables = null;
    private int m_StepCount = 0;
    private List<int> m_Heros = null;
    private UluaBinding m_Bindings = null;
    private string m_Scene_id = "";
    string m_strAudioName = "";
    public GameObject m_SelCamera = null;
    public GameObject m_SelScene = null;
    public GameObject m_BattleScene = null;
    public GameObject m_BattleCamera = null;
    public TeamManager m_TeamMGR = null;

    public bool m_IsTalk = false;
    #region 变量导出

    public string AudioName
    {
        get
        {
            return m_strAudioName;
        }
    }
    #endregion
    #region 解析lua脚本相关
    /// <summary>
    /// 转义字符串  初始化操作
    /// </summary>
    /// <param name="text">脚本string</param>
    public void TranslateString(LuaTable lua_data)
    {
        m_Tables = lua_data;
        m_StepCount = m_Tables.length();
        m_Step = 1;
        CallNextStep();
    }


    public void ToEnd()
    {
        m_Step = m_StepCount;
        CallNextStep();
    }
    public void CallNextStep()
    {
        if (m_Step > m_StepCount)
        {
            if (FightManager.Inst.m_IsNewBie == false )
            {
                if (m_IsTalk)
                {
                    m_IsTalk = false;
                    GuideManager.getInstance().HidePlot();
                    FightManager.Inst.EnableAll(true);
                }
                FightManager.Inst.Next();
            }
            FightManager.Inst.m_IsNewBie = false;
            return;
        }

        TranslateLine();
    }

    void TranslateLine()
    {
        LuaTable curTable = m_Tables[m_Step] as LuaTable;
        m_Step++;
        if (curTable == null)
        {
            CallNextStep();
            return;
        }

        int curTableCount = 0;
        string type = curTable[1] as string;
        if (type != "talk" && type != "destroytalk" && m_IsTalk == true)
        {
            m_IsTalk = false;
            FightManager.Inst.EnableAll(true);
            GuideManager.getInstance().HidePlot();
        }
        float time = 0;
        GameObject obj = null;
        bool isBoss = false;
        float modelSize = 1;
        int star = 1;
        switch (type)
        {
            case "enter"://进入战斗
                
                //FightManager.Inst.StartFight();
                //FightManager.Inst.InitFight();
                //ClientTool.showFighting();
                //StartAni.Inst.Begin();
                //SceneMgr.beginLoadScene(m_Scene_id);
                //CallNextStep();
                break;
            case "in":
                ClientTool.showFighting();
                curTableCount = curTable.length();
                if (curTableCount > 7)
                    isBoss = System.Convert.ToBoolean(curTable[8]);
                if (curTableCount > 8)
                    modelSize = System.Convert.ToSingle(curTable[9]);
                if (curTableCount > 9)
                    star = System.Convert.ToInt32(curTable[10]);
                //添加新人
                int heroid = System.Convert.ToInt32(curTable[3]);
                string name = "";
                if (heroid == -1)
                {
                    heroid = GetPlayerID_Name(out name);
                }                
                FightManager.Inst.LoadSingleHero(System.Convert.ToBoolean(curTable[2]), heroid,
                    System.Convert.ToInt32(curTable[4]), System.Convert.ToInt32(curTable[5]), System.Convert.ToInt32(curTable[6]), System.Convert.ToInt32(curTable[7]), false, isBoss, modelSize,name, star);
                break;
            case "sudden_in":

                curTableCount = curTable.length();
                if (curTableCount > 7)
                    isBoss = System.Convert.ToBoolean(curTable[8]);
                if (curTableCount > 8)
                    modelSize = System.Convert.ToSingle(curTable[9]);
                if (curTableCount > 9)
                    star = System.Convert.ToInt32(curTable[10]);
                //添加新人
                int heroid1 = System.Convert.ToInt32(curTable[3]);
                string name_e = "";
                if (heroid1 == -1)
                {
                    heroid1 = GetPlayerID_Name(out name_e);
                }
                FightManager.Inst.LoadSingleHero(System.Convert.ToBoolean(curTable[2]), heroid1,
                    System.Convert.ToInt32(curTable[4]), System.Convert.ToInt32(curTable[5]), System.Convert.ToInt32(curTable[6]), System.Convert.ToInt32(curTable[7]), true, isBoss, modelSize, name_e, star);

                break;
            case "talk":
                m_IsTalk = true;
                FightManager.Inst.EnableAll(false);
                FightManager.Inst.m_Bg.SetActive(true);//只显示背景
                if (GlobalVar.MainUI)
                    GuideManager.getInstance().ShowPlot(this, curTable[2], curTable[3], curTable[4], curTable[5], curTable[6], curTable[7], curTable[8]);
                break;
            case "destroytalk":
                m_IsTalk = true;
                if (GlobalVar.MainUI)
                    GuideManager.getInstance().DestroyPlot();
                CallNextStep();
                break;
           case "show_end":
                if (SimpleUI.Ins)
                {
                    FightManager.Inst.m_IsReplay = true;
                    SimpleUI.Ins.ShowBattleRun(false);

                    //SimpleUI.Ins.m_RunUI.ModifyClickBtn(true);
                }
                CallNextStep();
                break;
            case "spell":
                List<int> nums = new List<int>();
                List<int> hurts = new List<int>();
                
                JsonObject table_data = TableReader.Instance.TableRowByID("skill", System.Convert.ToInt32(curTable[3]));
                int skill_type = table_data.num("effect");
                int skil_hurt = 4;
                if (skill_type == 4) //合体技能
                {
                    skil_hurt = 5;
                }
                curTableCount = curTable.length();
                int num = curTableCount - skil_hurt;
                if (num > 0)
                {
                    for (int i = 0; i < num; i += 2)
                    {
                        nums.Add(System.Convert.ToInt32(curTable[skil_hurt + 1 + i]));
                        hurts.Add(System.Convert.ToInt32(curTable[skil_hurt + 2 + i]));
                    }
                }

                if (skill_type <= 3)
                {
                    FightManager.Inst.SpellSkills(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[4]), skill_type, nums, hurts, System.Convert.ToInt32(curTable[3]));
                }
                else if(skill_type == 4)
                {
                    FightManager.Inst.SpellHetiSkills(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[4]), System.Convert.ToInt32(curTable[5]), System.Convert.ToInt32(curTable[3]), nums, hurts);
                }
                break;
            case "wait":
                FightManager.Inst.LaterNext(System.Convert.ToSingle(curTable[2]));
                break;

            case "hide_object":
                obj = GameObject.Find(curTable[2] as string);
                obj.SetActive(false);
                CallNextStep();
                break;
            
            case "effect":
                FightManager.Inst.CreateEffect(curTable, out time, out obj);
                CallNextStep();
                break;
            case "show_line":
                EffectManager.Instance.ShowSpeedLine(System.Convert.ToSingle(curTable[2]));
                EffectManager.Instance.m_SpeedLine.transform.position = new Vector3(
                    System.Convert.ToSingle(curTable[3]), System.Convert.ToSingle(curTable[4]), System.Convert.ToSingle(curTable[5]));
                CallNextStep();
                break;
            case "sound":
                if (AudioManagerFight.Inst != null)
                    AudioManagerFight.Inst.Play(curTable[2] as string);
                CallNextStep();
                break;
            case "black_show":
                
                FightManager.Inst.LaterNext(System.Convert.ToSingle(curTable[3]));
                break;
            case "scene":
                //scene id
                //ClientTool.showFighting();
                m_Scene_id = curTable[2] as string;
                FightManager.Inst.InitBattleInfo(FightManager.Inst.m_Data, m_Scene_id);
                CallNextStep();
                break;
            case "audio":
                //audio id
                m_strAudioName = curTable[2] as string;
                CallNextStep();
                break;

            case "load":
                //hero need to be load
              
                curTableCount = curTable.length();
                for (int i = 2; i <= curTableCount; i++)
                {
                    int id = System.Convert.ToInt32(curTable[i]);
                    SimpleJson.JsonObject mon = TableReader.Instance.TableRowByID("avter", id);

                    string model_name = mon.str("model");
                    //加载模型 动画 变身后
                    // AssetLoad.Instance.LoadAsset(AssetType.Model, model_name);
                    string path = UrlManager.ModelPath(model_name, "heroprefab");
                    LoadManager.getInstance().LoadSceneModel(path, model_name, (pram) =>
                    {
                    });
                }
                CallNextStep();
                break;
            case "SwitchCamera":
                SwitchCamera();
                CallNextStep();
                break;
          
            case "remove_char":
                //添加新人
                FightManager.Inst.RemoveChar(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]));
                break;

            case "shake":
                CameraCtrl.Inst.StartShake(System.Convert.ToSingle(curTable[2]), System.Convert.ToSingle(curTable[3]));
                CallNextStep();
                break;
            case "foward":
                FightManager.Inst.Forward(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), System.Convert.ToSingle(curTable[4]), System.Convert.ToSingle(curTable[5]),
                System.Convert.ToSingle(curTable[6]));
                break;
            case "backto":
                FightManager.Inst.BackTo(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]));
                break;
            case "camerafollow":
                //接口删除
                //FightManager.Inst.CameraFollow(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), System.Convert.ToSingle(curTable[4]));
                break;
            case "say":
                if (GlobalVar.MainUI)
                    GuideManager.getInstance().PlayDialog(curTable[2] as string, curTable[3] as string, System.Convert.ToSingle(curTable[4]));
                CallNextStep();
                break;
            case "init_pos":
                //有路径的加入，不再需要...为兼容旧脚本，暂时不删
                FightManager.Inst.transform.position = new Vector3(System.Convert.ToSingle(curTable[2]), System.Convert.ToSingle(curTable[3]), System.Convert.ToSingle(curTable[4]));
                CallNextStep();
                break;
            case "init_rot":
                FightManager.Inst.transform.eulerAngles = new Vector3(System.Convert.ToSingle(curTable[2]), System.Convert.ToSingle(curTable[3]), System.Convert.ToSingle(curTable[4]));
                CallNextStep();
                break;
            case "field_ani":
                CameraCtrl.Inst.StartFieldAnimation(System.Convert.ToSingle(curTable[2]), System.Convert.ToSingle(curTable[3]));
                CallNextStep();
                break;
            case "move":
                //TeamMoveMgr.inst.Move(curTable[2].ToString());
                break;
            case "modify_blood":
                FightManager.Inst.ModifyBlood(System.Convert.ToBoolean(curTable[2]));
                break;
            case "animate":
                Debug.Log(curTable[4]);
                FightManager.Inst.PlayAnimation(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), curTable[4] as string);
                break;
            case "add_buff":
                FightManager.Inst.AddBuff(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), System.Convert.ToInt32(curTable[4]));
                break;
            case "remove_buff":
                FightManager.Inst.RemoveBuff(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), System.Convert.ToInt32(curTable[4]));
                break;
            case "start":
                FightManager.Inst.StartFighting();
                break;
            case "hide":
                FightManager.Inst.HideHero(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]));
                break;
            case "set_rotate":
                FightManager.Inst.SetHeroRotation(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), System.Convert.ToSingle(curTable[4]), System.Convert.ToSingle(curTable[5]), System.Convert.ToSingle(curTable[6]));
                break;
            case "set_position":
                FightManager.Inst.SetHeroPosition(System.Convert.ToBoolean(curTable[2]), System.Convert.ToInt32(curTable[3]), System.Convert.ToSingle(curTable[4]), System.Convert.ToSingle(curTable[5]), System.Convert.ToSingle(curTable[6]));
                break;
            case "speedscale":
                EffectManager.Instance.SpeedScaleDelay(System.Convert.ToSingle(curTable[2]), System.Convert.ToSingle(curTable[3]), System.Convert.ToSingle(curTable[4]));
                CallNextStep();
                break;
            case "flash":
                curTableCount = curTable.length();
                if (CameraCtrl.Inst != null)
                    CameraCtrl.Inst.StartEnd(System.Convert.ToSingle(curTable[2]), System.Convert.ToSingle(curTable[3]));
                if (curTableCount < 4)
                    FightManager.Inst.LaterNext(System.Convert.ToSingle(curTable[2]));
                else
                {
                    float val = System.Convert.ToSingle(curTable[4]);
                    if (val <= 0)
                        CallNextStep();
                    else
                        FightManager.Inst.LaterNext(val);
                }
                break;
            case "win":
                //FightManager.Inst.ShowEnd(true);
                bool isShowNext = true;
                curTableCount = curTable.length();
                if (curTableCount > 1)
                    isShowNext = System.Convert.ToBoolean(curTable[2]);
                SimpleUI.Ins.ShowBattleEnd(true, isShowNext, this);
                Messenger.Broadcast("BattleWin");
                break;
            case "lose":
                //FightManager.Inst.ShowEnd(false);
                break;
            case "end":
                ClientTool.DestoryScene();
                UIMrg.Ins.pop();
                FightManager.Inst.ExitFighting();
                Messenger.Broadcast("EndThePlot");
                break;

            default:
                CallNextStep();
                break;
        }
    }
    private static int GetPlayerID_Name(out string name)
    {
        int dictID = 0;
        MStruct mst = MPlayer2.Instance.getStruct("Info");
        name = mst.getString("nickname");
        int id = mst.getInt("playercharid");
        MStruct chars = MPlayer2.Instance.getStruct("Chars");
        MStruct tmp = chars.getStruct(id.ToString());
        dictID = tmp.getInt("dictid");
        
        return dictID;
    }
    #endregion

    #region  选择角色相关
    public void ExcuteSelectChar(int hero_id = 19)
    {
        string file_name = "uLuaModule/modules/conversation/uShowSkills.lua";

        object objs = LuaManager.getInstance().DoFile(file_name);
        FightManager.Inst.m_Attacker.m_Heros[1] = m_TeamMGR.m_Heros[0];
        m_TeamMGR.m_Heros[0].m_TeamID = 1;
        m_TeamMGR.m_Heros[0].m_MyTeam = FightManager.Inst.m_Attacker;
        TranslateScripts.Inst.TranslateString(objs as LuaTable);
    }
    public void ExcuteLuaFile(string fileName)
    {
        object objs = LuaManager.getInstance().DoFile(fileName);
        TranslateScripts.Inst.TranslateString(objs as LuaTable);
    }


    public void SwitchCamera()
    {
        return;
    }


    public void InitScene()
    {

    }
    public void HideBattle()
    {
    }
    #endregion

    #region  对象单例化
    private TranslateScripts()
    {

    }
    /// <summary>
    /// 单利对象
    /// </summary>
    public static TranslateScripts Inst
    {
        get
        {
            if (_ins == null)
            {
                _ins = new TranslateScripts();
            }
            return _ins;
        }
    }
    #endregion
}
