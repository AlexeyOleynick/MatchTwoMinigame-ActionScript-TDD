/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.controller {
	import flash.events.Event;

	//todo: this class is not required
	public class GameEvent extends Event {

		public static const ADD_FIELD:String = "ADD_FIELD";

		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
