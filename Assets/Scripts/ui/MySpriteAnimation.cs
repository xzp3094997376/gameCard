using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(UISprite))]
public class MySpriteAnimation : MonoBehaviour
{
    public bool hideWhenFinish = false;
    public int mFPS = 30;
    public float mLoopTimeDelta = 0;
    public string mPrefix = "";
    public bool mLoop = true;
    public bool mSnap = true;

    protected UISprite mSprite;
    protected float mDelta = 0f;
    protected int mIndex = 0;
    protected bool mActive = true;
    protected List<string> mSpriteNames = new List<string>();
    private bool isDelay = false;

    /// <summary>
    /// Number of frames in the animation.
    /// </summary>

    public int frames { get { return mSpriteNames.Count; } }

    /// <summary>
    /// Animation framerate.
    /// </summary>

    public int framesPerSecond { get { return mFPS; } set { mFPS = value; } }

    /// <summary>
    /// Set the name prefix used to filter sprites from the atlas.
    /// </summary>

    public string namePrefix { get { return mPrefix; } set { if (mPrefix != value) { mPrefix = value; RebuildSpriteList(); } } }

    /// <summary>
    /// Set the animation to be looping or not
    /// </summary>

    public bool loop { get { return mLoop; } set { mLoop = value; } }

    /// <summary>
    /// Returns is the animation is still playing or not
    /// </summary>

    public bool isPlaying { get { return mActive; } }

    /// <summary>
    /// Rebuild the sprite list first thing.
    /// </summary>

    protected virtual void Start() { RebuildSpriteList(); }

    /// <summary>
    /// Advance the sprite animation process.
    /// </summary>

    protected virtual void Update()
    {
        if (mActive && mSpriteNames.Count > 1 && Application.isPlaying && mFPS > 0)
        {
            mDelta += RealTime.deltaTime;
            float rate = 1f / mFPS;
            if (isDelay)
            {
                if (mDelta >= mLoopTimeDelta)
                {
                    mActive = mLoop;
                    isDelay = false;
                    mDelta = 0;
                }
                return;
            }
            if (rate < mDelta)
            {

                mDelta = (rate > 0f) ? mDelta - rate : 0f;

                if (++mIndex >= mSpriteNames.Count)
                {
                    mIndex = 0;
                    mActive = mLoop;
                    if (mLoop && mLoopTimeDelta > 0)
                    {
                        isDelay = true;
                        mDelta = 0;
                        return;
                    }

                    if (hideWhenFinish)
                    {
                        gameObject.SetActive(!hideWhenFinish);
                    }
                }

                if (mActive)
                {
                    mSprite.spriteName = mSpriteNames[mIndex];
                    if (mSnap) mSprite.MakePixelPerfect();
                }
            }
        }
    }

    /// <summary>
    /// Rebuild the sprite list after changing the sprite name.
    /// </summary>

    public void RebuildSpriteList()
    {
        if (mSprite == null) mSprite = GetComponent<UISprite>();
        mSpriteNames.Clear();

        if (mSprite != null && mSprite.atlas != null)
        {
            List<UISpriteData> sprites = mSprite.atlas.spriteList;

            for (int i = 0, imax = sprites.Count; i < imax; ++i)
            {
                UISpriteData sprite = sprites[i];

                if (string.IsNullOrEmpty(mPrefix) || sprite.name.StartsWith(mPrefix))
                {
                    mSpriteNames.Add(sprite.name);
                }
            }
            mSpriteNames.Sort();
        }
    }

    /// <summary>
    /// Reset the animation to the beginning.
    /// </summary>

    public void Play() { mActive = true; }

    /// <summary>
    /// Pause the animation.
    /// </summary>

    public void Pause() { mActive = false; }

    /// <summary>
    /// Reset the animation to frame 0 and activate it.
    /// </summary>
    void OnEnable()
    {
        if (Application.isPlaying)
        {
            Reset();
        }
    }

    public void Reset()
    {
        mActive = true;
        mIndex = 0;

        if (mSprite != null && mSpriteNames.Count > 0)
        {
            mSprite.spriteName = mSpriteNames[mIndex];
            if (mSnap) mSprite.MakePixelPerfect();
        }
    }

    public void ResetToBeginning()
    {
        if (gameObject.activeSelf)
        {
            Reset();
        }
        else
        {
            gameObject.SetActive(true);
        }
    }
}
