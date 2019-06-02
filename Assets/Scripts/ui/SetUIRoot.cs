/*************************************************************************************
 * 类 名 称：       SetUIRoot
 * 命名空间：       Assets.Scripts.ui
 * 创建时间：       2014/9/1 20:00:38
 * 作    者：       Oliver shen
 * 说    明：       给Anchors加入UIRoot节点
 * 最后修改时间：
 * 最后修改人：
 * 曾修改人：
*************************************************************************************/
using UnityEngine;
using System.Collections;

public class SetUIRoot : MonoBehaviour
{
    public UIRect target;
    public int up = 0;
    public int down = 0;
    public int left = 0;
    public int right = 0;
    public bool syncBox = true;
    public bool isParentRoot = false;
    void Awake()
    {
        if (target == null) target = GetComponent<UIRect>();
        if (target)
        {
            var root = GlobalVar.Root;
            if (isParentRoot)
            {
                root = null;
            }
            if (root)
            {
                //Vector2 screen = NGUITools.screenSize;
                //float aspect = screen.x / screen.y;
                //int w = Mathf.RoundToInt(root.activeHeight * aspect);
                //int l = (w - root.manualWidth)/2 + 1;
                //int t = (root.activeHeight - root.manualHeight) / 2 + 1;
                //target.SetAnchor(root.gameObject, left + l, down + t, right - l, up - t);
                target.SetAnchor(root.gameObject, left - 1, down - 1, right + 1, up + 1);
            }
        }
    }
    void Start()
    {
        //if (target == null) target = GetComponent<UIRect>();
        //if (target)
        //{
        //    var root = GlobalVar.UI;
        //    if (root)
        //    {
        //        //target.SetAnchor(GlobalVar.UI);
        //        target.SetAnchor(GlobalVar.UI, 0, 0, 0, 0);
        //        StartCoroutine(removeAnchor());
        //    }
        //}
        if (isParentRoot)
        {
            var root = GetComponentInParent<UIPanel>().gameObject;
            if (root)
            {
                target.SetAnchor(root, left - 1, down - 1, right + 1, up + 1);
            }
        }

        if (syncBox) {
            var box = GetComponent<BoxCollider>();
            if (box) { 
                var widget = GetComponent<UIWidget>();
                box.size = new Vector3(widget.width, widget.height, 1);
            }
        }
        
    }

    IEnumerator removeAnchor()
    {
        yield return new WaitForFixedUpdate();
        target.SetAnchor(null,0,0,0,0);
    }
}
