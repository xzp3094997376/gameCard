using UnityEngine;
using System.Collections;
/**
 * 说明：贝瑟尔曲线的运动，只支持最多三个顶点的移动
 * 用例：
 * 给物件添加对象，然后调用MoveTo
 * */

public class BezierMove : MonoBehaviour {

	// Use this for initialization

    public Vector3 m_StartPos = new Vector3();
    public Vector3 m_MidPos = new Vector3();
    public Vector3 m_EndPos = new Vector3();
    public Vector3 m_FinalPos = new Vector3();

    public float m_CountTime = 0;
    public float m_TotalTime = 0;
    public Vector3[] m_Points;
   
	void Start () {
        //MoveTo(new Vector3(0.5f, 0.5f, -8) ,new Vector3(-8.6f, 2.9f, -4.7f),  1);
	}
	/// <summary>
    /// 贝舍尔曲线移动至目标 B(t)=(1-t)平方P0+2t(1-t)P1+t平方P2,0<=t<=1
	/// </summary>
	/// <param name="points">贝瑟尔曲线参考点</param>
	/// <param name="UseTime">走完路线的耗时</param>
    public void MoveTo(Vector3[] points,float UseTime)
    {
        if (points.Length < 0 || points.Length > 3)
        {
            MyDebug.Log("invalid use in bizer");
            return;
        }
        m_Points = new Vector3[points.Length+1];
        m_Points[0] = transform.position;
        for(int i=0; i<points.Length; i++){
            m_Points[i + 1] = points[i];
        }
        m_CountTime = 0;
        m_TotalTime = UseTime;

    }
    /// <summary>
    /// 错误的求C方法 对于小于3时正确
    /// </summary>
    /// <param name="a"></param>
    /// <param name="b"></param>
    /// <returns></returns>
    int C(int a, int b)
    {
        a *= b;
        if (a <= 0)
            a = 1;
        return a;
    }
	// Update is called once per frame
	void Update () {
        if (m_CountTime >= m_TotalTime)
        {
           //MoveTo(m_EndPos, m_MidPos, 0.5f);
            return;
        }
            
        //MyDebug.Log(m_CountTime);
        m_CountTime += Time.deltaTime;
        m_CountTime = Mathf.Min(m_CountTime, m_TotalTime);
        float rate = m_CountTime/m_TotalTime;

        //MyDebug.Log( "rate:  "+ rate +"   " +m_StartPos);
        Vector3 new_pos = new Vector3();

        for (int i = 0, len = m_Points.Length-1; i <= len; i++)
        {
            new_pos += C(i, len - i) *Mathf.Pow(1-rate, len-i)*Mathf.Pow(rate, i)* m_Points[i];
        }
        transform.position = new_pos;
	}
}
