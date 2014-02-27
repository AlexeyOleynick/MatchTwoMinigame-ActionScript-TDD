/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.controller {
	public class CardVo {

		public var x:Number;
		public var y:Number;
		public var opened:Boolean;
		public var type:int;

		public function CardVo(x:int, y:int, type, opened = false)
		{
			this.opened = opened;
			this.x = x;
			this.y = y;
			this.type = type;
		}
	}
}
