using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
namespace LuaBind
{
    public class ReplaceAtlasWindow : EditorWindow
    {
        UIAtlas mSelectAtlas;
        UIAtlas mTargetAtlas;
        string spriteName;
        string targetSpriteName;

        GameObject go;
        void OnGUI()
        {
            //if (GUILayout.Button("检查无用Sprite"))
            //{
            //    findAll();
            //}
            //GUILayout.Space(5);
            //mSelectAtlas = EditorGUILayout.ObjectField("选择一个图集", mSelectAtlas, typeof(UIAtlas), false) as UIAtlas;
            //GUILayout.Space(5);
            //if (!mSelectAtlas)
            //{
            //    mTargetAtlas = null;
            //    return;
            //}
            //GUILayout.BeginHorizontal();
            //GUILayout.Label("图片名", GUILayout.Width(146), GUILayout.Height(18f));
            //NGUIEditorTools.DrawAdvancedSpriteField(mSelectAtlas, spriteName, SelectSprite, false);
            //GUILayout.EndHorizontal();
            //GUILayout.Space(5);

            //GUILayout.Space(5);
            //mTargetAtlas = EditorGUILayout.ObjectField("替换成图集", mTargetAtlas, typeof(UIAtlas), false) as UIAtlas;
            //GUILayout.Space(5);
            //if (!mTargetAtlas)
            //{
            //    targetSpriteName = "";
            //    return;
            //}
            //if (string.IsNullOrEmpty(targetSpriteName))
            //    targetSpriteName = spriteName;
            //GUILayout.BeginHorizontal();
            //GUILayout.Label("图片名", GUILayout.Width(146), GUILayout.Height(18f));
            //NGUIEditorTools.DrawAdvancedSpriteField(mTargetAtlas, targetSpriteName, SelectTargetSprite, false);
            //GUILayout.EndHorizontal();
            //GUILayout.Space(5);

            //go = EditorGUILayout.ObjectField("选择一个UI", go, typeof(GameObject), true) as GameObject;
            //if (go)
            //{
            //    if (GUILayout.Button("替换"))
            //    {
            //        replaceAtlas(go, mSelectAtlas, spriteName, mTargetAtlas, targetSpriteName);
            //    }
            //}

            //GUILayout.Space(5);
            //GUILayout.Space(5);
            //GUILayout.Space(5);
            mSelectAtlas = EditorGUILayout.ObjectField("选择一个图集", mSelectAtlas, typeof(UIAtlas), false) as UIAtlas;
            GUILayout.Space(5);
            if (GUILayout.Button("还原"))
            {
                var go = Selection.activeGameObject;
                if (go && mSelectAtlas)
                {
                    UISprite[] sp = go.GetComponentsInChildren<UISprite>(true);
                    for (int i = 0; i < sp.Length; i++)
                    {
                        var s = sp[i];
                        if (s && !s.atlas)
                        {
                            s.atlas = mSelectAtlas;
                        }
                    }
                }
            }

        }

        private void SelectSprite(string sprite)
        {
            spriteName = sprite;
        }

        private void SelectTargetSprite(string sprite)
        {
            targetSpriteName = sprite;
        }

        public void replaceAtlas(GameObject go, UIAtlas mSelectAtlas, string spriteName, UIAtlas mTargetAtlas, string targetSpriteName)
        {
            if (!go || !mSelectAtlas || string.IsNullOrEmpty(spriteName)
                || !mTargetAtlas
                || mTargetAtlas.GetSprite(targetSpriteName) == null)
            {
                return;
            }
            var find = false;
            string path = AssetDatabase.GetAssetPath(go);
            var _go = go;
            if (!string.IsNullOrEmpty(path))
            {
                _go = Instantiate(go) as GameObject;
            }
            UISprite[] args = _go.GetComponentsInChildren<UISprite>(true);
            for (int i = 0; i < args.Length; i++)
            {
                var sp = args[i];
                if (!sp)
                    continue;
                if (sp.atlas != mSelectAtlas)
                    continue;
                if (sp.spriteName != spriteName)
                    continue;
                sp.atlas = mTargetAtlas;
                sp.spriteName = targetSpriteName;
                find = true;
            }
            if (!find) return;
            AssetDatabase.SaveAssets();
        }

        public const string rootPath = "Assets/Resources";

        public void findAll()
        {

            Dictionary<string, List<string>> atlasDict = BuildWindow.loadObjectFromJsonFile<Dictionary<string, List<string>>>(Application.dataPath + "/Z_Test/ref_text.json");
            var f = 0;
            int count = atlasDict.Count;
            Dictionary<string, Dictionary<string, int>> info = new Dictionary<string, Dictionary<string, int>>();
            foreach (var i in atlasDict)
            {
                var list = i.Value;
                UIAtlas d = AssetDatabase.LoadAssetAtPath(i.Key, typeof(UIAtlas)) as UIAtlas;
                var dic = new Dictionary<string, int>();
                for (int k = 0; k < d.spriteList.Count; k++)
                {
                    dic.Add(d.spriteList[k].name, 0);
                }
                EditorUtility.DisplayProgressBar("查找图集引用", "正在搜索" + d.name, f / (float)count);
                for (int j = 0; j < list.Count; j++)
                {
                    var p = list[j];
                    var go = AssetDatabase.LoadAssetAtPath(p, typeof(GameObject)) as GameObject;
                    findSpriteInAtlas(go, d, ref dic);
                }
                info.Add(i.Key, dic);
                f++;
            }
            BuildWindow.saveObjectToJsonFile(info, Application.dataPath + "/Z_Test/ref_sprite.json");
            EditorUtility.ClearProgressBar();

        }
        public void findSpriteInAtlas(GameObject go, UIAtlas atlas, ref Dictionary<string, int> dic)
        {
            UISprite[] sp_list = go.GetComponentsInChildren<UISprite>(true);

            for (int i = 0; i < sp_list.Length; i++)
            {
                var sp = sp_list[i];
                
                if (sp.atlas == atlas)
                {
                   
                    if (dic.ContainsKey(sp.spriteName))
                    {
                        dic[sp.spriteName]++;
                    }
                }
            }
        }

        public static void RemoveUnUseSprite(GameObject go)
        {
            string path = AssetDatabase.GetAssetPath(go);
            if (string.IsNullOrEmpty(path)) return;
            Dictionary<string, Dictionary<string, int>> atlasDict = BuildWindow.loadObjectFromJsonFile<Dictionary<string, Dictionary<string, int>>>(Application.dataPath + "/Z_Test/ref_sprite.json");
            if (atlasDict != null)
            {
                if (atlasDict.ContainsKey(path))
                {
                    UIAtlas atlas = AssetDatabase.LoadAssetAtPath(path, typeof(UIAtlas)) as UIAtlas;
                    if (!atlas) return;
                    var list = atlas.spriteList;
                    var sp_list = atlasDict[path];
                    var find = false;
                    foreach (var i in sp_list)
                    {
                        if (i.Value == 0)
                        {
                            list.Remove(atlas.GetSprite(i.Key));
                            find = true;
                        }
                    }
                    if (!find)
                        return;
                    BundleMrg.resetMaterial(atlas);
                    var e_sp_list = new List<UIAtlasMaker.SpriteEntry>();
                    for (int i = 0; i < list.Count; i++)
                    {
                        var sp = UIAtlasMaker.ExtractSprite(atlas, list[i].name);
                        if (sp != null)
                            e_sp_list.Add(sp);
                    }
                    UIAtlasMaker.UpdateAtlas(atlas, e_sp_list);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    BundleMrg.reloadMaterial(atlas);
                }
            }
        }
    }
}