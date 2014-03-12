/**
 * Created by OOliinyk on 1/11/14.
 */
package core.stage {
	import flash.events.Event;

	import game.startup.StartupEventType;

	import robotlegs.bender.bundles.mvcs.Mediator;

	import starling.events.EnterFrameEvent;

	public class StarlingRootMediator extends Mediator {

		[Inject]
		public var view:StarlingStageView;
		[Inject]
		public var contextModel:IContextModel;


		override public function initialize():void
		{
			super.initialize();

			contextModel.initialize(view.stage.stageWidth, view.stage.stageHeight);
			addContextListener(StageEvent.ADD_TO_STAGE, addToStageListener, StageEvent);
			view.addEventListener(EnterFrameEvent.ENTER_FRAME, stageEnterFrameListener);

			dispatch(new Event(StartupEventType.STARTUP));
		}

		private function stageEnterFrameListener(event:EnterFrameEvent):void
		{
			dispatch(new Event(Event.ENTER_FRAME));
		}

		private function addToStageListener(e:StageEvent):void
		{
			view.addChild(e.getViewContainer().getView())
		}
	}
}
