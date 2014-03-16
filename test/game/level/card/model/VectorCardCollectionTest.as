/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.model {
	import game.level.field.model.vo.CardVo;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.hasItems;
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
			var firstCard:CardVo = new CardVo();
			firstCard.opened = true;
			var secondCard:CardVo = new CardVo();
			secondCard.opened = false;
			var thirdCard:CardVo = new CardVo();
			thirdCard.opened = true;
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
			var firstCard:CardVo = new CardVo();
			var secondCard:CardVo = new CardVo();
			var thirdCard:CardVo = new CardVo();
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
			var firstCard:CardVo = new CardVo();
			var secondCard:CardVo = new CardVo();
			cardCollection.add(firstCard, secondCard);

			assertThat(cardCollection.getFirst(), equalTo(firstCard));
		}


		[Test]
		public function shouldFindOpenedCardsWithDifferentTypes():void
		{
			var firstCard:CardVo = new CardVo();
			firstCard.type = 5;
			firstCard.opened = true;
			var secondCard:CardVo = new CardVo();
			secondCard.type = 3;
			secondCard.opened = false;
			var thirdCard:CardVo = new CardVo();
			thirdCard.type = 5;
			thirdCard.opened = true;
			var fourthCard:CardVo = new CardVo();
			fourthCard.type = 2;
			fourthCard.opened = true;
			cardCollection.add(firstCard, secondCard, thirdCard, fourthCard);
			var openedCards:ICardCollection = cardCollection.getOpenedWithDifferentTypes();
			assertThat(openedCards.getSize(), equalTo(3));
		}

		[Test]
		public function shouldIncreaseSizeOnAdd():void
		{
			cardCollection.add(new CardVo());
			cardCollection.add(new CardVo());

			assertThat(cardCollection.getSize(), equalTo(2));
		}

		[Test]
		public function shouldContainAddedCards():void
		{
			var firstCard:CardVo = new CardVo();
			var secondCard:CardVo = new CardVo();
			var thirdCard:CardVo = new CardVo();

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);

			assertThat(cardCollection.contains(firstCard), equalTo(true));
			assertThat(cardCollection.contains(secondCard), equalTo(true));
			assertThat(cardCollection.contains(thirdCard), equalTo(false));
		}


		[Test]
		public function shouldAddCardsFromCollection():void
		{
			var firstCard:CardVo = new CardVo();
			var secondCard:CardVo = new CardVo();

			var collectionToAdd:ICardCollection = new VectorCardCollection();
			collectionToAdd.add(firstCard, secondCard);

			cardCollection.addCards(collectionToAdd);

			assertThat(cardCollection.contains(firstCard), equalTo(true));
			assertThat(cardCollection.contains(secondCard), equalTo(true));
		}

		[Test]
		public function shouldReturnVector():void
		{
			var firstCard:CardVo = new CardVo();
			var secondCard:CardVo = new CardVo();

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);

			assertThat(cardCollection.getAll().length, equalTo(2));
			assertThat(cardCollection.getAll(), hasItems(firstCard, secondCard));
		}

		[Test]
		public function shouldRemoveItems():void
		{
			var firstCard:CardVo = new CardVo();
			var secondCard:CardVo = new CardVo();

			cardCollection.add(firstCard);
			cardCollection.add(secondCard);
			cardCollection.remove(firstCard);

			assertThat(cardCollection.getSize(), equalTo(1));
			assertThat(cardCollection.contains(firstCard), equalTo(false));
		}
	}
}
