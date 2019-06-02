using UnityEngine;
using System.Collections;
/***
 * Author: 曾家东
 * Content: 用于管理角色选择相关逻辑
 */

//摄像头的模式 Lock 摄像头锁定不动 

public class SelectCamera : MonoBehaviour
{
    public static SelectCamera Inst = null;
    void Start()
    {
        Inst = this;
    }

    // Update is called once per frame
    void Update()
    {

    }
}
