/**
 * Created by OOliinyk on 1/24/14.
 */
package game.level.card.view {
	import flash.events.Event;

	import game.level.card.view.texture.ICardTextureProvider;

	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.osflash.signals.Signal;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class TextureStateViewTest {
		private var stateView:TextureStateView;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(ICardTextureProvider, Texture, Sprite), Event.COMPLETE, setUp);
		}


		private function setUp(e:Event, pathThroughData:Object):void
		{
			stateView = new TextureStateView();
			stateView.cardTextureProvider = nice(ICardTextureProvider);
			stub(stateView.cardTextureProvider).method('getOpenedTexture').returns(nice(Texture));
			stub(stateView.cardTextureProvider).method('getClosedTexture').returns(nice(Texture));
			stateView.touchSignal = new Signal();
		}

		[Test(async)]
		public function shouldRunExternalOpenListenerOnTouch():void
		{
			var externalOpenListener:Function = Async.asyncHandler(this, new Function(), 500);
			stateView.addOpenRequestListener(externalOpenListener);
			stateView.logiclessContainer.dispatchEvent(createEndedTouchEvent());
		}

		private function createEndedTouchEvent():TouchEvent
		{
			var touches:Vector.<Touch> = new Vector.<Touch>();
			var touch:Touch = new Touch(0);
			touch.phase = TouchPhase.ENDED;
			touch.target = stateView.logiclessContainer;
			touches.push(touch);
			return new TouchEvent(TouchEvent.TOUCH, touches);
		}

		[Test]
		public function shouldContainOneEmptySpriteOnCreate():void
		{
			assertThat(stateView.numChildren, equalTo(1));
			assertThat(stateView.getChildAt(0), instanceOf(Sprite));
			assertThat((stateView.getChildAt(0) as Sprite).numChildren, equalTo(0));
			assertThat(stateView.getChildAt(0), equalTo(stateView.logiclessContainer));
		}

		[Test]
		public function shouldAddOneImageWhenClosedManyTimes():void
		{
			stateView.logiclessContainer = partial(Sprite);
			stateView.close();
			stateView.close();
			stateView.close();
			assertThat(stateView.logiclessContainer, received().method("addChild").once().args(instanceOf(Image)));
		}


		[Test(async)]
		public function shouldCloseInProvidedTime():void
		{
			stateView.logiclessContainer = partial(Sprite);
			stateView.closeWithDelay(100);
			Async.delayCall(this, checkNotClosed, 50);
			Async.delayCall(this, checkClosed, 300);
		}

		private function checkNotClosed():void
		{
			assertThat('Was closed', stateView.logiclessContainer, received().method("addChild").never());
		}

		private function checkClosed():void
		{
			assertThat('Was not closed', stateView.logiclessContainer, received().method("addChild").once());
		}

		[Test(async)]
		public function shouldNotExecuteDelayedCloseThatWasBeforeOpen():void
		{
			stateView.logiclessContainer = partial(Sprite);
			stateView.closeWithDelay(100);
			Async.delayCall(this, function ():void
			{
				assertThat('Was closed', stateView.logiclessContainer, received().method("addChild").once());
			}, 110);
			stateView.open(1);
		}

		[Test]
		public function shouldAddOneImageWhenOpenedManyTimesWithTheSameTextureId():void
		{
			stateView.logiclessContainer = partial(Sprite);
			stateView.open(1);
			stateView.open(1);
			assertThat(stateView.logiclessContainer, received().method("addChild").once().args(instanceOf(Image)));
		}
	}
}
