/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model {
	import flash.events.Event;

	import game.level.card.model.ICardCollection;

	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.signal.CardsMatchedSignal;
	import game.level.card.signal.CardsRemovedSignal;
	import game.level.card.signal.CardsUpdatedSignal;
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.matcher.ICardMatcher;
	import game.level.field.model.updater.ICardUpdater;
	import game.level.field.model.vo.CardVo;

	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class DefaultCardsModelTest {
		private var cardsModel:DefaultCardsModel;
		private var collectionToRemove:ICardCollection;
		private var collectionToCreate:ICardCollection;
		private var collectionWithOpenDifferentTypes:ICardCollection;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.handleEvent(this, prepare(ICardCollection, ICardMatcher, CardsRemovedSignal, CardsCreatedSignal, CardsMatchedSignal, CardsUpdatedSignal, CardVo, ICardFilter, VectorCardCollection, ICardUpdater, ICardProducer), Event.COMPLETE, setUp);
		}

		private function setUp(e:Event, passThrough:Object):void
		{
			cardsModel = new DefaultCardsModel();
			cardsModel.removalFilter = nice(ICardFilter);
			cardsModel.producer = nice(ICardProducer);
			cardsModel.cardUpdater = nice(ICardUpdater);
			cardsModel.cardCollection = partial(VectorCardCollection);
			cardsModel.cardsUpdatedSignal = nice(CardsUpdatedSignal);
			cardsModel.cardsMatchedSignal = nice(CardsMatchedSignal);
			cardsModel.cardsCreatedSignal = nice(CardsCreatedSignal);
			cardsModel.cardsRemovedSignal = nice(CardsRemovedSignal);
			cardsModel.cardsMatcher = nice(ICardMatcher);

			collectionToRemove = generateCollection();
			stub(cardsModel.removalFilter).method('filter').returns(collectionToRemove);

			collectionToCreate = generateCollection();
			stub(cardsModel.producer).method('produce').returns(collectionToCreate);

			collectionWithOpenDifferentTypes = generateCollection();
			stub(cardsModel.cardCollection).method('getOpenedWithDifferentTypes').returns(collectionWithOpenDifferentTypes);
		}

		[Test(async)]
		public function shouldDispatchUpdateSignalWithOpenedCardIfClosedOnSelect():void
		{
			var cardVo:CardVo = new CardVo();

			collectionWithOpenDifferentTypes.add(cardVo);

			var cardCollectionCapture:Capture = new Capture();
			stub(cardsModel.cardsUpdatedSignal).method('dispatch').args(capture(cardCollectionCapture));

			cardsModel.select(cardVo);
			var cardCollection:ICardCollection = cardCollectionCapture.values.shift();

			assertThat(cardCollection.contains(cardVo), equalTo(true));
		}

		[Test]
		public function shouldNotDispatchUpdateSignalIfOpenedOnSelect():void
		{
			var cardVo:CardVo = new CardVo();
			cardVo.opened = true;
			cardsModel.select(cardVo);
			assertThat(cardsModel.cardsUpdatedSignal, received().method('dispatch').never());
		}

		[Test]
		public function shouldDispatchMatchSignalIfMatchedCardsPresent():void
		{
			var collectionToMatch:ICardCollection = generateCollection();

			stub(cardsModel.cardsMatcher).method('hasCardsToMatch').returns(true);
			stub(cardsModel.cardsMatcher).method('getCardsToMatch').returns(collectionToMatch);

			var cardVo:CardVo = new CardVo();

			cardsModel.select(cardVo);
			assertThat(cardsModel.cardsMatchedSignal, received().method('dispatch').args(equalTo(collectionToMatch)));
			assertThat(cardsModel.cardCollection, received().method('removeCards').args(equalTo(collectionToMatch)));
		}

		[Test]
		public function shouldDispatchUpdateSignalWithClosedCardsIfCardsToClosePresent():void
		{
			var collectionToClose:ICardCollection = nice(ICardCollection);

			cardsModel.cardsMatcher = nice(ICardMatcher);
			stub(cardsModel.cardsMatcher).method('hasCardsToClose').returns(true);
			stub(cardsModel.cardsMatcher).method('getCardsToClose').returns(collectionToClose);

			var cardVo:CardVo = new CardVo();

			cardsModel.select(cardVo);
			assertThat(collectionToClose, received().method('closeAll'));
			assertThat(cardsModel.cardsUpdatedSignal, received().method('dispatch').args(equalTo(collectionToClose)));
		}

		[Test]
		public function shouldDispatchCreateSignalAndAddToCollectionIfProducerReturnsCards():void
		{
			cardsModel.stepForward();
			assertThat(cardsModel.cardsCreatedSignal, received().method('dispatch').arg(collectionToCreate));

		}

		[Test]
		public function shouldNotDispatchUpdateSignalIfProducerReturnsEmptyCollection():void
		{
			cardsModel.producer = nice(ICardProducer);
			stub(cardsModel.producer).method("produce").returns(new VectorCardCollection());
			cardsModel.stepForward();
			assertThat(cardsModel.cardsCreatedSignal, received().method('dispatch').never());
		}

		[Test(async)]
		public function shouldDispatchUpdateSignalOnUpdate():void
		{
			cardsModel.stepForward();
			assertThat(cardsModel.cardUpdater, received().method('update').arg(cardsModel.cardCollection).once());
			assertThat(cardsModel.cardsUpdatedSignal, received().method('dispatch').arg(equalTo(cardsModel.cardCollection)))
		}

		[Test(async)]
		public function shouldDispatchRemoveSignal():void
		{
			cardsModel.stepForward();
			assertThat(cardsModel.cardsRemovedSignal, received().method('dispatch').args(collectionToRemove));

		}

		private function generateCollection():ICardCollection
		{
			var cardCollection:ICardCollection = new VectorCardCollection();
			cardCollection.add(new CardVo());
			cardCollection.add(new CardVo());
			cardCollection.add(new CardVo());
			return cardCollection;
		}
	}
}
