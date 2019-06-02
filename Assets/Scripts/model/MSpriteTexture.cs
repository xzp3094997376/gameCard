using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MSpriteTexture : MonoBehaviour 
{

	void OnEnable()
	{
		UISprite _uisp = this.gameObject.GetComponentInChildren<UISprite> ();
		UITexture _uitex = this.gameObject.GetComponentInChildren<UITexture> ();
		if(_uisp != null)
		{
			if(_uisp.atlas == null || string.IsNullOrEmpty(_uisp.spriteName))
			{
				_uisp.enabled = false;
				if(_uitex != null)
				{
					if(_uitex.mainTexture != null)
					{
						_uitex.enabled = true;
					}
				}
			}
			else
			{	
				if(_uisp.atlas.GetSprite(_uisp.spriteName) == null)
				{
					_uisp.enabled = false;
					if(_uitex != null)
					{
						if(_uitex.mainTexture != null)
						{
							_uitex.enabled = true;
						}
					}
				}
				else
				{
					_uisp.enabled = true;
					_uitex.enabled = false;
				}

			}
		}
		else if(_uitex != null)
		{	
			_uisp.enabled = false;
			if(_uitex.mainTexture != null)
			{
				_uitex.enabled = true;
			}
		}
		
	}
}
