/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.card.view.ICardView;
	import game.level.field.controller.CardViewEvent;
	import game.level.field.controller.CardVo;
	import game.level.field.controller.CardsEvent;
	import game.level.field.controller.ICardCollection;
	import game.level.field.model.ICardsModel;

	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.strictlyEqualTo;

	import robotlegs.bender.extensions.localEventMap.impl.EventMap;

	public class CardMediatorTest {


		private var cardCollection:ICardCollection;
		private var cardMediator:CardMediator;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.handleEvent(this, prepare(ICardView, ICardCollection, ICardsModel, EventDispatcher), Event.COMPLETE, setUp);
		}


		public function setUp(e:Event, pathThroughData:Object):void
		{
			cardMediator = new CardMediator();
			cardMediator.eventDispatcher = new EventDispatcher();
			cardMediator.eventMap = new EventMap();

			cardMediator.cardsModel = nice(ICardsModel);


			var cardContainer:ICardView = nice(ICardView);

			var captured:Capture = new Capture();
			stub(cardContainer).method("addSelectListener").args(capture(captured));

			cardMediator.view = cardContainer;
			stub(cardMediator.view).method("getCardVo").returns(new CardVo(10, 10, 5));
			cardCollection = nice(ICardCollection);
			stub(cardCollection).method("contains").returns(true);
			cardMediator.initialize();

			captured.value(new CardViewEvent(CardViewEvent.SELECT, cardMediator.view));
		}


		[Test]
		public function shouldUpdateModelOnSelect():void
		{
			assertThat(cardMediator.cardsModel, received().method('select').args(strictlyEqualTo(cardMediator.view.getCardVo())));
		}

		[Test]
		public function shouldUpdateViewWithVoOnEvent():void
		{
			var cardsEvent:CardsEvent = new CardsEvent(CardsEvent.UPDATED, cardCollection);
			cardMediator.eventDispatcher.dispatchEvent(cardsEvent);
			assertThat(cardMediator.view, received().method('setCardVo').args(instanceOf(CardVo)));
		}

		[Test]
		public function shouldExecuteShowAnimOnEvent():void
		{
			var cardsEvent:CardsEvent = new CardsEvent(CardsEvent.MATCHED, cardCollection);
			cardMediator.eventDispatcher.dispatchEvent(cardsEvent);
			assertThat(cardMediator.view, received().method('showMatchAnimation'));
		}

		[Test]
		public function shouldRemoveOnEvent():void
		{
			var cardsEvent:CardsEvent = new CardsEvent(CardsEvent.REMOVED, cardCollection);
			cardMediator.eventDispatcher.dispatchEvent(cardsEvent);
			assertThat(cardMediator.view, received().method('remove'));
		}


	}
}
