/**
 * Created by OOliinyk on 1/11/14.
 */
package core.stage {
	import flash.events.Event;

	public class StageEvent extends Event {
		public static const ADD_TO_STAGE:String = "ADD_TO_STAGE";
		private var viewContainer:IViewContainer;

		public function StageEvent(type:String, viewContainer:IViewContainer)
		{
			this.viewContainer = viewContainer;
			super(type);
		}

		public function getViewContainer():IViewContainer
		{
			return viewContainer;
		}
	}
}
