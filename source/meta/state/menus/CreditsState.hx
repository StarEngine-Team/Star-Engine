package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import gameObjects.userInterface.CreditsIcon;
import meta.data.font.Alphabet;

class CreditsState extends MusicBeatState
{
    var TestCredits:Array<Array<Dynamic>> = [];
    
    static var curSelected:Int = 0;
    
    private var grpMembers:FlxTypedGroup<Alphabet>;
    
    private var iconArray:Array<CreditsIcon> = [];
    
    override function create()
	{
	    super.create();
	
	    TestCredits = [ // name, icon (só depois)
		['StarNova / Cream.BR', 'starnova'],
		['FNF BR', 'fnfbr'],
		['Felipinas', 'felipinas'],
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
			membersText.targetY = i;
			membersText.ID = i;
			grpMembers.add(membersText);
			membersText.x += 40;
			
			var icon:CreditsIcon = new CreditsIcon(TestCredits[i][1]);
			icon.sprTracker = membersText;
			icon.scale.set(0.85,0.85);
			icon.updateHitbox();
			iconArray.push(icon);
			add(icon);
		}
		
		#if mobile
		addVirtualPad(UP_DOWN, B);
		addVirtualPadCamera();
		#end
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		
		if (upP)
				changeSelection(-1);
	
	    if (downP)
				changeSelection(1);
		
		if (controls.BACK) {
   	     FlxG.sound.play(Paths.sound('cancelMenu'));
			Main.switchState(new MainMenuState());
		}
	}
	
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = TestCredits.length - 1;
		if (curSelected >= TestCredits.length)
			curSelected = 0;

		for (i in 0...iconArray.length) {
			iconArray[i].alpha = 0.6;
		}
		
		var bullShit:Int = 0;

		iconArray[curSelected].alpha = 1;

		for (item in grpMembers.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
	
}