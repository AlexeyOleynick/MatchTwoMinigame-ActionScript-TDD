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
	import game.level.field.model.filter.ICardFilter;
	import game.level.field.model.generator.ICardProducer;
	import game.level.field.model.matcher.ICardMatcher;
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
		[Inject]
		public var cardsMatcher:ICardMatcher;

		public function select(cardVo:CardVo):void
		{
			if(!cardVo.opened){
				cardVo.opened = true;
				var openCardCollection:ICardCollection = new VectorCardCollection();
				openCardCollection.add(cardVo);
				cardsUpdatedSignal.dispatch(openCardCollection);
			}

			if(cardsMatcher.hasCardsToMatch(cardCollection)){
				var matchedCards:ICardCollection = cardsMatcher.getCardsToMatch(cardCollection);
				cardsMatchedSignal.dispatch(matchedCards);
				cardCollection.removeCards(matchedCards);
			}

			if(cardsMatcher.hasCardsToClose(cardCollection)){
				var cardsToClose:ICardCollection = cardsMatcher.getCardsToClose(cardCollection);
				cardsToClose.closeAll();
				cardsUpdatedSignal.dispatch(cardsToClose);
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