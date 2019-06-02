using UnityEngine;
using System.Collections;

public class MoveUp : MonoBehaviour {

	// Use this for initialization
    float sstart = 0;
    float target = 0;
    float count = 0;
    float total = 0;
	void Start () {
	
	}

    public void MoveToUp(float nLen, float cost)
    {
        sstart = transform.localPosition.y;
        target = nLen;
        total = cost;
        count = 0;
    } 
	
	// Update is called once per frame
	void Update () {
        if (count >= total)
            return;

        count += Time.deltaTime;
        count = Mathf.Min(count, total);
        transform.localPosition = new Vector3(transform.localPosition.x, sstart + count * target / total, 0);
	}
}
