package game.startup {
	import flash.events.Event;

	import game.level.field.signal.AddFieldSignal;

	import mockolate.nice;

	import mockolate.prepare;
	import mockolate.received;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;

	public class StartupCommandTest {

		[Before(async)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(AddFieldSignal),Event.COMPLETE);
		}

		[Test(async)]
		public function shouldDispatchAddFieldCommand():void
		{
			var command:StartupCommand = new StartupCommand();
			command.addFieldSignal = nice(AddFieldSignal);
			command.execute();
			assertThat(command.addFieldSignal, received().method("dispatch"));
		}
	}
}
