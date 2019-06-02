using UnityEngine;
using SimpleJson;
using System.Collections;

public class BattleIn : MonoBehaviour {

    public UILabel m_TxtDes = null;
    public GameObject m_EffName = null;
    public TweenPosition m_mo = null;
    public GameObject m_des = null;
    private TweenPosition[] m_tweenObject;
	private TweenAlpha[] m_alphaObject;
    private GameObject effctName;
    public UISprite chiLun;
    public UIWidget renderOrder;

    // Use this for initialization
    void Start () {
        m_tweenObject = this.GetComponentsInChildren<TweenPosition>();
		m_alphaObject = this.GetComponentsInChildren<TweenAlpha>();
        this.gameObject.SetActive(false);
    }
	
	// Update is called once per frame
	void Update () {
        if(m_mo.position.y < 360)
        {
            m_des.SetActive(true);
			if(m_mo.position.y < -160)
			{
	            if(effctName != null)
	            {
	                StartCoroutine(EffectNameShow(0.1f));
	            }
			}
        }
	    
	}

    IEnumerator EffectNameShow(float time)
    {
        yield return new WaitForSeconds(time);
        if (effctName != null)
        {
            effctName.SetActive(true);
        }
		yield return new WaitForSeconds(0.5f);
		chiLun.gameObject.SetActive(true);
	}
	
	void OnEnable()
    {	
		chiLun.gameObject.SetActive(false);
        if (m_tweenObject == null) return;
        foreach (var tween in m_tweenObject)
        {
            tween.ResetToBeginning();
            tween.PlayForward();
        }
		m_des.SetActive(false);
		if (m_alphaObject == null) return;
		foreach (var tween in m_alphaObject)
		{
			tween.ResetToBeginning();
			tween.PlayForward();
		}
	}


    public void Init(int playerid,float lastTime)
    {	
        JsonObject mon = TableReader.Instance.TableRowByID("avatar", playerid);

        string strentername = mon.str("enter_name");
        int partyName = mon.num("party");
        GameObject eobj = LoadManager.getInstance().GetEffect(strentername);
        Debug.Log("strentername  "+ strentername);
        effctName = Instantiate(eobj, m_EffName.gameObject.transform.position + new Vector3(0, 0.1f, 0), m_EffName.gameObject.transform.rotation) as GameObject;

        RenderQueueModifier renderModifier = effctName.AddComponent<RenderQueueModifier>();
        renderModifier.m_type = RenderQueueModifier.RenderType.FRONT;
        renderModifier.m_target = renderOrder;

        effctName.transform.parent = gameObject.transform;
        NGUITools.SetLayer(effctName, gameObject.layer);
        strentername = mon.str("show_title");
        m_TxtDes.text = strentername;

        chiLun.spriteName = "party" + partyName.ToString();
        effctName.SetActive(false);
        if(lastTime >= 0)
        {
            DestroyObject(effctName, lastTime);
        }
    }


}
