/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.view {
	import flash.events.Event;

	import game.level.card.model.ICardCollection;
	import game.level.card.signal.CardsMatchedSignal;
	import game.level.card.signal.CardsRemovedSignal;
	import game.level.card.signal.CardsUpdatedSignal;
	import game.level.field.model.ICardsModel;
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
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.strictlyEqualTo;

	import robotlegs.bender.extensions.localEventMap.api.IEventMap;

	public class CardMediatorTest {


		private var cardCollection:ICardCollection;
		private var cardMediator:CardMediator;
		private var selectListener:Function;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(IEventMap, ICardView, ICardCollection, ICardsModel), Event.COMPLETE, setUp);
		}


		public function setUp(e:Event, pathThroughData:Object):void
		{
			cardMediator = new CardMediator();

			cardMediator.cardsModel = nice(ICardsModel);
			var cardView:ICardView = nice(ICardView);

			var captured:Capture = new Capture();
			stub(cardView).method("addSelectListener").args(capture(captured));

			cardMediator.view = cardView;
			stub(cardMediator.view).method("getCardVo").returns(new CardVo());

			cardCollection = nice(ICardCollection);
			stub(cardCollection).method("contains").returns(true);

			cardMediator.cardsUpdatedSignal = new CardsUpdatedSignal();
			cardMediator.cardsMatchedSignal = new CardsMatchedSignal();
			cardMediator.cardsRemovedSignal = new CardsRemovedSignal();

			cardMediator.initialize();
			selectListener = captured.value;
		}


		[Test]
		public function shouldUpdateModelOnSelect():void
		{
			selectListener();
			assertThat(cardMediator.cardsModel, received().method('select').args(strictlyEqualTo(cardMediator.view.getCardVo())));
		}

		[Test]
		public function shouldUpdateViewWithVoOnUpdatedSignal():void
		{
			cardMediator.cardsUpdatedSignal.dispatch(cardCollection);
			assertThat(cardMediator.view, received().method('setCardVo').args(instanceOf(CardVo)));
		}

		[Test]
		public function shouldExecuteShowAnimOnMatchedSignal():void
		{
			cardMediator.cardsMatchedSignal.dispatch(cardCollection);
			assertThat(cardMediator.view, received().method('showMatchAnimation'));
		}

		[Test]
		public function shouldRemoveOnRemovedSignal():void
		{
			cardMediator.cardsRemovedSignal.dispatch(cardCollection);
			assertThat(cardMediator.view, received().method('remove'));
		}


		[Test]
		public function shouldRemoveListenersFromSignals():void
		{
			cardMediator.eventMap = nice(IEventMap)
			cardMediator.postDestroy();
			assertThat(cardMediator.cardsMatchedSignal.numListeners, equalTo(0))
			assertThat(cardMediator.cardsRemovedSignal.numListeners, equalTo(0))
			assertThat(cardMediator.cardsUpdatedSignal.numListeners, equalTo(0))
		}
	}
}
