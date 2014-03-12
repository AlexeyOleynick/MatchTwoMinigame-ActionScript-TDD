/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model {
	import flash.events.IEventDispatcher;

	import game.level.card.model.CardsEvent;
	import game.level.card.model.CardsEventType;
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.updater.ICardUpdater;
	import game.level.field.model.vo.CardVo;

	public class DefaultCardsModel implements ICardsModel {

		[Inject]
		public var dispatcher:IEventDispatcher;
		[Inject]
		public var cardCollection:ICardCollection;

		[Inject(name='removal filter')]
		public var removalFilter:ICardFilter;
		[Inject]
		public var updater:ICardUpdater;
		[Inject]
		public var producer:ICardProducer;

		public function select(cardVo:CardVo):void
		{
			openCard(cardVo);
			closeNotMatched();
			matchCards();
		}

		private function openCard(cardVo:CardVo):void
		{
			if(!cardVo.opened){
				cardVo.opened = true;
				var cardsToSelect:ICardCollection = new VectorCardCollection();
				cardsToSelect.add(cardVo);
				dispatcher.dispatchEvent(new CardsEvent(CardsEventType.UPDATED, cardsToSelect));
			}
		}

		private function closeNotMatched():void
		{
			var openedCards:ICardCollection = cardCollection.getOpenedWithDifferentTypes();
			if(openedCards.getSize() > 1){
				openedCards.closeAll();
				dispatcher.dispatchEvent(new CardsEvent(CardsEventType.UPDATED, openedCards));
			}
		}

		private function matchCards():void
		{
			var matchedCards:ICardCollection = cardCollection.getOpened();
			if(matchedCards.getSize() > 1){
				dispatcher.dispatchEvent(new CardsEvent(CardsEventType.MATCHED, matchedCards));
				cardCollection.removeCards(matchedCards);
			}
		}

		public function stepForward():void
		{
			removeInvalidCards();
			updateAllCards();
			createNewCards();
		}

		private function removeInvalidCards():void
		{
			var cardsToRemove:ICardCollection = removalFilter.filter(cardCollection);
			if(cardsToRemove.getSize() > 0){
				cardCollection.removeCards(cardsToRemove);
				dispatcher.dispatchEvent(new CardsEvent(CardsEventType.REMOVED, cardsToRemove));
			}
		}

		private function updateAllCards():void
		{
			updater.update(cardCollection);
			dispatcher.dispatchEvent(new CardsEvent(CardsEventType.UPDATED, cardCollection));
		}

		private function createNewCards():void
		{
			var producedCards:ICardCollection = producer.produce();
			if(producedCards.getSize() > 0){
				dispatcher.dispatchEvent(new CardsEvent(CardsEventType.CREATED, producedCards));
				cardCollection.addCards(producedCards);
			}
		}
	}
}