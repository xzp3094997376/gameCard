using UnityEngine;
using SLua;

[CustomLuaClass]
public class AspectUtility : MonoBehaviour
{
    public Vector2 maxAspectRatio = new Vector2(16, 9);
    public Vector2 minAspectRatio = new Vector2(3, 2);
    public bool landscapeModeOnly = true;

    private float _wantedAspectRatio = 1.5f;
    static public bool _landscapeModeOnly = true;
    static float wantedAspectRatio;
    static Camera cam;
    static Camera backgroundCam;

    public static AspectUtility instance { get { return _instance; } }
    private static AspectUtility _instance;

    void Awake()
    {
        if (_instance == null)
        {
            _instance = this;
            //DontDestroyOnLoad();

            UpdateLayout();
        }
        else
        {
            Destroy(this);
        }
    }

    public void UpdateLayout()
    {
        if (Screen.width * maxAspectRatio.y > Screen.height * maxAspectRatio.x)
        {
            _wantedAspectRatio = maxAspectRatio.x / maxAspectRatio.y;
        }
        else if (Screen.width * minAspectRatio.y < Screen.height * minAspectRatio.x)
        {
            _wantedAspectRatio = minAspectRatio.x / minAspectRatio.y;
        }
        else
        {
            _wantedAspectRatio = (float)Screen.width / Screen.height;
        }

        _landscapeModeOnly = landscapeModeOnly;
        cam = GetComponent<Camera>();
        if (!cam)
        {
            cam = Camera.main;
        }

        if (!cam)
        {
            Debug.Log("No camera available");
            return;
        }
        wantedAspectRatio = _wantedAspectRatio;
        SetCamera();
    }

    public static void SetCamera()
    {
        float currentAspectRatio = 0.0f;
        if (Screen.orientation == ScreenOrientation.LandscapeRight ||
            Screen.orientation == ScreenOrientation.LandscapeLeft)
        {
            currentAspectRatio = (float)Screen.width / Screen.height;
        }
        else
        {
            if (Screen.height > Screen.width && _landscapeModeOnly)
            {
                currentAspectRatio = (float)Screen.height / Screen.width;
            }
            else
            {
                currentAspectRatio = (float)Screen.width / Screen.height;
            }
        }
        // If the current aspect ratio is already approximately equal to the desired aspect ratio,
        // use a full-screen Rect (in case it was set to something else previously)

        //Debug.Log("currentAspectRatio = " + currentAspectRatio + ", wantedAspectRatio = " + wantedAspectRatio);

        if ((int)(currentAspectRatio * 100) / 100.0f == (int)(wantedAspectRatio * 100) / 100.0f)
        {
            cam.rect = new Rect(0.0f, 0.0f, 1.0f, 1.0f);
            if (backgroundCam)
            {
                Destroy(backgroundCam.gameObject);
            }
            return;
        }

        // Pillarbox
        if (currentAspectRatio > wantedAspectRatio)
        {
            float inset = 1.0f - wantedAspectRatio / currentAspectRatio;
            cam.rect = new Rect(inset / 2, 0.0f, 1.0f - inset, 1.0f);
        }
        // Letterbox
        else
        {
            float inset = 1.0f - currentAspectRatio / wantedAspectRatio;
            cam.rect = new Rect(0.0f, inset / 2, 1.0f, 1.0f - inset);
        }
        if (!backgroundCam)
        {
            // Make a new camera behind the normal camera which displays black; otherwise the unused space is undefined
            backgroundCam = new GameObject("BackgroundCam", typeof(Camera)).GetComponent<Camera>();
            backgroundCam.depth = int.MinValue;
            backgroundCam.clearFlags = CameraClearFlags.SolidColor;
            backgroundCam.backgroundColor = Color.black;
            backgroundCam.cullingMask = 0;
        }
    }

    public static int screenHeight
    {
        get
        {
            return (int)(Screen.height * cam.rect.height);
        }
    }

    public static int screenWidth
    {
        get
        {
            return (int)(Screen.width * cam.rect.width);
        }
    }

    public static int xOffset
    {
        get
        {
            return (int)(Screen.width * cam.rect.x);
        }
    }

    public static int yOffset
    {
        get
        {
            return (int)(Screen.height * cam.rect.y);
        }
    }

    public static Rect screenRect
    {
        get
        {
            return new Rect(cam.rect.x * Screen.width, cam.rect.y * Screen.height, cam.rect.width * Screen.width, cam.rect.height * Screen.height);
        }
    }

    public static Vector3 mousePosition
    {
        get
        {
            Vector3 mousePos = Input.mousePosition;
            mousePos.y -= (int)(cam.rect.y * Screen.height);
            mousePos.x -= (int)(cam.rect.x * Screen.width);
            return mousePos;
        }
    }

    public static Vector2 guiMousePosition
    {
        get
        {
            Vector2 mousePos = Input.mousePosition;//Event.current.mousePosition;
            mousePos.y = Mathf.Clamp(mousePos.y, cam.rect.y * Screen.height, cam.rect.y * Screen.height + cam.rect.height * Screen.height);
            mousePos.x = Mathf.Clamp(mousePos.x, cam.rect.x * Screen.width, cam.rect.x * Screen.width + cam.rect.width * Screen.width);
            return mousePos;
        }
    }
}