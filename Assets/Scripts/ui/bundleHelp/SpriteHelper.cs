using UnityEngine;
using System.Collections;
using System;

public class SpriteHelper : MonoBehaviour
{
    public string atlasName;
    private AtlasItem item;
    UISprite sp = null;
    void Awake()
    {
        sp = GetComponent<UISprite>();
        init();
    }
    void init()
    {
        if (sp && sp.atlas == null)
        {
            item = AtlasMrg.getInstance().getAtlas(atlasName);
            UIAtlas atlas = null;
            if (item != null)
            {
                atlas = item.atlas;
                item.retain();
                sp.atlas = atlas;
                reBuild();
            }
            else
            {
                item = AtlasMrg.getInstance().addAtlas(atlasName);
                if (item != null)
                {
                    item.retain();
                    atlas = item.atlas;
                    sp.atlas = atlas;
                    reBuild();
                }
                //StartCoroutine(AtlasMrg.getInstance().addAtlasAsync(atlasName, (it) => {
                //    if (it == null) return;
                //    item = it;
                //    item.retain();
                //    atlas = item.atlas;
                //    sp.atlas = atlas;
                //    reBuild();
                //}));

            }
        }

    }

    private void reBuild()
    {
        MySpriteAnimation ani = GetComponent<MySpriteAnimation>();
        if (ani)
        {
            ani.RebuildSpriteList();
        }
        UISpriteAnimation a = GetComponent<UISpriteAnimation>();
        if (a)
        {
            a.RebuildSpriteList();
        }
    }

    void OnEnable()
    {
        if (sp && sp.atlas == null)
            init();
    }
    void OnDestroy()
    {
        if (item != null)
        {
            item.release();
        }
    }

}
