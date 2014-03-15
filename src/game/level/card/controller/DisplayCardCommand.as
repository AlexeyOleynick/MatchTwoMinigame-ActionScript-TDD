/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.controller {
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.card.signal.CardsCreatedSignal;
	import game.level.card.signal.DisplayCardsSignal;
	import game.level.card.view.ICardView;
	import game.level.field.model.vo.CardVo;

	import robotlegs.bender.bundles.mvcs.Command;

	public class DisplayCardCommand extends Command {

		[Inject(name='not for mediator')]
		public var cardView:ICardView;

		[Inject]
		public var cardCollection:ICardCollection;

		[Inject]
		public var displayCardsSignal:DisplayCardsSignal;

		//todo: Should It really resend signal?
		[Inject]
		public var cardsCreatedSignal:CardsCreatedSignal;

		override public function execute():void
		{
			if(cardCollection.getSize() > 1){
				resendByOne();
			} else{
				cardView.setCardVo(cardCollection.getFirst());
				displayCardsSignal.dispatch(cardView);
			}
		}


		private function resendByOne():void
		{
			for each (var cardVo:CardVo in cardCollection.getAll()){
				var singleCardCollection:VectorCardCollection = new VectorCardCollection();
				singleCardCollection.add(cardVo);
				cardsCreatedSignal.dispatch(singleCardCollection);
			}
		}

	}
}
