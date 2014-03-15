/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import core.stage.signal.EnterFrameSignal;

	import flash.events.Event;

	import game.level.card.signal.DisplayCardsSignal;
	import game.level.card.view.ICardView;
	import game.level.field.model.ICardsModel;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;

	import robotlegs.bender.extensions.localEventMap.impl.EventMap;

	public class FieldMediatorTest {

		private var fieldMediator:FieldMediator;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(DisplayCardsSignal, IFieldContainer, ICardsModel, ICardView), Event.COMPLETE);
		}


		[Before]
		public function setUp():void
		{
			fieldMediator = new FieldMediator();
			fieldMediator.eventMap = new EventMap();
			fieldMediator.displayCardsSignal = new DisplayCardsSignal();
			fieldMediator.enterFrameSignal = new EnterFrameSignal();
			fieldMediator.initialize();
		}

		[Test]
		public function shouldUpdateModelOnEnterFrame():void
		{
			var cardsModel:ICardsModel = nice(ICardsModel);
			fieldMediator.cardsModel = cardsModel;
			fieldMediator.enterFrameSignal.dispatch();
			assertThat(cardsModel, received().method('stepForward'));
		}

		[Test]
		public function shouldAddCardToView():void
		{
			var fieldContainer:IFieldContainer = nice(IFieldContainer);
			fieldMediator.view = fieldContainer;
			var cardView:ICardView = nice(ICardView);

			fieldMediator.displayCardsSignal.dispatch(cardView);

			assertThat(fieldContainer, received().method("addCard").args(strictlyEqualTo(cardView)));
		}
	}
}
