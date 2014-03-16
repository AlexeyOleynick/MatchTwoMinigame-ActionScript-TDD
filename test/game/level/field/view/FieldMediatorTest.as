/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import core.stage.signal.EnterFrameSignal;

	import flash.events.Event;

	import game.level.card.model.ICardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.view.ICardView;
	import game.level.field.model.ICardsModel;
	import game.level.field.view.factory.ICardViewFactory;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	import robotlegs.bender.extensions.localEventMap.impl.EventMap;

	public class FieldMediatorTest {

		private var fieldMediator:FieldMediator;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(ICardViewFactory, ICardCollection, CardsCreatedSignal, IFieldContainer, ICardsModel, ICardView), Event.COMPLETE);
		}


		[Before]
		public function setUp():void
		{
			fieldMediator = new FieldMediator();
			fieldMediator.eventMap = new EventMap();
			fieldMediator.cardsCreatedSignal = new CardsCreatedSignal();
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
			fieldMediator.fieldContainer = nice(IFieldContainer);

			fieldMediator.viewFactory = nice(ICardViewFactory);
			var cardViews:Vector.<ICardView> = new Vector.<ICardView>();
			cardViews.push(nice(ICardView));
			stub(fieldMediator.viewFactory).method('generateViewsByCardCollection').returns(cardViews);

			fieldMediator.cardsCreatedSignal.dispatch(nice(ICardCollection));

			assertThat(fieldMediator.fieldContainer, received().method('addCard').arg(equalTo(cardViews.pop())));
		}
	}
}
