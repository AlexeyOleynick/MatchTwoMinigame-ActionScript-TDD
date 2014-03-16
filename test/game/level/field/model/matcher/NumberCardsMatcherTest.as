package game.level.field.model.matcher {
	import flash.events.Event;

	import game.level.card.model.ICardCollection;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NumberCardsMatcherTest {

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(ICardCollection), Event.COMPLETE, setUp);
		}

		private var numberCardsMatcher:NumberCardsMatcher;

		private var cardCollectionToSearchIn:*;

		private function setUp(e:Event, passThroughData:Object):void
		{
			numberCardsMatcher = new NumberCardsMatcher();
			cardCollectionToSearchIn = nice(ICardCollection);
		}

		[Test]
		public function shouldReturnCardsToCloseIfContains():void
		{
			var openedWithDifferentTypeCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithDifferentTypeCollection).method('getSize').returns(2);
			stub(cardCollectionToSearchIn).method('getOpenedWithDifferentTypes').returns(openedWithDifferentTypeCollection);

			assertThat(numberCardsMatcher.hasCardsToClose(cardCollectionToSearchIn), equalTo(true));
			assertThat(numberCardsMatcher.getCardsToClose(cardCollectionToSearchIn), equalTo(openedWithDifferentTypeCollection));
		}

		[Test]
		public function shouldNotReturnCardsToCloseIfNotContainsDifferentOpenedCards():void
		{
			var openedWithDifferentTypeSingleCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithDifferentTypeSingleCardCollection).method('getSize').returns(0);
			stub(cardCollectionToSearchIn).method('getOpenedWithDifferentTypes').returns(openedWithDifferentTypeSingleCardCollection);

			assertThat(numberCardsMatcher.hasCardsToClose(cardCollectionToSearchIn), equalTo(false));
			assertThat(numberCardsMatcher.getCardsToClose(cardCollectionToSearchIn).getSize(), equalTo(0));
		}


		[Test]
		public function shouldReturnCardsToMatchIfContains():void
		{
			var openedWithSameTypeCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithSameTypeCardCollection).method('getSize').returns(numberCardsMatcher.MIN_NUMBER_TO_MATCH);
			stub(cardCollectionToSearchIn).method('getOpened').returns(openedWithSameTypeCardCollection);

			var openedWithDifferentTypeSingleCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithDifferentTypeSingleCardCollection).method('getSize').returns(0);
			stub(cardCollectionToSearchIn).method('getOpenedWithDifferentTypes').returns(openedWithDifferentTypeSingleCardCollection);

			assertThat(numberCardsMatcher.hasCardsToMatch(cardCollectionToSearchIn), equalTo(true));
			assertThat(numberCardsMatcher.getCardsToMatch(cardCollectionToSearchIn), equalTo(openedWithSameTypeCardCollection));
		}

		[Test]
		public function shouldNotReturnCardsToMatchIfHasOpenedWithDifferentTypes():void
		{
			var openedWithSameTypeCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithSameTypeCardCollection).method('getSize').returns(4);
			stub(cardCollectionToSearchIn).method('getOpened').returns(openedWithSameTypeCardCollection);

			var openedWithDifferentTypeSingleCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithDifferentTypeSingleCardCollection).method('getSize').returns(1);
			stub(cardCollectionToSearchIn).method('getOpenedWithDifferentTypes').returns(openedWithDifferentTypeSingleCardCollection);

			assertThat(numberCardsMatcher.hasCardsToMatch(cardCollectionToSearchIn), equalTo(false));
			assertThat(numberCardsMatcher.getCardsToMatch(cardCollectionToSearchIn).getSize(), equalTo(0));
		}

		[Test]
		public function shouldNotReturnCardsToMatchIfHasOneOpenedCard():void
		{
			var openedWithSameTypeCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithSameTypeCardCollection).method('getSize').returns(1);
			stub(cardCollectionToSearchIn).method('getOpened').returns(openedWithSameTypeCardCollection);

			var openedWithDifferentTypeSingleCardCollection:ICardCollection = nice(ICardCollection);
			stub(openedWithDifferentTypeSingleCardCollection).method('getSize').returns(0);
			stub(cardCollectionToSearchIn).method('getOpenedWithDifferentTypes').returns(openedWithDifferentTypeSingleCardCollection);

			assertThat(numberCardsMatcher.hasCardsToMatch(cardCollectionToSearchIn), equalTo(false));
			assertThat(numberCardsMatcher.getCardsToMatch(cardCollectionToSearchIn).getSize(), equalTo(0));
		}
	}
}
