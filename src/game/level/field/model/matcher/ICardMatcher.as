package game.level.field.model.matcher {
	import game.level.card.model.ICardCollection;

	public interface ICardMatcher {

		function hasCardsToMatch(cardCollection:ICardCollection):Boolean;
		function getCardsToMatch(cardCollection:ICardCollection):ICardCollection;

		function hasCardsToClose(cardCollection:ICardCollection):Boolean;
		function getCardsToClose(cardCollection:ICardCollection):ICardCollection;

	}
}
