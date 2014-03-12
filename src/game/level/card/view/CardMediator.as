/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.view {
	import flash.events.Event;

	import game.level.card.model.CardsEvent;
	import game.level.card.model.CardsEventType;
	import game.level.card.model.ICardCollection;
	import game.level.field.model.ICardsModel;
	import game.level.field.model.vo.CardVo;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CardMediator extends Mediator {

		[Inject]
		public var view:ICardView;

		[Inject]
		public var cardsModel:ICardsModel;

		override public function initialize():void
		{
			addContextListener(CardsEventType.UPDATED, cardsUpdatedListener);
			addContextListener(CardsEventType.REMOVED, cardsRemovedListener);
			addContextListener(CardsEventType.MATCHED, cardsMatchedListener);

			view.addSelectListener(cardSelectedListener);
		}

		private function cardsMatchedListener(e:CardsEvent):void
		{
			var cardVo:CardVo = view.getCardVo();
			var cardCollection:ICardCollection = e.cardCollection;
			if(cardCollection.contains(cardVo)){
				view.showMatchAnimation();
			}
		}

		private function cardSelectedListener(event:Event):void
		{
			cardsModel.select(view.getCardVo());
		}

		private function cardsUpdatedListener(e:CardsEvent):void
		{
			var cardVo:CardVo = view.getCardVo();
			var cardCollection:ICardCollection = e.cardCollection;
			if(cardCollection.contains(cardVo)){
				view.setCardVo(cardVo);
			}
		}

		private function cardsRemovedListener(e:CardsEvent):void
		{
			var cardVo:CardVo = view.getCardVo();
			var cardCollection:ICardCollection = e.cardCollection;
			if(cardCollection.contains(cardVo)){
				view.remove();
			}
		}
	}
}
