package game.level.field.view.factory {
	import game.level.card.model.ICardCollection;
	import game.level.card.view.ICardView;

	public interface ICardViewFactory {
		function generateViewsByCardCollection(cardCollection:ICardCollection):Vector.<ICardView>;
	}
}
