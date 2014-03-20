/**
 * Created by OOliinyk on 1/24/14.
 */
package game.level.card.view {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import game.level.card.view.texture.ICardTextureProvider;

	import org.osflash.signals.ISignal;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TextureStateView extends Sprite implements IStateView {

		internal var logiclessContainer:Sprite;

		[Inject]
		public var touchSignal:ISignal;

		[Inject]
		public var cardTextureProvider:ICardTextureProvider;

		private var currentState:CardViewStateEnum;

		private var openedImage:Image;
		private var closeTimer:Timer;

		public function TextureStateView()
		{
			currentState = CardViewStateEnum.NO_STATE;
			logiclessContainer = new Sprite();
			logiclessContainer.addEventListener(TouchEvent.TOUCH, touchListener);
			addChild(logiclessContainer);
		}

		public function open(textureId:int):void
		{
			if(currentState != CardViewStateEnum.OPENED_STATE){
				openedImage = new Image(cardTextureProvider.getOpenedTexture(textureId));
				setImage(openedImage);
				if(closeTimer) closeTimer.stop();
				currentState = CardViewStateEnum.OPENED_STATE;
			}
		}

		public function close():void
		{
			if(currentState != CardViewStateEnum.CLOSED_STATE){
				setImage(new Image(cardTextureProvider.getClosedTexture()));
				currentState = CardViewStateEnum.CLOSED_STATE;
			}
		}

		public function closeWithDelay(delayInMilliseconds:int):void
		{
			if(currentState != CardViewStateEnum.WAITING_FOR_CLOSE_STATE){
				closeTimer = new Timer(delayInMilliseconds, 1);
				closeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, closeTimerCompleteListener)
				closeTimer.start();
				currentState = CardViewStateEnum.WAITING_FOR_CLOSE_STATE;
			}
		}

		private function closeTimerCompleteListener(event:TimerEvent):void
		{
			closeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, closeTimerCompleteListener);
			close();
		}

		private function setImage(image:Image):void
		{
			logiclessContainer.removeChildren();
			logiclessContainer.addChild(image);
		}

		public function addOpenRequestListener(listener:Function):void
		{
			touchSignal.add(listener);
		}

		private function touchListener(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(logiclessContainer, TouchPhase.ENDED);
			if(touch){
				touchSignal.dispatch();
			}
		}

		public function getView():Sprite
		{
			return this;
		}
	}
}