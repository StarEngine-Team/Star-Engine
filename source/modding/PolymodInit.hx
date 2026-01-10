package modding;

import flixel.FlxG;
import polymod.Polymod;

using StringTools;

class PolymodInit
{

	public static final API_VERSION:Array<Int> = [1, 8, 0];
	public static final API_VERSION_STRING:String = API_VERSION[0]+"."+API_VERSION[1]+"."+API_VERSION[2];

	public static final ASSETS_FOLDER:String =
	#if (REDIRECT_ASSETS_FOLDER && macos)
	"../../../../../../../assets"
	#elseif REDIRECT_ASSETS_FOLDER
	"../../../../assets"
	#else
	"assets"
	#end;
	
	public static var modsLoaded:Array<String>;
	public static var modMeta:Array<ModMetadata>;

	public static function init():Void{
		reInit();
	}

	public static function reInit():Void{
		modMeta = Polymod.init({
			modRoot: "mods/",
			dirs: modsLoaded,
			useScriptedClasses: true,
			errorCallback: onModsError,
			ignoredFiles: ignoreList(),
			frameworkParams: {
				coreAssetRedirect: ASSETS_FOLDER
			}
		});

		Polymod.clearCache();
	}
	
	static function onModsError(error:PolymodError):Void{
		// Perform an action based on the error code.
		switch (error.code){
			case MISSING_ICON:
				
			default:
				// Log the message based on its severity.
				switch (error.severity){
					case NOTICE:
						//does nothing lol
					case WARNING:
						trace(error.message, null);
					case ERROR:
						trace(error.message, null);
				}
	  	}
	}
	
	static function ignoreList():Array<String>{
		var result = Polymod.getDefaultIgnoreList();

		result.push('.vscode');
		result.push('.git');
		result.push('.gitignore');
		result.push('.gitattributes');
		result.push('README.md');

		return result;
	}

	//Checks through the loaded mods to see what mod a file is from. Returns `null` if it's not a mod file.
	public static function getAssetModFolder(path:String):String{
		for(mod in modsLoaded){
			if(sys.FileSystem.exists('mods/$mod/' + path.split("assets/")[1])){
				return mod;
			}
		}
		return null;
	}
}