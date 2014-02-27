/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.view {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import game.level.field.controller.CardViewEvent;
	import game.level.field.controller.CardVo;

	import starling.display.Sprite;

	public class CardView extends Sprite implements ICardView {

		private var vo:CardVo;

		[Inject(name='local')]
		public var eventDispatcher:EventDispatcher;

		[Inject]
		internal var stateView:IStateView;
		public static const DELAY_FOR_CLOSE_IN_MILLISECONDS:int = 500;

		public function CardView(stateView:IStateView)
		{
			this.stateView = stateView;
			addChild(stateView.getView());
			stateView.addOpenListener(touchListener);
			stateView.close();
		}

		private function touchListener(event:Event):void
		{
			eventDispatcher.dispatchEvent(new Event(CardViewEvent.SELECT));
		}

		public function showMatchAnimation():void
		{
			remove();
		}

		public function remove():void
		{
			removeFromParent(true);
		}

		public function getCardVo():CardVo
		{
			return vo;
		}

		public function setCardVo(cardVo:CardVo):void
		{
			this.vo = cardVo;
			x = cardVo.x;
			y = cardVo.y;
			if(cardVo.opened) stateView.open(cardVo.type); else stateView.closeWithDelay(DELAY_FOR_CLOSE_IN_MILLISECONDS);
		}

		public function getView():Sprite
		{
			return this;
		}

		public function addSelectListener(listener:Function):void
		{
			eventDispatcher.addEventListener(CardViewEvent.SELECT, listener);
		}
	}
}
