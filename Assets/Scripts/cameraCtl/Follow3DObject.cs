using UnityEngine;
using System.Collections;

public class Follow3DObject : UIFollowTargetCtrl
{
    GameObject child;
    private Transform m_CameraTransform = null;
    public float autoHide = 80;
    void Start()
    {
        transform.Find("");
        if (target != null)
        {
            if (gameCamera == null) gameCamera = NGUITools.FindCameraForLayer(target.gameObject.layer);
            if (uiCamera == null) uiCamera = NGUITools.FindCameraForLayer(gameObject.layer);
            m_CameraTransform = gameCamera.transform;
            SetVisible(false);
        }
        else
        {
            MyDebug.LogError("Expected to have 'target' set to a valid transform", this);
            enabled = false;
        }
        if(transform.childCount > 0)
            child = transform.GetChild(0).gameObject;
    }
    protected override void SetVisible(bool val)
    {
        mIsVisible = val;         
    }
    protected override void OnUpdate(bool isVisible)
    {
        if (child)
        {
            if (Vector3.Distance(m_CameraTransform.position, target.position) > autoHide)
            {
                isVisible = false;
            }
            
            child.SetActive(isVisible);

        }
    }
}
