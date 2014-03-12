/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.card.model.CardsEvent;
	import game.level.card.model.CardsEventType;
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.updater.ICardUpdater;
	import game.level.field.model.vo.CardVo;

	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;

	public class CardsModelTest {
		private var cardsModel:DefaultCardsModel;
		private var collectionToRemove:ICardCollection;
		private var collectionToCreate:ICardCollection;
		private var collectionWithOpenDifferentTypes:ICardCollection;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.handleEvent(this, prepare(ICardFilter, VectorCardCollection, ICardUpdater, ICardProducer), Event.COMPLETE, setUp);
		}

		private function setUp(e:Event, passThrough:Object):void
		{
			cardsModel = new DefaultCardsModel();
			cardsModel.dispatcher = new EventDispatcher();
			cardsModel.removalFilter = nice(ICardFilter);
			cardsModel.producer = nice(ICardProducer);
			cardsModel.updater = nice(ICardUpdater);
			cardsModel.cardCollection = partial(VectorCardCollection);

			collectionToRemove = generateCollection();
			stub(cardsModel.removalFilter).method('filter').returns(collectionToRemove);

			collectionToCreate = generateCollection();
			stub(cardsModel.producer).method('produce').returns(collectionToCreate);

			collectionWithOpenDifferentTypes = generateCollection();
			stub(cardsModel.cardCollection).method('getOpenedWithDifferentTypes').returns(collectionWithOpenDifferentTypes);
		}

		[Test(async)]
		public function shouldOpenCardAndDispatchUpdateEventIfClosedOnSelect():void
		{
			var cardVo:CardVo = new CardVo(10, 10, 5, false);
			var checkFunction:Function = function (e:CardsEvent, passThroughData:CardVo):void
			{
				assertThat(e.cardCollection.getFirst(), strictlyEqualTo(passThroughData));
			}
			Async.handleEvent(this, cardsModel.dispatcher, CardsEventType.UPDATED, checkFunction, 300, cardVo);
			cardsModel.select(cardVo);
			assertThat(cardVo.opened, equalTo(true));
		}

		[Test(async)]
		public function shouldNotDispatchUpdateEventIfOpenedOnSelect():void
		{
			var cardVo:CardVo = new CardVo(10, 10, 5, true);
			var checkEventNotContains:Function = function (e:CardsEvent):void
			{
				assertThat(e.cardCollection.getFirst(), not(strictlyEqualTo(cardVo)));
			}
			cardsModel.dispatcher.addEventListener(CardsEventType.UPDATED, checkEventNotContains);
			cardsModel.select(cardVo);
		}


		[Test(async)]
		public function shouldDispatchMatchEvent():void
		{
			var collectionToMatch:ICardCollection = generateCollection();
			stub(cardsModel.cardCollection).method('getOpened').returns(collectionToMatch);
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, collectionToMatch);
			cardsModel.dispatcher.addEventListener(CardsEventType.MATCHED, listener);
			cardsModel.select(new CardVo(10, 10, 5));

		}


		[Test(async)]
		public function shouldNotDispatchMatchEventIfOpenedCardsCountMoreThanOne():void
		{
			var singleCardCollection:ICardCollection = new VectorCardCollection();
			singleCardCollection.add(new CardVo(0, 0, 5));

			var checkEventNotContains:Function = function (e:CardsEvent):void
			{
				assertThat(e.cardCollection, not(equalTo(singleCardCollection)));
			}

			cardsModel.dispatcher.addEventListener(CardsEventType.MATCHED, checkEventNotContains)
			stub(cardsModel.cardCollection).method('getOpened').returns(singleCardCollection);

			cardsModel.select(new CardVo(10, 10, 5));

		}

		[Test(async)]
		public function shouldDispatchUpdateEventIfDifferentPresent():void
		{
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, collectionWithOpenDifferentTypes);
			cardsModel.dispatcher.addEventListener(CardsEventType.UPDATED, listener);
			var cardVo:CardVo = new CardVo(10, 10, 5, true);
			cardsModel.select(cardVo);
		}

		[Test(async)]
		public function shouldNotDispatchUpdateEventIfDifferentCountLessThanTwo():void
		{
			var singleCardCollection:ICardCollection = new VectorCardCollection();
			singleCardCollection.add(new CardVo(10, 10, 5));

			cardsModel.cardCollection = partial(VectorCardCollection);
			stub(cardsModel.cardCollection).method('getOpenedWithDifferentTypes').returns(singleCardCollection);
			var checkEventNotContains:Function = function (e:CardsEvent):void
			{
				assertThat(e.cardCollection, not(strictlyEqualTo(singleCardCollection)));
			}
			cardsModel.dispatcher.addEventListener(CardsEventType.UPDATED, checkEventNotContains)
			var cardVo:CardVo = new CardVo(10, 10, 5, true);
			cardsModel.select(cardVo);
		}

		[Test(async)]
		public function shouldDispatchCreateEventAndAddToCollectionIfProducerReturnsCards():void
		{
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, collectionToCreate);
			cardsModel.dispatcher.addEventListener(CardsEventType.CREATED, listener);
			cardsModel.stepForward();
			assertThat(cardsModel.cardCollection, received().method('addCards').arg(collectionToCreate));
		}

		[Test(async)]
		public function shouldNotDispatchEventOrAddToCollectionIfProducerReturnsEmptyCollection():void
		{
			cardsModel.producer = nice(ICardProducer);
			stub(cardsModel.producer).method("produce").returns(new VectorCardCollection());
			Async.failOnEvent(this, cardsModel.dispatcher, CardsEventType.CREATED);
			cardsModel.stepForward();
			assertThat(cardsModel.cardCollection, received().method('addCards').never());
		}

		[Test(async)]
		public function shouldSendUpdateEventOnUpdate():void
		{
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, cardsModel.cardCollection);
			cardsModel.dispatcher.addEventListener(CardsEventType.UPDATED, listener);
			cardsModel.stepForward();
			assertThat(cardsModel.updater, received().method('update').arg(cardsModel.cardCollection).once());
		}

		[Test(async)]
		public function shouldSendRemoveEvent():void
		{
			cardsModel.dispatcher.addEventListener(CardsEventType.REMOVED, Async.asyncHandler(this, eventShouldContainCollection, 300, collectionToRemove));
			cardsModel.stepForward();
			assertThat(cardsModel.cardCollection, received().method("removeCards").args(collectionToRemove));

		}

		private function eventShouldContainCollection(e:CardsEvent, collectionToCompate:ICardCollection):void
		{
			assertThat(e.cardCollection, equalTo(collectionToCompate));
		}

		private function generateCollection():ICardCollection
		{
			var cardCollection:ICardCollection = new VectorCardCollection();
			cardCollection.add(new CardVo(10, 10, 4));
			cardCollection.add(new CardVo(10, 20, 4));
			cardCollection.add(new CardVo(10, 30, 4));
			return cardCollection;
		}
	}
}
