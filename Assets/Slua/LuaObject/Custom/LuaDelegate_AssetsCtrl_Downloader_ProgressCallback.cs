
using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;

namespace SLua
{
    public partial class LuaDelegation : LuaObject
    {

        static internal int checkDelegate(IntPtr l,int p,out AssetsCtrl.Downloader.ProgressCallback ua) {
            int op = extractFunction(l,p);
			if(LuaDLL.lua_isnil(l,p)) {
				ua=null;
				return op;
			}
            else if (LuaDLL.lua_isuserdata(l, p)==1)
            {
                ua = (AssetsCtrl.Downloader.ProgressCallback)checkObj(l, p);
                return op;
            }
            LuaDelegate ld;
            checkType(l, -1, out ld);
            if(ld.d!=null)
            {
                ua = (AssetsCtrl.Downloader.ProgressCallback)ld.d;
                return op;
            }
			LuaDLL.lua_pop(l,1);
			
			l = LuaState.get(l).L;
            ua = (double a1,double a2,string a3,string a4) =>
            {
                int error = pushTry(l);

				pushValue(l,a1);
				pushValue(l,a2);
				pushValue(l,a3);
				pushValue(l,a4);
				ld.pcall(4, error);
				LuaDLL.lua_settop(l, error-1);
			};
			ld.d=ua;
			return op;
		}
	}
}
