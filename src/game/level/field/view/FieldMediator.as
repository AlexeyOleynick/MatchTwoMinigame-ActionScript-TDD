/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import flash.events.Event;

	import game.level.card.view.CardViewEvent;
	import game.level.card.view.ICardView;
	import game.level.field.model.ICardsModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class FieldMediator extends Mediator {
		[Inject]
		public var view:IFieldContainer;
		[Inject]
		public var cardsModel:ICardsModel;


		override public function initialize():void
		{
			addContextListener(Event.ENTER_FRAME, enterFrameListener);
			addContextListener(CardViewEvent.DISPLAY, displayCardListener);
		}

		private function displayCardListener(e:CardViewEvent):void
		{
			var cardView:ICardView = e.cardView;
			view.addCard(cardView);
		}

		private function enterFrameListener(e:Event):void
		{
			cardsModel.stepForward();
		}
	}
}
