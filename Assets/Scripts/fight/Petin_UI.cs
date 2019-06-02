using UnityEngine;
using System.Collections;

public class Petin_UI : MonoBehaviour {
    public GameObject atk_obj;
    public GameObject def_obj;
	// Use this for initialization
	void Start () {
        
    }

    public void SetAtk()
    {
        atk_obj.gameObject.SetActive(true);
    }

    public void SetDef()
    {
        def_obj.gameObject.SetActive(true);
    }

    // Update is called once per frame
    void Update () {
	
	}
}
