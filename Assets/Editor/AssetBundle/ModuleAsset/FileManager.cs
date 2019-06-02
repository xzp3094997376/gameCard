/*********************************************************************
* 类 名 称：       FileManager
* 命名空间：       
* 创建时间：       2014/7/27 9:44:20
* 作    者：       张晶晶
* 说    明：       文件管理包括文件删除，移动
* 最后修改时间：   2014/7/30 
* 最后修 改 人：   张晶晶
* 曾修改人：    
**********************************************************************/


using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;

public class FileManager : MonoBehaviour {

   /// <summary>
    /// 删除某目录下的texture
   /// </summary>
 
    public static void deleteFile(string filePath)
    {
        if (File.Exists(filePath))
        {
            File.Delete(filePath);
       //     MyDebug.Log("file delete success " + filePath);
        }
    }

	/// <summary>
	/// 删除某目录下的texture
	/// </summary>

	public static void deleteFiles(List<string> delList){
		foreach (string del in delList) {
			if (File.Exists(del))
			{
				File.Delete(del);
				if(File.Exists(del+".meta")){
					File.Delete(del+".meta");
				}
			}
		}
	}
	
	
	/// <summary>
    /// 移动某目录下的texture 
    /// </summary>


    public static void moveFile(string sourceDir, string destinationDir)
    {
  
        if (File.Exists(sourceDir) && !File.Exists(destinationDir))
        {
            File.Move(sourceDir, destinationDir);        
        }
    }

	public static void moveFileList(List<string> list, string destinationDir){
		foreach(string source in list){
			string new_destinationDir = destinationDir+"/" + Path.GetFileName(source);
			if (File.Exists(source) && !File.Exists(new_destinationDir))
			{		
				File.Move(source, new_destinationDir);
				File.Move(source+".meta", new_destinationDir+".meta");
	//			MyDebug.Log("move success " + source + "  to   " + destinationDir);
				
			}
		}
	}
}