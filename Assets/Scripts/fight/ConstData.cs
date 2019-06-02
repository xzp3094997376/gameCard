using UnityEngine;
using System.Collections;

/// <summary>
/// 战斗数据
/// </summary>
static public class ConstData
{
    static public Vector4 FightCameraDir = new Vector4(16f, 132f, 13f, 35f);//相机角度，对应CameraCtrl.m_EndDir
    static public float FightCamerX = 0.5f;//相机偏移，对应CameraCtrl.m_cameraX
    static public float FightCamerY = 0.25f;//相机偏移，对应CameraCtrl.m_cameraY
    static public float FightCamerZ = -2.5f;//相机偏移，对应CameraCtrl.m_cameraZ
		//缩放（己方1~6号位 + 宠物）
    static public float[] FightAtkScale = new float[7] { 0.2f, 0.2f, 0.2f, 0.2f, 0.2f, 0.2f, 0.2f};
    //缩放（敌方1~6号位 + 宠物）
    static public float[] FightDefScale = new float[7] { 0.2f, 0.2f, 0.2f, 0.2f, 0.2f, 0.2f, 0.2f };

    //己方站位（1~6号位 宠物）
    static public Vector3[] FightAtkPosition = new Vector3[7]
    {
			new Vector3( -2.5f, -0.6f, 1f),
			new Vector3( -2.7f, -1.8f, 0.5f),
			new Vector3( -2.9f, -3f, 0f),
			new Vector3( -4.46f, -0.6f, 1f),
			new Vector3( -4.66f, -1.8f, 0.5f),
			new Vector3( -4.86f, -3f, 0f),
            new Vector3( -3.66f, -1.8f, -0.1f),
    };

    //攻击己方站位（1~6号位 宠物）
    static public Vector3[] FightAtkPositionE = new Vector3[7]
   {
			new Vector3( -1.5f, -0.6f, 0.8f),
			new Vector3( -1.7f, -1.8f, 0.3f),
			new Vector3( -1.9f, -3f, -0.2f),
			new Vector3( -3.46f, -0.6f, 0.8f),
			new Vector3( -3.66f, -1.8f, 0.3f),
			new Vector3( -3.86f, -3f, -0.2f),
            new Vector3( -2.66f, -1.8f,-0.3f),
   };

    /// 敌方站位（1~6号位 宠物）
    static public Vector3[] FightDefPosition = new Vector3[7]
   {
			new Vector3( 2.5f, -0.6f, 1f),
			new Vector3( 2.7f, -1.8f, 0.5f),
			new Vector3( 2.9f, -3f, 0f),
			new Vector3( 4.46f, -0.6f, 1f),
			new Vector3( 4.66f, -1.8f, 0.5f),
			new Vector3( 4.86f, -3f, 0f),
            new Vector3( 3.66f, -1.8f, -0.1f),

   };

    //攻击敌方站位（1~6号位 宠物）
    static public Vector3[] FightDefPositionE = new Vector3[7]
    {
			new Vector3( 1.5f, -0.6f, 0.8f),
			new Vector3( 1.7f, -1.8f, 0.3f),
			new Vector3( 1.9f, -3f, -0.2f),
			new Vector3( 3.46f, -0.6f, 0.8f),
			new Vector3( 3.66f, -1.8f, 0.3f),
			new Vector3( 3.86f, -3f, -0.2f),
            new Vector3( 2.66f, -1.8f, -0.3f),


    };
    //攻击方合体位置
    static public Vector3[] FightHetiPosition2 = new Vector3[3]
       {
        new Vector3( -1.0f, -2.0f, -10f),//主位
        new Vector3( -1.09f, -0.7f, -1f),//从位1
        new Vector3( -1.09f, -3.0f, -11f),//从位2
       };
    //受击方合体位置
    static public Vector3[] FightHetiPositionE2 = new Vector3[3]
   {
		new Vector3( 1.05f, -2.0f, -10f),//攻击位
		new Vector3( 0.96f, -0.7f,  -1f),
        new Vector3( 0.96f, -3.0f,  -11f),
   };
    //攻击方队伍进攻位置
    static public Vector3[] FightTeamPosition = new Vector3[2]
    {
        new Vector3( 1.05f, -2.0f, -10f),//攻击位
        new Vector3( 0.96f, -0.7f, -1f),
    };
    //受击方队伍进攻位置
    static public Vector3[] FightTeamPositionE = new Vector3[2]
    {
		new Vector3( -1.0f, -2.0f, -10f),//主位
		new Vector3( -1.09f, -0.7f, -1f),//从位1
    };
}
