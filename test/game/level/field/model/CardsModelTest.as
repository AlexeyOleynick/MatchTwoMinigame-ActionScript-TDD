/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.field.controller.CardVo;
	import game.level.field.controller.CardsEvent;
	import game.level.field.controller.ICardCollection;
	import game.level.field.controller.VectorCardCollection;
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.updater.ICardUpdater;

	import mockolate.nice;
	import mockolate.partial;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

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
				assertEquals(e.cardCollection.getFirst(), passThroughData)
			}
			Async.handleEvent(this, cardsModel.dispatcher, CardsEvent.UPDATED, checkFunction, 300, cardVo);
			cardsModel.select(cardVo);
			assertTrue(cardVo.opened);
		}

		[Test(async)]
		public function shouldNotDispatchUpdateEventIfOpenedOnSelect():void
		{
			var cardVo:CardVo = new CardVo(10, 10, 5, true);
			var checkEventNotContains:Function = function (e:CardsEvent):void
			{
				assertFalse(e.cardCollection.getFirst() == cardVo);
			}
			cardsModel.dispatcher.addEventListener(CardsEvent.UPDATED, checkEventNotContains);
			cardsModel.select(cardVo);
		}


		[Test(async)]
		public function shouldDispatchMatchEvent():void
		{
			var collectionToMatch:ICardCollection = generateCollection();
			stub(cardsModel.cardCollection).method('getOpened').returns(collectionToMatch);
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, collectionToMatch);
			cardsModel.dispatcher.addEventListener(CardsEvent.MATCHED, listener);
			cardsModel.select(new CardVo(10, 10, 5));

		}


		[Test(async)]
		public function shouldNotDispatchMatchEventIfOpenedCardsCountMoreThanOne():void
		{
			var singleCardCollection:ICardCollection = new VectorCardCollection();
			singleCardCollection.add(new CardVo(0, 0, 5));

			var checkEventNotContains:Function = function (e:CardsEvent):void
			{
				assertFalse(e.cardCollection == singleCardCollection);
			}

			cardsModel.dispatcher.addEventListener(CardsEvent.MATCHED, checkEventNotContains)
			stub(cardsModel.cardCollection).method('getOpened').returns(singleCardCollection);

			cardsModel.select(new CardVo(10, 10, 5));

		}

		[Test(async)]
		public function shouldDispatchUpdateEventIfDifferentPresent():void
		{
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, collectionWithOpenDifferentTypes);
			cardsModel.dispatcher.addEventListener(CardsEvent.UPDATED, listener);
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
				assertFalse(e.cardCollection == singleCardCollection);
			}
			cardsModel.dispatcher.addEventListener(CardsEvent.UPDATED, checkEventNotContains)
			var cardVo:CardVo = new CardVo(10, 10, 5, true);
			cardsModel.select(cardVo);
		}

		[Test(async)]
		public function shouldDispatchCreateEventAndAddToCollectionIfProducerReturnsCards():void
		{
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, collectionToCreate);
			cardsModel.dispatcher.addEventListener(CardsEvent.CREATED, listener);
			cardsModel.stepForward();
			assertThat(cardsModel.cardCollection, received().method('addCards').arg(collectionToCreate));
		}

		[Test(async)]
		public function shouldNotDispatchEventOrAddToCollectionIfProducerReturnsEmptyCollection():void
		{
			cardsModel.producer = nice(ICardProducer);
			stub(cardsModel.producer).method("produce").returns(new VectorCardCollection());
			Async.failOnEvent(this, cardsModel.dispatcher, CardsEvent.CREATED);
			cardsModel.stepForward();
			assertThat(cardsModel.cardCollection, received().method('addCards').never());
		}

		[Test(async)]
		public function shouldSendUpdateEventOnUpdate():void
		{
			var listener:Function = Async.asyncHandler(this, eventShouldContainCollection, 300, cardsModel.cardCollection);
			cardsModel.dispatcher.addEventListener(CardsEvent.UPDATED, listener);
			cardsModel.stepForward();
			assertThat(cardsModel.updater, received().method('update').arg(cardsModel.cardCollection).once());
		}

		[Test(async)]
		public function shouldSendRemoveEvent():void
		{
			cardsModel.dispatcher.addEventListener(CardsEvent.REMOVED, Async.asyncHandler(this, eventShouldContainCollection, 300, collectionToRemove));
			cardsModel.stepForward();
			assertThat(cardsModel.cardCollection, received().method("removeCards").args(collectionToRemove));

		}

		private function eventShouldContainCollection(e:CardsEvent, collectionToCompate:ICardCollection):void
		{
			assertEquals(e.cardCollection, collectionToCompate);
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
