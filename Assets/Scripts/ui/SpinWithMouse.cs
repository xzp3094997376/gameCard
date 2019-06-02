/*************************************************************************************
* CLR 版本：       4.0.30319.34014
* 类 名 称：       SpinWithMouse
* 机器名称：       SHEN
* 命名空间：       Assets.Scripts.bleach.modules.createModule
* 文 件 名：       SpinWithMouse
* 创建时间：       2014/6/19 10:23:02
* 作    者：       Oliver shen
* 说    明：
* 修改时间：
* 修 改 人：
*************************************************************************************/
using UnityEngine;
using System.Collections;

public class SpinWithMouse : MonoBehaviour
{
    public Transform target;
    public float speed = 1f;

    private bool canMove = false;
    Transform mTrans;

    void Start()
    {
        mTrans = transform;
    }

    //void OnDragStart()
    //{
    //    if (!enabled) return;
    //    canMove = true;
    //}
    void OnDrag(Vector2 delta)
    {
        //if (canMove == false) return;
        UICamera.currentTouch.clickNotification = UICamera.ClickNotification.None;

        if (target != null)
        {
            target.localRotation = Quaternion.Euler(0f, -0.5f * delta.x * speed, 0f) * target.localRotation;
        }
        else
        {
            mTrans.localRotation = Quaternion.Euler(0f, -0.5f * delta.x * speed, 0f) * mTrans.localRotation;
        }
    }
    //void OnDragOut()
    //{
    //    canMove = false;
    //}
}