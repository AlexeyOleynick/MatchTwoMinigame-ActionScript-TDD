/**
 * Created by OOliinyk on 1/24/14.
 */
package game.level.card.view {
	import core.external.texture.ITextureService;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class TextureStateViewTest {
		private var cardView:TextureStateView;
		private var textureService:ITextureService;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(ITextureService, Texture, Sprite, EventDispatcher), Event.COMPLETE, setUp);
		}


		private function setUp(e:Event, pathThroughData:Object):void
		{
			textureService = nice(ITextureService);
			stub(textureService).method("getTexture").returns(nice(Texture));
			cardView = new TextureStateView(textureService);
		}


		[Test(async)]
		public function shouldDispatchSelectEvent():void
		{
			cardView.eventDispatcher = new EventDispatcher();
			cardView.addOpenListener(Async.asyncHandler(this, checkSelectEvent, 300));
			cardView.logiclessContainer.dispatchEvent(createEndedTouchEvent());
		}

		private function checkSelectEvent(e:Event, passThroughData:Object):void
		{
			assertTrue(e.type == StateViewEventType.OPEN);
		}

		private function createEndedTouchEvent():TouchEvent
		{
			var touches:Vector.<Touch> = new Vector.<Touch>();
			var touch:Touch = new Touch(0);
			touch.phase = TouchPhase.ENDED;
			touch.target = cardView.logiclessContainer;
			touches.push(touch);
			return new TouchEvent(TouchEvent.TOUCH, touches);
		}

		[Test]
		public function shouldContainOneEmptySpriteOnCreate():void
		{
			assertTrue(cardView.numChildren == 1);
			assertTrue(cardView.getChildAt(0) is Sprite);
			assertTrue((cardView.getChildAt(0) as Sprite).numChildren == 0);
			assertTrue(cardView.getChildAt(0) == cardView.logiclessContainer);
		}

		[Test]
		public function shouldRequestForClosedTextureOnCreation():void
		{
			assertThat(textureService, received().method('getTexture').once().args(equalTo("closed")));
		}

		[Test]
		public function shouldAddOneImageWhenClosedManyTimes():void
		{
			cardView.logiclessContainer = partial(Sprite);
			cardView.close();
			cardView.close();
			cardView.close();
			assertThat(cardView.logiclessContainer, received().method("addChild").once().args(instanceOf(Image)));
		}


		[Test(async)]
		public function shouldCloseInProvidedTime():void
		{
			cardView.logiclessContainer = partial(Sprite);
			cardView.closeWithDelay(100);
			Async.delayCall(this, checkNotClosed, 50);
			Async.delayCall(this, checkClosed, 110);
		}

		private function checkNotClosed():void
		{
			assertThat('Was closed', cardView.logiclessContainer, received().method("addChild").never());

		}

		private function checkClosed():void
		{
			assertThat('Was not closed', cardView.logiclessContainer, received().method("addChild").once());
		}

		[Test(async)]
		public function shouldNotExecuteDelayedCloseThatWasBeforeOpen():void
		{
			cardView.logiclessContainer = partial(Sprite);
			cardView.closeWithDelay(100);
			Async.delayCall(this, function ():void
			{
				assertThat('Was closed', cardView.logiclessContainer, received().method("addChild").once());
			}, 110);
			cardView.open(1);
		}

		[Test]
		public function shouldRequestForCorrectTexture():void
		{
			cardView.open(1);
			assertThat(textureService, received().method('getTexture').once().args(equalTo("card1")));
		}


		[Test]
		public function shouldAddOneImageWhenOpenedManyTimesWithTheSameTextureId():void
		{
			cardView.logiclessContainer = partial(Sprite);
			cardView.open(1);
			cardView.open(1);
			assertThat(cardView.logiclessContainer, received().method("addChild").once().args(instanceOf(Image)));
		}
	}
}
