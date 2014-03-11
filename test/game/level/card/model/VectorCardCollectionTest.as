/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.model {
	import game.level.field.model.vo.CardVo;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

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

			assertTrue(matchedCards.getSize() == 2);
			assertTrue(matchedCards.contains(firstCard));
			assertTrue(matchedCards.contains(thirdCard));
			assertFalse(matchedCards.contains(secondCard));
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
			assertEquals('Size not decreased', 1, cardCollection.getSize());
			assertEquals('Removed not correct cards', thirdCard, cardCollection.getFirst());
		}

		[Test]
		public function shouldReturnFirstCard():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(20, 30, 5);
			cardCollection.add(firstCard, secondCard);

			assertTrue(cardCollection.getFirst() == firstCard);
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
			assertEquals(3, openedCards.getSize());
		}

		[Test]
		public function shouldIncreaseSizeOnAdd():void
		{
			cardCollection.add(new CardVo(10, 10, 5));
			cardCollection.add(new CardVo(10, 10, 5));

			assertTrue(cardCollection.getSize() == 2);
		}

		[Test]
		public function shouldContainAddedCards():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);
			var thirdCard:CardVo = new CardVo(10, 10, 5);

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);

			assertTrue(cardCollection.contains(firstCard));
			assertTrue(cardCollection.contains(secondCard));
			assertFalse(cardCollection.contains(thirdCard));
		}


		[Test]
		public function shouldAddCardsFromCollection():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);

			var collectionToAdd:ICardCollection = new VectorCardCollection();
			collectionToAdd.add(firstCard, secondCard);

			cardCollection.addCards(collectionToAdd);

			assertTrue(cardCollection.contains(firstCard));
			assertTrue(cardCollection.contains(secondCard));
		}

		[Test]
		public function shouldReturnVector():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);

			assertTrue(cardCollection.getAll().length == 2);
		}

		[Test]
		public function testRemove():void
		{
			var firstCard:CardVo = new CardVo(10, 10, 5);
			var secondCard:CardVo = new CardVo(10, 10, 5);

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);
			cardCollection.remove(firstCard);

			assertTrue(cardCollection.getSize() == 1);
		}
	}
}
