package meta;

import lime.utils.Assets;
import meta.state.PlayState;
import flixel.util.FlxSave;

using StringTools;

#if sys
import sys.FileSystem;
#end

class CoolUtil
{
	public static final difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var difficultyLength = difficultyArray.length;

	public static inline function difficultyFromNumber(number:Int):String
	{
		return difficultyArray[number];
	}

	public static inline function dashToSpace(string:String):String
	{
		return string.replace("-", " ");
	}

	public static inline function spaceToDash(string:String):String
	{
		return string.replace(" ", "-");
	}

	public static inline function swapSpaceDash(string:String):String
	{
		return string.contains('-') ? dashToSpace(string) : spaceToDash(string);
	}
	
	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	public static inline function getOffsetsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);
		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
			swagOffsets.push(i.split(' '));

		return swagOffsets;
	}

	public static inline function returnAssetsLibrary(library:String, ?subDir:String = 'assets/images'):Array<String>
	{
		var libraryArray:Array<String> = [];

		#if sys
		var unfilteredLibrary = FileSystem.readDirectory('$subDir/$library');

		for (folder in unfilteredLibrary)
		{
			if (!folder.contains('.'))
				libraryArray.push(folder);
		}
		//trace(libraryArray);
		#end

		return libraryArray;
	}

	public static inline function getAnimsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);
		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
			swagOffsets.push(i.split('--'));
		return swagOffsets;
	}
	
	inline public static function getSavePath():String
    {
       final company:String = FlxG.stage.application.meta.get('company');
       final file:String = FlxG.stage.application.meta.get('file');
    
       var folderName = ~/[\/:*?"<>|]/g.replace(file, ""); 
       return '$company/$folderName';
     }


	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		return [for (i in min...max) i];
	}
}
