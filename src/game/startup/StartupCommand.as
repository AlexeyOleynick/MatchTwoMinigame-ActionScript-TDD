/**
 * Created by OOliinyk on 1/12/14.
 */
package game.startup {
	import flash.events.IEventDispatcher;

	import game.controller.GameEvent;

	import robotlegs.bender.bundles.mvcs.Command;

	public class StartupCommand extends Command {

		[Inject]
		public var dispatcher:IEventDispatcher;


		override public function execute():void
		{
			dispatcher.dispatchEvent(new GameEvent(GameEvent.ADD_FIELD));
		}
	}
}
