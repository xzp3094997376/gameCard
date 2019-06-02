using UnityEngine;
using System.Collections;

public class UISetActive : MonoBehaviour
{
    public bool isActive = false;

    void OnClick()
    {
        gameObject.SetActive(isActive);
    }
}
