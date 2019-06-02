using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SimpleJson;
public class BuffInfo
{
    public GameObject buffObject = null;
    public JsonObject data = null;
    public Transform icon = null;
}

public enum BodyLight
{
    Light,
    Black,
    Gold
}
public class HeroBuffMgr : MonoBehaviour
{

    // Use this for initialization

    Dictionary<int, BuffInfo> m_Buffs = new Dictionary<int, BuffInfo>();

    public HeroCtrl m_SelfCtrl = null;
    public BodyLight m_SelfLight = BodyLight.Light;
    void Start()
    {
        if (m_SelfCtrl == null)
        {
            m_SelfCtrl = gameObject.GetComponent<HeroCtrl>();
        }
    }

    public void AddBuff(int sid)
    {
        if (m_Buffs.ContainsKey(sid))
        {
            RemoveBuff(sid);
        }
        JsonObject tableData = TableReader.Instance.TableRowByID("state", sid);
        if (tableData == null)
            return;
        BuffInfo info = new BuffInfo();
        info.data = tableData;

        if (string.IsNullOrEmpty(tableData.str("effect")) == false)
        {
            CreateBuffEffect(tableData.str("effect"), info);
        }
        else
        {
            if (m_SelfCtrl == null)
            {
                m_SelfCtrl = gameObject.GetComponent<HeroCtrl>();
            }
            info.icon = m_SelfCtrl.m_LifeBar.AddBuff(tableData.str("icon"));
        }

        m_Buffs[sid] = info;
    }

    void CreateBuffEffect(string effect_name, BuffInfo info)
    {
        if (m_SelfCtrl == null || m_SelfCtrl.m_Hero == null || m_SelfCtrl.m_HP <= 0)
        {
            return;
        }
        LoadManager.getInstance().LoadSceneEffect(effect_name, (pram) =>
        {
            if (m_SelfCtrl == null || m_SelfCtrl.m_Hero == null || m_SelfCtrl.m_HP <= 0)
            {
                return;
            }
            GameObject effobj = pram.assetbundle.LoadAsset(effect_name, typeof(GameObject)) as GameObject;
            GameObject eff = Instantiate(effobj) as GameObject;
            if (eff == null)
            {
                if (effect_name == "black")
                {
                    m_SelfLight = BodyLight.Black;
                }
                else if (effect_name == "gold")
                {
                    m_SelfLight = BodyLight.Gold;
                }
                return;
            }
            ModelShowUtil.CompleteRenderMaterialShader(eff);
            
            eff.transform.parent = m_SelfCtrl.m_Hero.transform;
            eff.transform.localPosition = new Vector3(0.0f, 5.0f, 0.0f);
            eff.transform.position = eff.transform.position - new Vector3(0, 0, 0.1f);
            eff.transform.localEulerAngles = Vector3.zero;
            eff.transform.localScale = new Vector3(1.0f, 1.0f, 1.0f);
            info.buffObject = eff;
        });
    }
    public void RemoveBuff(int sid)
    {
        if (m_Buffs.ContainsKey(sid))
        {
            if (m_Buffs[sid] != null)
            {
                DestroyObject(m_Buffs[sid].buffObject);
                if (m_Buffs[sid].data.str("effect") == "black")
                {
                    if (m_SelfLight == BodyLight.Black)
                    {
                        m_SelfCtrl.SetShaderColorAndRim(0, Color.white, Color.yellow);
                        m_SelfLight = BodyLight.Light;
                    }
                }
                else if (m_Buffs[sid].data.str("effect") == "gold")
                {
                    if (m_SelfLight == BodyLight.Gold)
                    {
                        m_SelfCtrl.SetShaderColorAndRim(0, Color.white, Color.white);
                        m_SelfLight = BodyLight.Light;
                    }
                }
                if (m_Buffs[sid].icon != null)
                    m_SelfCtrl.m_LifeBar.RemoveBuff(m_Buffs[sid].icon);
            }

            m_Buffs.Remove(sid);
        }
    }

    public void ClearAllBuff()
    {
        foreach (var item in m_Buffs)
        {
            if (item.Value != null)
            {
                DestroyObject(item.Value.buffObject);
                if (item.Value.icon != null)
                    m_SelfCtrl.m_LifeBar.RemoveBuff(item.Value.icon);
            }
        }
        m_Buffs.Clear();
        if (m_SelfCtrl)
            m_SelfCtrl.SetShaderColorAndRim(0, Color.white, Color.white);
        m_SelfLight = BodyLight.Light;
    }
    // Update is called once per frame
    void Update()
    {
        if (m_SelfLight == BodyLight.Gold)
        {
            m_SelfCtrl.SetShaderColorAndRim(1, Color.white, new Color(1, 0.968f, 0.2f, 1));

        }
        else if (m_SelfLight == BodyLight.Black)
        {
            m_SelfCtrl.SetShaderColorAndRim(0, new Color(0.88f, 0, 1, 1), Color.white);
        }
    }
}
