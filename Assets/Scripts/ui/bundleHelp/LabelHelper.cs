using UnityEngine;
using System.Collections;

public class LabelHelper : MonoBehaviour
{
    public string fontName;
    private FontItem item;
    UILabel lab = null;
    void Awake()
    {
        lab = GetComponent<UILabel>();
        init();
    }
    //void Start()
    //{
    //    lab = GetComponent<UILabel>();

    //    Invoke("init", 0.1f);
    //}

    void init()
    {
        if (lab && lab.bitmapFont == null)
        {
            item = FontMrg.getInstance().getFont(fontName);
            UIFont font = null;
            if (item != null)
            {
                item.retain();
                font = item.font;
                lab.bitmapFont = font;
                gameObject.SetActive(false);
                gameObject.SetActive(true);
            }
            else
            {
                item = FontMrg.getInstance().addFont(fontName);
                if (item != null)
                {
                    item.retain();
                    lab.bitmapFont = item.font;
                    if (gameObject.activeInHierarchy)
                    {
                        gameObject.SetActive(false);
                        gameObject.SetActive(true);
                    }
                }
            }
        }
    }


    void OnDestroy()
    {
        if (item != null)
        {
            item.release();
        }
    }
}
