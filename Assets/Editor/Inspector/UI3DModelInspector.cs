using UnityEngine;
using UnityEditor;

[CanEditMultipleObjects]
[CustomEditor(typeof(UI3DModel), true)]
public class UI3DModelInspector : UIWidgetInspector
{
    protected override bool ShouldDrawProperties()
    {
        base.ShouldDrawProperties();
        GUILayout.BeginHorizontal();
        GUILayout.Label("ShowType", GUILayout.Width(76f));
        SerializedProperty sp = serializedObject.FindProperty("_type");
        sp = NGUIEditorTools.DrawProperty("", serializedObject, "_type", GUILayout.MinWidth(16f));
        GUILayout.EndHorizontal();
        return true;
    }
}
