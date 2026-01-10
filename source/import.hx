#if !macro

//Flixel
import flixel.FlxG;
#if (flixel > "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Mods
import modding.Mods;

// Stuff
import meta.Controls;
import meta.OptionsSaves;
import meta.CoolUtil;

#if mobile
import meta.mobile.data.StorageSystem;
#end


using StringTools;
#end