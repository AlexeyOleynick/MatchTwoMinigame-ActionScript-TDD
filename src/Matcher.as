package {

	import core.stage.StarlingStageView;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;

	import starling.core.Starling;

	[SWF(width="900", height="500", backgroundColor="0x110022")]
	public class Matcher extends Sprite {
		private var starling:Starling;
		private var context:IContext;

		public function Matcher()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			mouseEnabled = mouseChildren = false;

			starling = new Starling(StarlingStageView, stage);
			starling.enableErrorChecking = false;
			starling.showStats = true;
			starling.start();

			context = new Context();
			context.install(MVCSBundle, StarlingViewMapExtension, SignalCommandMapExtension);
			context.configure(AppConfig, this, starling);
			context.configure(new ContextView(this));
		}
	}
}
