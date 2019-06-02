using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class SZUIRenderQueue : MonoBehaviour
{
    public int renderQueue = 3100;
    public bool runOnlyOnce = false;
	Renderer _renderer;
    void Start()
    {
		_renderer = GetComponent<Renderer>();
    }
    void Update()
    {
        if (_renderer != null && _renderer.sharedMaterial != null)
        {
            _renderer.sharedMaterial.renderQueue = renderQueue;
        }
        if (runOnlyOnce && Application.isPlaying)
        {
            this.enabled = false;
        }
    }
}