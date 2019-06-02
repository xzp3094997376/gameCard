using UnityEngine;
using System.Collections;

public class AutoDestroy : MonoBehaviour
{

    public bool autoDestroy = true;
    public float delay = 1f;
	void Start () {
	    if(autoDestroy && delay > 0)
            Invoke("AutoD", delay);
	}

    void AutoD()
    {
        DestroyImmediate(gameObject);
    }
}
