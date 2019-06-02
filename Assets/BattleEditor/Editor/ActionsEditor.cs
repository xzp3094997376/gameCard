using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
/// <summary>
/// 所有动画类型
/// </summary>

[CustomEditor(typeof(Actions))]
public class ActionsEditor : Editor
{
    public enum AnimationType
    {
        free = 0,
        stand = 1,
        attack = 2,
        move_out = 3,
        move_back = 4,
        spell1 = 5,
        spell2 = 6,
        normal_hit = 7,
        great_hit = 8,
        dead = 9,
        transform = 10,
        spell_1,
        spell_2,
        spell_3,
        spell_4,
        spell_5,
        spell_6,
        spell_7,
    };
    string[] g_StrToNum = new string[]{
        "free",
        "stand",
        "attack",
        "move_out",
        "move_back",
        "spell1",
        "spell2",
        "normal_hit",
        "great_hit",
        "dead",
        "transform",
        "spell_1",
        "spell_2",
        "spell_3",
        "spell_4",
        "spell_5",
        "spell_6",
        "spell_7",
    };
    private SerializedObject m_Actions;
    private SerializedProperty m_BaseActions;
    private static GUIContent
        insertContent = new GUIContent("+", "添加一行"),
        deleteContent = new GUIContent("-", "删除一行"),
        upContent = new GUIContent("↑", "向上移动"),
        downContent = new GUIContent("↓", "向下移动"),
        teleportContent = new GUIContent("T");

    public static GUIContent conMajor = new GUIContent("操作类型", "控制大的操作类型");

    public static GUILayoutOption widMajor = GUILayout.MaxWidth(120f);
    public bool oper = true;
    List<bool> m_opers = null;

    void OnEnable()
    {
        m_Actions = new SerializedObject(target);
        m_BaseActions = m_Actions.FindProperty("m_Actions");
        m_opers = new List<bool>();
    }

    int AniStrToNum(string ani_name)
    {
        for (int i = 0; i < g_StrToNum.Length; i++)
            if (ani_name == g_StrToNum[i])
                return i;
        return 0;
    }
    public override void OnInspectorGUI()
    {
        m_Actions.Update();
        m_Actions.ApplyModifiedProperties();
        Actions data = (Actions)m_Actions.targetObject;
        EditorGUILayout.BeginHorizontal();
        
        EditorGUILayout.LabelField(data.gameObject.name + "动作脚本编辑器1.0!欢迎使用!", GUILayout.MaxWidth(180f));
       
        EditorGUILayout.EndHorizontal();

        for (int i = 0; i < m_BaseActions.arraySize; i++)
        {
            if (i >= data.m_Actions.Length)
                continue;
            if (i >= m_opers.Count)
                m_opers.Add(false);
            m_opers[i] = EditorGUILayout.Foldout(m_opers[i], "ActionID: " + data.m_Actions[i].m_ActionID.ToString());
           

            if (m_opers[i] == false)
                continue;
           
            SerializedProperty bs = m_BaseActions.GetArrayElementAtIndex(i);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button(insertContent, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(30f)))
            {
                m_BaseActions.InsertArrayElementAtIndex(i);
                m_Actions.ApplyModifiedProperties();
                return;
            }
            if (GUILayout.Button(deleteContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(30f)))
            {
                if (m_BaseActions.arraySize <= 0)
                    return;
                m_BaseActions.DeleteArrayElementAtIndex(i);
                m_Actions.ApplyModifiedProperties();
                return;
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("ID:", GUILayout.MaxWidth(25f));
            EditorGUILayout.PropertyField(bs.FindPropertyRelative("m_ActionID"), GUIContent.none, GUILayout.MaxWidth(90f));
            EditorGUILayout.LabelField(" ", GUILayout.MaxWidth(20f));
            EditorGUILayout.LabelField("动作长度:" + data.m_Actions[i].m_Data.Length, GUILayout.MaxWidth(80f));
            
            bs = bs.FindPropertyRelative("m_Data");
            if (GUILayout.Button(insertContent, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(20f)))
            {
                bs.InsertArrayElementAtIndex(0);
                m_Actions.ApplyModifiedProperties();
                return;
            }
            if (GUILayout.Button(deleteContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(20f)))
            {
                if (bs.arraySize <= 0)
                    return;
                bs.DeleteArrayElementAtIndex(bs.arraySize - 1);
                m_Actions.ApplyModifiedProperties();
                return;
            }
            EditorGUILayout.LabelField("", GUILayout.MaxWidth(40f));
            if (GUILayout.Button(upContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(20f)))
            {
                if (i <= 0)
                    return;
                ActionsData tmp = data.m_Actions[i - 1];
                data.m_Actions[i - 1] = data.m_Actions[i];
                data.m_Actions[i] = tmp;
                return;
            }
            if (GUILayout.Button(downContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(20f)))
            {
                if (i + 1 >= data.m_Actions.Length)
                    return;
                ActionsData tmp = data.m_Actions[i + 1];
                data.m_Actions[i + 1] = data.m_Actions[i];
                data.m_Actions[i] = tmp;
                return;
            }
            EditorGUILayout.EndHorizontal();
            //SkillActionBaseData cur = data.datas[i];


            EditorGUILayout.BeginHorizontal(GUILayout.Height(20),
               GUILayout.ExpandWidth(true));
            EditorGUILayout.LabelField("", GUILayout.MaxWidth(88f));
            EditorGUILayout.LabelField("动作类型", GUILayout.MaxWidth(80f));
            EditorGUILayout.LabelField("间隔", GUILayout.MaxWidth(40f));
            EditorGUILayout.LabelField("持续", GUILayout.MaxWidth(40f));
            EditorGUILayout.LabelField("参数", GUILayout.MaxWidth(40f));
            EditorGUILayout.EndHorizontal();
            BaseAction[] actions = data.m_Actions[i].m_Data;
            for (int j = 0; j < bs.arraySize; j++)
            {
                BaseAction curAction = actions[j];
                EditorGUILayout.BeginHorizontal(GUILayout.Height(20),
                 GUILayout.ExpandWidth(true));
                SerializedProperty lineProperty = bs.GetArrayElementAtIndex(j);


                if (GUILayout.Button(insertContent, EditorStyles.miniButtonLeft, GUILayout.MaxWidth(18f)))
                {
                    bs.InsertArrayElementAtIndex(j);
                    m_Actions.ApplyModifiedProperties();
                    return;
                }
                if (GUILayout.Button(deleteContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(18f)))
                {
                    bs.DeleteArrayElementAtIndex(j);
                    m_Actions.ApplyModifiedProperties();
                    return;
                }
                if (GUILayout.Button(upContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(18f)))
                {
                    if (j <= 0)
                        return;
                    BaseAction tmp = actions[j - 1];
                    actions[j - 1] = curAction;
                    actions[j] = tmp;
                    return;
                }
                if (GUILayout.Button(downContent, EditorStyles.miniButtonRight, GUILayout.MaxWidth(18f)))
                {
                    if (j + 1 >= actions.Length)
                        return;
                    BaseAction tmp = actions[j + 1];
                    actions[j + 1] = curAction;
                    actions[j] = tmp;
                    return;
                }
                //显示类型
                EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_ActionType"), GUIContent.none, GUILayout.MaxWidth(80f));
                EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_BreakTime"), GUIContent.none, GUILayout.MaxWidth(40f));
                EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_LastTime"), GUIContent.none, GUILayout.MaxWidth(40f));
                EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_NumValue"), GUIContent.none, GUILayout.MaxWidth(40f));
                //EditorGUILayout.LabelField("" + curAction.m_ActionType.ToString(),GUILayout.MaxWidth(40f));
                if (curAction.m_ActionType == ActionTypeEnum.PlayAnimation)
                {
                    //特殊处理动画文件 名字等等
                    EditorGUILayout.LabelField(new GUIContent("动画名称", "必须选择"), GUILayout.MaxWidth(50f));
                    //curAction.m_StrValue = EditorGUILayout.EnumPopup((AnimationType)AniStrToNum(curAction.m_StrValue), GUILayout.MaxWidth(100f)).ToString();
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                    EditorGUILayout.LabelField(new GUIContent("播放对象", ""), GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_TargetType"), GUIContent.none, GUILayout.MaxWidth(80f));
                }               
                else if (ActionTypeEnum.WeaponEnable == curAction.m_ActionType)
                {
                    EditorGUILayout.LabelField("隐显武器", GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (ActionTypeEnum.HetiCameraAni == curAction.m_ActionType)
                {
                    EditorGUILayout.LabelField("动画名称", GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if(ActionTypeEnum.EnableEnemy == curAction.m_ActionType)
                {
                    EditorGUILayout.LabelField("隐藏或显示", GUILayout.MaxWidth(100.0f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_NumValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (ActionTypeEnum.EnableAll == curAction.m_ActionType)
                {
                    EditorGUILayout.LabelField("隐藏或显示", GUILayout.MaxWidth(100.0f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_NumValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (ActionTypeEnum.EnableFriend == curAction.m_ActionType)
                {
                    EditorGUILayout.LabelField("隐藏或显示", GUILayout.MaxWidth(100.0f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_NumValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.FowardTo)
                {
                    EditorGUILayout.LabelField(new GUIContent("移动方向", "影响目标的移动方向"), GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_TargetType"), GUIContent.none, GUILayout.MaxWidth(80f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.PlaySound)
                {
                    EditorGUILayout.LabelField(new GUIContent("声音文件", "不用后缀"), GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.ChangeModel)
                {
                    EditorGUILayout.LabelField("模型名称", GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.ShowSimpleUI)
                {
                    //
                    EditorGUILayout.LabelField(new GUIContent("UI类型（如：in）", "必须选择"), GUILayout.MaxWidth(120f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.SpeedLine)
                {
                    EditorGUILayout.LabelField("速度线名", GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.PlayEffect)
                {
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(80f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_BackUp"), GUIContent.none, GUILayout.MaxWidth(80f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_TargetType"), GUIContent.none, GUILayout.MaxWidth(80f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_LayerType"), GUIContent.none, GUILayout.MaxWidth(80f));
                    EditorGUILayout.LabelField("Pos", GUILayout.MaxWidth(30f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_Position"), GUIContent.none, GUILayout.MaxWidth(120f));
                    EditorGUILayout.LabelField("Rot", GUILayout.MaxWidth(30f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_Rotation"), GUIContent.none, GUILayout.MaxWidth(120f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_NumValue"), GUIContent.none, GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_NumValue2"), GUIContent.none, GUILayout.MaxWidth(50f));

                }
                else if (curAction.m_ActionType == ActionTypeEnum.DropLife)
                {
                    EditorGUILayout.LabelField("是否受击", GUILayout.MaxWidth(50f));
                    EditorGUILayout.PropertyField(lineProperty.FindPropertyRelative("m_StrValue"), GUIContent.none, GUILayout.MaxWidth(100f));
                }
                else if (curAction.m_ActionType == ActionTypeEnum.ChangeColors)
                {
                    EditorGUILayout.LabelField("是否受击", GUILayout.MaxWidth(50f));
                    Color col = EditorGUILayout.ColorField(new Color(curAction.m_Position.x, curAction.m_Position.y, curAction.m_Position.z), GUILayout.MaxWidth(100f));
                    curAction.m_Position.x = col.r;
                    curAction.m_Position.y = col.g;
                    curAction.m_Position.z = col.b;
                }
                EditorGUILayout.EndHorizontal();
            }
        }
        m_Actions.ApplyModifiedProperties();
    }
}

