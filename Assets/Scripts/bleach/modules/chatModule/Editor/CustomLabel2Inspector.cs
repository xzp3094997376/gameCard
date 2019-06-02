using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Text;
using System;

[CustomEditor(typeof(CustomLabel2))]
public class CustomLabel2Inspector : UIWidgetInspector
{

    private CustomLabel2 mLabel;

    public override void OnInspectorGUI()
    {

        base.OnInspectorGUI();
    }

    protected override bool ShouldDrawProperties()
    {
        mLabel = target as CustomLabel2;

        SerializedProperty sp = NGUIEditorTools.DrawProperty(serializedObject, "symbolFont");

        if (sp != null)
        {
            TextAsset data = EditorGUILayout.ObjectField("Import Data", null, typeof(TextAsset), false) as TextAsset;
            if (data != null)
            {
                NGUIEditorTools.RegisterUndo("Import Face Data", mLabel);
                //string text = UTF8Encoding.UTF8.GetString(data.bytes);

                ByteReader reader = new ByteReader(data.bytes);
                char[] separator = new char[] { ',' };

                int lineCount = 0;
                while (reader.canRead)
                {
                    string line = reader.ReadLine();
                    if (string.IsNullOrEmpty(line)) break;
                    lineCount++;
                    if (lineCount == 1)
                    {
                        continue; //skip first line;
                    }

                    string[] split = line.Split(separator, System.StringSplitOptions.RemoveEmptyEntries);
                    if (split.Length == 2)
                    {
                        string fileName = split[0];
                        fileName = fileName.Substring(0, fileName.IndexOf('.'));
                        mLabel.symbolFont.AddSymbol(split[1], fileName);
                    }
                }

                Debug.Log(string.Format("import {0} faces", lineCount - 1));
                mLabel.symbolFont.MarkAsChanged();
            }
        }

        NGUIEditorTools.DrawProperty(serializedObject, "block");
        NGUIEditorTools.DrawProperty(serializedObject, "labelPrefab");
        NGUIEditorTools.DrawProperty(serializedObject, "facePrefab");
        //NGUIEditorTools.DrawProperty(serializedObject, "testString");
        NGUIEditorTools.DrawProperty(serializedObject, "alignment");
        NGUIEditorTools.DrawProperty(serializedObject, "minWidth");
        NGUIEditorTools.DrawProperty(serializedObject, "region");
        NGUIEditorTools.DrawProperty(serializedObject, "heightAdjust");
        NGUIEditorTools.DrawProperty(serializedObject, "paddingLeft");
        NGUIEditorTools.DrawProperty(serializedObject, "paddingTop");
        NGUIEditorTools.DrawProperty(serializedObject, "paddingRight");
        NGUIEditorTools.DrawProperty(serializedObject, "paddingBottom");
        return true;
    }
}
