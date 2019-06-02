using UnityEditor;
using UnityEngine;
using System.IO;
using System.Collections.Generic;

public class AddTexture2Atlas : EditorWindow
{

    public Texture2D src;
    public UIAtlas desAtlas;

    private const int PaddingInEditor = 3;

    [MenuItem("Window/AddTexture2Atlas")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(AddTexture2Atlas));
    }

    void OnGUI()
    {
        EditorGUI.LabelField(new Rect(PaddingInEditor, PaddingInEditor, 100, 20), "Select a Texture");
        src = (Texture2D)EditorGUI.ObjectField(new Rect(120, PaddingInEditor, position.width - 120, 16), src, typeof(Texture2D), true);
        EditorGUI.LabelField(new Rect(PaddingInEditor, PaddingInEditor + 16, 100, 20), "Select a Atlas");
        desAtlas = (UIAtlas)EditorGUI.ObjectField(new Rect(120, PaddingInEditor + 16, position.width - 120, 16), desAtlas, typeof(UIAtlas), true);

        if (src != null && desAtlas != null)
        {
            if (GUI.Button(new Rect(PaddingInEditor, position.height - 120, position.width - PaddingInEditor * 2, 20), "AddOrUpdate"))
            {
                changeMainTexture();
                addTexture();
            }
            if (GUI.Button(new Rect(PaddingInEditor, position.height - 100, position.width - PaddingInEditor * 2, 20), "Del"))
            {
                changeMainTexture();
                deleteTexture();
            }
        }
    }

	void changeMainTexture()
	{
		NGUISettings.atlas = desAtlas;
		
		Material kTargetMat = desAtlas.spriteMaterial;
		Texture2D tmp = kTargetMat.mainTexture as Texture2D;
		string p = AssetDatabase.GetAssetPath(tmp);
		p = p.Substring(0,p.LastIndexOf("_")) + ".png";
		Texture2D main = AssetDatabase.LoadAssetAtPath(p , typeof(Texture2D)) as Texture2D;
		kTargetMat.mainTexture = main;
	}
	
	private void addTexture()
	{
		Material kTargetMat = desAtlas.spriteMaterial;
		if(kTargetMat != null)
		{
			Texture2D kTargetTexture = kTargetMat.mainTexture as Texture2D;
			changeToRGBA32(kTargetTexture);
			UIAtlasMaker.AddOrUpdate(desAtlas , src);
			splitTexture();
			//compressToETC4(kTargetTexture);
		}
	}

	private void deleteTexture()
	{
		Material kTargetMat = desAtlas.spriteMaterial;
		if(kTargetMat != null)
		{
			Texture2D kTargetTexture = kTargetMat.mainTexture as Texture2D;
			
			changeToRGBA32(kTargetTexture);
			
			List<UIAtlasMaker.SpriteEntry> sprites = new List<UIAtlasMaker.SpriteEntry>();
			UIAtlasMaker.ExtractSprites(desAtlas, sprites);
			
			for (int i = sprites.Count; i > 0; )
			{
				UIAtlasMaker.SpriteEntry ent = sprites[--i];
				if (src.name == ent.name)
				{
					sprites.RemoveAt(i);
					break;
				}
			}
			UIAtlasMaker.UpdateAtlas(desAtlas, sprites);

			splitTexture();
			//compressToETC4(kTargetTexture);
		}
	}

	void changeToRGBA32(Texture2D tmp)
	{
		string path = AssetDatabase.GetAssetPath(tmp);
		TextureImporter textureimporter = AssetImporter.GetAtPath(path) as TextureImporter;
		textureimporter.isReadable = true;
		textureimporter.alphaIsTransparency = true;
		textureimporter.SetPlatformTextureSettings("Android" , 2048 , TextureImporterFormat.RGBA32);
		textureimporter.compressionQuality = (int)TextureCompressionQuality.Best;
		textureimporter.mipmapEnabled = false;
		AssetDatabase.SaveAssets();
		AssetDatabase.Refresh();
		AssetDatabase.ImportAsset(path);
	}

    void compressToETC4(Texture2D tmp)
    {
        string path = AssetDatabase.GetAssetPath(tmp);
        TextureImporter textureimporter = AssetImporter.GetAtPath(path) as TextureImporter;
        textureimporter.isReadable = false;
        textureimporter.alphaIsTransparency = false;
        textureimporter.SetPlatformTextureSettings("Android", 2048, TextureImporterFormat.ETC_RGB4, false);
        textureimporter.mipmapEnabled = false;
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        AssetDatabase.ImportAsset(path);
    }

	private void splitTexture()
	{
		Material kTargetMat = desAtlas.spriteMaterial;
		Texture2D tmp = kTargetMat.mainTexture as Texture2D;
		string p = AssetDatabase.GetAssetPath(tmp);
		TextureImporter textureimporter = AssetImporter.GetAtPath(p) as TextureImporter;
		textureimporter.isReadable = true;
		AssetDatabase.SaveAssets();
		AssetDatabase.Refresh();
		AssetDatabase.ImportAsset(p);

        Texture2D RGBTex = new Texture2D(tmp.width, tmp.height, TextureFormat.RGB24, false);
        Texture2D aphlaTex = new Texture2D(tmp.width, tmp.height, TextureFormat.RGB24, false);

        Color[] c = tmp.GetPixels();
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
        string path = AssetDatabase.GetAssetPath(tmp);
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

		if (kTargetMat != null)
		{
			Shader shader = Shader.Find("Custom/Split Images");
			if (shader != null)
			{
				kTargetMat.shader = shader;
				
				string texPath = path + "_RGB.png";
				
				Texture2D _ainTex = null;
				_ainTex = AssetDatabase.LoadAssetAtPath(path + "_RGB.png", typeof(Texture2D)) as Texture2D;
				
				Texture2D _aphlaTex = null;
				_aphlaTex = AssetDatabase.LoadAssetAtPath(path + "_A.png", typeof(Texture2D)) as Texture2D;
				
				if (_ainTex == null) Debug.LogError("_ainTex" + " = " + path);
				if (_aphlaTex == null) Debug.LogError("_aphlaTex");
				compressToETC4(_ainTex);
				compressToETC4(_aphlaTex);
				kTargetMat.SetTexture("_MainTex", _ainTex);
				kTargetMat.SetTexture("_AlphaTex", _aphlaTex);
			}
			else Debug.LogError("not find shader / Split Images");
		}
		AssetDatabase.Refresh();
		EditorUtility.FocusProjectWindow();
		Selection.activeObject = tmp;
	}
}
