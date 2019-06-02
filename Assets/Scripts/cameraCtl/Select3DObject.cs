using UnityEngine;
using System.Collections;
using SLua;

public class Select3DObject : MonoBehaviour
{
	private bool m_IsMouseDown = false;

	private Vector2 startPos = Vector2.zero;
	private Vector2 endPos = Vector2.zero;
	private bool isMouse = true;
	private float mouseDelta = 4f;
	private float touchDelta = 10f;
	private Camera mCamera;
	private bool fistTouch;
	void Awake()
	{
	}
	
	void OnEnable ()
	{
	}
	
	void Start()
	{
		mCamera = Camera.main;
		#if UNITY_EDITOR
		Material mtl = RenderSettings.skybox;
		if (mtl != null)
		{
			mtl.shader = Shader.Find(mtl.shader.name);
			
		}
		GameObject mGobj = GameObject.Find("scene");
		if (mGobj != null)
		{
			ModelShowUtil.resetShader(mGobj.transform);
		}
		
		#endif

		//SceneManager.CallBack(this);
		
	}
	/// <summary>
	/// 获取点击的屏幕坐标
	/// </summary>
	public Vector3 touchPostion
	{
		get
		{
			if (Input.touchCount > 0)
			{
				isMouse = false;
				return Input.GetTouch(0).position;
			}
			else
			{
				return Input.mousePosition;
			}
			//return Vector3.zero;
		}
	}
	public bool TouchBegin()
	{
		#if UNITY_EDITOR
		return Input.GetMouseButtonDown(0);
		#else
		if (Input.touchCount == 2) fistTouch = false; 
		return (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began);
		#endif
	}
	// Update is called once per frame
	void Update()
	{
		if (TouchBegin ()) {
			if (UICamera.isOverUI) {
				m_IsMouseDown = false;
				return;
			}
			fistTouch = true;
			m_IsMouseDown = true;
			startPos = touchPostion;
		}
		
		
		if (m_IsMouseDown && Input.GetMouseButtonUp (0)) {
			m_IsMouseDown = false;
			Vector2 delta = endPos - startPos;
			float _delta = isMouse ? mouseDelta : touchDelta;
			if (delta.sqrMagnitude < _delta) {
				onClickBuilding ();
			}
		}

		if (m_IsMouseDown) {
			endPos = touchPostion;
		}
	}

	private void onClickBuilding()
	{
		Ray ray = mCamera.ScreenPointToRay(Input.mousePosition);
		RaycastHit hit;
		if (Physics.Raycast(ray, out hit))
		{
			BuildCtrlTarget sc = hit.transform.GetComponent<BuildCtrlTarget>();
			GameObject go = null;
			if (sc)
			{
				go = sc.gameObject;
				sc.GetComponent<Collider>().enabled = false;
				
				sc.onClick();
				sc.GetComponent<Collider>().enabled = true;
			}
		}
	}
}
