using UnityEngine;
using System.Collections;

public class Destory : MonoBehaviour {
    public float m_fLastTime = 4.0f;
	// Use this for initialization
	void Start () {
        DestroyObject(gameObject, m_fLastTime);
	}
	
	// Update is called once per frame
	void Update () {

	}
}
