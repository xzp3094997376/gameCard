using UnityEngine;
using System.Collections;
using Pomelo.DotNetClient;
using SimpleJson;
public class Saver : MonoBehaviour {

	// Use this for initialization
    PomeloClient m_PomeloClient = null;
	void Start () {
        m_PomeloClient = new PomeloClient("127.0.0.1", 3150);
        JsonObject user = new JsonObject();
        //m_PomeloClient.connect(user, (data) =>
        //{

        //});
	}
	
	// Update is called once per frame
	void Update () {
       // MyDebug.Log(Time.timeScale);
        if (Input.GetMouseButtonDown(0))
        {
            if (Time.timeScale > 0)
                Time.timeScale = 0;
            else
                Time.timeScale = 1;
        }
	}
}
