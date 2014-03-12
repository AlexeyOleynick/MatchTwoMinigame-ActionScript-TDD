/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.model {
	import flash.events.Event;

	public class CardsEvent extends Event {
		public var cardCollection:ICardCollection;

		public function CardsEvent(type:String, cardCollection:ICardCollection)
		{
			super(type);
			this.cardCollection = cardCollection;
		}
	}
}
