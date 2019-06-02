using UnityEngine;
using System.Collections;

/// <summary>
/// 位置重置
/// </summary>
public class PositionUtils : MonoBehaviour
{

    public Transform sourceTrans;
    public int addX = 0;
    public int addY = 0;
    public Vector3 sourceStatePositon;
    private bool isOverJob = false;
    private int delayCount = 0;
    void Start()
    {
        sourceStatePositon = sourceTrans.transform.localPosition;
    }

    void Update()
    {
        if (delayCount >= 1)
        {
            PositionUtils thisScript = gameObject.GetComponent<PositionUtils>();
            GameObject.Destroy(thisScript);
        }
        delayCount++;
        transform.localPosition = sourceTrans.transform.localPosition + new Vector3(addX, addY, 0);
    }
}
