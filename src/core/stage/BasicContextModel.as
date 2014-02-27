/**
 * Created by OOliinyk on 1/18/14.
 */
package core.stage {
	public class BasicContextModel implements IContextModel {

		private var width:int;
		private var height:int;

		public function initialize(width:int, height:int):void
		{
			this.width = width;
			this.height = height;
		}

		public function getWidth():int
		{
			return width;
		}

		public function getHeight():int
		{
			return height;
		}
	}
}
