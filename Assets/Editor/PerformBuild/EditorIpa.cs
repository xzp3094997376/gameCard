using UnityEngine;
using System.Collections;
using UnityEditor;
public class EditorIpa : MonoBehaviour {


	static void MyBuild(){
		string[] levels = { "Assets/Scenes/AutoUpdate.unity", "Assets/Scenes/UICreateUser.unity", "Assets/Scenes/UI_Scene.unity", "Assets/Scenes/LoadingScene.unity"};
        BuildPipeline.BuildPlayer(levels, "/Users/build/share/zjjTest/UnityProject/UnityBuild/BuildIphone/BLEACH", BuildTarget.iOS, BuildOptions.AcceptExternalModificationsToPlayer);
	}

}
