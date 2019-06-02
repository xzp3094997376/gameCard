using UnityEngine;
using System.Collections;
using System;

public class Scene : MonoBehaviour
{
    public struct Tags
    {
        public const string Map = "Map";
        public const string Layer = "Layer";
        public const string Tile = "Tile";
        public const string Overlay = "Overlay";
        public const string UICamera2D = "NGUI";
        public const string UICamera3D = "UICamera3D";
        public const string UIFXCamera = "UIFXCamera";
        public const string UICameraBook = "UICameraBook";
    }
    private Camera mainCamera;
    public Camera uiCamera2D { get { return _uiCamera2D; } }
    private Camera _uiCamera2D;
    public Camera uiCamera3D { get { return _uiCamera3D; } }
    private Camera _uiCamera3D;
    public Camera uiFxCamera { get { return _uiFxCamera; } }
    private Camera _uiFxCamera;
    public Transform uiLayer2D { get { return _uiLayer2D; } }
    private Transform _uiLayer2D;
    public Transform uiLayer3D { get { return _uiLayer3D; } }
    private Transform _uiLayer3D;
    public Transform uiLayerFx { get { return _uiLayerFx;} }
    private Transform _uiLayerFx;
    private GameObject _book3DLayer;
    public GameObject book3DLayer { get { return _book3DLayer; } }

    public static Action OnSceneLoaded;
    public static Action OnSceneDestroy;

    private static Scene _instance;
    public static Scene Instance { get { return _instance as Scene; } }

    private Vector2 UISIZE = new Vector2(1134, 750);

    void Awake()
    {
        if (_instance != null)
        {
            Destroy(_instance);
        }
        _instance = this;

        _InitLayer();

        if (OnSceneLoaded != null)
        {
            OnSceneLoaded();
        }
    }

    public void SetUILayer3DActive(bool value)
    {
        _uiLayer3D.gameObject.SetActive(value);
    }

    private void _InitLayer()
    {
        foreach (Camera c in Camera.allCameras)
        {
            if (c.gameObject.CompareTag ( Tags.UICamera2D))
            {
                _uiCamera2D = c;
                _uiLayer2D = _uiCamera2D.transform.parent;

                mainCamera = _uiCamera2D; //_uiCamera2D.rect = Camera.main.rect;
                _uiCamera2D.rect = mainCamera.rect;
            }
            else if (c.gameObject.CompareTag( Tags.UICamera3D))
            {
                _uiCamera3D = c;
                _uiLayer3D = _uiCamera3D.transform.parent.GetChild(0);
                if (_uiLayer3D == c.transform)
                {
                    _uiLayer3D = _uiCamera3D.transform.parent.GetChild(0);
                }
            }
            else if (c.GetComponent<Camera>().CompareTag( Tags.UIFXCamera))
            {
                _uiFxCamera = c;
                _uiLayerFx = _uiCamera2D.transform.parent;

                _uiFxCamera.rect = mainCamera.rect;
            }
            else if (c.GetComponent<Camera>().CompareTag(Tags.UICameraBook))
            {
                _book3DLayer = GameObject.FindGameObjectWithTag(Tags.UICameraBook).transform.parent.gameObject;
                _book3DLayer.SetActive(false);
            }
        }
    }

    void Start()
    {
        _UpdateLayout();

        // 隐藏3D相机
        if (_uiLayer3D != null)
        {
            _uiCamera3D.gameObject.SetActive(false);
        }
    }

#if UNITY_WEBPLAYER
    void Update()
    {
        AspectUtility.instance.UpdateLayout();
        _UpdateLayout();

        if (AspectUtility.screenWidth * GameConfig.UISIZE.y > AspectUtility.screenHeight * GameConfig.UISIZE.x)
        {
            _uiCamera2D.rect = _uiFxCamera.rect = mainCamera;
        }
        else
        {
            _uiCamera2D.rect = _uiFxCamera.rect = mainCamera.rect;
        }
    }
#endif
    private void _UpdateLayout()
    {
        UIRoot root = _uiCamera2D.transform.parent.GetComponent<UIRoot>();
        //UIRoot fxRoot = _uiFxCamera.transform.parent.GetComponent<UIRoot>();

        int height;
        if (AspectUtility.screenWidth * UISIZE.y > AspectUtility.screenHeight * UISIZE.x)
        {
            height = (int)UISIZE.y;
            if (root != null)
            {
                root.maximumHeight = height;
                root.minimumHeight = height;
            }

            //if (fxRoot != null && fxRoot != root)
            //{
            //    fxRoot.manualHeight = height;
            //    fxRoot.minimumHeight = height;
            //}

            if (_uiLayer3D != null && _uiCamera3D.gameObject.activeSelf)
            {
                _uiCamera3D.rect = new Rect(
                    _uiCamera3D.rect.x * AspectUtility.screenHeight * UISIZE.x / (AspectUtility.screenWidth * UISIZE.y),
                    _uiCamera3D.rect.y,
                    _uiCamera3D.rect.width,
                    _uiCamera3D.rect.height
                );
                _uiLayer3D.localScale *= AspectUtility.screenHeight / UISIZE.y;
            }
        }
        else
        {
            height = (int)(AspectUtility.screenHeight * UISIZE.x / AspectUtility.screenWidth);
            if (root != null)
            {
                root.minimumHeight = height;
                root.maximumHeight = height;
            }

            //if (fxRoot != null)
            //{
            //    fxRoot.manualHeight = height;
            //    fxRoot.minimumHeight = height;
            //}

            if (_uiLayer3D != null)
            {
                _uiCamera3D.rect = new Rect(
                    _uiCamera3D.rect.x,
                    _uiCamera3D.rect.y * AspectUtility.screenWidth * UISIZE.y / (AspectUtility.screenHeight * UISIZE.x),
                    _uiCamera3D.rect.width,
                    _uiCamera3D.rect.height
                );
                _uiLayer3D.localScale *= AspectUtility.screenWidth / UISIZE.x;
            }
        }
    }

    void OnDestroy()
    {
        if (OnSceneDestroy != null)
        {
            OnSceneDestroy();
        }
    }
}
