using System.Linq;
using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class ParticleDepth : MonoBehaviour
{
    public int renderQueue = 3000;
    public bool runOnlyOnce = false;
    public int depth = 0;
    public bool autoDestroy;
    public bool autoHide;
    public float delay = 1f;
    public Renderer[] renders;
    public ParticleSystem particleSys;
	public bool autoClick;
	public bool delayHide; 
//	public GameObject particleRoot;
	private ParticleSystem [] particles = null;
	void OnEnable()
	{
		if (delayHide) 
		{
			Invoke("AutoHide", delay);
		}
	}
	void OnDisable()
	{
		CancelInvoke();
	}
    void Start()
    {
        if (renders == null || renders.Length == 0)
        {
            renders = transform.GetComponentsInChildren<Renderer>();
            //if (renders != null && renders.Length > 0) render = re[0];
        }
        if (autoDestroy)
        {
            Invoke("AutoDestroy", delay);

        }
		if(autoHide)
			particles = transform.GetComponentsInChildren<ParticleSystem>();
    }
	void AutoHide()
    {
		gameObject.SetActive (false);
    }
	void AutoDestroy()
	{
		Destroy(gameObject);
	}
    void Update()
    {
		if (autoClick && particleSys != null)
		{
			if (!particleSys.isPlaying)
			{
				particleSys.gameObject.SetActive(false);
			}
		}
        if (autoDestroy && particles != null)
        {
			for( int i = 0;i < particles.Length;i++)
			{
				if(!particles[i].isPlaying)
				{
					if (i == particles.Length-1)
					{
						Destroy(gameObject);
					}
				}
			}
		}
        if (autoHide && particles != null)
        {
            for (int i = 0; i < particles.Length; i++)
            {
                if (!particles[i].isPlaying)
                {
                    if (i == particles.Length - 1)
                    {
                        AutoHide();
                    }
                }
            }
        }
		//if (render == null) return;
        //if (render.sharedMaterial != null)
        //{
        //    render.sharedMaterial.renderQueue = renderQueue + depth;
        //}
        for (int i = 0; i < renders.Length; i++)
        {
            if (renders[i] != null && renders[i].sharedMaterial != null)
			{
           	 	renders[i].sharedMaterial.renderQueue = renderQueue + depth;
			}
        }
        if (runOnlyOnce && Application.isPlaying)
        {
            this.enabled = false;
        }
    }
}
