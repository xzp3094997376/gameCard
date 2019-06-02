using UnityEngine;
using System.Collections;

public class RevertSize : MonoBehaviour {

	
	void Update () {
        if (this.transform.localScale.x == 1f)
        {
            this.transform.localScale = new Vector3(375f, 375f, 375f);
        }
    }
}
