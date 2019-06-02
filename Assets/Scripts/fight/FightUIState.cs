using UnityEngine;
using System.Collections;

public class FightUIState : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnDestroy()
    {
        // 在UI销毁时
        FightManager.Inst.ExitFighting();
    }
}