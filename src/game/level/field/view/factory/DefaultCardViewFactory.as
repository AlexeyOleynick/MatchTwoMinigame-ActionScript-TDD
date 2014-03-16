package game.level.field.view.factory {
	import game.level.card.model.ICardCollection;
	import game.level.card.view.CardView;
	import game.level.card.view.ICardView;
	import game.level.field.model.vo.CardVo;

	import robotlegs.bender.framework.api.IInjector;

	public class DefaultCardViewFactory implements ICardViewFactory {

		[Inject]
		public var injector:IInjector;

		public function generateViewsByCardCollection(cardCollection:ICardCollection):Vector.<ICardView>
		{
			var cardsVo:Vector.<CardVo> = cardCollection.getAll();
			var cardViews:Vector.<ICardView> = new Vector.<ICardView>();
			for each (var cardVo:CardVo in cardsVo){
				var cardView:ICardView = injector.instantiateUnmapped(CardView);
				cardView.setCardVo(cardVo);
				cardViews.push(cardView);
			}
			return cardViews;
		}
	}
}
