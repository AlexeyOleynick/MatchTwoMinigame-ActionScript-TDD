package game.level.card.view.texture {
	import core.external.texture.ITextureService;

	import starling.textures.Texture;

	public class CardTextureProvider implements ICardTextureProvider {

		internal static const CLOSED_TEXTURE_NAME:String = "closed";
		internal static const OPENED_TEXTURE_PREFIX:String = "card";

		[Inject]
		public var textureService:ITextureService;

		public function getClosedTexture():Texture
		{
			return textureService.getTexture(CLOSED_TEXTURE_NAME);
		}

		public function getOpenedTexture(cardType:int):Texture
		{
			return textureService.getTexture(OPENED_TEXTURE_PREFIX+cardType);
		}

		public function getClosedTextureWidth():Number
		{
			var closedTexture:Texture = getClosedTexture();
			return closedTexture.nativeWidth;
		}
	}
}
