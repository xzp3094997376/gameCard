using UnityEngine;
using System.Collections;
using SLua;
public class RayChapter : MonoBehaviour
{

    public UITexture[] allNeedTest;
    private LuaFunction[] callBackFuns = new LuaFunction[10];
    public LuaTable[] mTargets = new LuaTable[10];
    private bool isMouseDown = false;
    private int clickIndex = 0;
    private Camera guideCamere;
    private UICamera ui_camere;
    void Start()
    {
        ui_camere = GlobalVar.camera.GetComponent<UICamera>();
        if (GuideManager.getInstance())
        {
            guideCamere = GuideManager.getInstance().mCamera.GetComponent<Camera>();
        }
    }
    public void onSetLuaTable(LuaFunction func, LuaTable _target, LuaTable _index)
    {
        int index = UluaUtil.transTableToInt(_index);
        if (func != null && _target != null)
        {
            callBackFuns[index] = func;
            mTargets[index] = _target;
        }
    }
    public void onClick(int index)
    {
        callBackFuns[index].call(mTargets[index], index);
        if (index < allNeedTest.Length)
            Messenger.BroadcastObject("ClickCpapter", allNeedTest[index].gameObject);
#if UNITY_EDITOR
        record(allNeedTest[index].gameObject, index + 1);
#endif

    }
#if UNITY_EDITOR
    void record(GameObject go, int index)
    {
        if (!UluaBinding.recordGuideStep) return;
        string path = go.name;
        Transform parent = go.transform.parent;
        while (parent)
        {
            path = parent.name + "/" + path;
            parent = parent.parent;
        }
        var map = new System.Collections.Generic.Dictionary<int, string>()
        {
            { 1,"一" },
            { 2,"二" },
            { 3,"三" },
            { 4,"四" },
            { 5,"五" },
            { 6,"六" },
            { 7,"七" },
            { 8,"八" },
            { 9,"九" }
        };
        string one = map[index];

        path = "{ \"guide\", path = \"" + path + "\",say = \"点击第" + one + "关\",pos = \"top\", event = \"ClickCpapter\" }\n";
        
        FileUtils.getInstance().writeFileStream(Application.dataPath + "/Z_Test/guideStep.txt", new System.Collections.Generic.List<byte[]> { System.Text.Encoding.UTF8.GetBytes(path) });
    }
#endif   
    public void OnDestroy()
    {
        for (int i = 0; i < 10; i++)
        {
            callBackFuns[i] = null;
            mTargets[i] = null;
        }
        callBackFuns = null;
        mTargets = null;
    }
    void Update()
    {
        if (DragPageComponent.isPlaying)
        {
            return;
        }
        if (Input.GetMouseButtonDown(0))
        {
            isMouseDown = false;
            var main = ui_camere.enabled ? ui_camere.GetComponent<Camera>() : guideCamere;

            if (UICamera.hoveredObject == null || UICamera.hoveredObject.name != "simpleImage")
            {
                return;
            }
            if (main != null)
            {
                Ray ray = main.ScreenPointToRay(Input.mousePosition);//从摄像机发出到点击坐标的射线
                RaycastHit[] hitInfos = Physics.RaycastAll(ray);
                for (var i = 0; i < hitInfos.Length; i++)
                {
                    var collider = hitInfos[i].collider;
                    for (var j = 0; j < allNeedTest.Length; j++)
                    {
                        var collider2 = allNeedTest[j].GetComponent<Collider>();
                        if (collider == collider2 && collider.gameObject.name.IndexOf("Image") != -1)
                        {
                            var go = allNeedTest[j];
                            if (go == null) return;
                            var texture2 = go.mainTexture as Texture2D;
                            if (texture2 == null || go.gameObject.layer != main.gameObject.layer)
                                return;
                            var vec = allNeedTest[j].transform.InverseTransformPoint(hitInfos[i].point);
                            var x = texture2.width / 2 + vec.x;
                            var y = texture2.height / 2 + vec.y;
                            if (texture2.GetPixel((int)x, (int)y).a > 0.1)
                            {
                                clickIndex = j;
                                isMouseDown = true;
                                return;
                            }
                        }
                    }
                }
            }
        }
        if (isMouseDown && Input.GetMouseButtonUp(0))
        {
            isMouseDown = false;
            if (DragPageComponent.deltaCount < 2)
            {
                onClick(clickIndex);
            }
        }
    }
}
