/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.view {
	import flash.events.Event;

	public class CardViewEvent extends Event {
		public var cardView:ICardView;

		public static const DISPLAY:String = 'CardViewEvent.DISPLAY';
		public static const SELECT:String = 'CardViewEvent.SELECT';

		public function CardViewEvent(type:String, cardView:ICardView)
		{
			super(type);
			this.cardView = cardView;
		}
	}
}
