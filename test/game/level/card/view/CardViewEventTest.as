package game.level.card.view {
	import flash.events.Event;

	import mockolate.nice;
	import mockolate.prepare;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class CardViewEventTest {

		[Before(async)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(ICardView), Event.COMPLETE);
		}

		[Test]
		public function shouldContainCardCollection():void
		{
			var cardView:ICardView = nice(ICardView);
			var cardViewEvent:CardViewEvent = new CardViewEvent(CardViewEvent.SELECT, cardView);
			assertThat(cardViewEvent.cardView, equalTo(cardView));
		}
	}
}
