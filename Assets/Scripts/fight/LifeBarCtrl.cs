using UnityEngine;
using System.Collections;
/***
 * 描述：控制血条 能量槽播放
 * 
 * 
 * */
public class LifeBarCtrl : MonoBehaviour {

	// Use this for initialization

    public Transform m_Fuel;
    public Transform m_Life;
    public UILabel m_LabelName;
    public GameObject fuelObj;

    float m_LifeTarget = 1;
    float m_FuelTarget = 0;
    public float m_Speed = 0.04f;
    //public UIAtlas m_BattleAtlas;
    public UIGrid m_BuffGrid ;
    public bool m_IsBoss = false;  //boss专用血条
	void Start () {

	}

    /// <summary>
    /// 初始化血条状态
    /// </summary>
    /// <param name="life"></param>
    /// <param name="fuel"></param>
	public void InitState(float life=1, float fuel=0){
        life = Mathf.Min(1, life);
        m_Life.localScale = new Vector3(life, 1, 1);
        m_LifeTarget = life;
        fuel = Mathf.Min(1, fuel);
        m_Fuel.localScale = new Vector3(fuel, 1, 1);
        m_FuelTarget = fuel;
        if (!m_IsBoss) setFuelObjState(m_FuelTarget);
        //gameObject.SetActive(true);
    }

    public void SetName(string name)
    {
        m_LabelName.text = name;
    }

    void setFuelObjState(float fuel)
    {
        if (fuelObj == null) return;

        if ( fuel == 1 )
        {
            fuelObj.SetActive(true);
        }
        else
        {
            fuelObj.SetActive(false);
        }
    } 

    public void SetLife(float life){
       // m_Life.localScale = new Vector3(life, 1, 1);
        life = Mathf.Min(1, life);
        m_LifeTarget = life;
        //gameObject.SetActive(true);
    }

    public void SetFuel(float fuel)
    {
        //m_Fuel.localScale = new Vector3(fuel, 1, 1);
        fuel = Mathf.Min(1, fuel);
        m_FuelTarget = fuel;
        setFuelObjState(m_FuelTarget);
    }

    public Transform AddBuff(string buff_name)
    {
        GameObject gobj = ClientTool.load("Prefabs/moduleFabs/battleModule/buff_icon");
        gobj.transform.position = transform.position + new Vector3(0, -0.6f, 0);
        m_BuffGrid.AddChild(gobj.transform);
        gobj.transform.localScale = Vector3.one;
        UISprite sprite = gobj.GetComponent<UISprite>();

        sprite.spriteName = buff_name;
        return gobj.transform;
    }
    public void RemoveBuff(Transform sonBuff)
    {
        m_BuffGrid.RemoveChild(sonBuff);
        DestroyObject(sonBuff.gameObject);
    }
	// Update is called once per frame
	void Update () {
        if (m_Fuel.localScale.x != m_FuelTarget)
        {
            float dec = m_FuelTarget - m_Fuel.localScale.x;
            if (dec < 0)
                dec = -Mathf.Min(-dec, m_Speed);
            else dec = Mathf.Min(dec, m_Speed);

            dec = m_Fuel.localScale.x + dec;
            if (dec < 0)
                dec = 0f;
            m_Fuel.localScale = new Vector3(dec, 1, 1);
        }

        if (m_Life.localScale.x != m_LifeTarget)
        {
            float dec = m_LifeTarget - m_Life.localScale.x;
            if (dec < 0)
                dec =  -Mathf.Min(-dec, m_Speed);
            else dec = Mathf.Min(dec, m_Speed);

            dec = m_Life.localScale.x + dec;
            if (dec < 0)
                dec = 0.0f;
            m_Life.localScale = new Vector3(dec, 1, 1);
            if (m_Life.localScale.x <= 0)
                gameObject.SetActive(false);
        }
	}
}
