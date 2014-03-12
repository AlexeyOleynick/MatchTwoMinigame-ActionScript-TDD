/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.model {
	import game.level.field.model.vo.CardVo;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class VectorCardCollectionTest {
		private var cardCollection:VectorCardCollection;

		[Before]
		public function setUp():void
		{
			cardCollection = new VectorCardCollection();
		}


		[Test]
		public function ShouldReturnOpened():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5, true);
			var secondCard:CardVo = new CardVo(20, 30, 3, false);
			var thirdCard:CardVo = new CardVo(20, 30, 5, true);
			cardCollection.add(firstCard, secondCard, thirdCard);

			var matchedCards:ICardCollection = cardCollection.getOpened();

			assertThat(matchedCards.getSize(), equalTo(2));
			assertThat(matchedCards.contains(firstCard), equalTo(true));
			assertThat(matchedCards.contains(thirdCard), equalTo(true));
			assertThat(matchedCards.contains(secondCard), equalTo(false));
		}


		[Test]
		public function shouldSubtract():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5, true);
			var secondCard:CardVo = new CardVo(20, 30, 3, false);
			var thirdCard:CardVo = new CardVo(20, 30, 5, true);
			cardCollection.add(firstCard, secondCard, thirdCard);

			var collectionToSubtract:VectorCardCollection = new VectorCardCollection();
			collectionToSubtract.add(firstCard, secondCard);

			cardCollection.removeCards(collectionToSubtract);
			assertThat('Size not decreased', cardCollection.getSize(), equalTo(1));
			assertThat('Removed not correct cards', cardCollection.getFirst(), equalTo(thirdCard));
		}

		[Test]
		public function shouldReturnFirstCard():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(20, 30, 5);
			cardCollection.add(firstCard, secondCard);

			assertThat(cardCollection.getFirst(), equalTo(firstCard));
		}


		[Test]
		public function shouldFindOpenedCardsWithDifferentTypes():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5, true);
			var secondCard:CardVo = new CardVo(20, 30, 3, false);
			var thirdCard:CardVo = new CardVo(20, 30, 5, true);
			var fourthCard:CardVo = new CardVo(25, 35, 2, true);
			cardCollection.add(firstCard, secondCard, thirdCard, fourthCard);
			var openedCards:ICardCollection = cardCollection.getOpenedWithDifferentTypes();
			assertThat(openedCards.getSize(), equalTo(3));
		}

		[Test]
		public function shouldIncreaseSizeOnAdd():void
		{
			cardCollection.add(new CardVo(10, 10, 5));
			cardCollection.add(new CardVo(10, 10, 5));

			assertThat(cardCollection.getSize(), equalTo(2));
		}

		[Test]
		public function shouldContainAddedCards():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);
			var thirdCard:CardVo = new CardVo(10, 10, 5);

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);

			assertThat(cardCollection.contains(firstCard), equalTo(true));
			assertThat(cardCollection.contains(secondCard), equalTo(true));
			assertThat(cardCollection.contains(thirdCard), equalTo(false));
		}


		[Test]
		public function shouldAddCardsFromCollection():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);

			var collectionToAdd:ICardCollection = new VectorCardCollection();
			collectionToAdd.add(firstCard, secondCard);

			cardCollection.addCards(collectionToAdd);

			assertThat(cardCollection.contains(firstCard), equalTo(true));
			assertThat(cardCollection.contains(secondCard), equalTo(true));
		}

		[Test]
		public function shouldReturnVector():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);

			assertThat(cardCollection.getAll().length, equalTo(2));
		}

		[Test]
		public function testRemove():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);
			cardCollection.remove(firstCard);

			assertThat(cardCollection.getSize(), equalTo(1));
		}
	}
}
