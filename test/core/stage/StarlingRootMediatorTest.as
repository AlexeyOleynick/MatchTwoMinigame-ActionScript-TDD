/**
 * Created by OOliinyk on 1/11/14.
 */
package core.stage {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mockolate.nice;
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

	public class StarlingRootMediatorTest {

		private var starlingRootMediator:StarlingRootMediator;


		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.handleEvent(this, prepare(IViewContainer, StarlingStageView, IContextModel, Stage), Event.COMPLETE, setUp);
		}

		public function setUp(e:Event, passThroughObject:Object):void
		{
			starlingRootMediator = new StarlingRootMediator();
			starlingRootMediator.eventMap = new EventMap();
			starlingRootMediator.eventDispatcher = new EventDispatcher();
			starlingRootMediator.view = nice(StarlingStageView);
			starlingRootMediator.contextModel = nice(IContextModel);
			var stage:Stage = nice(Stage);
			stub(stage).getter("stageWidth").returns(300);
			stub(stage).getter("stageHeight").returns(200);
			stub(starlingRootMediator.view).getter("stage").returns(stage);
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
			starlingRootMediator.eventDispatcher.dispatchEvent(new StageEvent(StageEvent.ADD_TO_STAGE, viewContainer));
			assertThat(starlingRootMediator.view, received().method("addChild").arg(strictlyEqualTo(childSprite)));
		}
	}
}
