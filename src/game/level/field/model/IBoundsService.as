/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.field.model {
	import flash.geom.Rectangle;

	public interface IBoundsService {
		function isOutOfBounds(x:int, y:int):Boolean;

		function setBounds(rectangle:Rectangle):void;

		function getWidth():int;
	}
}
