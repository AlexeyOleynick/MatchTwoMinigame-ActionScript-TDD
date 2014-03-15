/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import core.stage.signal.EnterFrameSignal;

	import game.level.card.signal.DisplayCardsSignal;
	import game.level.card.view.ICardView;
	import game.level.field.model.ICardsModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class FieldMediator extends Mediator {
		[Inject]
		public var view:IFieldContainer;
		[Inject]
		public var cardsModel:ICardsModel;
		[Inject]
		public var displayCardsSignal:DisplayCardsSignal;
		[Inject]
		public var enterFrameSignal:EnterFrameSignal;


		override public function initialize():void
		{
			displayCardsSignal.add(displayCardListener);
			enterFrameSignal.add(enterFrameListener);
		}

		private function displayCardListener(cardView:ICardView):void
		{
			view.addCard(cardView);
		}

		private function enterFrameListener():void
		{
			cardsModel.stepForward();
		}
	}
}
