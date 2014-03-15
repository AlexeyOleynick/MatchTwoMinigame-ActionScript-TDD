/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.view {
	import game.level.card.model.ICardCollection;
	import game.level.card.signal.CardsMatchedSignal;
	import game.level.card.signal.CardsRemovedSignal;
	import game.level.card.signal.CardsUpdatedSignal;
	import game.level.field.model.ICardsModel;
	import game.level.field.model.vo.CardVo;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CardMediator extends Mediator {

		[Inject]
		public var view:ICardView;
		[Inject]
		public var cardsModel:ICardsModel;
		[Inject]
		public var cardsUpdatedSignal:CardsUpdatedSignal;
		[Inject]
		public var cardsMatchedSignal:CardsMatchedSignal;
		[Inject]
		public var cardsRemovedSignal:CardsRemovedSignal;


		override public function initialize():void
		{
			cardsUpdatedSignal.add(cardsUpdatedListener);
			cardsMatchedSignal.add(cardsMatchedListener);
			cardsRemovedSignal.add(cardsRemovedListener);

			view.addSelectListener(cardSelectedListener);
		}

		private function cardsMatchedListener(cardCollection:ICardCollection):void
		{
			var cardVo:CardVo = view.getCardVo();
			if(cardCollection.contains(cardVo)){
				view.showMatchAnimation();
			}
		}

		private function cardSelectedListener():void
		{
			cardsModel.select(view.getCardVo());
		}

		private function cardsUpdatedListener(cardCollection:ICardCollection):void
		{
			var cardVo:CardVo = view.getCardVo();
			if(cardCollection.contains(cardVo)){
				view.setCardVo(cardVo);
			}
		}

		private function cardsRemovedListener(cardCollection:ICardCollection):void
		{
			var cardVo:CardVo = view.getCardVo();
			if(cardCollection.contains(cardVo)){
				view.remove();
			}
		}
	}
}
