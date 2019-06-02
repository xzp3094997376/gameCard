using UnityEngine;
using System.Collections;
/**
 * 说明：动作脚本信息的存储文件是actiondata文件的升级版本
 * 用于呈现描述各种类型文件
 * 
 * 方便于加载的时候系列化
 * */
//动作的每次操作类型
public enum ActionTypeEnum
{
    None = 0,
    FowardTo,
    BackTo,
    PlayAnimation,
    DropLife,
    AddLife,
    FollowCamera,
    MotionBlur,
    Blur,
    Shake,
    SpeedScale,
    SpeedLine,
    PlaySound,
    ChangeModel,
    PlayEffect,
    InvertGrayScale,
    ChangeColors,
    WhiteScreen,
    FieldOfView,
    StartFocus,
    EndFocus,
    ShowSimpleUI,
    WeaponEnable,//武器显示和隐藏
    HetiCameraAni, // 相机动画
    EnableAll,
    EnableEnemy,
    EnableFriend,

}
//目标的类型枚举
public enum TargetType
{
    Self,
    Target,
    TargetTeam,
    Self2Target,
    TargetRow,
    TargetCol,
    SelfBizer2Target,
    SelfBizer2Team,
    Atk2Def,
    Screen,
};
public enum LayerType
{
    Self, //角色身上
    Top, //最上
    Bottom, //下面之下
    Background, // 背景
    SelfUp, //角色上面
    SelfDown, // 角色下面
};
[System.Serializable]
public class BaseAction
{
    public ActionTypeEnum m_ActionType = ActionTypeEnum.None;   //动作的类型
    public float m_BreakTime = 0;                       //与上一个动作的间隔时间
    public float m_LastTime = 0;                        //此次操作的持续时间
    public float m_NumValue = 0;                        //浮点数字参数
    public string m_StrValue = "";                      //字符串参数
    public string m_BackUp = "";                        //备用字符串
    public TargetType m_TargetType = TargetType.Self;   //目标的选取
    public LayerType m_LayerType = LayerType.Self;     // 目示显示的层级
    public Vector3 m_Position;                           //位置变化
    public Vector3 m_Rotation;                          //角度变化
    public float m_NumValue2 = 0;
}
[System.Serializable]
public class FightActionData 
{
    public AttackType m_Type;
    public string m_Name;               //名字
    public BaseAction[] m_Data;         //数据
}
public class ScriptableActionData : ScriptableObject
{
    public string m_SkillName;               //名字
    public BaseAction[] m_NormalData;        //普通攻击
    public BaseAction[] m_SpecialData;       //特殊攻击
    public BaseAction[] m_TransformData;     //变身
    public BaseAction[] m_SuperData;         //大招
}
[System.Serializable]
public class ActionsData
{
    public int m_ActionID;
    public string m_Name;               //名字
    public BaseAction[] m_Data;         //数据
}
public class ActionsScriptableData : ScriptableObject
{
    public ActionsData[] m_Actions;     //所有的动作
}
