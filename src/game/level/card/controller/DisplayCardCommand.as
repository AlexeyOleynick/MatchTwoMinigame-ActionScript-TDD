/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.controller {
	import flash.events.IEventDispatcher;

	import game.level.card.model.CardsEvent;
	import game.level.card.model.CardsEventType;
	import game.level.card.model.VectorCardCollection;
	import game.level.card.view.CardViewEvent;
	import game.level.card.view.ICardView;
	import game.level.field.model.vo.CardVo;

	import robotlegs.bender.bundles.mvcs.Command;

	public class DisplayCardCommand extends Command {
		[Inject]
		public var dispatcher:IEventDispatcher;
		[Inject]
		public var event:CardsEvent;

		[Inject(name='not for mediator')]
		public var cardView:ICardView;

		override public function execute():void
		{
			if(event.cardCollection.getSize() > 1){
				resendByOne();
			} else{
				cardView.setCardVo(event.cardCollection.getFirst());
				dispatcher.dispatchEvent(new CardViewEvent(CardViewEvent.DISPLAY, cardView));
			}
		}


		private function resendByOne():void
		{
			for each (var cardVo:CardVo in event.cardCollection.getAll()){
				var singleCardCollection:VectorCardCollection = new VectorCardCollection();
				singleCardCollection.add(cardVo);
				dispatcher.dispatchEvent(new CardsEvent(CardsEventType.CREATED, singleCardCollection));
			}
		}

	}
}
