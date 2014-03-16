/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model {

	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.signal.CardsMatchedSignal;
	import game.level.card.signal.CardsRemovedSignal;
	import game.level.card.signal.CardsUpdatedSignal;
	import game.level.field.model.filter.CardFilterType;
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.updater.ICardUpdater;
	import game.level.field.model.vo.CardVo;

	public class DefaultCardsModel implements ICardsModel {

		[Inject]
		public var cardCollection:ICardCollection;

		[Inject(name='REMOVAL')]
		public var removalFilter:ICardFilter;
		[Inject]
		public var cardUpdater:ICardUpdater;
		[Inject]
		public var producer:ICardProducer;
		[Inject]
		public var cardsUpdatedSignal:CardsUpdatedSignal;
		[Inject]
		public var cardsMatchedSignal:CardsMatchedSignal;
		[Inject]
		public var cardsCreatedSignal:CardsCreatedSignal;
		[Inject]
		public var cardsRemovedSignal:CardsRemovedSignal;

		public function select(cardVo:CardVo):void
		{
			if(!cardVo.opened){
				openCard(cardVo);
				var cardsToUpdateCollection:ICardCollection = closeNotMatched();
				cardsToUpdateCollection.add(cardVo);
				cardsUpdatedSignal.dispatch(cardsToUpdateCollection);
				matchCards();
			}
		}

		private function openCard(cardVo:CardVo):void
		{
			cardVo.opened = true;
			var openCardCollection:ICardCollection = new VectorCardCollection();
			openCardCollection.add(cardVo);
			cardsUpdatedSignal.dispatch(openCardCollection);
		}

		private function closeNotMatched():ICardCollection
		{
			var cardsToClose:ICardCollection = cardCollection.getOpenedWithDifferentTypes();
			if(cardsToClose.getSize() > 1){
				cardsToClose.closeAll();
			}
			return cardsToClose;
		}

		//todo: move it to cardsMatcher
		private function matchCards():void
		{
			var matchedCards:ICardCollection = cardCollection.getOpened();
			if(matchedCards.getSize() > 1){
				cardsMatchedSignal.dispatch(matchedCards);
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
				cardsRemovedSignal.dispatch(cardsToRemove);
			}
		}

		private function updateAllCards():void
		{
			cardUpdater.update(cardCollection);
			cardsUpdatedSignal.dispatch(cardCollection);
		}

		private function createNewCards():void
		{
			var producedCards:ICardCollection = producer.produce();
			if(producedCards.getSize() > 0){
				cardCollection.addCards(producedCards);
				cardsCreatedSignal.dispatch(producedCards);
			}
		}
	}
}