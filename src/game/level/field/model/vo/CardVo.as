/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model.vo {
	public class CardVo {

		public var x:Number;
		public var y:Number;
		public var opened:Boolean;
		public var type:int;

		public function CardVo()
		{
			opened = false;
			x = 0;
			y = 0;
		}


	}
}
