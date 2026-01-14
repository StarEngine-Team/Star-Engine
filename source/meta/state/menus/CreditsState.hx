package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import meta.data.font.Alphabet;

class CreditsState extends MusicBeatState
{
    var TestCredits:Array<Array<Dynamic>> = [];
    private var grpMembers:FlxTypedGroup<Alphabet>;
    
    override function create()
	{
	    super.create();
	
	    TestCredits = [ // name, icon (só depois)
		['StarNova / Cream.BR', 'starnova'],
		['FNF BR', 'fnfbr'],
		];
		
		var bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0xCE64DF;
		bg.antialiasing = true;
		add(bg);
	
    	grpMembers = new FlxTypedGroup<Alphabet>();
		add(grpMembers);
		for (i in 0...TestCredits.length)
		{
			var membersText:Alphabet = new Alphabet(0, (50 * i) + 30, TestCredits[i][0], true, false, 0.85);
			membersText.isMenuItem = true;
			membersText.middleX = true;
			membersText.targetY = i;
			membersText.ID = i;
			grpMembers.add(membersText);
			membersText.x += 40;
		}
		
		#if mobile
		addVirtualPad(UP_DOWN, B);
		addVirtualPadCamera();
		#end
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.BACK) {
   	     FlxG.sound.play(Paths.sound('cancelMenu'));
			Main.switchState(new MainMenuState());
		}
	}
}