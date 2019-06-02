using UnityEngine;
using System.Collections;
using UnityEditor;

public class EditorApk : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	static void MyBuild(){
		string[] levels = { "Assets/Scenes/AutoUpdate.unity", "Assets/Scenes/UICreateUser.unity", "Assets/Scenes/UI_Scene.unity", "Assets/Scenes/LoadingScene.unity"};
        BuildPipeline.BuildPlayer(levels, "/Users/build/share/zjjTest/UnityProject/UnityBuild/BuildAndroid/BLEACH", BuildTarget.Android, BuildOptions.AcceptExternalModificationsToPlayer);
	}

}
