using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Object = UnityEngine.Object;
using PathologicalGames;

public class TTPoolManager {

	public static SpawnPool GetPool(string name){
		SpawnPool pool = null;
		if(!PoolManager.Pools.TryGetValue(name,out pool)){
			pool = PoolManager.Pools.Create(name);
		}
		return pool;
	}

	public static Transform Spawn(string poolName,Transform tran)
	{
		if(tran == null) return null;
		SpawnPool pool = GetPool(poolName);
		Transform res = pool.Spawn(tran);
		return res;
	}

	public static bool Contains(SpawnPool pool,string name){
		if(pool == null) return false;
		Transform ori = null;
		if(pool.prefabs.ContainsKey(name) == false) return false;
		if(!pool.prefabs.TryGetValue(name,out ori)) {
			//Debuger.Log("GetObjectFrom is null");
			return false;
		}
		return true;
	}

	public static void InitPoolPreload(string poolName,Transform tran,int amount = 3,int limitAmount = 10){
		if(tran == null) return;
		SpawnPool pool = GetPool(poolName);
		//Debuger.Log("InitPoolPreload:"+poolName+"\n"+tran.name);
		if(Contains(pool,tran.name)){
			return;
		}

		PrefabPool prefabPool = new PrefabPool(tran);
        prefabPool.preloadAmount = amount;      // This is the default so may be omitted
        prefabPool.preloadFrames = 20;
        prefabPool.cullDespawned = true;
        prefabPool.cullAbove = 0;
        prefabPool.cullDelay = 60;
        prefabPool.cullMaxPerPass = 5;
        prefabPool.limitInstances = true;
        prefabPool.limitAmount = limitAmount;
        prefabPool.limitFIFO = true;

        //Debuger.Log("InitPoolPreload " + poolName + ","+tran.name);
        pool.CreatePrefabPool(prefabPool);
	}

	public static void InitPoolAutoLoad(string poolName,Transform tran,int amount)
	{
		if(tran == null) return;
		SpawnPool pool = GetPool(poolName);
		//Debuger.Log("InitPoolPreload:"+poolName+"\n"+tran.name);
		if(Contains(pool,tran.name)){
			return;
		}
		
		PrefabPool prefabPool = new PrefabPool(tran);
		prefabPool.preloadAmount = amount;      // This is the default so may be omitted
		prefabPool.preloadFrames = 20;
		prefabPool.cullDespawned = false;
		prefabPool.limitInstances = false;
		prefabPool.limitFIFO = true;
		
		//Debuger.Log("InitPoolPreload " + poolName + ","+tran.name);
		pool.CreatePrefabPool(prefabPool);
	}

	///<summary>
	/// 从一个pool中读取某个名称的object对象
	///</summary>
	public static Transform GetObjectFrom(string poolName,string objName){
		SpawnPool pool = GetPool(poolName);
		Transform ori = null;
		if(!pool.prefabs.TryGetValue(objName,out ori)) {
			//Debuger.Log("GetObjectFrom is null");
			return null;
		}
		//PrefabPool pp = pool.GetPrefabPool(ori);
		//if(pp == null) return null;

		if(ori == null)
		{
			#if UNITY_EDITOR
				//Debuger.LogWarning("==========GetObjectFrom========\nwanna get pool:"+poolName+"\nobj:"+objName+" is not exist prefabPool.");
			#endif
			return null;
		}

		Transform res = pool.Spawn(ori);
		//Debuger.Log("ori:"+ori.gameObject.name+"\npp.prefab:"+pp.prefab.gameObject.name+"\nres:"+res.gameObject.name);
		return res != null ? res : null;
	}

	public static Transform GetObjectFromCached(string poolName,string objName)
	{
		SpawnPool pool = GetPool(poolName);
		Transform ori = null;
		if(!pool.prefabs.TryGetValue(objName,out ori)) {
			//Debuger.Log("GetObjectFrom is null");
			return null;
		}

		//preload items protected.
		PrefabPool pp = pool.GetPrefabPool(ori);
		if(pp == null) 
			return null;
		else if(pp.totalCount < pp.preloadAmount)
		{
			//pp.preloaded = false;
			pp.PreloadInstances();
		}
		if(ori == null)
		{
			#if UNITY_EDITOR
				//Debuger.LogWarning("==========GetObjectFrom========\nwanna get pool:"+poolName+"\nobj:"+objName+" is not exist prefabPool.");
			#endif
			return null;
		}

		Transform res = pool.Spawn(ori);
		//Debuger.Log("ori:"+ori.gameObject.name+"\npp.prefab:"+pp.prefab.gameObject.name+"\nres:"+res.gameObject.name);
		return res != null ? res : null;
	}


	public static void Despawn(string poolName,Transform tran)
	{
		if(tran == null) return;
		SpawnPool pool = GetPool(poolName);
		pool.Despawn(tran,pool.transform);
	}

}
