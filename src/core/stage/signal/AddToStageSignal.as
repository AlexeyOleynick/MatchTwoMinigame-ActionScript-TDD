package core.stage.signal {
	import core.stage.IViewContainer;

	import org.osflash.signals.Signal;

	public class AddToStageSignal extends Signal {
		public function AddToStageSignal()
		{
			super(IViewContainer);
		}

	}
}
