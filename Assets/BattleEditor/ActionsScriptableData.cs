using UnityEngine;
using System.Collections;
/**
 * 说明：动作脚本信息的存储文件是actiondata文件的升级版本
 * 用于呈现描述各种类型文件
 * 
 * 方便于加载的时候系列化
 * */
//动作的每次操作类型
public enum ActionsTypeEnum
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
}
//目标的类型枚举
public enum TargetsType
{
    Self,
    Target,
    TargetTeam,
    Self2Target,
    TargetRow,
    TargetCol,
    SelfBizer2Target,
    SelfBizer2Team
};

[System.Serializable]
public class N_BaseAction
{
    public ActionTypeEnum m_ActionType = ActionTypeEnum.None;   //动作的类型
    public float m_BreakTime = 0;                       //与上一个动作的间隔时间
    public float m_LastTime = 0;                        //此次操作的持续时间
    public float m_NumValue = 0;                        //浮点数字参数
    public string m_StrValue = "";                      //字符串参数
    public string m_BackUp = "";                        //备用字符串
    public TargetType m_TargetType = TargetType.Self;   //目标的选取
    public Vector3 m_Position;                           //位置变化
    public Vector3 m_Rotation;                          //角度变化
}

