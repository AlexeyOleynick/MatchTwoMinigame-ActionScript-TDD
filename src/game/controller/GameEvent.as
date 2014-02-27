/**
 * Created by OOliinyk on 1/12/14.
 */
package game.controller {
	import flash.events.Event;

	public class GameEvent extends Event {

		public static const ADD_FIELD:String = "ADD_FIELD";

		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
