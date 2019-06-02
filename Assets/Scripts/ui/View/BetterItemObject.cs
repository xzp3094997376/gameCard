/*
 */
using UnityEngine;
using System.Collections;

/// <summary>
/// item对像的封装类Lzh_LoopItemObject，不要求具体的item类来继承它。
/// 但我们要示具体的item对像一定要包含UIWidget组件。
/// </summary>
[System.Serializable]
public class BetterItemObject
{
	/// <summary>
	/// The widget.
	/// </summary>
	public UIWidget widget;
    public UluaBinding binding;

	/// <summary>
	/// 本item，在实际整个scrollview中的索引位置，
	/// 即对就数据，在数据列表中的索引
	/// </summary>
	public int dataIndex= -1;

}
