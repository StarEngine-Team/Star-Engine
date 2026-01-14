package gameObjects.userInterface;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import sys.FileSystem;

using StringTools;

class CreditsIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var initialWidth:Float = 0;
	public var initialHeight:Float = 0;

	public function new(char:String = 'face', isPlayer:Bool = false)
	{
		super();
		updateIcon(char, isPlayer);
	}

	public function updateIcon(char:String = 'face', isPlayer:Bool = false)
	{
		var trimmedCharacter:String = char;
		if (trimmedCharacter.contains('-'))
			trimmedCharacter = trimmedCharacter.substring(0, trimmedCharacter.indexOf('-'));

		var iconPath = char;
		if (!FileSystem.exists(Paths.getPath('images/menus/base/credits/' + iconPath + '.png', IMAGE)))
		{
			if (iconPath != trimmedCharacter)
				iconPath = trimmedCharacter;
			else
				iconPath = 'face';
			trace('$char icon trying $iconPath instead you fuck');
		}

		antialiasing = true;
		var iconGraphic:FlxGraphic = Paths.image('menus/base/credits/' + iconPath);
		loadGraphic(iconGraphic, true, iconGraphic.width, iconGraphic.height);
		
		initialWidth = width;
		initialHeight = height;

		animation.add('icon', [0], 0, false, isPlayer);
		animation.play('icon');
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}