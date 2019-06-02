using UnityEngine;
using System.Collections;
using SLua;
public class MoveLabel : MonoBehaviour
{
    private bool isPlaying = false;
    public UILabel tvLab;
    private LuaFunction callFun;
    public void beginMove(LuaFunction _callFun)
    {
        callFun = _callFun;
        tvLab.transform.localPosition = new Vector3(250, 8, 0);
        targetPos = new Vector3(-tvLab.width - 250, 8, 0);
        isPlaying = true;
    }

    //解析字符串
    public string analysisUrlEncry(string str)
    {
        //if (string.IsNullOrEmpty(str))
        //    return "";
        //return System.Web.HttpUtility.UrlDecode(str);
        return str;
    }

    private Vector3 targetPos = Vector3.one;
    void Update()
    {
        if (isPlaying)
        {
            float dis = Vector3.Distance(tvLab.transform.localPosition, targetPos);
            if (dis <= 0)
            {
                tvLab.transform.localPosition = targetPos;
                isPlaying = false;
                if (callFun != null)
                {
                    callFun.call();
                }
            }
            else
            {
                tvLab.transform.localPosition = Vector3.MoveTowards(tvLab.transform.localPosition, targetPos, Time.deltaTime * 90);
            }
        }
    }
}
