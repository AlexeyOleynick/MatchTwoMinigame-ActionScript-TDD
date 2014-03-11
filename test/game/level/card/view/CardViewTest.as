/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.view {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.field.model.vo.CardVo;

	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	import starling.display.Sprite;
	import starling.textures.Texture;

	public class CardViewTest {

		private var cardView:CardView;
		private var stateView:IStateView;


		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(IStateView, Texture, Sprite, CardView, EventDispatcher), Event.COMPLETE, setUp);
		}

		private function setUp(e:Event, pathThroughData:Object):void
		{
			stateView = nice(IStateView);
			stub(stateView).method("getView").returns(new Sprite());

			var captured:Capture = new Capture();
			stub(stateView).method("addOpenListener").args(capture(captured));
			cardView = new CardView(stateView);
			cardView.eventDispatcher = partial(EventDispatcher);

			(captured.value as Function)(new Event(CardViewEvent.SELECT));
		}


		[Test]
		public function shouldCloseStateView():void
		{
			assertThat(cardView.stateView, received().method('close').once());
		}

		[Test]
		public function shouldDispatchSelectEventWhenStateViewDispatchSelectEvent():void
		{
			assertThat(cardView.eventDispatcher, received().method('dispatchEvent').args(instanceOf(Event)));
		}


		[Test]
		public function shouldAddSelectEventToDispatcher():void
		{
			var listener:Function = new Function();
			cardView.addSelectListener(listener);
			assertThat(cardView.eventDispatcher, received().method("addEventListener").args(CardViewEvent.SELECT, listener));
		}

		[Test]
		public function shouldSetPropertiesFromVo():void
		{
			cardView.setCardVo(new CardVo(10, 5, 3, true));
			assertEquals(cardView.x, 10);
			assertEquals(cardView.y, 5);

			assertThat(cardView.stateView, received().method('open').args(equalTo(3)));

			cardView.setCardVo(new CardVo(10, 5, 3, false));
			assertThat(cardView.stateView, received().method('closeWithDelay').args(CardView.DELAY_FOR_CLOSE_IN_MILLISECONDS));
		}


	}
}
