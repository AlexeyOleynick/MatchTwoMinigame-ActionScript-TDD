/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.controller {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.card.view.ICardView;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.async.Async;

	public class DisplayCardCommandTest {


		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.proceedOnEvent(this, prepare(ICardView, ICardCollection), Event.COMPLETE);
		}

		[Test(async)]
		public function shouldSendEventWithCardView():void
		{
			var cardCollection:ICardCollection = nice(ICardCollection);
			stub(cardCollection).method("getAll").returns(generateSingleCardVector());
			stub(cardCollection).method("getSize").returns(1);

			var displayCardCommand:DisplayCardCommand = new DisplayCardCommand();
			displayCardCommand.dispatcher = new EventDispatcher();
			displayCardCommand.cardView = nice(ICardView);
			displayCardCommand.event = new CardsEvent(CardsEvent.CREATED, cardCollection);
			displayCardCommand.dispatcher.addEventListener(CardViewEvent.DISPLAY, Async.asyncHandler(this, eventShouldContainView, 100));
			displayCardCommand.execute();
		}


		[Test(async)]
		public function shouldResendIfCardCountBiggerThanOne():void
		{
			var cardCollection:ICardCollection = nice(ICardCollection);
			stub(cardCollection).method("getAll").returns(generateSingleCardVector());
			stub(cardCollection).method("getSize").returns(2);

			var displayCardCommand:DisplayCardCommand = new DisplayCardCommand();
			displayCardCommand.dispatcher = new EventDispatcher();
			displayCardCommand.event = new CardsEvent(CardsEvent.CREATED, cardCollection);
			Async.proceedOnEvent(this, displayCardCommand.dispatcher, CardsEvent.CREATED);
			displayCardCommand.execute();
		}

		private function generateSingleCardVector():Vector.<CardVo>
		{
			var cards:Vector.<CardVo> = new Vector.<CardVo>();
			cards.push(new CardVo(10, 10, 2));
			return cards;
		}

		private function eventShouldContainView(cardViewEvent:CardViewEvent, passThrough:Object):void
		{
			assertNotNull(cardViewEvent.cardView);
		}


	}
}
