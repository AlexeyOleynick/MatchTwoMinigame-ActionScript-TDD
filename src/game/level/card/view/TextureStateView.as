/**
 * Created by OOliinyk on 1/24/14.
 */
package game.level.card.view {
	import core.external.texture.ITextureService;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.osflash.signals.Signal;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TextureStateView extends Sprite implements IStateView {

		internal var logiclessContainer:Sprite;

		[Inject]
		public var touchSignal:Signal;

		private static const CLOSED_TEXTURE_NAME:String = "closed";
		private static const OPEN_TEXTURE_PATTERN:String = "card";

		internal var closedImage:Image;
		private var openedImage:Image;
		private var currentTextureName:String;
		private var textureService:ITextureService;
		private var closeTimer:Timer;

		public function TextureStateView(textureService:ITextureService)
		{
			this.textureService = textureService;
			closedImage = new Image(textureService.getTexture(CLOSED_TEXTURE_NAME));
			currentTextureName = '';
			logiclessContainer = new Sprite();
			logiclessContainer.addEventListener(TouchEvent.TOUCH, touchListener);
			addChild(logiclessContainer);
		}

		public function open(textureId:int):void
		{
			var textureName:String = getTextureNameById(textureId);
			if(currentTextureName != textureName){
				openedImage = new Image(textureService.getTexture(textureName));
				setImage(openedImage);
				currentTextureName = textureName;
				if(closeTimer) closeTimer.stop();
			}
		}

		private function getTextureNameById(textureId:int):String
		{
			return OPEN_TEXTURE_PATTERN + textureId;
		}

		public function close():void
		{
			if(!isClosed()){
				setImage(closedImage);
				currentTextureName = CLOSED_TEXTURE_NAME;
			}
		}

		private function isClosed():Boolean
		{
			return currentTextureName == CLOSED_TEXTURE_NAME;
		}

		public function closeWithDelay(delayInMilliseconds:int):void
		{
			if(!isWaitingForClose() && !isClosed()){
				closeTimer = new Timer(delayInMilliseconds, 1);
				closeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, closeTimerCompleteListener)
				closeTimer.start();
			}
		}

		private function closeTimerCompleteListener(event:TimerEvent):void
		{
			closeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, closeTimerCompleteListener);
			close();
		}

		private function isWaitingForClose():Boolean
		{
			if(closeTimer == null) return false;
			return closeTimer.running;
		}

		private function setImage(image:Image):void
		{
			logiclessContainer.removeChildren();
			logiclessContainer.addChild(image);
		}


		public function addOpenListener(listener:Function):void
		{
			touchSignal.add(listener);
		}

		private function touchListener(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(logiclessContainer, TouchPhase.ENDED);
			if(touch){
				if(!isWaitingForClose() || isClosed())
					touchSignal.dispatch();
			}
		}
		                        //todo: ??????
		override public function dispatchEvent(event:Event):void
		{
			super.dispatchEvent(event);
		}

		public function getView():Sprite
		{
			return this;
		}
	}
}
