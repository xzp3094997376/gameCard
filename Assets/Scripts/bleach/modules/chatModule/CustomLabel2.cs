
#if !UNITY_3_5
#define DYNAMIC_FONT
#endif

using UnityEngine;
using UnityEngine.Serialization;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;
using System;

public class CustomLabel2 : UIWidget {

    public UIFont symbolFont { get; set; }
    public UIWidget block;
    public GameObject labelPrefab { get; set; }
    public GameObject facePrefab { get; set; }
    //public string testString;
    public NGUIText.Alignment alignment = NGUIText.Alignment.Left;
	public int minWidth = 0;

	public UISprite region;

	public int heightAdjust = 0;
	public int lineSpace = 6;

	[SerializeField]
	public int paddingLeft = 8;
	[SerializeField]
    public int paddingTop = 8;
	[SerializeField]
    public int paddingRight = 8;
	[SerializeField]
    public int paddingBottom = 6;

	private string mText = "";
	private int maxLineWidth = 0;

	public Action onArchor;

	public string text
	{
		get 
		{
			return mText; 
		}
		set 
		{
			if(!string.IsNullOrEmpty(value)){
				mText = value;
				Reset();
				ParserSymbol(mText);

				if(onArchor != null){
					onArchor();
				}
			}
		}
	}

	public enum InfoType
	{
		Text,
		Face,
	}
	
	public class LabelType
	{
		public object info;
		public InfoType type;
		
		public LabelType(object text,InfoType tp)
		{
			info = text;
			type = tp;
		}
	}

	private List<UILabel> labelCaches;
	private List<UILabel> labelCur;
	private List<GameObject> faceCaches;
	private List<GameObject> faceCur;
	private List<LabelType> list;
	
	private UILabel label;
	private UISprite sprite;
	
	private int positionX = 0;
	private int positionY = 0;
	private float finalSpacingX = 0f;
	private bool useSpriteWidth = true;
    private FontItem item;

    override protected void Awake(){
        symbolFont = null;
        if (!Application.isPlaying) return;
        item = FontMrg.getInstance().getFont("AllAtlas/fontAltlas/emotionFont");
        UIFont font = null;
        if (item != null)
        {
            item.retain();
            font = item.font;
            symbolFont = font;
            gameObject.SetActive(false);
            gameObject.SetActive(true);
        }
        else
        {
            item = FontMrg.getInstance().addFont("AllAtlas/fontAltlas/emotionFont");
            if (item != null)
            {
                item.retain();
                symbolFont = item.font;
            }
        }
        labelPrefab = ClientTool.Pureload("Prefabs/moduleFabs/chatModule/ChatLabel");
        facePrefab = ClientTool.Pureload("Prefabs/moduleFabs/chatModule/ChatFace2");
        AssetBundles.AssetBundleLoader.Retain("Prefabs/moduleFabs/chatModule/ChatLabel".ToLower());
        AssetBundles.AssetBundleLoader.Retain("Prefabs/moduleFabs/chatModule/ChatFace2".ToLower());
        labelCur = new List<UILabel>();
		faceCur = new List<GameObject>();
		labelCaches = new List<UILabel>();
		faceCaches = new List<GameObject>();
		list = new List<LabelType>();

		label = labelPrefab.GetComponent<UILabel>();
        if (label.bitmapFont == null)
        {
            var it = FontMrg.getInstance().getFont("font/MyDanicFont");
            UIFont f = null;
            if (it != null)
            {
                f = it.font;
            }
            label.bitmapFont = f;
        }
        sprite = facePrefab.GetComponent<UISprite>();

		maxLineWidth = this.width;
		//Debug.Log("max line width: " + maxLineWidth);
		//block.height = 0;

		Vector4 myBorder = region.border;
		paddingLeft = Mathf.CeilToInt(myBorder.x);
		paddingBottom = Mathf.CeilToInt(myBorder.y);
		paddingRight = Mathf.CeilToInt(myBorder.z);
		paddingTop = Mathf.CeilToInt(myBorder.w);
	}

    //	void Start(){
    //		this.text = testString;
    //	}
    void OnDestroy()
    {
        if (item != null)
        {
            item.release();
        }
        DestroyImmediate(labelPrefab, false);
        DestroyImmediate(facePrefab, false);
        labelPrefab = null;
        facePrefab = null;
        AssetBundles.AssetBundleLoader.Release("Prefabs/moduleFabs/chatModule/ChatLabel".ToLower());
        AssetBundles.AssetBundleLoader.Release("Prefabs/moduleFabs/chatModule/ChatFace2".ToLower());
    }
    public void UpdateMyNGUIText(){
		NGUIText.bitmapFont = symbolFont;
		NGUIText.fontSize = label.fontSize;
		NGUIText.fontStyle = label.fontStyle;
		NGUIText.fontScale = 1.0f;
	}

	void OffsetPosition(){
		Vector3 origin = transform.localPosition;
		if(alignment == NGUIText.Alignment.Left){
			if(pivot == Pivot.TopLeft || pivot == Pivot.Left || pivot == Pivot.BottomLeft){
				transform.localPosition = new Vector3(origin.x + paddingLeft, origin.y, origin.z);
			}
			else if(pivot == Pivot.TopRight || pivot == Pivot.Right || pivot == Pivot.BottomRight){
				transform.localPosition = new Vector3(origin.x - paddingRight , origin.y, origin.z);
			}
		}
	}

	void Align(int paddingWidth){
		switch(alignment){
		case NGUIText.Alignment.Left:
			positionX = 0 + paddingLeft;
			break;
		case NGUIText.Alignment.Right:
			positionX = paddingWidth - paddingRight;
			break;
		}
	}

	private BetterList<Transform> offsetList = new BetterList<Transform>();

	public void ApplyOffset (BetterList<Transform> verts)
	{
		Vector2 po = pivotOffset;
		
		float fx = Mathf.Lerp(0f, -mWidth, po.x);
		
		fx = Mathf.Round(fx);
		
		for (int i = 0; i < verts.size; ++i)
		{
			Vector3 vert = verts[i].localPosition;
			verts[i].localPosition = new Vector3(vert.x + fx, vert.y, vert.z);
		}
	}

	public void ParserSymbol(string text){

		offsetList = new BetterList<Transform>();

		string processedText;
		string lastText;

		int myHeight;
		int paddingWidth;

		string subStr = text;

		int adjustPaddingTop = paddingTop + heightAdjust;
		positionY = 0 - adjustPaddingTop;

//		block.width = paddingLeft;
//		block.height = paddingTop;

		int requestWidth = paddingLeft;
		int requestHeight = adjustPaddingTop;

		int maxWidth = minWidth;

		bool firstLine = true;
		while(!string.IsNullOrEmpty(subStr)){
			list = new List<LabelType>();
			UpdateMyNGUIText();

			SingleLineWrapText(subStr, out processedText, out lastText, 1.0f, out paddingWidth, out myHeight);
			if(myHeight == 0){
				myHeight = label.fontSize;
			}
			else if(useSpriteWidth){
				myHeight = sprite.height;
			}

			Align(paddingWidth);
			if(maxLineWidth - paddingWidth > maxWidth){
				maxWidth = maxLineWidth - paddingWidth;
			}

			//Debug.Log(string.Format("~~~~~~ line height: {0}", myHeight));
			if(firstLine){
				firstLine = false;
			}
			else{
				myHeight = myHeight + lineSpace;
			}

			positionY -= myHeight;

//			block.height += myHeight;
			requestHeight += myHeight;
			ShowSymbol(list);
			subStr = lastText;
		}

//		block.width += maxWidth + paddingRight;
		requestWidth += maxWidth + paddingRight;

//		block.height += paddingBottom;
		requestHeight += paddingBottom;

		block.width = requestWidth;
		block.height = requestHeight;

		if(alignment == NGUIText.Alignment.Left){
			this.width = requestWidth;
			ApplyOffset(offsetList);
		}
		else if(alignment == NGUIText.Alignment.Right){
			ApplyOffset(offsetList);
			this.width = requestWidth;
		}
	}

	private void ShowSymbol(List<LabelType> list)
	{
		foreach (LabelType item in list)
		{
			switch (item.type)
			{
			case InfoType.Text :
				CreateTextLabel(item.info as string);
				break;
			case  InfoType.Face :
				CreateFace(item.info as BMSymbol);
				break;
			}
		}
	}

	private void CreateTextLabel(string value)
	{
		UILabel label;
		if (labelCaches.Count > 0)
		{
			label = labelCaches[0];
			labelCaches.Remove(label);
			label.gameObject.SetActive(true);
		}
		else
		{
			GameObject go = GameObject.Instantiate(labelPrefab) as GameObject;
			go.transform.parent = transform;
			label = go.GetComponent<UILabel>();
			go.transform.localScale = Vector3.one;
		}

		string sbstr = "";
		string text = "";

		sbstr = value;

		int index = sbstr.IndexOf("\n");
		
		if (index > -1)
		{
			text = sbstr.Substring(0, index);
		}
		else
		{
			text = sbstr;
		}
		
		label.text = text;
		label.gameObject.transform.localPosition = new Vector3(positionX, positionY, 0);
		offsetList.Add(label.gameObject.transform);
		positionX += label.width;
		labelCur.Add(label);
	}
	
	private void CreateFace(BMSymbol symbol)
	{
		GameObject face;
		UIWidget widget;
		
		if (faceCaches.Count > 0)
		{
			face = faceCaches[0];
			faceCaches.Remove(face);
			face.SetActive(true);
		}
		else
		{
			face = GameObject.Instantiate(facePrefab) as GameObject;
			face.transform.parent = gameObject.transform;
			face.transform.localScale = facePrefab.transform.localScale;
		}
		
		UISprite sprite = face.GetComponent<UISprite>();
		sprite.spriteName = symbol.spriteName;
        //sprite.MakePixelPerfect();
		widget = face.GetComponent<UIWidget>();
		widget.pivot = UIWidget.Pivot.BottomLeft;
		face.transform.localPosition = new Vector3(positionX, positionY, 0);
		offsetList.Add(face.gameObject.transform);
		positionX += widget.width;
		
		faceCur.Add(face);
	}

	private void Reset()
	{
		positionX = 0;
		positionY = 0;
		
		while (labelCur.Count > 0)
		{
			UILabel lab = labelCur[0];
			
			labelCur.Remove(lab);
			labelCaches.Add(lab);
			lab.gameObject.SetActive(false);
		}
		
		while (faceCur.Count > 0)
		{
			GameObject go = faceCur[0];
			
			faceCur.Remove(go);
			faceCaches.Add(go);
			go.SetActive(false);
		}
	}

	//	public void Parse(string text){
	//		UpdateMyNGUIText();
	//		List<LabelType> myList = new List<LabelType>();
	//
	//		int textLength = text.Length;
	//
	//		int prevIndex = 0;
	//
	//		int offset = 0;
	//		for (; offset < textLength; ++offset)
	//		{
	//			// See if there is a symbol matching this text
	//			BMSymbol symbol = NGUIText.GetSymbol(text, offset, textLength);
	//			
	//			if (symbol != null)
	//			{
	//				if(prevIndex < offset){
	//					myList.Add(new LabelType(text.Substring(prevIndex, offset-prevIndex), InfoType.Text));
	//				}
	//
	//				myList.Add(new LabelType(symbol, InfoType.Face));
	//
	//				offset += symbol.length-1;
	//
	//				prevIndex = offset+1;
	//			}
	//		}
	//
	//		if(prevIndex < textLength){
	//			myList.Add(new LabelType(text.Substring(prevIndex), InfoType.Text));
	//		}
	//
	//		ShowSymbol(myList);
	//	}

	#region duplicate

	public bool SingleLineWrapText (string text, out string finalText, out string lastText, float fontScale, out int paddingWidth, out int myHeight)
	{
		myHeight = 0;
		paddingWidth = maxLineWidth;

		if (maxLineWidth < 1)
		{
			finalText = "";
			lastText = text;

			return false;
		}

		if (string.IsNullOrEmpty(text)) text = " ";

		UIFont bitmapFont = label.bitmapFont;
		Font dynamicFont = null;

		#if DYNAMIC_FONT

		if(bitmapFont != null && bitmapFont.isDynamic){
			dynamicFont = bitmapFont.dynamicFont;
		}

		if(dynamicFont == null){
			//trueTypeFont may not be right!!
			dynamicFont = label.trueTypeFont;
		}

		if (dynamicFont != null){
			bitmapFont = null;
			dynamicFont.RequestCharactersInTexture(text, label.fontSize, label.fontStyle);
		}
		#endif
		
		StringBuilder sb = new StringBuilder();
		int textLength = text.Length;
		float remainingWidth = maxLineWidth;
		int start = 0, offset = 0, prev = 0;
		bool lineIsEmpty = true;
		bool fits = true;
		bool eastern = false;

		int maxHeight = 0;
		int prevIndex = 0;
		
		// Run through all characters
		for (; offset < textLength; ++offset)
		{
			char ch = text[offset];
			if (ch > 12287) eastern = true;
			
			// New line character -- start a new line
			if (ch == '\n')
			{
				break;
			}
			
			// When encoded symbols such as [RrGgBb] or [-] are encountered, skip past them
			if (NGUIText.encoding && NGUIText.ParseSymbol(text, ref offset)) { --offset; continue; }
			
			// See if there is a symbol matching this text
			BMSymbol symbol = NGUIText.GetSymbol(text, offset, textLength);
			
			// Calculate how wide this symbol or character is going to be
			float glyphWidth;
			
			if (symbol == null)
			{
				// Find the glyph for this character
				float w = GetGlyphWidth(ch, prev, bitmapFont, dynamicFont, label.fontSize, label.fontStyle, fontScale, 1.0f);
				//Debug.Log(string.Format("width: {0} : {1}", ch, w));
				if (w == 0f) continue;
				glyphWidth = finalSpacingX + w;
			}
			else {
				if(useSpriteWidth){
					glyphWidth = finalSpacingX + sprite.width * fontScale;
				}
				else{ 
					glyphWidth = finalSpacingX + symbol.advance * fontScale;
				}

				//Debug.Log(string.Format("width: {0} : {1}", symbol.sequence, glyphWidth));
			}
			
			// Reduce the width
			remainingWidth -= glyphWidth;


			
			// If this marks the end of a word, add it to the final string.
			if (IsSpace(ch) && !eastern && start < offset)
			{
				int end = offset - start + 1;

				if(remainingWidth <= 0f && offset < textLength){
					char cho = text[offset];
					if (cho < ' ' || IsSpace(cho)) --end;
				}

				sb.Append(text.Substring(start, end));
				lineIsEmpty = false;
				start = offset + 1;
				prev = ch;
			}
			
			// Doesn't fit?
			if (Mathf.RoundToInt(remainingWidth) < 0)
			{
				paddingWidth = Mathf.RoundToInt(remainingWidth + glyphWidth);

				// Can't start a new line
				if (lineIsEmpty){
					// This is the first word on the line -- add it up to the character that fits
					sb.Append(text.Substring(start, Mathf.Max(0, offset - start)));
					bool space = IsSpace(ch);
					if (!space && !eastern) fits = false;
					
					start = offset;
					break;
				}
				else{
					// Revert the position to the beginning of the word and reset the line
					lineIsEmpty = true;
					remainingWidth = maxLineWidth;
					offset = start - 1;
					prev = 0;

					break;
				}

			}
			else {
				paddingWidth = Mathf.RoundToInt(remainingWidth);

				prev = ch;
			}
			
			// Advance the offset past the symbol
			if (symbol != null)
			{
				if(prevIndex < offset){
					string body = text.Substring(prevIndex, offset-prevIndex);
					//Debug.Log(string.Format("=== fragment: {0}", body));
					list.Add(new LabelType(body, InfoType.Text));
				}

				//Debug.Log(string.Format("=== fragment: {0}", symbol.sequence));
				list.Add(new LabelType(symbol, InfoType.Face));

				//NGUIText original code;
				offset += symbol.length - 1;
				prev = 0;
				//NGUIText original code;

				prevIndex = offset+1;

				float height = symbol.height * fontScale;
				if(height > maxHeight) maxHeight = (int)height;
//				Debug.Log(string.Format("....{0}", symbol.sequence));
//				Debug.Log(string.Format("....{0}", height));
			}
			else{
//				float height = NGUIText.GetGlyph(ch, prev).advance * fontScale;
//				if(height > maxHeight) maxHeight= (int)height;
//				Debug.Log(string.Format("....{0}", height));
			}
		}

		if(prevIndex <= offset){
			string body = text.Substring(prevIndex, offset-prevIndex);
			//Debug.Log(string.Format("=== fragment: {0}", body));
			list.Add(new LabelType(body, InfoType.Text));
		}
		
		if (start < offset) sb.Append(text.Substring(start, offset - start));
		finalText = sb.ToString();
		lastText = text.Substring(finalText.Length);
		myHeight = maxHeight;

		return fits && (offset == textLength);
	}

	public float GetGlyphWidth (int ch, int prev, UIFont bitmapFont, Font dynamicFont, int fontSize, FontStyle fontStyle, float fontScale, float pixelDensity)
	{
		CharacterInfo mTempChar;

		if (bitmapFont != null)
		{
			bool thinSpace = false;
			
			if (ch == '\u2009')
			{
				thinSpace = true;
				ch = ' ';
			}
			
			BMGlyph bmg = bitmapFont.bmFont.GetGlyph(ch);
			
			if (bmg != null)
			{
				int adv = bmg.advance;
				if (thinSpace) adv >>= 1;
				return fontScale * ((prev != 0) ? adv + bmg.GetKerning(prev) : bmg.advance);
			}
		}
		#if DYNAMIC_FONT
		else if (dynamicFont != null)
		{
			if (dynamicFont.GetCharacterInfo((char)ch, out mTempChar, fontSize, fontStyle))
				#if UNITY_4_3 || UNITY_4_5 || UNITY_4_6
				return mTempChar.width * fontScale * pixelDensity;
			#else
			return mTempChar.advance * fontScale * pixelDensity;
			#endif
		}
		#endif
		return 0f;
	}

	void EndLine (ref StringBuilder s)
	{
		int i = s.Length - 1;
		if (i > 0 && IsSpace(s[i])) s[i] = '\n';
		else s.Append('\n');
	}

	bool IsSpace (int ch) { return (ch == ' ' || ch == 0x200a || ch == 0x200b || ch == '\u2009'); }

	void ReplaceSpaceWithNewline (ref StringBuilder s)
	{
		int i = s.Length - 1;
		if (i > 0 && IsSpace(s[i])) s[i] = '\n';
	}

	#endregion
}
