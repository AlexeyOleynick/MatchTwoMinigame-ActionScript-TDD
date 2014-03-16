/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.view {
	import flash.events.Event;

	import game.level.field.model.vo.CardVo;

	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.osflash.signals.Signal;

	import starling.display.Sprite;
	import starling.textures.Texture;

	public class CardViewTest {

		private var cardView:CardView;
		private var stateView:IStateView;

		private var selectListener:Function;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(IStateView, Texture, Sprite, CardView), Event.COMPLETE, setUp);
		}

		private function setUp(e:Event, pathThroughData:Object):void
		{
			stateView = nice(IStateView);
			stub(stateView).method("getView").returns(new Sprite());

			var captured:Capture = new Capture();
			stub(stateView).method("addOpenListener").args(capture(captured));
			cardView = new CardView(stateView);
			cardView.stateViewOpenedSignal = new Signal();

			selectListener = captured.value;
		}


		[Test]
		public function shouldCloseStateView():void
		{
			assertThat(cardView.stateView, received().method('close').once());
		}

		[Test(async)]
		public function shouldRunExternalSelectListenerWhenStateViewDispatchSelectEvent():void
		{
			var externalSelectListener:Function = Async.asyncHandler(this, new Function(), 500);
			cardView.addSelectListener(externalSelectListener);
			selectListener();
		}

		[Test]
		public function shouldSetPropertiesFromVo():void
		{
			var cardVo:CardVo = new CardVo();
			cardVo.x = 10;
			cardVo.y = 5;
			cardVo.type = 3;
			cardVo.opened = true;
			cardView.setCardVo(cardVo);
			assertThat(cardView.x, equalTo(10));
			assertThat(cardView.y, equalTo(5));

			assertThat(cardView.stateView, received().method('open').args(equalTo(3)));

			cardView.setCardVo(new CardVo());
			assertThat(cardView.stateView, received().method('closeWithDelay').args(CardView.DELAY_FOR_CLOSE_IN_MILLISECONDS));
		}


	}
}
