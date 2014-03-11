/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.model {
	import flash.events.Event;

	//todo: add test
	public class CardsEvent extends Event {
		public var cardCollection:ICardCollection;

		public static const UPDATED:String = "CardsEvent.UPDATE_CARDS";
		public static const REMOVED:String = "CardsEvent.REMOVE_CARDS";
		public static const CREATED:String = "CardsEvent.CARDS_CREATED";
		public static const MATCHED:String = "CardsEvent.CARDS_MATCH";

		public function CardsEvent(type:String, cardCollection:ICardCollection)
		{
			super(type);
			this.cardCollection = cardCollection;
		}
	}
}
