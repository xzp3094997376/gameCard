using UnityEngine;
using System.Collections;

/**
 * 说明：管理游戏机制里面一些效果的控制
 * 
 * 
 * */
public class EffectManager : MonoBehaviour
{

    public static EffectManager Instance = null;
    public GameObject m_2DSprite = null;        //2d插画对象  目测需求以及移除
    public GameObject m_SpeedLine = null;       //速度线控制
    public GameObject m_Scene = null;           //整个场景
    public float m_GameSpeed = 1.0f;

    public GameObject m_CameraObject = null;
    float m_lastRate = 0;
    float m_cost = 0;

    public GameObject m_Plane = null;
    // Use this for initialization
    void Awake()
    {
        Instance = this;
       // int speed = PlayerPrefs.GetInt("FightSpeed");
       // m_SpeedLevel = speed;
        //ModifySpeed(m_SpeedLevel + 1);
    }
    void OnDestory()
    {
        Time.timeScale = 1;
    }
    /// <summary>
    /// 弹出2d人物移动动画
    /// </summary>
    /// <param name="str">播放移动动画的名字 normal special</param>
    /// <param name="isOpposite">是否反转播放</param>
    public void ShowSkillPictrue(string str, bool isOpposite = true)
    {
        
    }
    /// <summary>
    /// 设置全局的速度
    /// </summary>
    /// <param name="speed"></param>
    public void ModifySpeed( float speed)
    {
        float last = m_GameSpeed;
        m_GameSpeed *= speed / last;
        Time.timeScale = m_GameSpeed;
    }
    public void SpeedScaleDelay(float rate, float cost, float delay)
    {
        if (m_lastRate > 0)
            return;
        m_GameSpeed *= rate;
        m_lastRate = rate;
        m_cost = cost;
        Invoke("StartSpeedScale", delay);
    }

    void StartSpeedScale()
    {
        Time.timeScale = m_GameSpeed;
        float cost = m_cost * m_GameSpeed;
        Invoke("CancelSpeed", cost);
    }
    /// <summary>
    /// 游戏速度按比例缩放
    /// </summary>
    /// <param name="rate">缩放比例</param>
    /// <param name="cost">缩放持续时间</param>
    public void SpeedScale(float rate, float cost)
    {
        if (m_lastRate > 0)
            return;
        m_GameSpeed *= rate;
        m_lastRate = rate;
        Time.timeScale = m_GameSpeed;


        cost *= m_GameSpeed;
        Invoke("CancelSpeed", cost);
    }
    /// <summary>
    /// 取消速度播放
    /// </summary>
    void CancelSpeed()
    {
        m_GameSpeed /= m_lastRate;
        m_lastRate = 0;
        Time.timeScale = m_GameSpeed;
    }

    /// <summary>
    /// 显示速度线
    /// </summary>
    /// <param name="cost">消耗的时间</param>
    public void ShowSpeedLine(float cost, string strName = "")
    {
        if (m_SpeedLine == null)
        {
            GameObject new_obj = ClientTool.load("prefab/dazao");
            if (!new_obj) return;
            new_obj.transform.parent = FightManager.Inst.transform;
            new_obj.transform.localPosition = new Vector3(0, -0.01f, 0);
            new_obj.transform.localEulerAngles = new Vector3(270, 0, 0);
            new_obj.transform.localScale = new Vector3(3, 3, 3);
            m_SpeedLine = new_obj;
            m_Scene = GameObject.Find("scene");
            if(m_Scene == null)
                m_Scene = GameObject.Find("sence");
            if(m_Scene == null)
                m_Scene = GameObject.Find("scene(Clone)");
        }
        if(m_Scene != null)
            m_Scene.gameObject.SetActive(false);
        m_SpeedLine.gameObject.SetActive(true);
        Invoke("HideSpeedLine", cost);
    }
    /// <summary>
    /// 停掉速度线
    /// </summary>
    void HideSpeedLine()
    {
        m_Scene.gameObject.SetActive(true);
        m_SpeedLine.gameObject.SetActive(false);
        if (m_Plane != null)
            m_Plane.SetActive(false);
    }
    /// <summary>
    /// 旧版本的显示2d图片 已经遗弃
    /// </summary>
    /// <param name="cost"></param>
    public void ShowPicture(float cost)
    {
        if (m_2DSprite == null)
        {
            GameObject obj = Resources.Load<GameObject>("prefab/pricture");
            Transform trans = Camera.main.transform;
            GameObject new_obj = Instantiate(obj, trans.position, trans.rotation) as GameObject;
            new_obj.transform.parent = Camera.main.transform;
            new_obj.transform.Translate(0, 0, 4);
            m_2DSprite = new_obj;
        }
        else
        {
            m_2DSprite.gameObject.SetActive(true);
        }

        Invoke("HidePicture", cost);
    }
    void HidePicture()
    {
        m_2DSprite.gameObject.SetActive(false);
    }
    // Update is called once per frame
    void Update()
    {

    }
}
