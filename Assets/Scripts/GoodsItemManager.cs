using UnityEngine;
using System.Collections;

public class GoodsItemManager : MonoBehaviour
{
    public CustomSprite icon;
    public UILabel count;
    public UILabel name;
    public GameObject flash;
    public UISprite frame;
    public GameObject charPiece;
    public GameObject xibie;
    public void serInfo(string iconName, string goodsname, string count, string type, string frame, string altasName)
    {
        if (type.IndexOf("Piece") > -1)
        {
            charPiece.SetActive(true);
        }
        else
        {
            charPiece.SetActive(false);
        }
        icon.setImage(iconName, altasName);
        
        xibie.SetActive(type == "char");
        this.frame.spriteName = frame;
        this.name.text = goodsname;
        this.count.text = count;
    }
}
