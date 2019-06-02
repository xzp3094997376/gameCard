using UnityEngine;
using System.Collections;

public class TimeCtrl : MonoBehaviour {

	// Use this for initialization

    public float m_Delay = 0;
    public float m_Last = 0;
    public float m_Rate = 0;
	void Start () {

        Invoke("CallNext", m_Delay);
	}

    void CallNext()
    {
        Time.timeScale = m_Rate;
        Invoke("Cancel", m_Last * m_Rate);
    }
    void Cancel()
    {
        Time.timeScale = 1;
    }
	// Update is called once per frame
	void Update () {
	
	}
}
