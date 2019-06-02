using UnityEngine;
using System.Collections;
using UnityEditor;
 
public class UISceneLines : Editor {
    static public bool isLines = false;
    static int offset = 10;

    const string UI_LINE = "Setting/UI辅助线";

    [MenuItem(UI_LINE)]
    public static void setUILines()
    {
        isLines = !isLines;
        UIWidgetInspector.isLines = isLines;
    }

	[DrawGizmo(GizmoType.InSelectionHierarchy | GizmoType.NotInSelectionHierarchy)]
	static void DrawWidgetLines(Transform transform, GizmoType gizmoType)
	{
        if (!isLines) return;
        var objs = transform.gameObject.GetComponentsInChildren<UIWidget>();

        foreach (Object o in objs) 
        {
            var mWidget = o as UIWidget;
            if (mWidget != null)
            { 
                Transform t = mWidget.cachedTransform;
                Vector3[] handles = mWidget.worldCorners;

                NGUIHandles.DrawShadowedLine(handles, handles[0], handles[1], Color.blue);
                NGUIHandles.DrawShadowedLine(handles, handles[1], handles[2], Color.blue);
                NGUIHandles.DrawShadowedLine(handles, handles[2], handles[3], Color.blue);
                NGUIHandles.DrawShadowedLine(handles, handles[0], handles[3], Color.blue);
            }
        }

        if (transform.name == "GameManager")
        {
            DrawGizmos(transform.gameObject);
        }

	}

    public static void DrawGizmos(GameObject go)
    {
#if UNITY_EDITOR
        Handles.color = new Color(0, 0, 0, 0.2f);
        UIRoot root = go.GetComponent<UIRoot>();
        Camera uiCamera = go.GetComponentInChildren<Camera>();
        int w = root.manualWidth / offset;
        int h = root.manualHeight / offset;
        for (int i = 0; i < w; i++)
        {
            Handles.DrawLine(uiCamera.ScreenToWorldPoint(new Vector3(i * offset, 0, 1)), uiCamera.ScreenToWorldPoint(new Vector3(i * offset, h * offset, 1)));
        }
        for (int j = 0; j < h; j++)
        {
            Handles.DrawLine(uiCamera.ScreenToWorldPoint(new Vector3(0, j * offset, 1)), uiCamera.ScreenToWorldPoint(new Vector3(w * offset, j * offset, 1)));
        }
#endif
    }
}