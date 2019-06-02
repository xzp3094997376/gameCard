/*************************************************************************************
 * 类 名 称：       SetBoxCollider
 * 命名空间：       Assets.Scripts.ui
 * 创建时间：       2014/10/9 16:13:24
 * 作    者：       Oliver shen
 * 说    明：       
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;

public class SetBoxCollider : MonoBehaviour
{

    // Use this for initialization
    BoxCollider _mBoxCollider;
    void Start()
    {
        _mBoxCollider = GetComponent<BoxCollider>();
        if (_mBoxCollider == null)
        {
            _mBoxCollider = gameObject.AddComponent<BoxCollider>();
        }
        _mBoxCollider.size = new Vector3(Screen.width, Screen.height, 1);
    }

}
