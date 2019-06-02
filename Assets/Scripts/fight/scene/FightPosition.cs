using UnityEngine;
using System.Collections;

public class FightPosition : MonoBehaviour
{

    public Vector3[] m_Positions;
    public Vector3 m_Rotation;
    public static FightPosition Instance = null;
    void Awake()
    {
        Instance = this;
    }

    // Update is called once per frame
    void OnDestory()
    {
        Instance = null;
    }
}
