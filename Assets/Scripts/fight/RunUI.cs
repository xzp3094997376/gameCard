using UnityEngine;
using System.Collections;
using DataModel;
public class RunUI : MonoBehaviour {

	// Use this for initialization
    public UILabel m_TxtRound = null;
    public LifeBarCtrl m_LifeBar = null;
    public UILabel m_TextCount = null;
    public UILabel m_TextTotal = null;

    public GameObject m_Lianjisz = null;
    public UILabel m_TextTotalHurt = null;
    public UILabel m_TextTotalLianji = null;
    private int m_nHurt = 0;
    private int m_nLianji = 0;

    public UIButton m_BtnSprite = null;

    //加速相关的tips
    public UILabel m_Tips = null;
    public TweenAlpha m_AniAlpha = null;
    public int m_SpeedLevel = 0;
    public float[] m_Speeds = new float[] {1.0f, 1.5f, 2.0f };
    public static RunUI Ins = null;
    void Awake()
    {
        Ins = this;
    }
	void Start () {
     //   m_BtnSprite.isEnabled = false;
        if (FightManager.Inst.m_IsNewBie)
        {
            m_BtnSprite.gameObject.SetActive(false);
            return;
        }
        m_SpeedLevel = PlayerPrefs.GetInt("FightSpeed");
        m_AniAlpha.value = 0;
        SetGameSpeed(m_SpeedLevel);
	}
    public void SetRound(string str){
        m_TxtRound.text = str;
    }
    public void OnClickBTN()
    {
        if (FightManager.Inst.m_IsNewBie)
        {
            TranslateScripts.Inst.ToEnd();
        }
        else
        {
            TranslateBattleII.Inst.ToEnd();
            //SimpleUI.Ins.CheckGameResult();
        }
        
        return;
    }

    public void AddHurtNum(int hurt)
    {
        m_nHurt = m_nHurt + hurt;
        m_nLianji++;
        if (m_nLianji < 2)
        {
            return;
        }
        m_Lianjisz.SetActive(true);
        m_TextTotalHurt.text = "-" + m_nHurt.ToString();
        m_TextTotalLianji.text = "-" + m_nLianji.ToString();

    }
    public void ClearHurtNum()
    {
        m_nHurt = 0;
        m_nLianji = 0;
        m_Lianjisz.SetActive(false);
    }

    public void OnClickSpeed()
    {
        //m_Tips.text = "VIP3或者40级开启X3";
        ////m_AniAlpha.value = 1;
        //m_AniAlpha.ResetToBeginning();
        //m_AniAlpha.PlayForward();
        ////UITooltip.Show("fuck!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        //speedlv = (speedlv + 1) % 3;
        //int num = speedlv + 1;
        if (FightManager.Inst.m_IsBattleEditor)
        {
            m_SpeedLevel++;
            m_SpeedLevel %= 3;
            PlayerPrefs.SetInt("FightSpeed", m_SpeedLevel);
            SetGameSpeed(m_SpeedLevel);
            return;
        }

        int lv = m_SpeedLevel;
        if (lv == 0)
        {
            MStruct mst = MPlayer2.Instance.getStruct("Info");
            int playerLv = mst.getInt("level");
            int vip = mst.getInt("vip");
            int needLV = TableReader.Instance.TableRowByID("systemConfig", "x2_lv").num("value");
            int needVIP = TableReader.Instance.TableRowByID("systemConfig", "x2_viplv").num("value");
            if (playerLv < needLV && vip < needVIP)
            {
				string msg = Localization.Get ("LocalKey_849");
				msg=msg.Replace ("{0}", needVIP.ToString());
				m_Tips.text = msg.Replace ("{1}", needLV.ToString());
                m_AniAlpha.ResetToBeginning();
                m_AniAlpha.PlayForward();
                return;
            }
            lv++;
        }
        else if (lv == 1)
        {
            MStruct mst = MPlayer2.Instance.getStruct("Info");
            int playerLv = mst.getInt("level");
            int vip = mst.getInt("vip");
            int needLV = TableReader.Instance.TableRowByID("systemConfig", "x3_lv").num("value");
            int needVIP = TableReader.Instance.TableRowByID("systemConfig", "x3_viplv").num("value");
            if (playerLv < needLV && vip < needVIP)
            {
				string msg = Localization.Get ("LocalKey_850");
				msg=msg.Replace ("{0}", needVIP.ToString());
				m_Tips.text = msg.Replace ("{1}", needLV.ToString());
                m_AniAlpha.ResetToBeginning();
                m_AniAlpha.PlayForward();

                lv = 0;
            }
            else lv++;
        }
        else
        {
            lv = 0;
        }
        m_SpeedLevel = lv;

        PlayerPrefs.SetInt("FightSpeed", lv);
        SetGameSpeed(lv);
        //EffectManager.Instance.ModifySpeed(3);
    }

    private void SetGameSpeed(int lv)
    {
        EffectManager.Instance.ModifySpeed(m_Speeds[lv]);
        m_BtnSprite.normalSprite = "zhandou_" + (lv + 1) + "bei";
    }

    public void  UpdateBattleCount(int count, int total)
    {
        if (m_TextCount.gameObject.activeSelf == false)
        {
            m_TextCount.gameObject.SetActive(true);
            m_TextTotal.gameObject.SetActive(true);
        }

        m_TextCount.text = count.ToString();
        m_TextTotal.text = "/" + total.ToString();
    }
    public void ModifyClickBtnLater(float val)
    {
        if (gameObject != null)
        {
            Invoke("CallModifyClickBtn", val);
        }
    }
    public void CallModifyClickBtn()
    {
        ModifyClickBtn(true);
    }
    public void ModifyClickBtn(bool show)
    {
        Transform tran = transform.Find("btn_end");
        if (tran != null)
        {
            tran.gameObject.SetActive(show);
        }
    }
    
	// Update is called once per frame
	void Update () {
#if UNITY_EDITOR
        if (Input.GetKeyUp(KeyCode.A)) {
            OnClickBTN();
        }
#endif
	}
}
