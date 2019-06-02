using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//为了存放 宝箱开启后的数据
public class GoodsItem
{
	public string type;
	public string icon ;
	public string text ;
	public string goodsname;
	public string frame;
	public string atlasName;
	public GoodsItem()
	{
	}
	public GoodsItem(string i , string icon , string text,string goodsName,string frame,string atlasName )
	{
		this.type = i;
		this.icon = icon;
		this.text = text;
		this.goodsname = goodsName;
		this.frame = frame;
		this.atlasName = atlasName;
	}
}