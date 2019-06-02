using UnityEngine;
using System.Collections;

public class ModelCamera : MonoBehaviour
{
    public GameObject modelParent;
    //public GameObject eff_lv_up;
    //public GameObject eff_power_up_tip;
    public GameObject sunshine;
    public GameObject yuantai;
    //public GameObject eff_section_one;
    //public GameObject eff_section_two;
    //public GameObject eff_section_three;
    void Start()
    {
        if (modelParent == null)
        {
            modelParent = NGUITools.AddChild(gameObject);
            modelParent.transform.localPosition = new Vector3(0, -6.6f, 18);   //(0, -1.4, 6)
        }
    }
    public void Clear()
    {
        Transform mTran = modelParent.transform;
        for (int i = mTran.childCount - 1; i >= 0; i--)
        {
            GameObject.Destroy(mTran.GetChild(i).gameObject);
        }
    }
    public void HideAll()
    {
        Transform mTran = modelParent.transform;
        for (int i = mTran.childCount - 1; i >= 0; i--)
        {
            mTran.GetChild(i).gameObject.SetActive(false);
        }
    }
}
