package game.level.field.model.matcher {
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;

	public class NumberCardsMatcher implements ICardMatcher {
		internal const MIN_NUMBER_TO_MATCH:int = 2;


		public function hasCardsToMatch(cardCollection:ICardCollection):Boolean
		{
			if(hasCardsToClose(cardCollection)) return false;
			if(cardCollection.getOpened().getSize() < MIN_NUMBER_TO_MATCH) return false;
			return true;
		}

		public function getCardsToMatch(cardCollection:ICardCollection):ICardCollection
		{
			if(hasCardsToMatch(cardCollection)){
				return cardCollection.getOpened();
			} else return new VectorCardCollection();
		}

		public function hasCardsToClose(cardCollection:ICardCollection):Boolean
		{
			var cardsToClose:ICardCollection = cardCollection.getOpenedWithDifferentTypes();
			return cardsToClose.getSize() > 0;
		}

		public function getCardsToClose(cardCollection:ICardCollection):ICardCollection
		{
			if(hasCardsToClose(cardCollection)){
				return cardCollection.getOpenedWithDifferentTypes();
			} else return new VectorCardCollection();
		}
	}
}
