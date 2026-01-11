#if LUA_ALLOWED
package modding;

import haxe.Json;

class FunkinLua {
	public var lua:State = null;
	public var scriptName:String = '';
	public var modFolder:String = null;
	
	public function new(scriptName:String) {
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		
		this.scriptName = scriptName.trim();
		
		var myFolder:Array<String> = this.scriptName.split('/');
		#if MODS_ALLOWED
		if(myFolder[0] + '/' == Paths.mods() && (Mods.currentModDirectory == myFolder[1] || Mods.getGlobalMods().contains(myFolder[1]))) //is inside mods folder
			this.modFolder = myFolder[1];
		#end
		
		// Lua shit
		set('scriptName', scriptName);
		set('modFolder', this.modFolder);
	}
	
	// Functions to activate Lua
	public function set(variable:String, data:Dynamic) {
		if(lua == null) {
			return;
		}

		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
	}
}
#end