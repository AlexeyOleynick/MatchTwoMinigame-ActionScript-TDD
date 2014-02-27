/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import flash.events.Event;

	import game.level.card.view.ICardView;
	import game.level.field.controller.CardVo;
	import game.level.field.controller.CardsEvent;
	import game.level.field.controller.ICardCollection;
	import game.level.field.model.ICardsModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CardMediator extends Mediator {

		[Inject]
		public var view:ICardView;

		[Inject]
		public var cardsModel:ICardsModel;

		override public function initialize():void
		{
			addContextListener(CardsEvent.UPDATED, cardsUpdatedListener);
			addContextListener(CardsEvent.REMOVED, cardsRemovedListener);
			addContextListener(CardsEvent.MATCHED, cardsMatchedListener);

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
