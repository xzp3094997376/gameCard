using UnityEngine;
using System.Collections;

public class BattleEditor : MonoBehaviour {

    public static BattleEditor Inst;
    public int[] m_AtkHero = new int[6];
    public int[] m_DefHero = new int[6];

    public int[] m_Actions = null;

    public int[] m_AtkTarget = null;
    public int[] m_DefTarget = null;

    public bool m_IsHeti = false;

    public int[] m_AtkFriend = null;
    public int[] m_DefFriend = null;



    private int m_AttackIdx = -1;
    private int m_DefendIdx = -1;
    private int m_CurAction = 0;

    void Awake()
    {
        Inst = this;
    }

    // Use this for initialization
    void Start () {
        Invoke("Init", 2.0f);

    }

    void Init()
    {
        FightManager.Inst.InitFight();
        SimpleUI.Ins.ShowBattleRun(false);
        ClientTool.showFighting();

        for (int i = 0; i < m_AtkHero.Length; i++)
        {
            if ( m_AtkHero[i] > 0)
            {
                FightManager.Inst.m_Attacker.LoadSingleHeros(m_AtkHero[i], i, 1000000000, 1000000000, 100);
            }
        }
        for (int i = 0; i < m_DefHero.Length; i++)
        {
            if (m_DefHero[i] > 0)
            {
                FightManager.Inst.m_Defender.LoadSingleHeros(m_DefHero[i], i, 1000000000, 1000000000, 100);
            }
        }
        Invoke("Begin", 1.0f);
    }

    void Begin()
    {
        for (int i = 0; i < m_AtkHero.Length; i++)
        {
            if (m_AtkHero[i] > 0)
            {
                for (int j = 0; j < m_Actions.Length; j++)
                    FightManager.Inst.m_Attacker.m_Heros[i].m_SelfAction.AddAction(m_Actions[j]);
            }

        }
        for (int i = 0; i < m_DefHero.Length; i++)
        {
            if (m_DefHero[i] > 0)
            {
                for (int j = 0; j < m_Actions.Length; j++)
                    FightManager.Inst.m_Defender.m_Heros[i].m_SelfAction.AddAction(m_Actions[j]);
            }
        }
        Next();

    }

    public void Next()
    {
        int len = m_Actions.Length;
        int actionid = m_Actions[m_CurAction % len];
        m_CurAction++;

        if (m_AttackIdx <= m_DefendIdx)
        {
            m_AttackIdx++;
            if (FightManager.Inst.m_Attacker.m_Heros[m_AttackIdx % 6] == null || FightManager.Inst.m_Attacker.m_Heros[m_AttackIdx % 6].m_HP <= 0)
            {
                Next();
                return;
            }

            HeroCtrl[] arr = SelectTarget(FightManager.Inst.m_Defender.m_Heros, AttackType.One);

            if (m_IsHeti)
                FightManager.Inst.m_Attacker.m_Heros[m_AttackIdx % 6].m_SelfAction.StartAction(actionid, arr, 0);
            else
                FightManager.Inst.m_Attacker.m_Heros[m_AttackIdx % 6].m_SelfAction.StartAction(actionid, arr, -1);

        }
        else
        {
            m_DefendIdx++;
            if (FightManager.Inst.m_Defender.m_Heros[m_DefendIdx % 6] == null || FightManager.Inst.m_Defender.m_Heros[m_DefendIdx % 6].m_HP <= 0)
            {


                Next();
                return;
            }

            HeroCtrl[] arr = SelectTarget(FightManager.Inst.m_Attacker.m_Heros, AttackType.One);
            if (m_IsHeti)
                FightManager.Inst.m_Defender.m_Heros[m_AttackIdx % 6].m_SelfAction.StartAction(actionid, arr, 0);
            else
                FightManager.Inst.m_Defender.m_Heros[m_AttackIdx % 6].m_SelfAction.StartAction(actionid, arr, -1);
        }

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
            int rd = ((int)(Random.value * lives.Count)) % lives.Count;
            HeroCtrl[] arr = new HeroCtrl[1];
            arr[0] = (HeroCtrl)lives[rd];
            return arr;
        }
        if (type == AttackType.Col)
        {
            int rd = ((int)(Random.value * lives.Count)) % lives.Count;
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
            int rd = ((int)(Random.value * lives.Count)) % lives.Count;
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

    // Update is called once per frame
    void Update () {
	
	}
}
