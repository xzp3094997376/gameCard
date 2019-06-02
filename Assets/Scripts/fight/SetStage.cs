using UnityEngine;
using System.Collections;

public class SetStage : MonoBehaviour {

	// Use this for initialization

    public UISprite m_Current = null;
    public UISprite m_Total = null;
    public Animator m_Animator = null;
	void Start () {
        //SetRounds(1,3);
	}

    public void SetRounds(int cur, int total)
    {

        m_Current.spriteName = cur.ToString();
        m_Total.spriteName = total.ToString();
        m_Animator.enabled = true;
        m_Animator.Play("stage1-1");
        DestroyObject(gameObject, 1.30f);
    }
	
	// Update is called once per frame
	void Update () {
	
	}
}
