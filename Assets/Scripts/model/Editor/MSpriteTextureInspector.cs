using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

[CanEditMultipleObjects]
[CustomEditor(typeof(MSpriteTexture), true)]
public class MSpriteTextureInspector : Editor 
{
	MSpriteTexture Mst;
	public override void OnInspectorGUI ()
	{
		Mst = target as MSpriteTexture;
		if(Mst != null)
		{
			if(Mst.gameObject.GetComponentInChildren<UISprite>() == null)
			{	
				GameObject go = null;
				if(Mst.transform.FindChild("_Sprite") != null)
				{
					go = Mst.transform.FindChild("_Sprite").gameObject;
				}

				if(go == null)
				{
					go = NGUITools.AddChild(Mst.gameObject);
					go.name = "_Sprite";
				}
				go.AddComponent<UISprite>();
			}

			if(Mst.gameObject.GetComponentInChildren<UITexture>() == null)
			{
				GameObject go = null;
				if(Mst.transform.FindChild("_Texture") != null)
				{
					go = Mst.transform.FindChild("_Texture").gameObject;
				}
				
				if(go == null)
				{
					go = NGUITools.AddChild(Mst.gameObject);
					go.name = "_Texture";
				}
				go.AddComponent<UITexture>();
			}
		}

		base.DrawDefaultInspector ();
	}



}
