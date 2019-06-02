using UnityEngine;
using System.Collections;
using Spine.Unity;
/***
 * 描述战斗脚步的播放文件，用于播放fightActionData
 * 
 * 驱动整个战斗
 * 
 ***/
/// <summary>
/// 技能的id列表 用枚举只是为了能够用名字的形式来表示
/// </summary>
public enum SkillTypeToID
{
    NormalAttack = 1,
    SpecialAttack = 2,
    Transform = 3,
    SuperAttack = 4,
}
public class ActionPlayer : MonoBehaviour
{
    static int m_HetiPlayerCount = 0;
    public Hashtable m_ActionsData = new Hashtable();
    public BaseAction[] m_CurActions;     //当前的动作

    public bool m_IsPlaying = false;        //动作脚本是否正在播放

    //用于控制
    private int m_ActionStep = 0;
    private HeroCtrl m_SelfTarget = null;
    private Transform m_Transform = null;
    private HeroCtrl[] m_EnemyList = null;
    private int m_friendPos = -1; // 合体技助攻位
    private Hashtable m_TotalAttackTimes = new Hashtable();
    Hashtable m_Effets = new Hashtable();
    // Use this for initialization

    void Awake()
    {
        m_SelfTarget = this.GetComponent<HeroCtrl>();
    }
   
    public void AddAction(int nActionid)
    {
        if (nActionid <= 0)
        {
            return;
        }
        if (m_ActionsData.ContainsKey(nActionid))
        {
            return;
        }
        ActionsData dat = ActionMgr.Ins.GetAction(nActionid);
        if (dat == null)
        {
            return;
        }
        m_ActionsData.Add(nActionid, dat);

        int count = 0;
        if (dat != null && dat.m_Data != null)
        {
            foreach (BaseAction ba in dat.m_Data)
            {
                // 计算伤害次数
                if (ba.m_ActionType == ActionTypeEnum.DropLife || ba.m_ActionType == ActionTypeEnum.AddLife)
                {
                    count++;
                }
                // 预加载特效
                if (ba.m_ActionType == ActionTypeEnum.PlayEffect && ba.m_StrValue != "")
                {
                    LoadManager.getInstance().LoadSceneEffect(ba.m_StrValue, LoadComplete);
                }
            }
        }
        m_TotalAttackTimes.Add(nActionid, count);
    }

    public void LoadComplete(LoadParam load)
    {
    }
    /// <summary>
    /// 开始一套动作流畅
    /// </summary>
    /// <param name="skill_id">技能的id</param>
    /// <param name="enemy">敌人的队伍</param>
    /// <param name="friend">己方的队伍</param>
    public void StartAction(int action_id, HeroCtrl[] enemy, int friendPos = -1)
    {
        if (action_id <=0) //todo:zhangqingbin
        {
            action_id = 3002;
        }
        m_IsPlaying = true;
        m_ActionStep = -1;
        ActionsData ac = m_ActionsData[action_id] as ActionsData;
        if (ac == null)
        {
            Debug.LogWarning("m_ActionsData cannt find action_id = " + action_id.ToString());
            Invoke("DecideNextAction", 0.1f);
            return;
        }
        m_CurActions = ac.m_Data;

        m_EnemyList = enemy;
        m_friendPos = friendPos;
        if (friendPos == 0)
        {
            m_HetiPlayerCount = 0;
            m_HetiPlayerCount++;
        }
        else if(friendPos > 0)
        {
            m_HetiPlayerCount++;
        }
        else
        {
            m_HetiPlayerCount = 0;
        }
        if (m_friendPos == -1 || m_friendPos == 0)
        {
            if (RunUI.Ins != null)
                RunUI.Ins.ClearHurtNum();

            FightManager.Inst.m_AttackTimes = System.Convert.ToInt32(m_TotalAttackTimes[action_id]);
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
            {
                if (m_EnemyList[i] != null) // 找到第一个         
                {
                    m_EnemyList[i].m_CurrentAttackTimes = 0;
                }
            }
        }
        if (m_CurActions == null || m_CurActions.Length <= 0)
        {
            //兼容技能找不到的方案
            Invoke("DecideNextAction", 0.1f);
            return;
        }
        
        DecideNextAction();

    }
    /// <summary>
    /// 决定下一个动作
    /// </summary>
    void DecideNextAction()
    {
        float breaktime = 0;
        
        if (m_CurActions != null && (m_ActionStep + 1 < m_CurActions.Length))
        {
            breaktime = m_CurActions[m_ActionStep + 1].m_BreakTime;
        }
        else
        {
            if (m_SelfTarget.m_TeamID == 6)
            {
                m_SelfTarget.ShowPet(false);
            }
            if (m_friendPos == -1 )
                FightManager.Inst.Next();
            else
            {
                m_HetiPlayerCount--;
                if (m_HetiPlayerCount <= 0)
                {
                    FightManager.Inst.Next();
                }
            }
            return;
        }
        m_ActionStep++;
        if (breaktime <= 0)
        {
            NextAction();
            return;
        }
        Invoke("NextAction", breaktime);
    }
    void NextAction()
    {
        if (m_CurActions == null || m_ActionStep >= m_CurActions.Length)
        {
            return;
        }
        BaseAction curAction = m_CurActions[m_ActionStep];
        if (curAction.m_ActionType == ActionTypeEnum.FowardTo)
        {
            if (m_friendPos != -1)
            {
                if (m_friendPos >= 4)
                {
                    m_friendPos = 3;
                }
                if (m_SelfTarget.m_MyTeam.m_IsAtk)
                    m_SelfTarget.FowardTo(ConstData.FightHetiPosition2[m_friendPos], curAction.m_LastTime, curAction.m_NumValue);
                else
                    m_SelfTarget.FowardTo(ConstData.FightHetiPositionE2[m_friendPos], curAction.m_LastTime, curAction.m_NumValue);

            }
            else
            {
                //向前移动到某个位置
                for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                { 
                    if (m_EnemyList[i] != null && m_EnemyList[i].m_HP > 0) // 找到第一个
                    {
                        TeamSelectType what_i_sel = TeamSelectType.Self;
                        if (curAction.m_TargetType == TargetType.TargetCol)
                        {
                            what_i_sel = TeamSelectType.Col;
                        }
                        else if (curAction.m_TargetType == TargetType.TargetRow)
                        {
                            what_i_sel = TeamSelectType.Row;
                        }
                        else if (curAction.m_TargetType == TargetType.TargetTeam)
                        {
                            what_i_sel = TeamSelectType.All;
                        }
                        m_SelfTarget.FowardTo(m_EnemyList[i].GetSkillPosition(what_i_sel), curAction.m_LastTime, m_EnemyList[i].m_MyTeam.GetTeamScale(m_EnemyList[i].m_TeamID));
                        break;
                    }
                }
            }
        }
        else if (ActionTypeEnum.BackTo == curAction.m_ActionType)
        {   //回到自己的位置
            m_SelfTarget.BackTo(curAction.m_LastTime);
        }
        else if (ActionTypeEnum.PlayAnimation == curAction.m_ActionType)
        {   //播放动画
            if (curAction.m_TargetType == TargetType.Self)
            {
                if (m_SelfTarget == null)
                {
                    m_SelfTarget = GetComponent<HeroCtrl>();
                }
                m_SelfTarget.PlayAnimation(curAction.m_StrValue);
            }
            else
            {
                for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                    if (m_EnemyList[i] != null && m_EnemyList[i].m_HP > 0)
                    {
                        m_EnemyList[i].PlayAnimation(curAction.m_StrValue);
                    }
            }
        }
        else if (ActionTypeEnum.DropLife == curAction.m_ActionType)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null) //&& m_EnemyList[i].m_HP > 0)
                {
                    m_EnemyList[i].DropLife((int)(Random.value * 5000), curAction.m_StrValue);
                }
            TranslateBattleII.Inst.OnLifeChangingTime();
            TranslateBattleII.Inst.OnDropLifeByTarget();
        }
        else if (ActionTypeEnum.AddLife == curAction.m_ActionType)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null && m_EnemyList[i].m_HP > 0)
                {
                    m_EnemyList[i].addLife((int)(Random.value * 5000));
                }
            TranslateBattleII.Inst.OnLifeChangingTime();
        }
        else if (ActionTypeEnum.ShowSimpleUI == curAction.m_ActionType)
        {
            if (curAction.m_StrValue == "in")
            {
                //SimpleUI.Ins.ShowBattlePlayerIn(m_SelfTarget.m_PlayerID, curAction.m_LastTime, m_SelfTarget.m_PlayerID);
            }
            if (curAction.m_StrValue.Contains("heti"))
            {
                SimpleUI.Ins.ShowHeti(curAction.m_StrValue, curAction.m_LastTime, m_SelfTarget);
            }
            else if (curAction.m_StrValue == "skn")
            {
                SimpleUI.Ins.ShowSkillName(curAction.m_StrValue, curAction.m_LastTime, m_SelfTarget);
            }

        }
        else if (ActionTypeEnum.MotionBlur == curAction.m_ActionType)
        {
            CameraCtrl ctrl = Camera.main.GetComponent<CameraCtrl>();

            ctrl.StartMotionBlur(curAction.m_NumValue, curAction.m_LastTime);

        }
        else if (ActionTypeEnum.FollowCamera == curAction.m_ActionType)//无用
        {
        }
        else if (ActionTypeEnum.Blur == curAction.m_ActionType)
        {
            CameraCtrl.Inst.StartBlur(curAction.m_LastTime);
        }
        else if (ActionTypeEnum.ChangeColors == curAction.m_ActionType)
        {
            //m_SelfTarget.ResetShaderColor(new Color(curAction.m_Position.x, curAction.m_Position.y, curAction.m_Position.z, 1));
        }
        else if (ActionTypeEnum.WhiteScreen == curAction.m_ActionType)
        {
            float last = curAction.m_LastTime;
            if (last <= 0)
                last = 0.5f;
            SimpleUI.Ins.ShowWhiteScreen(last);
        }
        else if (ActionTypeEnum.Shake == curAction.m_ActionType)
        {
            CameraCtrl_new.Inst.StartShake(curAction.m_LastTime, curAction.m_NumValue);
        }
        else if (ActionTypeEnum.HetiCameraAni == curAction.m_ActionType)
        {
            CameraCtrl_new.Inst.StartCameraAnimtion(curAction.m_StrValue, m_SelfTarget.m_MyTeam.m_IsAtk, curAction.m_LastTime);
        }
        else if (ActionTypeEnum.EnableEnemy == curAction.m_ActionType)
        {
            if (curAction.m_NumValue == 1)
            {
                FightManager.Inst.EnableHetiEnemy(m_EnemyList, true);
            }
            else
            {
                FightManager.Inst.EnableHetiEnemy(m_EnemyList, false);
            }

        }
        else if (ActionTypeEnum.EnableAll == curAction.m_ActionType)
        {
            if (curAction.m_NumValue == 1)
            {
                FightManager.Inst.EnableAll(true);
            }
            else
            {
                FightManager.Inst.EnableAll(false);
            }

        }
        else if (ActionTypeEnum.EnableFriend == curAction.m_ActionType)
        {
            if (curAction.m_NumValue == 1)
            {
                FightManager.Inst.EnableFriend(m_SelfTarget, true);
            }
            else
            {
                FightManager.Inst.EnableFriend(m_SelfTarget, false);
            }

        }
        else if (ActionTypeEnum.SpeedScale == curAction.m_ActionType)
        {
            EffectManager.Instance.SpeedScale(curAction.m_NumValue, curAction.m_LastTime);
        }
        else if (ActionTypeEnum.StartFocus == curAction.m_ActionType)
        {

            CameraCtrl.Inst.StartFocus(m_SelfTarget, curAction.m_LastTime);
        }
        else if (ActionTypeEnum.EndFocus == curAction.m_ActionType)
        {

            CameraCtrl.Inst.EndFocus(curAction.m_LastTime);
        }
        else if (ActionTypeEnum.FieldOfView == curAction.m_ActionType)
        {
            CameraCtrl.Inst.StartFieldAnimation(curAction.m_LastTime, curAction.m_NumValue);
        }
        else if (ActionTypeEnum.SpeedLine == curAction.m_ActionType)
        {
            EffectManager.Instance.ShowSpeedLine(curAction.m_LastTime, curAction.m_StrValue);
        }
        else if (ActionTypeEnum.PlaySound == curAction.m_ActionType)
        {
            AudioManagerFight.Inst.Play(curAction.m_StrValue);
        }
        else if (ActionTypeEnum.InvertGrayScale == curAction.m_ActionType)
        {
            CameraCtrl.Inst.StartInvert(curAction.m_LastTime);
        }
        else if (ActionTypeEnum.PlayEffect == curAction.m_ActionType)
        {
            CreatEffectForFight(curAction);
        }

        DecideNextAction();
    }
    /// <summary>
    /// 为战斗创建特效
    /// </summary>
    /// <param name="curAction">战斗脚本</param>
    private void CreatEffectForFight(BaseAction curAction)
    {
        GameObject eff = LoadManager.getInstance().GetEffect(curAction.m_StrValue);
        if (eff == null)
        {
            return;
        }
        float playTime = curAction.m_LastTime;
        if (playTime <= 0)
            playTime = 4;//
        switch (curAction.m_LayerType)
        {
            case LayerType.Top:
                curAction.m_Position.z = -5;
                break;
            case LayerType.Bottom:
                curAction.m_Position.z = 1;
                break;
            case LayerType.Background:
                curAction.m_Position.z = 5;
                break;
            case LayerType.SelfUp:
                curAction.m_Position.z = -0.1f;
                break;
            case LayerType.SelfDown:
                curAction.m_Position.z = 0.1f;
                break;
            default:
                curAction.m_Position.z = 0;
                break;
        }
        if (curAction.m_NumValue <= 0)
        {
            curAction.m_NumValue = 1.0f;
        }
        if (curAction.m_TargetType == TargetType.Self)
        {
            Transform tran = m_SelfTarget.transform;
            GameObject curObj = CreateFollowEffect(eff, tran, curAction, playTime);

        }
        else if (curAction.m_TargetType == TargetType.Screen)
        {
            GameObject curObj = CreateEffectEx(eff, new Vector3(0, -5f, 0), curAction, playTime);
        }
        else if (curAction.m_TargetType == TargetType.Self2Target)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    Vector3 taV = m_EnemyList[i].transform.position - m_SelfTarget.transform.position;
                    taV.z = 0;
                    float angl = Vector3.Angle(taV, new Vector3(1.0f, 0, 0.0f));
                    Vector3 taC = Vector3.Cross(taV, new Vector3(1.0f, 0, 0.0f));
                    if (taC.z > 0)
                        angl = -angl;
                    Vector3 pos = m_SelfTarget.transform.position;
                    GameObject curObj = CreateEffect(eff, pos, curAction, playTime);
                    curObj.transform.localEulerAngles = new Vector3(0, angl, 0);
                    MoveAction mv = curObj.AddComponent<MoveAction>();                    
                    pos = m_EnemyList[i].transform.position + curAction.m_Position;
                    mv.MoveTo(pos, curAction.m_LastTime);
                }
        }
        else if (curAction.m_TargetType == TargetType.Atk2Def)
        {
            Vector3[] teampos = null;
            if (m_SelfTarget.m_MyTeam.m_IsAtk)
                teampos = ConstData.FightTeamPosition;
            else
                teampos = ConstData.FightTeamPositionE;
            GameObject curObj = CreateEffect(eff, teampos[0], curAction, playTime);
            MoveAction mv = curObj.AddComponent<MoveAction>();
            mv.MoveTo(teampos[1], curAction.m_LastTime);
        }
        else if (curAction.m_TargetType == TargetType.Target)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    GameObject curObj = CreateEffect(eff, m_EnemyList[i].transform, m_EnemyList[i], curAction, playTime);
                }
        }
        else if (curAction.m_TargetType == TargetType.TargetCol)
        {
            
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    TeamSelectType what_i_sel = TeamSelectType.Col;
                    GameObject curObj = CreateEffectEx(eff, m_EnemyList[i].GetSkillPosition(what_i_sel), curAction,  playTime);
                    if (m_EnemyList[i].m_MyTurn)
                    {
                        curObj.transform.eulerAngles = m_SelfTarget.transform.eulerAngles + new Vector3(0, -180, 0);
                    }
                    else
                    {
                        curObj.transform.eulerAngles = m_SelfTarget.transform.eulerAngles;
                    }
                    break;
                }
        }
        else if (curAction.m_TargetType == TargetType.TargetRow)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    TeamSelectType what_i_sel = TeamSelectType.Row;
                    GameObject curObj = CreateEffectEx(eff, m_EnemyList[i].GetSkillPosition(what_i_sel), curAction, playTime);
                    if (m_EnemyList[i].m_MyTurn)
                    {
                        curObj.transform.eulerAngles = m_SelfTarget.transform.eulerAngles + new Vector3(0, -180, 0);
                    }
                    else
                    {
                        curObj.transform.eulerAngles = m_SelfTarget.transform.eulerAngles;
                    }
                    break;
                }
        }
        else if (curAction.m_TargetType == TargetType.TargetTeam)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    TeamSelectType what_i_sel = TeamSelectType.All;
                    GameObject curObj = CreateEffectEx(eff, m_EnemyList[i].GetSkillPosition(what_i_sel), curAction, playTime);
                    if (m_EnemyList[i].m_MyTurn)
                    {
                        curObj.transform.eulerAngles = m_SelfTarget.transform.eulerAngles + new Vector3(0, -180, 0);
                    }
                    else
                    {
                        curObj.transform.eulerAngles = m_SelfTarget.transform.eulerAngles;
                    }
                    break;
                }
        }
        else if (curAction.m_TargetType == TargetType.SelfBizer2Target)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    GameObject curObj = CreateEffect(eff, m_SelfTarget.transform, m_SelfTarget, curAction, playTime);
                    BezierMove mv = curObj.AddComponent<BezierMove>();
                    Vector3[] v3 = new Vector3[2];
                    Vector3 cur = transform.position;
                    transform.Translate(curAction.m_Rotation);
                    v3[0] = transform.position;
                    transform.position = cur;
                    v3[1] = m_EnemyList[i].transform.position + new Vector3(curAction.m_Position.x, curAction.m_Position.y, curAction.m_Position.z); ;
                    mv.MoveTo(v3, curAction.m_LastTime);
                }
        }
        else if (curAction.m_TargetType == TargetType.SelfBizer2Team)
        {
            for (int i = 0; m_EnemyList != null && i < m_EnemyList.Length; i++)
                if (m_EnemyList[i] != null)
                {
                    GameObject curObj = CreateEffect(eff, m_SelfTarget.transform, m_SelfTarget, curAction, playTime);
                    BezierMove mv = curObj.AddComponent<BezierMove>();
                    Vector3[] v3 = new Vector3[2];
                    Vector3 cur = transform.position;
                    transform.Translate(curAction.m_Rotation);
                    v3[0] = transform.position;

                    //transform.Translate(-2 * curAction.m_Rotation.x, 1, 0);
                    //v3[1] = transform.position;
                    transform.position = cur;

                    v3[1] = m_EnemyList[i].GetSkillPosition(TeamSelectType.All);
                    mv.MoveTo(v3, curAction.m_LastTime);
                    break;
                }
        }
    }
    GameObject CreateFollowEffect(GameObject effect, Transform target, BaseAction curAction, float cost = 4)
    {
        Vector3 position = curAction.m_Position;
        Vector3 rotation = curAction.m_Rotation;
        float scale = curAction.m_NumValue;
        int color_type = (int)curAction.m_NumValue2;
        string strAni = curAction.m_BackUp;
        GameObject objRotation = new GameObject();
        objRotation.transform.parent = target;
        objRotation.transform.localPosition = new Vector3(0, position.y, position.z);
        position.z = 0.0f;
        position.y = 0.0f;
        objRotation.transform.localScale = new Vector3(1, 1, 1);
        objRotation.transform.localEulerAngles = new Vector3(0, 0, 0);
        objRotation.name = "effectRF";
        if (m_SelfTarget.m_MyTurn)
        {
            objRotation.transform.localEulerAngles = new Vector3(0, 180, 0);
        }
        GameObject obj = Instantiate(effect, target.position, target.rotation) as GameObject;
        obj.transform.parent = objRotation.transform;
        obj.transform.localPosition = new Vector3();
        obj.transform.localEulerAngles = new Vector3(0, 0, 0);
        obj.transform.Translate(position);
        obj.transform.Rotate(rotation);
        obj.transform.localScale = new Vector3(scale, scale, scale);

        if (strAni != null && strAni != "")
        {
            SkeletonAnimation ani = obj.GetComponent<SkeletonAnimation>();
            if (ani != null && ani.state != null && ani.state.FindAnimation(strAni))
            {
                ani.state.SetAnimation(0, strAni, ani.loop);
            }
        }
        ModelShowUtil.resetShader(obj.transform);
        if (color_type > 0)
        {
            SimpleJson.JsonObject jo = TableReader.Instance.TableRowByID("effectcolor", color_type);
            if (jo != null)
            {
                Color col = new Color(jo.num("R") / 255.0f, jo.num("G") / 255.0f, jo.num("B") / 255.0f);
                ModelShowUtil.ChangeSpineSkeletonShader(obj.transform, col);
                
            }
        }
        
        DestroyObject(obj, cost);
        DestroyObject(objRotation, cost);
        return objRotation;
    }
    GameObject CreateEffect(GameObject effect, Transform target, HeroCtrl targetCtrl, BaseAction curAction, float cost = 4)
    {
        Vector3 position = curAction.m_Position;
        Vector3 rotation = curAction.m_Rotation;
        float scale = curAction.m_NumValue;
        int color_type = (int)curAction.m_NumValue2;
        string strAni = curAction.m_BackUp;
        GameObject objRotation = new GameObject();
        objRotation.transform.parent = target;
        objRotation.transform.localPosition = new Vector3(0, position.y, position.z);
        position.z = 0.0f;
        position.y = 0.0f;
        objRotation.transform.localScale = new Vector3(1, 1, 1);
        objRotation.transform.localEulerAngles = new Vector3(0, 0, 0);
        objRotation.name = "effectR";
        if (targetCtrl.m_MyTurn)
        {
            objRotation.transform.localEulerAngles = new Vector3(0, 180, 0);
        }

        Vector3 m_pos = new Vector3();
        m_pos = target.position;
        GameObject obj = Instantiate(effect, m_pos, target.rotation) as GameObject;
        obj.transform.parent = objRotation.transform;
        obj.transform.localPosition = new Vector3();
        obj.transform.localEulerAngles = new Vector3(0, 0, 0);
        obj.transform.Translate(position);
        
        obj.transform.Rotate(rotation);
        obj.transform.localScale = new Vector3(scale, scale, scale);

        if (strAni != null && strAni != "")
        {
            SkeletonAnimation ani = obj.GetComponent<SkeletonAnimation>();
            if (ani != null && ani.state != null && ani.state.FindAnimation(strAni))
            {
                ani.state.SetAnimation(0, strAni, ani.loop);
            }
        }
        ModelShowUtil.resetShader(obj.transform);
        if (color_type > 0)
        {
            SimpleJson.JsonObject jo = TableReader.Instance.TableRowByID("effectcolor", color_type);
            if (jo != null)
            {
                Color col = new Color(jo.num("R") / 255.0f, jo.num("G") / 255.0f, jo.num("B") / 255.0f);
                ModelShowUtil.ChangeSpineSkeletonShader(obj.transform, col);
            }
        }
        DestroyObject(obj, cost);
        DestroyObject(objRotation, cost);
        return objRotation;
    }
    GameObject CreateEffect(GameObject effect, Vector3 selfPostion, BaseAction curAction, float cost = 4)
    {
        Vector3 position = curAction.m_Position;
        Vector3 rotation = curAction.m_Rotation;
        float scale = curAction.m_NumValue;
        int color_type = (int)curAction.m_NumValue2;
        string strAni = curAction.m_BackUp;
        GameObject obj = Instantiate(effect, selfPostion, Quaternion.identity) as GameObject;
        obj.transform.Translate(position);
        obj.transform.Rotate(rotation);
        obj.transform.localScale = new Vector3(0.28f* scale, 0.28f * scale, 1f);
        if (strAni != null && strAni != "")
        {
            SkeletonAnimation ani = obj.GetComponent<SkeletonAnimation>();
            if (ani != null && ani.state != null && ani.state.FindAnimation(strAni))
            {
                ani.state.SetAnimation(0, strAni, ani.loop);
            }
        }
        ModelShowUtil.resetShader(obj.transform);
        if (color_type > 0)
        {
            SimpleJson.JsonObject jo = TableReader.Instance.TableRowByID("effectcolor", color_type);
            if (jo != null)
            {
                Color col = new Color(jo.num("R") / 255.0f, jo.num("G") / 255.0f, jo.num("B") / 255.0f);
                ModelShowUtil.ChangeSpineSkeletonShader(obj.transform, col);
            }
        }
        DestroyObject(obj, cost);
        
        return obj;
    }
    GameObject CreateEffectEx(GameObject effect, Vector3 selfPostion, BaseAction curAction,   float cost = 4)
    {
        Vector3 position = curAction.m_Position;
        Vector3 rotation = curAction.m_Rotation;
        float scale = curAction.m_NumValue;
        int color_type = (int)curAction.m_NumValue2;
        string strAni = curAction.m_BackUp;
        GameObject objRotation = new GameObject();
        objRotation.transform.localPosition = selfPostion + new Vector3(0, position.y, position.z);
        position.z = 0.0f;
        position.y = 0.0f;
        objRotation.transform.localScale = new Vector3(1, 1, 1);
        objRotation.transform.localEulerAngles = new Vector3(0, 0, 0);
        objRotation.name = "effectFEx";

        GameObject obj = Instantiate(effect) as GameObject;
        obj.transform.parent = objRotation.transform;
        obj.transform.localPosition = new Vector3();
        obj.transform.localEulerAngles = new Vector3(0, 0, 0);

        obj.transform.Translate(position);
        obj.transform.Rotate(rotation);
        obj.transform.localScale = new Vector3(0.3f * scale, 0.3f * scale, 1f);
        if (strAni != null && strAni != "")
        {
            SkeletonAnimation ani = obj.GetComponent<SkeletonAnimation>();
            if (ani != null && ani.state != null && ani.state.FindAnimation(strAni))
            {
                ani.state.SetAnimation(0, strAni, ani.loop);
            }
        }
        ModelShowUtil.resetShader(obj.transform);
        if (color_type > 0)
        {
            SimpleJson.JsonObject jo = TableReader.Instance.TableRowByID("effectcolor", color_type);
            if (jo != null)
            {
                Color col = new Color(jo.num("R") / 255.0f, jo.num("G") / 255.0f, jo.num("B") / 255.0f);
                ModelShowUtil.ChangeSpineSkeletonShader(obj.transform, col);
            }           
        }
        
        DestroyObject(obj, cost);
        DestroyObject(objRotation, cost);
        
        return objRotation;
    }
}
