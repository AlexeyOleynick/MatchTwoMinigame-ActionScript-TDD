package game.level.card.model {
	import flash.events.Event;

	import mockolate.nice;
	import mockolate.prepare;

	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;

	public class CardsEventTest {

		[Before(async)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(ICardCollection), Event.COMPLETE);
		}

		[Test]
		public function shouldContainCardCollection():void
		{
			var cardCollection:ICardCollection = nice(ICardCollection);
			var cardsEvent:CardsEvent = new CardsEvent(CardsEventType.CREATED, cardCollection);
			assertThat(cardsEvent.cardCollection, equalTo(cardCollection));
		}
	}
}
