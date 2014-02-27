/**
 * Created by OOliinyk on 1/12/14.
 */
package game.startup {
	import flash.events.Event;

	public class StartupEvent extends Event {
		public static const STARTUP:String = "STARTUP";

		public function StartupEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
