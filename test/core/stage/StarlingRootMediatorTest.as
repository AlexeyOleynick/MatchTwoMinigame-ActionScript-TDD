/**
 * Created by OOliinyk on 1/11/14.
 */
package core.stage {
	import core.signal.StartupSignal;
	import core.stage.signal.AddToStageSignal;
	import core.stage.signal.EnterFrameSignal;

	import flash.events.Event;

	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;

	import robotlegs.bender.extensions.localEventMap.impl.EventMap;

	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;

	public class StarlingRootMediatorTest {

		private var starlingRootMediator:StarlingRootMediator;


		[Before(async, timeout=5000)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(EnterFrameSignal, StartupSignal, AddToStageSignal, IViewContainer, StarlingStageView, IContextModel, Stage), Event.COMPLETE, setUp);
		}

		public function setUp(e:Event, passThroughObject:Object):void
		{
			starlingRootMediator = new StarlingRootMediator();
			starlingRootMediator.eventMap = new EventMap();
			starlingRootMediator.view = nice(StarlingStageView);
			starlingRootMediator.startupSignal = nice(StartupSignal);
			starlingRootMediator.enterFrameSignal = nice(EnterFrameSignal);
			starlingRootMediator.addToStageSignal = partial(AddToStageSignal);
			starlingRootMediator.contextModel = nice(IContextModel);
			var stage:Stage = nice(Stage);
			stub(stage).getter("stageWidth").returns(300);
			stub(stage).getter("stageHeight").returns(200);
			stub(starlingRootMediator.view).getter("stage").returns(stage);
		}

		[Test]
		public function shouldDispatchEnterFrameSignal():void
		{
			var enterFrameCapture:Capture = new Capture();
			stub(starlingRootMediator.view).method("addEventListener").args(equalTo(Event.ENTER_FRAME), capture(enterFrameCapture));

			starlingRootMediator.initialize();

			var enterFrameListener:Function = enterFrameCapture.value as Function;
			enterFrameListener(new EnterFrameEvent(EnterFrameEvent.ENTER_FRAME, 100));

			assertThat(starlingRootMediator.enterFrameSignal, received().method('dispatch'));
		}

		[Test]
		public function shouldDispatchStartupSignal():void
		{
			starlingRootMediator.initialize();
			assertThat(starlingRootMediator.startupSignal, received().method('dispatch'));
		}

		[Test]
		public function shouldInitializeContextModel():void
		{
			starlingRootMediator.initialize();
			assertThat(starlingRootMediator.contextModel, received().method('initialize').args(equalTo(300), equalTo(200)))
		}

		[Test]
		public function shouldAddViewToRoot():void
		{
			starlingRootMediator.initialize();
			var viewContainer:IViewContainer = nice(IViewContainer);
			var childSprite:Sprite = new Sprite();
			stub(viewContainer).method("getView").returns(childSprite);
			starlingRootMediator.addToStageSignal.dispatch(viewContainer);
			assertThat(starlingRootMediator.view, received().method("addChild").arg(strictlyEqualTo(childSprite)));
		}
	}
}
