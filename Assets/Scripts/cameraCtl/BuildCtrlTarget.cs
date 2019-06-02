using UnityEngine;

public class BuildCtrlTarget : MonoBehaviour
{

    public float m_AngleY;
    private GameObject effect;

    internal void onClick()
    {
        LuaManager.getInstance().CallLuaFunction("GameManager.OnClick", name);
        if (effect)
        {
            Destroy(effect);
        }
        Messenger.BroadcastObject("ClickBuild",gameObject);
#if UNITY_EDITOR
        record(gameObject);
#endif    
    }
#if UNITY_EDITOR

    void record(GameObject go)
    {
        if (!UluaBinding.recordGuideStep) return;
        string path = go.name;
        Transform parent = go.transform.parent;
        while (parent)
        {
            path = parent.name + "/" + path;
            parent = parent.parent;
        }
        path = "{ \"guide\", path = \"" + path + "\",say = \"\",pos = \"left\", event = \"ClickBuild\" }\n";
        FileUtils.getInstance().writeFileStream(Application.dataPath + "/Z_Test/guideStep.txt", new System.Collections.Generic.List<byte[]> { System.Text.Encoding.UTF8.GetBytes(path) });
    }
#endif    

    public void showEffect()
    {
        effect = ClientTool.load("Effect/Prefab/sceffect_tongyong_guangzhu");
        effect.transform.parent = transform;
        effect.transform.localEulerAngles = new Vector3(270, 0, 0);
        effect.transform.localPosition = new Vector3(0, -2, 0);
    }
}
