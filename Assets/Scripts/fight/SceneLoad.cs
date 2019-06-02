using UnityEngine;
using System.Collections;

public class SceneLoad : MonoBehaviour
{
    public static SceneLoad Inst;
    public string m_Scene = "map_008";
    void Awake()
    {
        Inst = this;
        
    }
    void Start()
    {
        if (FightManager.Inst.m_IsBattleEditor)
            LoadScene(m_Scene);
    }
    public void DestroyScene()
    {
        this.transform.DestroyChildren();
    }
    public void LoadScene(string name)
    {
        DestroyScene();
        GameObject battlescene = ClientTool.load("battlescene/" + name, this.gameObject, false);
        if (battlescene == null)
        {
            battlescene = ClientTool.load("battlescene/map_008", this.gameObject, false);
        }
    }
    // Update is called once per frame
    void Update()
    {
    }
}
