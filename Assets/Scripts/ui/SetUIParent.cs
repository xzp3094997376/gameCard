using UnityEngine;
using System.Collections;

//create by Hanyi on 2015.1.6
public class SetUIParent : MonoBehaviour
{
    public UIWidget target;
    public int up = 0;
    public int down = 0;
    public int left = 0;
    public int right = 0;

    void Start()
    {
        StartCoroutine(Set());
    }

    IEnumerator Set()
    {
        //yield return 1;
        if (target == null) target = transform.GetComponent<UIWidget>();
        if (target)
        {
            GameObject go = transform.parent.gameObject;
            if (go)
            {
                target.SetAnchor(go, left, down, right, up);
            }
        }
        yield return null;
    }
}
