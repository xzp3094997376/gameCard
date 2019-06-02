using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections;
using System;

public class LuaSelector : ScriptableWizard
{
    static public LuaSelector instance;
    string[] Myfiles = null;
    ArrayList FileNames; 
    void OnEnable() { instance = this; }
    void OnDisable() { instance = null; }

    public delegate void Callback(string sprite);

    SerializedObject mObject;
    SerializedProperty mProperty;

    Vector2 mPos = Vector2.zero;
    Callback mCallback;
    float mClickTime = 0f;

    string searchStr = "";
    string mSelectLua = "";
    void OnGUI()
    {
        EditorTools.SetLabelWidth(80f);

        EditorTools.DrawSeparator();

        GUILayout.BeginHorizontal();
        GUILayout.Space(84f);

        string before = searchStr;
        string after = EditorGUILayout.TextField("", before, "SearchTextField");
        if (before != after) searchStr = after;

        if (GUILayout.Button("", "SearchCancelButton", GUILayout.Width(18f)))
        {
            searchStr = "";
            GUIUtility.keyboardControl = 0;
        }
        GUILayout.Space(84f);
        GUILayout.EndHorizontal();

        string[] filesList = getFilesList(searchStr);

        float size = 80f;
        float padded = size + 10f;
        int columns = Mathf.FloorToInt(Screen.width / padded);
        if (columns < 1) columns = 1;

        int offset = 0;
        Rect rect = new Rect(10f, 0, size, size);

        GUILayout.Space(10f);
        mPos = GUILayout.BeginScrollView(mPos);
        int rows = 1;
        bool close = false;
        while (offset < filesList.Length)
        {
            GUILayout.BeginHorizontal();
            {
                int col = 0;
                rect.x = 10f;

                for (; offset < filesList.Length; ++offset)
                {
                    string na = filesList[offset];
                    if (GUI.Button(rect, ""))
                    {
                        if (Event.current.button == 0)
                        {
                            float delta = Time.realtimeSinceStartup - mClickTime;
                            mClickTime = Time.realtimeSinceStartup;

                            if (mSelectLua != na)
                            {
                                mSelectLua = na;
                                if (mCallback != null) mCallback(na);
                            }
                            else if (delta < 0.5f) close = true;
                        }
                    }
                    if (Event.current.type == EventType.Repaint)
                    {
                        // On top of the button we have a checkboard grid
                        EditorTools.DrawTiledTexture(rect, EditorTools.backdropTexture);
                        Rect uv = new Rect(0, 0, 80, 80);
                        uv = NGUIMath.ConvertToTexCoords(uv, 80, 80);

                        // Calculate the texture's scale that's needed to display the sprite in the clipped area
                        float scaleX = rect.width / uv.width;
                        float scaleY = rect.height / uv.height;

                        // Stretch the sprite so that it will appear proper
                        float aspect = (scaleY / scaleX) / ((float)80 / 80);
                        Rect clipRect = rect;

                        if (aspect != 1f)
                        {
                            if (aspect < 1f)
                            {
                                // The sprite is taller than it is wider
                                float padding = size * (1f - aspect) * 0.5f;
                                clipRect.xMin += padding;
                                clipRect.xMax -= padding;
                            }
                            else
                            {
                                // The sprite is wider than it is taller
                                float padding = size * (1f - 1f / aspect) * 0.5f;
                                clipRect.yMin += padding;
                                clipRect.yMax -= padding;
                            }
                        }

                        //GUI.DrawTextureWithTexCoords(clipRect, tex, uv);

                        // Draw the selection
                        if (mSelectLua == na)
                        {
                            EditorTools.DrawOutline(rect, new Color(0.4f, 1f, 0f, 1f));
                        }
                    }

                    GUI.backgroundColor = new Color(1f, 1f, 1f, 0.5f);
                    GUI.contentColor = new Color(1f, 1f, 1f, 0.7f);
                    GUI.Label(new Rect(rect.x, rect.y + rect.height, rect.width, 32f), Path.GetFileNameWithoutExtension(na), "ProgressBarBack");
                    GUI.contentColor = Color.white;
                    GUI.backgroundColor = Color.white;

                    if (++col >= columns)
                    {
                        ++offset;
                        break;
                    }
                    rect.x += padded;
                }
            }
            GUILayout.EndHorizontal();
            GUILayout.Space(padded);
            rect.y += padded + 26;
            ++rows;
        }
        GUILayout.Space(rows * 26);
        GUILayout.EndScrollView();

        if (close) Close();

    }
    string[] getFilesList(string match)
    {
        if (string.IsNullOrEmpty(match)) return Myfiles;
        ArrayList list = new ArrayList();
        for (int i = 0, iMax = FileNames.Count; i < iMax; i++)
        {
            string path = FileNames[i].ToString();
            if (string.Equals(match, path, StringComparison.OrdinalIgnoreCase))
            {
                //完全匹配
                list.Add(Myfiles[i]);
                return (string[])list.ToArray(typeof(string));
            }
        }

        //模糊匹配
        string[] keywords = match.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
        for (int i = 0; i < keywords.Length; ++i) keywords[i] = keywords[i].ToLower();

        for (int i = 0, imax = FileNames.Count; i < imax; ++i)
        {
            string path = FileNames[i].ToString();

            string tl = path.ToLower();
            int matches = 0;

            for (int b = 0; b < keywords.Length; ++b)
            {
                if (tl.Contains(keywords[b])) ++matches;
            }
            if (matches == keywords.Length) list.Add(Myfiles[i]);
        }
        return (string[])list.ToArray(typeof(string));
    }

    /// <summary>
    /// 得到目录里的.lua.txt文件
    /// </summary>
    void GetFiles()
    {
        string[] files = Directory.GetFiles(Application.dataPath, "*.lua", SearchOption.AllDirectories);
        Myfiles = new string[files.Length];
        FileNames = new ArrayList();
        for (int i = 0; i < files.Length; i++)
        {
            Myfiles[i] = files[i].Replace(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
                .Replace(Application.streamingAssetsPath + "/", "")
                .Replace(Application.dataPath + "/", string.Empty);
            FileNames.Add(Path.GetFileNameWithoutExtension(files[i]));
        }
    }

    /// <summary>
    /// 显示lua文件选择列表
    /// </summary>
    /// <param name="callback"></param>
    static public void Show(Callback callback)
    {
        if (instance != null)
        {
            instance.Close();
            instance = null;
        }

        LuaSelector comp = ScriptableWizard.DisplayWizard<LuaSelector>("选择一个Lua文件T_T");
        comp.mCallback = callback;
        comp.GetFiles();
    }
    [MenuItem("Assets/Create/Lua", false, 1)]
    static public void CreateLuaFile(MenuCommand commnd)
    {
        var objs = Selection.objects;
        if (objs.Length != 1) return;
        string path = AssetDatabase.GetAssetPath(objs[0].GetInstanceID());
        string fullPath = Path.GetFullPath(path) + Path.DirectorySeparatorChar + "newLua.lua";
        if (!File.Exists(fullPath))
        {            
            File.WriteAllText(fullPath, "local script = {} \n\nreturn script", System.Text.Encoding.UTF8);
            AssetDatabase.Refresh();
        }
    }
}