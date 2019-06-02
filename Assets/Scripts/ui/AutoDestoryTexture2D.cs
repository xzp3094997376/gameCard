using UnityEngine;
using System.Collections;

public class AutoDestoryTexture2D : MonoBehaviour
{
    private UITexture texture;
    void Start()
    {
        texture = GetComponent<UITexture>();
    }
    void OnDestroy()
    {
        if (texture)
        {
            Texture t = texture.mainTexture;
            if (t)
            {
                try
                {
                    if (t as RenderTexture)
                    {
                        ((RenderTexture)t).Release();
                        Destroy(t);
                    }
                    else
                    {
                        Resources.UnloadAsset(t);
                        Destroy(t);
                    }
                }
                catch (System.Exception e)
                {

                }
            }
        }
        
    }
}
