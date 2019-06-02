using UnityEditor;
using UnityEngine;
using System.IO;
using System;

public class SplitTexture : EditorWindow
{
	public Texture2D src;
    private Material mSrcMaterial;

	private const int PaddingInEditor = 3;

    [MenuItem("Window/SplitTexture")]
	public static void ShowWindow()
	{
        EditorWindow.GetWindow(typeof(SplitTexture));
	}

    bool mIsSplitUI = true;
	void OnGUI()
	{
		EditorGUI.LabelField(new Rect(PaddingInEditor, PaddingInEditor, 100, 20), "Select a Texture");
        mSrcMaterial = (Material)EditorGUI.ObjectField(new Rect(120, PaddingInEditor, position.width - 120, 16), mSrcMaterial, typeof(Material), true);

        if (mSrcMaterial != null)
        {
            src = (Texture2D)mSrcMaterial.GetTexture("_MainTex");
            if (src == null) 
            {
                Debug.LogError("没有发现texture");
                mSrcMaterial = null;
                return;
            }

            //string path = AssetDatabase.GetAssetPath(src);
            //TextureImporter textureimporter = AssetImporter.GetAtPath(path) as TextureImporter;
            //if (textureimporter != null) 
            //{
            //    textureimporter.isReadable = true;
            //    textureimporter.alphaIsTransparency = true;

            //    AssetDatabase.SaveAssets();
            //    AssetDatabase.Refresh();
            //    AssetDatabase.ImportAsset(path);

            //    Debug.LogError("====================");
            //}

			float scaleFact = Mathf.Min(1.0f, position.width*1.0f/src.width, (position.height - 110)/3/src.height);
			int width = (int)(src.width * scaleFact);
			int height = (int)(src.height * scaleFact);

			EditorGUI.LabelField(new Rect(PaddingInEditor, 25, 100, 15),"PreView:");
			EditorGUI.DrawTextureTransparent(new Rect(PaddingInEditor, 40, width, height),src);

			//EditorGUI.LabelField(new Rect(PaddingInEditor, 45 + height, 100, 15),"RGB:");
			//EditorGUI.DrawPreviewTexture(new Rect(PaddingInEditor, 60 + height, width, height),src);

            EditorGUI.LabelField(new Rect(PaddingInEditor, 45 + height, 100, 15), "Aphla:");
            EditorGUI.DrawTextureAlpha(new Rect(PaddingInEditor, 60 + height, width, height), src);

            //EditorGUI.LabelField(new Rect(PaddingInEditor, 65 + height*2, 100, 15),"Aphla:");
            //EditorGUI.DrawTextureAlpha(new Rect(PaddingInEditor, 80 + height*2, width, height),src);
            mIsSplitUI = GUI.Toggle(new Rect(PaddingInEditor, position.height - 40, position.width - PaddingInEditor * 2, 20), mIsSplitUI,"IsSplitUI");

			if(GUI.Button(new Rect(PaddingInEditor,position.height - 120, position.width-PaddingInEditor*2,20),"Split")) {
				splitTexture();

			}

            if (GUI.Button(new Rect(PaddingInEditor, position.height - 80, position.width - PaddingInEditor * 2, 20), "ApplyTexture"))
            {
                string path = AssetDatabase.GetAssetPath(src);
                TextureImporter textureimporter = AssetImporter.GetAtPath(path) as TextureImporter;
                if (textureimporter != null)
                {
                    textureimporter.textureType = TextureImporterType.Advanced;
                    textureimporter.isReadable = true;
                    textureimporter.alphaIsTransparency = true;
                    textureimporter.mipmapEnabled = false;

                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    AssetDatabase.ImportAsset(path);
                }
            }
		}
	}


    public static void SplitTextureByMaterial(Material mSrcMaterial)
    {
        if (!mSrcMaterial) return;

        var src = (Texture2D)mSrcMaterial.GetTexture("_MainTex");
        string p = AssetDatabase.GetAssetPath(src);
        TextureImporter textureimporter = AssetImporter.GetAtPath(p) as TextureImporter;
        if (textureimporter != null)
        {
            textureimporter.textureType = TextureImporterType.Advanced;
            textureimporter.isReadable = true;
            textureimporter.alphaIsTransparency = true;
            textureimporter.mipmapEnabled = false;

            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            AssetDatabase.ImportAsset(p);
        }
        Texture2D RGBTex = new Texture2D(src.width, src.height, TextureFormat.RGB24, false);
        Texture2D aphlaTex = new Texture2D(src.width, src.height, TextureFormat.RGB24, false);

        Color[] c = src.GetPixels();
        RGBTex.SetPixels(c);
        for (int i = 0; i < c.Length; i++)
        {
            c[i].r = c[i].a;
            c[i].g = c[i].a;
            c[i].b = c[i].a;
        }
        aphlaTex.SetPixels(c);

        byte[] RGBTexData = RGBTex.EncodeToPNG();
        byte[] aphlaTexData = aphlaTex.EncodeToPNG();
        string path = AssetDatabase.GetAssetPath(src);
        path = path.Substring(0, path.LastIndexOf("."));
        if (RGBTexData != null)
        {
            File.WriteAllBytes(path + "_RGB.png", RGBTexData);
        }
        if (aphlaTexData != null)
        {
            File.WriteAllBytes(path + "_A.png", aphlaTexData);
        }

        DestroyImmediate(RGBTex);
        DestroyImmediate(aphlaTex);
        AssetDatabase.Refresh();
        EditorUtility.FocusProjectWindow();
        Selection.activeObject = src;

        if (mSrcMaterial != null)
        {
            Shader shader = true ? Shader.Find("Custom/Split Images") : Shader.Find(mSrcMaterial.shader.name + " SA");
            if (shader != null)
            {
                mSrcMaterial.shader = shader;

                string texPath = path + "_RGB.png";

                Texture _ainTex = null;
                _ainTex = AssetDatabase.LoadAssetAtPath(path + "_RGB.png", typeof(Texture2D)) as Texture;

                Texture _aphlaTex = null;
                _aphlaTex = AssetDatabase.LoadAssetAtPath(path + "_A.png", typeof(Texture2D)) as Texture;

                if (_ainTex == null) Debug.LogError("_ainTex" + " = " + path);
                if (_aphlaTex == null) Debug.LogError("_aphlaTex");
                mSrcMaterial.SetTexture("_MainTex", _ainTex);
                mSrcMaterial.SetTexture("_AlphaTex", _aphlaTex);
            }
            else Debug.LogError("not find shader / Split Images");
        }
    }

    private void splitTexture()
	{
		Texture2D RGBTex = new Texture2D(src.width,src.height,TextureFormat.RGB24,false);
		Texture2D aphlaTex = new Texture2D(src.width,src.height,TextureFormat.RGB24,false);

		Color[] c = src.GetPixels();
		RGBTex.SetPixels(c);
		for (int i = 0 ;i < c.Length; i++) {
			c[i].r = c[i].a;
			c[i].g = c[i].a;
			c[i].b = c[i].a; 
		}
		aphlaTex.SetPixels(c); 
	
		byte[] RGBTexData = RGBTex.EncodeToPNG();
		byte[] aphlaTexData = aphlaTex.EncodeToPNG();
		string path = AssetDatabase.GetAssetPath(src);
		path = path.Substring(0,path.LastIndexOf("."));
		if (RGBTexData != null) {
			File.WriteAllBytes(path + "_RGB.png", RGBTexData);
		}
		if (aphlaTexData != null) {
			File.WriteAllBytes(path + "_A.png", aphlaTexData);
        }

		DestroyImmediate(RGBTex);
		DestroyImmediate(aphlaTex);
		AssetDatabase.Refresh();
		EditorUtility.FocusProjectWindow();
		Selection.activeObject = src;

        if (mSrcMaterial != null)
        {
            Shader shader = mIsSplitUI ? Shader.Find("Custom/Split Images") : Shader.Find(mSrcMaterial.shader.name + " SA");
            if (shader != null)
            {
                mSrcMaterial.shader = shader;

                string texPath = path + "_RGB.png";

                Texture _ainTex = null;
                _ainTex = AssetDatabase.LoadAssetAtPath(path + "_RGB.png", typeof(Texture2D)) as Texture;

                Texture _aphlaTex = null;
                _aphlaTex = AssetDatabase.LoadAssetAtPath(path + "_A.png", typeof(Texture2D)) as Texture;

                if (_ainTex == null) Debug.LogError("_ainTex" + " = " + path);
                if (_aphlaTex == null) Debug.LogError("_aphlaTex");
                mSrcMaterial.SetTexture("_MainTex", _ainTex);
                mSrcMaterial.SetTexture("_AlphaTex", _aphlaTex);
            }
            else Debug.LogError("not find shader / Split Images");
        }

        mSrcMaterial = null;
	}
}
