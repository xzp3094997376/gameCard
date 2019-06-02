using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;
using UnityEngine;

[CanEditMultipleObjects]
[CustomEditor(typeof(MCAnimation), true)]
public class MCAnimationInspector :  Editor {

    private SerializedObject obj;
    private SerializedProperty frames;
    public Vector2 lastUpdateMPos;
    public string fxPath = "";
    void OnEnable() 
    {
        obj = new SerializedObject(target);
        frames = obj.FindProperty("frames");
    }

	public override void OnInspectorGUI(){
		base.DrawDefaultInspector();
		if(GUILayout.Button("")){  
 
		}

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("特效路径: ", GUILayout.Width(80));
        Rect pathRect = EditorGUILayout.GetControlRect(GUILayout.Width(350), GUILayout.Height(30));
        string pathText = EditorGUI.TextField(pathRect, fxPath);
        EditorGUILayout.EndHorizontal();

        if (Event.current.type == EventType.DragUpdated || Event.current.type == EventType.DragExited)
        {
            if (Event.current.type != EventType.DragExited)
            {
                lastUpdateMPos = Event.current.mousePosition;
            }
            // 判断是否拖拽了文件 
            if (DragAndDrop.paths != null && DragAndDrop.paths.Length > 0)
            {
                string path = DragAndDrop.paths[0];
                DragAndDrop.visualMode = DragAndDropVisualMode.Generic;
                // 拖拽的过程中，松开鼠标之后，拖拽操作结束，此时就可以使用获得的 sfxPath 变量了 
                if (!string.IsNullOrEmpty(path) && Event.current.type == EventType.DragExited)
                {
                    DragAndDrop.AcceptDrag();
                    // 好了，这下想用这个 sfxPath 变量干嘛就干嘛吧 
                    bool isFxInRect = pathRect.Contains(lastUpdateMPos);
                    lastUpdateMPos = Vector2.zero;
                    path = Path.GetFileNameWithoutExtension(path);
                    if (isFxInRect)
                    {
                        fxPath = path;
                    }
                }
            }
        }
	}
}
