/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.controller {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.card.model.CardsEvent;
	import game.level.card.model.CardsEventType;
	import game.level.card.model.ICardCollection;
	import game.level.card.view.CardViewEvent;
	import game.level.card.view.ICardView;
	import game.level.field.model.vo.CardVo;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;

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
			displayCardCommand.event = new CardsEvent(CardsEventType.CREATED, cardCollection);
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
			displayCardCommand.event = new CardsEvent(CardsEventType.CREATED, cardCollection);
			Async.proceedOnEvent(this, displayCardCommand.dispatcher, CardsEventType.CREATED);
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
			assertThat(cardViewEvent.cardView, notNullValue());
		}


	}
}
