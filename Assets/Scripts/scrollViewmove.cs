using UnityEngine;
using System.Collections;


public class scrollViewmove : MonoBehaviour {

    public float moveSpeeed = 0f;
    public float delay = 0f;
    public float cellWidth = 200f;
    public UIScrollView view = null;
    protected bool isStart = false;
    public int itemCount = 0;
    protected bool isLeft = true;

    // Use this for initialization
    void Start() {
        this.Invoke("setTimeStart", delay);
    }

    // Update is called once per frame
    void Update() {
        if (isStart == true)
        {
            if (itemCount == 0)
            {
                itemCount = transform.GetChild(0).childCount;
                Debug.Log(itemCount);
            }
            if (isLeft == true)
            {
                view.MoveRelative(new Vector3(-moveSpeeed, 0, 0));
                if (transform.localPosition.x <= -itemCount * cellWidth)
                {
                    isLeft = false;
                }
            }
            else
            {
                view.MoveRelative(new Vector3(moveSpeeed, 0, 0));
                if (transform.localPosition.x >=0)
                {
                    isLeft = true;
                }

            }

        }

    }
    void setTimeStart()
    {
        isStart = true;
    }
}
