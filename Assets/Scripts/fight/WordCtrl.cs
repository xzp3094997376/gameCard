using UnityEngine;
using System.Collections;

public class WordCtrl : MonoBehaviour {

	// Use this for initialization
    public Transform m_transform= null;
    public Transform m_cameraTransform = null;
	void Start () {
        m_transform = this.transform;
        m_cameraTransform = Camera.main.transform;
	}
	
	// Update is called once per frame
	void Update () {
        Vector3 rot = new Vector3();
        rot.y = m_cameraTransform.eulerAngles.y;
        rot.x = m_cameraTransform.eulerAngles.x;
        m_transform.eulerAngles = rot;
	}
}
