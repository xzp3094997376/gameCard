using UnityEngine;
using System.Collections;

public class EventTips : MonoBehaviour
{
    public UnityEngine.Events.UnityAction<bool> onPress;
    void Start()
    {
        EventTriggerListener.Get(gameObject).onDown += onDown;
        EventTriggerListener.Get(gameObject).onUp += onUp;
    }

    private void onUp(GameObject go)
    {
        if (onPress != null)
        {
            onPress.Invoke(false);
        }
    }

    private void onDown(GameObject go)
    {
        if (onPress != null)
            onPress.Invoke(true);
    }
    void OnDestroy()
    {
        onPress = null;
    }
}
