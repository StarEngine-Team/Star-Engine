package meta;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import meta.*;
import meta.data.*;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.dependency.FNFTransition;
#if mobile
import meta.mobile.controls.MobileHitbox;
import meta.mobile.controls.MobileVirtualPad;
import flixel.util.FlxDestroyUtil;
#end

/* 
	Music beat state happens to be the first thing on my list of things to add, it just so happens to be the backbone of
	most of the project in its entirety. It handles a couple of functions that have to do with actual music and songs and such.

	I'm not going to change any of this because I don't truly understand how songplaying works, 
	I mostly just wanted to rewrite the actual gameplay side of things.
 */
class MusicBeatState extends FlxUIState
{
	/**
	 * Array of notes showing when each measure/bar STARTS in STEPS
	 * Usually rounded up??
	 */
	public static var instance:MusicBeatState;
	
	public var curBar:Int = 0;

	public var curBeat:Int = 0;
	public var curStep:Int = 0;

	function updateBar() curBar = Math.floor(curBeat * 0.25);
	function updateBeat() curBeat = Math.floor(curStep * 0.25);

	public var controls(get, never):Controls;
	private function get_controls()
	{
		return Controls.instance;
	}
	
	#if mobile
	public var hitbox:MobileHitbox;
	public var virtualPad:MobileVirtualPad;

	public var virtualPadCam:FlxCamera;
	public var hitboxCam:FlxCamera;

	
    public function addVirtualPad(DPad:MobileDPadMode, Action:MobileActionMode)
	{
		if (virtualPad != null)
			removeVirtualPad();

		virtualPad = new MobileVirtualPad(DPad, Action);
		add(virtualPad);
	}

	public function removeVirtualPad()
	{
		if (virtualPad != null)
			remove(virtualPad);
	}

	public function addHitbox(DefaultDrawTarget:Bool = false)
	{
		hitbox = new MobileHitbox();

		hitboxCam = new FlxCamera();
		hitboxCam.bgColor.alpha = 0;
		FlxG.cameras.add(hitboxCam, DefaultDrawTarget);

		hitbox.cameras = [hitboxCam];
		hitbox.visible = false;
		add(hitbox);
	}

	public function removeHitbox()
	{
		if (hitbox != null)
			remove(hitbox);
	}

	public function addVirtualPadCamera(DefaultDrawTarget:Bool = false)
	{
		if (virtualPad != null)
		{
			virtualPadCam = new FlxCamera();
			FlxG.cameras.add(virtualPadCam, DefaultDrawTarget);
			virtualPadCam.bgColor.alpha = 0;
			virtualPad.cameras = [virtualPadCam];
		}
	}

	override function destroy()
	{
		super.destroy();

		if (virtualPad != null)
		{
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
			virtualPad = null;
		}

		if (hitbox != null)
		{
			hitbox = FlxDestroyUtil.destroy(hitbox);
			hitbox = null;
		}
	}
	#end

	// class create event
	override function create()
	{
	    instance = this; // This isn't just for mobile
		// dump
		Paths.clearStoredMemory();
		if ((!Std.isOfType(this, meta.state.PlayState)) && (!Std.isOfType(this, meta.state.charting.OriginalChartingState)))
			Paths.clearUnusedMemory();

		// state stuffs
		if (!FlxTransitionableState.skipNextTransOut)
			openSubState(new FNFTransition(0.5, true));

		/*
		if (transIn != null)
			trace('reg ' + transIn.region);
		*/

		super.create();

		// For debugging
		FlxG.watch.add(Conductor, "songPosition");
		FlxG.watch.add(this, "curBeat");
		FlxG.watch.add(this, "curStep");
	}

	// class 'step' event
	override function update(elapsed:Float)
	{
		updateContents();
		super.update(elapsed);
	}

	public function updateContents()
	{
		updateCurStep();
		updateBeat();
		updateBar();

		// delta time bullshit
		var trueStep:Int = curStep;
		for (i in storedSteps)
			if (i < oldStep)
				storedSteps.remove(i);
		for (i in oldStep...trueStep)
		{
			if (!storedSteps.contains(i) && i > 0)
			{
				curStep = i;
				stepHit();
				skippedSteps.push(i);
			}
		}
		if (skippedSteps.length > 0)
		{
			//trace('skipped steps $skippedSteps');
			skippedSteps = [];
		}
		curStep = trueStep;

		//
		if (oldStep != curStep && curStep > 0 && !storedSteps.contains(curStep))
			stepHit();
		oldStep = curStep;
	}

	var oldStep:Int = 0;
	var storedSteps:Array<Int> = [];
	var skippedSteps:Array<Int> = [];

	public function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();

		// trace('step $curStep');
		if (!storedSteps.contains(curStep))
			storedSteps.push(curStep);
		else
			trace('SOMETHING WENT WRONG??? STEP REPEATED $curStep');
	}

	public function beatHit():Void
	{
		// used for updates when beats are hit in classes that extend this one
	}
}

class MusicBeatSubState extends FlxSubState
{
    public static var instance:MusicBeatSubState;
	public function new()
	{
	    instance = this;
		super();
	}

	/**
	 * Array of notes showing when each measure/bar STARTS in STEPS
	 * Usually rounded up??
	 */
	public var curBar: Int = 0;
	public var curBeat:Int = 0;
	public var curStep:Int = 0;

	function updateBar() curBar = Math.floor(curBeat * 0.25);
	function updateBeat() curBeat = Math.floor(curStep * 0.25);

	public var controls(get, never):Controls;
	private function get_controls()
	{
		return Controls.instance;
	}
	
	#if mobile
	public var virtualPad:MobileVirtualPad;
	public var virtualPadCam:FlxCamera;

    public function addVirtualPad(DPad:MobileDPadMode, Action:MobileActionMode)
	{
		if (virtualPad != null)
			removeVirtualPad();

		virtualPad = new MobileVirtualPad(DPad, Action);
		add(virtualPad);
	}

	public function removeVirtualPad()
	{
		if (virtualPad != null)
			remove(virtualPad);
	}

	public function addVirtualPadCamera(DefaultDrawTarget:Bool = false)
	{
		if (virtualPad != null)
		{
			virtualPadCam = new FlxCamera();
			FlxG.cameras.add(virtualPadCam, DefaultDrawTarget);
			virtualPadCam.bgColor.alpha = 0;
			virtualPad.cameras = [virtualPadCam];
		}
	}

	override function destroy()
	{
		super.destroy();

		if (virtualPad != null)
		{
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
			virtualPad = null;
		}
	}
	#end

	// class 'step' event
	override function update(elapsed:Float)
	{
		updateContents();
		super.update(elapsed);
	}

	public function updateContents()
	{
		updateCurStep();
		updateBeat();
		updateBar();

		// delta time bullshit
		var trueStep:Int = curStep;
		for (i in storedSteps)
			if (i < oldStep)
				storedSteps.remove(i);
		for (i in oldStep...trueStep)
		{
			if (!storedSteps.contains(i) && i > 0)
			{
				curStep = i;
				stepHit();
				skippedSteps.push(i);
			}
		}
		if (skippedSteps.length > 0)
		{
			//trace('skipped steps $skippedSteps');
			skippedSteps = [];
		}
		curStep = trueStep;

		//
		if (oldStep != curStep && curStep > 0 && !storedSteps.contains(curStep))
			stepHit();
		oldStep = curStep;
	}

	var oldStep:Int = 0;
	var storedSteps:Array<Int> = [];
	var skippedSteps:Array<Int> = [];

	public function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
