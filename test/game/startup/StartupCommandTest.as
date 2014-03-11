package game.startup {
	import flash.events.EventDispatcher;

	import game.level.field.controller.GameEvent;

	import org.flexunit.async.Async;

	public class StartupCommandTest {

		[Test(async)]
		public function shouldDispatchAddFieldCommand():void
		{
			var command:StartupCommand = new StartupCommand();
			command.dispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, command.dispatcher, GameEvent.ADD_FIELD);
			command.execute();
		}
	}
}
