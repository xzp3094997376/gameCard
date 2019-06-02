using UnityEngine;
using System.Collections.Generic;


public class MyUISettings
{
    static bool mLoaded = false;
    static UIFont mFont;
    static UIAtlas mAtlas;
    static string mFontName = "New Font";
    static string mAtlasName = "New Atlas";

    static Object GetObject(string name)
    {
        int assetID = PlayerPrefs.GetInt(name, -1);
        return null;
    }

    static void Load()
    {
        mLoaded = true;
        mFontName = PlayerPrefs.GetString("NGUI Font Name");
        mAtlasName = PlayerPrefs.GetString("NGUI Atlas Name");
        mFont = GetObject("NGUI Font") as UIFont;
        mAtlas = GetObject("NGUI Atlas") as UIAtlas;
        mAtlas = Resources.Load("uiImage/PublicUIAtlas", typeof(UIAtlas)) as UIAtlas;
        mFont = Resources.Load("Fonts/dynamicFont/MyDanicFont", typeof(UIFont)) as UIFont;
    }

    static void Save()
    {
        PlayerPrefs.SetString("NGUI Font Name", mFontName);
        PlayerPrefs.SetString("NGUI Atlas Name", mAtlasName);
        PlayerPrefs.SetInt("NGUI Font", (mFont != null) ? mFont.GetInstanceID() : -1);
        PlayerPrefs.SetInt("NGUI Atlas", (mAtlas != null) ? mAtlas.GetInstanceID() : -1);
    }

    static public UIFont getFont(string name)
    {
        return Resources.Load(name, typeof(UIFont)) as UIFont;
    }
    static public UIAtlas getAtlas(string name)
    {
        return Resources.Load(name, typeof(UIAtlas)) as UIAtlas;
    }
    /// <summary>
    /// 默认字体
    /// </summary>

    static public UIFont font
    {
        get
        {
            if (!mLoaded) Load();
            return mFont;
        }
        set
        {
            if (mFont != value)
            {
                mFont = value;
                mFontName = (mFont != null) ? mFont.name : "New Font";
                Save();
            }
        }
    }


    /// <summary>
    /// 默认图集
    /// </summary>

    static public UIAtlas atlas
    {
        get
        {
            if (!mLoaded) Load();
            return mAtlas;
        }
        set
        {
            if (mAtlas != value)
            {
                mAtlas = value;
                mAtlasName = (mAtlas != null) ? mAtlas.name : "New Atlas";
                Save();
            }
        }
    }


    static public string fontName { get { if (!mLoaded) Load(); return mFontName; } set { if (mFontName != value) { mFontName = value; Save(); } } }

    static public string atlasName { get { if (!mLoaded) Load(); return mAtlasName; } set { if (mAtlasName != value) { mAtlasName = value; Save(); } } }

}