/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.card.view.ICardView;
	import game.level.field.controller.CardViewEvent;
	import game.level.field.model.ICardsModel;
	import game.level.view.FieldMediator;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;

	import robotlegs.bender.extensions.localEventMap.impl.EventMap;

	public class FieldMediatorTest {

		private var fieldMediator:FieldMediator;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.proceedOnEvent(this, prepare(IFieldContainer, ICardsModel, ICardView), Event.COMPLETE);
		}


		[Before]
		public function setUp():void
		{
			fieldMediator = new FieldMediator();
			fieldMediator.eventDispatcher = new EventDispatcher();
			fieldMediator.eventMap = new EventMap();
			fieldMediator.initialize();
		}

		[Test]
		public function shouldUpdateModelOnEnterFrame():void
		{
			var cardsModel:ICardsModel = nice(ICardsModel);
			fieldMediator.cardsModel = cardsModel;
			fieldMediator.eventDispatcher.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(cardsModel, received().method('stepForward'));
		}

		[Test]
		public function shouldAddCardToView():void
		{
			var fieldContainer:IFieldContainer = nice(IFieldContainer);
			fieldMediator.view = fieldContainer;
			var cardView:ICardView = nice(ICardView);
			var event:CardViewEvent = new CardViewEvent(CardViewEvent.DISPLAY, cardView);

			fieldMediator.eventDispatcher.dispatchEvent(event);
			assertThat(fieldContainer, received().method("addCard").args(strictlyEqualTo(cardView)));
		}


	}
}
