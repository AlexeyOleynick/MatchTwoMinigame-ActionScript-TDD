/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.controller {
	import flash.events.Event;

	import game.level.card.model.ICardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.signal.DisplayCardsSignal;
	import game.level.card.view.ICardView;
	import game.level.field.model.vo.CardVo;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;

	public class DisplayCardCommandTest {


		[Before(async, timeout=5000)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(CardsCreatedSignal, CardVo, DisplayCardsSignal, ICardView, ICardCollection), Event.COMPLETE);
		}

		[Test(async)]
		public function shouldDispatchDisplaySignalWithCardView():void
		{
			var cardCollection:ICardCollection = nice(ICardCollection);
			stub(cardCollection).method("getSize").returns(1);
			stub(cardCollection).method("getFirst").returns(nice(CardVo));


			var displayCardCommand:DisplayCardCommand = new DisplayCardCommand();
			displayCardCommand.cardView = nice(ICardView);
			displayCardCommand.cardCollection = cardCollection;
			displayCardCommand.displayCardsSignal = nice(DisplayCardsSignal);

			displayCardCommand.execute();

			assertThat(displayCardCommand.cardView, received().method("setCardVo").arg(instanceOf(CardVo)));
			assertThat(displayCardCommand.displayCardsSignal, received().method("dispatch").arg(instanceOf(ICardView)));
		}


		[Test(async)]
		public function shouldResendIfCardCountBiggerThanOne():void
		{
			var cardCollection:ICardCollection = nice(ICardCollection);
			stub(cardCollection).method("getAll").returns(generateSingleCardVector());
			stub(cardCollection).method("getSize").returns(2);

			var displayCardCommand:DisplayCardCommand = new DisplayCardCommand();
			displayCardCommand.cardCollection = cardCollection;
			displayCardCommand.cardsCreatedSignal = nice(CardsCreatedSignal);
			displayCardCommand.execute();
			assertThat(displayCardCommand.cardsCreatedSignal, received().method("dispatch").arg(instanceOf(ICardCollection)));

		}

		private function generateSingleCardVector():Vector.<CardVo>
		{
			var cards:Vector.<CardVo> = new Vector.<CardVo>();
			cards.push(nice(CardVo));
			return cards;
		}


	}
}
