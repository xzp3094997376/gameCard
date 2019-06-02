using UnityEngine;
using System.Collections;

public class AutoPlayAnimation : MonoBehaviour {
    public GameObject ani;
    public string clipName;
    public float afterTime;
	void Start () 
    {
        Invoke("play", afterTime);
	}
    void play()
    {
        ClientTool.PlayAnimation(ani, clipName, null, true);
    }
	
}
