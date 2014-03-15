/**
 * Created by OOliinyk on 1/11/14.
 */
package core.stage {
	import core.signal.StartupSignal;
	import core.stage.signal.AddToStageSignal;
	import core.stage.signal.EnterFrameSignal;


	import robotlegs.bender.bundles.mvcs.Mediator;

	import starling.events.EnterFrameEvent;

	public class StarlingRootMediator extends Mediator {

		[Inject]
		public var view:StarlingStageView;
		[Inject]
		public var contextModel:IContextModel;
		[Inject]
		public var startupSignal:StartupSignal;
		[Inject]
		public var enterFrameSignal:EnterFrameSignal;
		[Inject]
		public var addToStageSignal:AddToStageSignal;

		override public function initialize():void
		{
			super.initialize();

			contextModel.initialize(view.stage.stageWidth, view.stage.stageHeight);

			addToStageSignal.add(addToStageListener)
			view.addEventListener(EnterFrameEvent.ENTER_FRAME, stageEnterFrameListener);
			startupSignal.dispatch();
		}

		private function stageEnterFrameListener(event:EnterFrameEvent):void
		{
			enterFrameSignal.dispatch();
		}

		private function addToStageListener(viewContainer:IViewContainer):void
		{
			view.addChild(viewContainer.getView());
		}
	}
}
