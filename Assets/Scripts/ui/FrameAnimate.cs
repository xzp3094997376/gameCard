using UnityEngine;
using System.Collections;

/// <summary>
/// author:Roy
/// description:
/// auto play ngui frame animations.
/// 
/// </summary>
public class FrameAnimate : MonoBehaviour
{

    UISprite m_Sprite = null;
    BetterList<string> m_Sprites = null;
    int m_FrameCount = 0;
    public int m_FramesPerSecond = 25;  //frames to play in 1 second
    public float m_Delay = 0;
    public bool isOnce = false;
    float m_TimeCount = 0;
    float m_UpdateTime = 0;
    bool isDelay = false;
	// Use this for initialization
	void Start () {
        InitValue();

	}
    /// <summary>
    /// init base values
    /// </summary>
    private void InitValue()
    {
        m_Sprite = this.GetComponent<UISprite>();
        UIAtlas altas = m_Sprite.atlas;
        m_Sprites = altas.GetListOfSprites();
        if (m_FramesPerSecond == 0)
            m_FramesPerSecond = 25;
        isDelay = true;
        m_UpdateTime = 1.0f / m_FramesPerSecond;
    }
    /// <summary>
    /// enable 
    /// </summary>
    void OnEnable()
    {
        InitValue();
    }
	// Update is called once per frame
    /// <summary>
    /// modify frame when is need 
    /// </summary>
	void Update () {
        m_TimeCount += Time.deltaTime;
        if (isDelay)
        {
            if (m_TimeCount >= m_Delay)
            {
                isDelay = false;
                m_TimeCount = 0;
            }
            return;
        }
        

        if (m_TimeCount >= m_UpdateTime)
        {
            m_TimeCount -= m_UpdateTime;
            m_FrameCount = (m_FrameCount + 1) % m_Sprites.size;
            m_Sprite.spriteName = m_Sprites[m_FrameCount];
            if (m_FrameCount + 1 == m_Sprites.size )
            {
                if (isOnce)
                {
                    enabled = false;
                }
            }
            if (m_FrameCount+1 == m_Sprites.size && m_Delay > 0)
            {
                isDelay = true;
                m_TimeCount = 0;
            }
        }

	}
}
