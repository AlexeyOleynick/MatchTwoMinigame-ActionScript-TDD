/**
 * Created by OOliinyk on 1/24/14.
 */
package game.level.card.view {
	import core.stage.IViewContainer;

	public interface IStateView extends IViewContainer {

		function open(imageId:int):void;

		function addOpenRequestListener(listener:Function):void;

		function closeWithDelay(timeInMilliseconds:int):void;

		function close():void;
	}
}
