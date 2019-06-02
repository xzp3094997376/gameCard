using UnityEngine;
using System.Collections;

public enum ActionsType
{
    EnterBattle = 1,//出场
    Idle,
    Atk,//普攻
    Skill,//普通技能（不切镜头）
    Transform,//变身
    SuperSkill,//大招(镜头切换)
    TwoinOne,//合体技
    HitFly, // 击飞
    Success,//胜利
    Fail,//失败（认输） 
    Interaction,//交互动作

    Max,
}
public class Actions : MonoBehaviour {
    public ActionsData[] m_Actions;     //所有的动作
    void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
