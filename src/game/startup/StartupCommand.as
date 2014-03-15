/**
 * Created by OOliinyk on 1/12/14.
 */
package game.startup {
	import game.level.field.signal.AddFieldSignal;

	import robotlegs.bender.bundles.mvcs.Command;

	public class StartupCommand extends Command {

		[Inject]
		public var addFieldSignal:AddFieldSignal;


		override public function execute():void
		{
			addFieldSignal.dispatch();
		}
	}
}
