using UnityEngine;
using System.Collections;

public class LifeBar : MonoBehaviour {

    public float m_fData = 1;
    public MeshRenderer m_Mesh = null;
    //public float m_fTime = 1.0f;
    //public float m_fCount = 999;
	// Use this for initialization
	void Start () {
        m_Mesh = this.GetComponent<MeshRenderer>();

       //SetPecent(Random.value);

        int j = 0;
        j++;
	}

    public void SetPercent(float fdata) {
        //MyDebug.Log("point: " + fdata);
        float temp = 1.0f - (fdata / 2.0f);
        if (temp < 0)
        {
            temp = 0;
        }
        m_Mesh.material.SetTextureOffset("_MainTex", new Vector2(temp, 0.0f)); 
    }
	// Update is called once per frame
	void Update () {
        
	}
}
