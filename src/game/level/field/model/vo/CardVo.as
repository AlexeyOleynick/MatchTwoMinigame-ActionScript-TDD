/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model.vo {
	public class CardVo {

		public var x:Number;
		public var y:Number;
		private var _opened:Boolean;
		public var type:int;

		public function CardVo(x:int, y:int, type, opened = false)
		{
			this._opened = opened;
			this.x = x;
			this.y = y;
			this.type = type;
		}

		public function get opened():Boolean
		{
			return _opened;
		}

		public function set opened(value:Boolean):void
		{
			_opened = value;
		}
	}
}
