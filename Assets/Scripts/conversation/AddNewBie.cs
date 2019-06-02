using UnityEngine;
using System.Collections;
using SLua;
public class AddNewBie : MonoBehaviour {

    // Use this for initialization
    public string[] luaFile = null;
    public UIButton btnStart = null;
    public UIButton btnRepet = null;
    public UIButton btnNext= null;
    public static int nStart = 0;
    public GameObject winPos;
    public GameObject star1;
    public GameObject star2;
    public GameObject star3;
    public UIWidget bottom;
    public UIWidget btnStartWidget;

    private GameObject kaishizhandouEffct;
    void Awake()
    {
        if (btnStart != null)
            UIEventListener.Get(btnStart.gameObject).onClick = ButtonClick;
        if (btnRepet != null)
            UIEventListener.Get(btnRepet.gameObject).onClick = ButtonClick;
        if (btnNext != null)
            UIEventListener.Get(btnNext.gameObject).onClick = ButtonClickNext;
        
    }
	void Start () {
        if (btnStart)
        {
            btnStart.enabled = false;
            StartCoroutine(delayInvoke(0.8f));
        }
    }

    IEnumerator delayInvoke(float time)
    {
        if (kaishizhandouEffct) yield break;
        yield return new WaitForSeconds(time);
            btnStart.enabled = true;
        kaishizhandouEffct =  ClientTool.load("effect/fight/kaishizhandou01", gameObject);
        //GameObject effctName = ClientTool.load("effect/fight/qiechangtexiao", obj);
        

        RenderQueueModifier renderModifier = kaishizhandouEffct.AddComponent<RenderQueueModifier>();
        renderModifier.m_type = RenderQueueModifier.RenderType.FRONT;
        renderModifier.m_target = btnStartWidget;
    }

    void OnEnable()
    {
		if(btnStart)  StartCoroutine(delayInvoke(0.8f));
    }
   


    void ButtonClick(GameObject obj)
    {
        string file_name = "uLuaModule/modules/conversation/" + luaFile[nStart];
        object objs = LuaManager.getInstance().DoFile(file_name);

        TranslateScripts.Inst.TranslateString(objs as LuaTable);
        gameObject.SetActive(false);

    }

    void ButtonClickNext(GameObject obj)
    {
        nStart = nStart + 1;
        nStart = nStart % luaFile.Length;
        string file_name = "uLuaModule/modules/conversation/" + luaFile[nStart];
        object objs = LuaManager.getInstance().DoFile(file_name);

        TranslateScripts.Inst.TranslateString(objs as LuaTable);
        gameObject.SetActive(false);

    }
    
    public void TweenFinish()
    {
        Invoke("Win", 0.2f);
    }

    void Win()
    {
        GameObject effctName =  ClientTool.load("effect/fight/shengli", winPos);
        RenderQueueModifier renderModifier = effctName.AddComponent<RenderQueueModifier>();
        renderModifier.m_type = RenderQueueModifier.RenderType.FRONT;
        renderModifier.m_target = bottom;
    }

   public void RightFinish()
    {
        StartCoroutine(ShowStar());
    }

    IEnumerator ShowStar()
    {
        yield return new WaitForSeconds(0.3f);
        ClientTool.load("effect/fight/shenglixingxing", star1);
        yield return new WaitForSeconds(0.3f);
        ClientTool.load("effect/fight/shenglixingxing", star2);
        yield return new WaitForSeconds(0.3f);
        ClientTool.load("effect/fight/shenglixingxing", star3);
        yield return new WaitForSeconds(0.3f);
    }
}
