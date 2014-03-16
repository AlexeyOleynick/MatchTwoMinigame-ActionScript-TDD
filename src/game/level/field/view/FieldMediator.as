/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import core.stage.signal.EnterFrameSignal;

	import game.level.card.model.ICardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.view.ICardView;
	import game.level.field.model.ICardsModel;
	import game.level.field.view.factory.ICardViewFactory;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class FieldMediator extends Mediator {
		[Inject]
		public var fieldContainer:IFieldContainer;
		[Inject]
		public var cardsModel:ICardsModel;
		[Inject]
		public var cardsCreatedSignal:CardsCreatedSignal;
		[Inject]
		public var enterFrameSignal:EnterFrameSignal;
		[Inject]
		public var viewFactory:ICardViewFactory;


		override public function initialize():void
		{
			cardsCreatedSignal.add(displayCardListener);
			enterFrameSignal.add(enterFrameListener);
		}

		private function displayCardListener(cardsToAddCollection:ICardCollection):void
		{
			var cardViews:Vector.<ICardView> = viewFactory.generateViewsByCardCollection(cardsToAddCollection);
			for each (var cardView:ICardView in cardViews){
				fieldContainer.addCard(cardView);
			}
		}

		private function enterFrameListener():void
		{
			cardsModel.stepForward();
		}
	}
}
