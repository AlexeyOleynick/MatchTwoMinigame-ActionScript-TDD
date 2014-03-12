/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.field.model.bounds {
	import flash.geom.Rectangle;

	public class RectangleBoundsService implements IBoundsService {

		private var rectangle:Rectangle;

		public function setBounds(rectangle:Rectangle):void
		{
			this.rectangle = rectangle;
		}

		public function isOutOfBounds(x:int, y:int):Boolean
		{
			return !rectangle.contains(x, y);
		}


		public function getWidth():int
		{
			return rectangle.width;
		}
	}
}
